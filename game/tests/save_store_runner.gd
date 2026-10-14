extends SceneTree

# G441: independent deterministic file adapter tests in user://, NOT G442 crash safety.
const STORE = preload("res://src/adapters/local/save_store.gd")
const SUFFIX: String = "user://g441-save-store-runner.json"

var _clock_value: float = 0.0


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    _remove_file()
    var ok: bool = _run_cases()
    _remove_file()
    if ok:
        print("MARICA_G441_SAVE_STORE_PASS scenarios=10")
    quit(0 if ok else 1)


func _run_cases() -> bool:
    var store: MaricaLocalSaveStore = STORE.new(SUFFIX)
    if not _check(_initial_roundtrip(store), "initial round-trip"):
        return false
    if not _check(_revision_checks(store), "revision and logical time"):
        return false
    if not _check(_reject_invalid_and_corrupt(store), "corrupt save fail-closed"):
        return false
    _remove_file()
    if not _check(_valid_complex_fixtures(store), "complex founder/succession snapshots"):
        return false
    return _check(not STORE.new("res://outside.json").load().get("ok", false), "safe path")


func _initial_roundtrip(store: MaricaLocalSaveStore) -> bool:
    var absent: Dictionary = store.load()
    if not _check(absent.get("ok", false) and not absent.get("found", true), "absent"):
        return false
    if not _check(
        not store.save(_fixture("save_v1_minimal.json"), 0, Callable(self, "_now")).get(
            "ok", false
        ),
        "missing profile revision"
    ):
        return false
    _clock_value = 1000.0
    var first: Dictionary = store.save(_fixture("save_v1_minimal.json"), -1, Callable(self, "_now"))
    if not _check(first.get("ok", false) and first.get("revision") == 0, "first write"):
        return false
    var loaded: Dictionary = store.load()
    if not _check(
        (
            loaded.get("ok", false)
            and loaded.get("found", false)
            and loaded["snapshot"]["last_observed_at"] == 1000.0
        ),
        "first disk load"
    ):
        return false
    var detached: Dictionary = loaded["snapshot"]
    detached["pets"]["bad"] = {"id": "bad"}
    return _check(store.load()["snapshot"]["pets"].is_empty(), "detached load")


func _revision_checks(store: MaricaLocalSaveStore) -> bool:
    var initial: Dictionary = store.load()["snapshot"]
    _clock_value = 500.0
    var update: Dictionary = store.save(initial, 0, Callable(self, "_now"))
    if not _check(
        (
            update.get("ok", false)
            and update["revision"] == 1
            and update["snapshot"]["last_observed_at"] == 1000.0
        ),
        "logical time monotonicity"
    ):
        return false
    if not _check(
        not store.save(initial, 0, Callable(self, "_now")).get("ok", false),
        "stale expected revision"
    ):
        return false
    if not _check(store.load()["snapshot"]["revision"] == 1, "stale write unchanged"):
        return false
    return _check(
        not store.save(_fixture("save_v1_minimal.json"), -1, Callable(self, "_now")).get(
            "ok", false
        ),
        "no silent overwrite of existing save"
    )


func _reject_invalid_and_corrupt(store: MaricaLocalSaveStore) -> bool:
    var original: Dictionary = store.load()
    var future: Dictionary = original["snapshot"].duplicate(true)
    future["schema_version"] = 2
    if store.save(future, 1, Callable(self, "_now")).get("ok", false):
        return false
    if store.load()["snapshot"]["schema_version"] != 1:
        return false
    return _reject_malformed(store, original) and _reject_duplicate(store)


func _reject_malformed(store: MaricaLocalSaveStore, original: Dictionary) -> bool:
    for corrupt_path in [SUFFIX, SUFFIX + ".bak"]:
        var bad: FileAccess = FileAccess.open(corrupt_path, FileAccess.WRITE)
        if bad == null:
            return false
        bad.store_string('{"schema_version":1,"schema_version":1}')
        bad.close()
    if store.load().get("ok", false):
        return false
    return not store.save(original["snapshot"], 1, Callable(self, "_now")).get("ok", false)


func _reject_duplicate(store: MaricaLocalSaveStore) -> bool:
    var source: String = FileAccess.get_file_as_string("res://tests/fixtures/save_v1_founder.json")
    var duplicated: String = source.replace(
        '"affection": 0.25', '"affection": 0.25, "affection": 0.25'
    )
    if duplicated == source:
        return false
    var file: FileAccess = FileAccess.open(SUFFIX, FileAccess.WRITE)
    if file == null:
        return false
    file.store_string(duplicated)
    file.close()
    return not store.load().get("ok", false)


func _valid_complex_fixtures(store: MaricaLocalSaveStore) -> bool:
    for name in ["save_v1_founder.json", "save_v1_succession.json"]:
        _remove_file()
        var fixture: Dictionary = _fixture(name)
        _clock_value = float(fixture["last_observed_at"])
        # A new local profile always begins with revision 0; no completed marker rewrite.
        fixture["revision"] = 0
        var outcome: Dictionary = store.save(fixture, -1, Callable(self, "_now"))
        if not outcome.get("ok", false):
            print("MARICA_G441_DIAGNOSTIC fixture=" + name + " save=" + str(outcome))
            return false
        var loaded: Dictionary = store.load()
        if not loaded.get("ok", false) or not loaded.get("found", false):
            print("MARICA_G441_DIAGNOSTIC fixture=" + name + " load=" + str(loaded))
            return false
        # Godot JSON normalizes integer wire values into integral floats when parsing.
        var wire_expected: Variant = JSON.parse_string(JSON.stringify(outcome["snapshot"]))
        if loaded["snapshot"] != wire_expected:
            print("MARICA_G441_DIAGNOSTIC fixture=" + name + " mismatched_roundtrip")
            return false
    return true


func _now() -> float:
    return _clock_value


func _fixture(name: String) -> Dictionary:
    var raw: String = FileAccess.get_file_as_string("res://tests/fixtures/" + name)
    var value: Variant = JSON.parse_string(raw)
    return value


func _remove_file() -> void:
    for suffix in ["", ".bak", ".tmp", ".bak.tmp", ".restore.tmp"]:
        var target: String = SUFFIX + suffix
        if FileAccess.file_exists(target):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(target))


func _check(condition: bool, label: String) -> bool:
    if not condition:
        push_error("MARICA_G441_FAIL " + label)
    return condition
