extends SceneTree

# SPEC-004 G442 independent fault-injection / backup recovery proofs.
const STORE = preload("res://src/adapters/local/save_store.gd")
const PATH: String = "user://g442-atomic-save-runner.json"
var _clock_value: float = 1000.0


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    _cleanup()
    var passed: bool = _scenarios()
    _cleanup()
    if passed:
        print("MARICA_G442_ATOMIC_SAVE_PASS scenarios=12")
    quit(0 if passed else 1)


func _scenarios() -> bool:
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    if not _check(_interrupted_initial_save(), "interrupted first write fail closed"):
        return false
    _cleanup()
    if not _check(_initial_commit(store), "first verified commit"):
        return false
    if not _check(_backup_rotation(store), "backup previous revision"):
        return false
    if not _check(_interrupted_existing(store), "interruptions preserve primary"):
        return false
    if not _check(_valid_new_commit(store), "next commit rotates backup"):
        return false
    if not _check(_corrupt_primary_recovers(store), "verified backup recovery"):
        return false
    if not _check(_stale_after_recovery(store), "stale revision after recovery"):
        return false
    if not _check(_missing_primary_recovers(store), "missing primary recovered"):
        return false
    if not _check(_both_invalid_reject(store), "double corruption fails closed"):
        return false
    _cleanup()
    if not _check(_orphan_staging_fails(store), "uncommitted temp is never a save"):
        return false
    _cleanup()
    if not _check(_fixture_roundtrip(store, "save_v1_founder.json"), "founder backup"):
        return false
    _cleanup()
    return _check(_fixture_roundtrip(store, "save_v1_succession.json"), "succession ledger backup")


func _interrupted_initial_save() -> bool:
    var interrupted: MaricaLocalSaveStore = STORE.new(PATH, Callable(self, "_after_temp"))
    var result: Dictionary = interrupted.save(_fixture("save_v1_minimal.json"), -1, _clock())
    return (
        not result.get("ok", false)
        and not FileAccess.file_exists(PATH)
        and FileAccess.file_exists(PATH + ".tmp")
        and not STORE.new(PATH).load().get("ok", false)
    )


func _initial_commit(store: MaricaLocalSaveStore) -> bool:
    var first: Dictionary = store.save(_fixture("save_v1_minimal.json"), -1, _clock())
    if not first.get("ok", false):
        push_error("MARICA_G442_FIRST_WRITE_ERROR " + str(first))
    if not first.get("ok", false) or first.get("revision", -1) != 0:
        return false
    var loaded: Dictionary = store.load()
    return (
        loaded.get("ok", false)
        and loaded.get("found", false)
        and loaded["snapshot"]["revision"] == 0
        and not FileAccess.file_exists(PATH + ".bak")
    )


func _backup_rotation(store: MaricaLocalSaveStore) -> bool:
    var original: Dictionary = store.load()["snapshot"]
    _clock_value = 1200.0
    var update: Dictionary = store.save(original, 0, _clock())
    var prior: Dictionary = STORE.new(PATH + ".bak").load()
    return (
        update.get("ok", false)
        and update.get("revision", -1) == 1
        and prior.get("ok", false)
        and prior.get("found", false)
        and prior["snapshot"]["revision"] == 0
    )


func _interrupted_existing(store: MaricaLocalSaveStore) -> bool:
    var doc: Dictionary = store.load()["snapshot"]
    var after_temp: MaricaLocalSaveStore = STORE.new(PATH, Callable(self, "_after_temp"))
    if after_temp.save(doc, 1, _clock()).get("ok", false):
        return false
    if store.load()["snapshot"]["revision"] != 1:
        return false
    var after_backup: MaricaLocalSaveStore = STORE.new(PATH, Callable(self, "_after_backup"))
    if after_backup.save(doc, 1, _clock()).get("ok", false):
        return false
    return (
        store.load()["snapshot"]["revision"] == 1
        and STORE.new(PATH + ".bak").load()["snapshot"]["revision"] == 1
    )


