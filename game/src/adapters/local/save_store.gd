class_name MaricaLocalSaveStore
extends RefCounted

# SPEC-004 G442: staged atomic local saves, verified backups and fail-closed recovery.
const TIME = preload("res://src/domain/simulation_time.gd")
const VALIDATOR = preload("res://src/adapters/local/save_v1_validator.gd")
const MAX_SAFE_INTEGER: int = 9007199254740991

var _path: String
var _fault: Callable


func _init(path: String = "user://marica-save-v1.json", fault: Callable = Callable()) -> void:
    _path = path
    _fault = fault


func load() -> Dictionary:
    if not _safe_path():
        return _fail("Save path must be a flat user:// file")
    var primary: Dictionary = _read_validated(_path)
    if primary.get("ok", false) and primary.get("found", false):
        return primary
    return _recover_or_reject(primary)


func _recover_or_reject(primary: Dictionary) -> Dictionary:
    # Orphan tmp is never a committed save; backup must pass strict G440 validation.
    var backup: Dictionary = _read_validated(_backup_path())
    if backup.get("ok", false) and backup.get("found", false):
        var restored: Dictionary = _restore_backup(backup["snapshot"])
        if not restored.get("ok", false):
            return restored
        return {
            "ok": true,
            "found": true,
            "recovered": true,
            "recovery_source": "verified_backup",
            "snapshot": backup["snapshot"].duplicate(true)
        }
    if not primary.get("ok", false):
        return _fail("Primary save invalid; no verified backup exists")
    if not backup.get("ok", false):
        return _fail("Backup save invalid; new profile creation is unsafe")
    return _missing_or_incomplete()


func _missing_or_incomplete() -> Dictionary:
    if FileAccess.file_exists(_staging_path()) or FileAccess.file_exists(_restore_path()):
        return _fail("Interrupted first save found; incomplete staging is not a profile")
    return {"ok": true, "found": false}

func _read_validated(path: String) -> Dictionary:
    if not FileAccess.file_exists(path):
        return {"ok": true, "found": false}
    var file: FileAccess = FileAccess.open(path, FileAccess.READ)
    if file == null:
        return _fail("Save cannot be read: " + path)
    var raw: String = file.get_as_text()
    file.close()
    var parsed: JSON = JSON.new()
    if parsed.parse(raw) != OK or not _unique_json_keys(raw):
        return _fail("Save JSON is invalid or has duplicate object keys")
    var validated: Dictionary = VALIDATOR.validate(parsed.data)
    if not validated.get("ok", false):
        return _fail(str(validated.get("error", "Save schema is invalid")))
    return {"ok": true, "found": true, "snapshot": validated["document"]}


func save(candidate: Variant, expected_revision: int, clock: Callable) -> Dictionary:
    # G442: staging/backup promotion; G446+ owns process-restart stress tests.
    if not _safe_path():
        return _fail("Save path must be a flat user:// file")
    if expected_revision < -1 or expected_revision >= MAX_SAFE_INTEGER:
        return _fail("Expected revision is invalid")
    var prepared: Dictionary = _prepare_document(candidate, expected_revision, clock)
    if not prepared.get("ok", false):
        return prepared
    return _write_document(prepared["document"])


func _prepare_document(candidate: Variant, expected_revision: int, clock: Callable) -> Dictionary:
    var checked: Dictionary = VALIDATOR.validate(candidate)
    if not checked.get("ok", false):
        return checked
    var current: Dictionary = self.load()
    if not current.get("ok", false):
        return current
    var revision_check: Dictionary = _verify_revision(
        checked["document"], current, expected_revision
    )
    if not revision_check.get("ok", false):
        return revision_check
    var next: Dictionary = checked["document"]
    var prior: float = revision_check["prior"]
    var observed: Dictionary = TIME.observe(clock, prior)
    if not observed.get("ok", false):
        return observed
    next["revision"] = expected_revision + 1
    next["last_observed_at"] = observed["observation"]["logicalNow"]
    return VALIDATOR.validate(next)


func _verify_revision(
    document: Dictionary, current: Dictionary, expected_revision: int
) -> Dictionary:
    var found: bool = current.get("found", false)
    if found and expected_revision != int(current["snapshot"]["revision"]):
        return _fail("Stale save revision")
    if not found and expected_revision != -1:
        return _fail("Missing save requires new-profile revision")
    if found and document["revision"] != expected_revision:
        return _fail("Candidate revision differs from stored revision")
    if not found and document["revision"] != 0:
        return _fail("New save must begin at revision zero")
    var prior: float = (
        float(current["snapshot"]["last_observed_at"])
        if found
        else float(document["last_observed_at"])
    )
    return {"ok": true, "prior": prior}


