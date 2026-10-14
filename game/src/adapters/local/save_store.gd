class_name MaricaLocalSaveStore
extends RefCounted

# SPEC-004 G441: direct local JSON I/O behind an adapter, NOT G442 atomic durability.
const TIME = preload("res://src/domain/simulation_time.gd")
const VALIDATOR = preload("res://src/adapters/local/save_v1_validator.gd")
const MAX_SAFE_INTEGER: int = 9007199254740991

var _path: String


func _init(path: String = "user://marica-save-v1.json") -> void:
    _path = path


func load() -> Dictionary:
    if not _safe_path():
        return _fail("Save path must be a flat user:// file")
    if not FileAccess.file_exists(_path):
        return {"ok": true, "found": false}
    var file: FileAccess = FileAccess.open(_path, FileAccess.READ)
    if file == null:
        return _fail("Save cannot be read")
    var raw: String = file.get_as_text()
    file.close()
    var parsed: JSON = JSON.new()
    if parsed.parse(raw) != OK or not _unique_json_keys(raw):
        return _fail("Save JSON is invalid or contains duplicate object keys")
    var validated: Dictionary = VALIDATOR.validate(parsed.data)
    if not validated.get("ok", false):
        return _fail(str(validated.get("error", "Save schema is invalid")))
    return {"ok": true, "found": true, "snapshot": validated["document"]}


func save(candidate: Variant, expected_revision: int, clock: Callable) -> Dictionary:
    # Not crash-atomic: G442 will provide temp/replace/backup semantics.
    if not _safe_path():
        return _fail("Save path must be a flat user:// file")
    if expected_revision < -1 or expected_revision >= MAX_SAFE_INTEGER:
        return _fail("Expected revision is invalid")
    var checked: Dictionary = VALIDATOR.validate(candidate)
    if not checked.get("ok", false):
        return checked
    var current: Dictionary = load()
    if not current.get("ok", false):
        return current
    var found: bool = current.get("found", false)
    if found and expected_revision != int(current["snapshot"]["revision"]):
        return _fail("Stale save revision")
    if not found and expected_revision != -1:
        return _fail("Missing save requires new-profile revision")
    var next: Dictionary = checked["document"]
    if found and next["revision"] != expected_revision:
        return _fail("Candidate revision differs from stored revision")
    if not found and next["revision"] != 0:
        return _fail("New save must begin at revision zero")
    var prior: float = (
        float(current["snapshot"]["last_observed_at"])
        if found
        else float(next["last_observed_at"])
    )
    var observation: Dictionary = TIME.observe(clock, prior)
    if not observation.get("ok", false):
        return observation
    next["revision"] = expected_revision + 1
    next["last_observed_at"] = observation["observation"]["logicalNow"]
    var revalidated: Dictionary = VALIDATOR.validate(next)
    if not revalidated.get("ok", false):
        return revalidated
    var output: FileAccess = FileAccess.open(_path, FileAccess.WRITE)
    if output == null:
        return _fail("Save cannot be opened for writing")
    output.store_string(JSON.stringify(next))
    output.flush()
    var write_error: Error = output.get_error()
    output.close()
    if write_error != OK:
        return _fail("Save write failed; durability is not guaranteed")
    return {"ok": true, "revision": next["revision"], "snapshot": next.duplicate(true)}


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
        elif letter == "\"":
            var start: int = i
            i += 1
            while i < raw.length():
                if raw.substr(i, 1) == "\\":
                    i += 2
                elif raw.substr(i, 1) == "\"":
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