func _valid_new_commit(store: MaricaLocalSaveStore) -> bool:
    _clock_value = 1300.0
    var saved: Dictionary = store.save(store.load()["snapshot"], 1, _clock())
    return (
        saved.get("ok", false)
        and saved["revision"] == 2
        and STORE.new(PATH + ".bak").load()["snapshot"]["revision"] == 1
    )


func _corrupt_primary_recovers(store: MaricaLocalSaveStore) -> bool:
    if not _overwrite(PATH, '{"schema_version":1,"schema_version":1}'):
        return false
    var loaded: Dictionary = store.load()
    return (
        loaded.get("ok", false)
        and loaded.get("recovered", false)
        and loaded.get("recovery_source") == "verified_backup"
        and loaded["snapshot"]["revision"] == 1
        and STORE.new(PATH).load()["snapshot"]["revision"] == 1
    )


func _stale_after_recovery(store: MaricaLocalSaveStore) -> bool:
    var stale: Dictionary = _fixture("save_v1_minimal.json")
    stale["revision"] = 2
    return not store.save(stale, 2, _clock()).get("ok", false)


func _missing_primary_recovers(store: MaricaLocalSaveStore) -> bool:
    _clock_value = 1500.0
    var written: Dictionary = store.save(store.load()["snapshot"], 1, _clock())
    if not written.get("ok", false):
        return false
    if DirAccess.remove_absolute(ProjectSettings.globalize_path(PATH)) != OK:
        return false
    var recovered: Dictionary = store.load()
    return (
        recovered.get("ok", false)
        and recovered.get("recovered", false)
        and recovered["snapshot"]["revision"] == 1
    )


func _both_invalid_reject(store: MaricaLocalSaveStore) -> bool:
    if not _overwrite(PATH, '{"schema_version":9}'):
        return false
    if not _overwrite(PATH + ".bak", '{"schema_version":1,"schema_version":2}'):
        return false
    var failed: Dictionary = store.load()
    return (
        not failed.get("ok", false)
        and not store.save(_fixture("save_v1_minimal.json"), -1, _clock()).get("ok", false)
        and FileAccess.file_exists(PATH)
        and FileAccess.file_exists(PATH + ".bak")
    )


func _orphan_staging_fails(store: MaricaLocalSaveStore) -> bool:
    if not _overwrite(PATH + ".tmp", JSON.stringify(_fixture("save_v1_minimal.json"))):
        return false
    return (
        not store.load().get("ok", false)
        and not store.save(_fixture("save_v1_minimal.json"), -1, _clock()).get("ok", false)
    )


func _fixture_roundtrip(store: MaricaLocalSaveStore, fixture_name: String) -> bool:
    var doc: Dictionary = _fixture(fixture_name)
    doc["revision"] = 0
    _clock_value = float(doc["last_observed_at"])
    var first: Dictionary = store.save(doc, -1, _clock())
    if not first.get("ok", false):
        return false
    var second: Dictionary = store.save(first["snapshot"], 0, _clock())
    if not second.get("ok", false):
        return false
    var backup: Dictionary = STORE.new(PATH + ".bak").load()
    if not backup.get("ok", false) or backup["snapshot"] != first["snapshot"]:
        return false
    if not _overwrite(PATH, '{"not":"a save"}'):
        return false
    var recovered: Dictionary = store.load()
    return (
        recovered.get("ok", false)
        and recovered.get("recovered", false)
        and recovered["snapshot"] == first["snapshot"]
    )


func _fixture(filename: String) -> Dictionary:
    return JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/" + filename))


func _clock() -> Callable:
    return Callable(self, "_now")


func _now() -> float:
    return _clock_value


func _after_temp(step: String) -> bool:
    return step == "after_temp"


func _after_backup(step: String) -> bool:
    return step == "after_backup"


func _overwrite(path: String, text: String) -> bool:
    var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        return false
    file.store_string(text)
    file.flush()
    var error: Error = file.get_error()
    file.close()
    return error == OK


func _cleanup() -> void:
    for suffix in ["", ".bak", ".tmp", ".bak.tmp", ".restore.tmp"]:
        var path: String = PATH + suffix
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _check(condition: bool, label: String) -> bool:
    if not condition:
        push_error("MARICA_G442_FAIL " + label)
    return condition