func _write_document(document: Dictionary) -> Dictionary:
    var previous: Dictionary = _read_validated(_path)
    if not previous.get("ok", false):
        return _fail("Refuse overwrite of invalid primary")
    var staged: Dictionary = _stage_document(_staging_path(), document)
    if not staged.get("ok", false):
        return staged
    if _interrupted("after_temp"):
        return _fail("Simulated interruption after temp flush; primary preserved")
    var backup: Dictionary = _backup_before_replace(previous)
    if not backup.get("ok", false):
        return backup
    if not _promote(_staging_path(), _path):
        return _fail("Atomic primary replacement failed; previous save retained")
    return {"ok": true, "revision": document["revision"], "snapshot": document.duplicate(true)}


func _backup_before_replace(previous: Dictionary) -> Dictionary:
    if not previous.get("found", false):
        return {"ok": true}
    var staged: Dictionary = _stage_document(_backup_staging_path(), previous["snapshot"])
    if not staged.get("ok", false):
        return staged
    if not _promote(_backup_staging_path(), _backup_path()):
        return _fail("Cannot publish verified backup; primary preserved")
    if _interrupted("after_backup"):
        return _fail("Simulated interruption after backup; primary preserved")
    return {"ok": true}

func _restore_backup(document: Dictionary) -> Dictionary:
    var staged: Dictionary = _stage_document(_restore_path(), document)
    if not staged.get("ok", false):
        return _fail("Verified backup exists but restoration staging failed")
    if not _promote(_restore_path(), _path):
        return _fail("Verified backup exists but primary restoration failed")
    return {"ok": true}


func _stage_document(path: String, document: Dictionary) -> Dictionary:
    var stream: FileAccess = FileAccess.open(path, FileAccess.WRITE)
    if stream == null:
        return _fail("Cannot open local staging path")
    stream.store_string(JSON.stringify(document))
    stream.flush()
    var error: Error = stream.get_error()
    stream.close()
    if error != OK:
        return _fail("Staging write failed")
    var reread: Dictionary = _read_validated(path)
    if not reread.get("ok", false) or not reread.get("found", false):
        return _fail("Staged save failed schema verification")
    if FileAccess.get_file_as_string(path) != JSON.stringify(document):
        return _fail("Staged JSON bytes differ from candidate")
    return {"ok": true}


func _promote(source: String, destination: String) -> bool:
    # Filesystem rename is atomic when supported by the target platform.
    # Never unlink a valid destination to work around a failed rename.
    return (
        DirAccess.rename_absolute(
            ProjectSettings.globalize_path(source), ProjectSettings.globalize_path(destination)
        )
        == OK
    )


func _backup_path() -> String:
    return _path + ".bak"


func _staging_path() -> String:
    return _path + ".tmp"


func _backup_staging_path() -> String:
    return _path + ".bak.tmp"


func _restore_path() -> String:
    return _path + ".restore.tmp"


func _interrupted(stage: String) -> bool:
    # Injected only by deterministic QA tests, not by normal gameplay.
    return _fault.is_valid() and _fault.call(stage) == true


func _safe_path() -> bool:
    if not _path.begins_with("user://"):
        return false
    var filename: String = _path.trim_prefix("user://")
    return (
        not filename.is_empty()
        and not filename.contains("/")
        and not filename.contains("\\")
        and filename != "."
        and filename != ".."
    )


# Parse with Godot JSON first, then scan keys for collisions at EVERY nesting depth.
# Godot's JSON parser otherwise accepts duplicate names with last-writer-wins.
static func _unique_json_keys(raw: String) -> bool:
    var frames: Array = []
    var i: int = 0
    while i < raw.length():
        var letter: String = raw.substr(i, 1)
        if letter == "{":
            frames.append({"object": true, "expect_key": true, "keys": {}})
        elif letter == "[":
            frames.append({"object": false, "expect_key": false, "keys": {}})
        elif letter == "}" or letter == "]":
            if frames.is_empty():
                return false
            frames.pop_back()
        elif letter == "," and not frames.is_empty():
            var current: Dictionary = frames.back()
            if current["object"]:
                current["expect_key"] = true
        elif letter == '"':
            var start: int = i
            i += 1
            while i < raw.length():
                if raw.substr(i, 1) == "\\":
                    i += 2
                elif raw.substr(i, 1) == '"':
                    break
                else:
                    i += 1
            if i >= raw.length():
                return false
            if not frames.is_empty():
                var top: Dictionary = frames.back()
                if top["object"] and top["expect_key"]:
                    var key: Variant = JSON.parse_string(raw.substr(start, i - start + 1))
                    if typeof(key) != TYPE_STRING or top["keys"].has(key):
                        return false
                    top["keys"][key] = true
                    top["expect_key"] = false
        i += 1
    return frames.is_empty()


static func _fail(message: String) -> Dictionary:
    return {"ok": false, "error": message}
