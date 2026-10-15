extends SceneTree

const STORE = preload("res://src/adapters/local/save_store.gd")
const PETS = preload("res://src/adapters/local/pet_persistence.gd")
const SUCCESSION = preload("res://src/adapters/local/durable_succession.gd")
const PATH: String = "user://g446-process-restart.json"
const PARENT: String = "pet-founder-001"
const IDS: Array = ["pet-child-001", "pet-child-002"]
const SEED: int = 9
const TIME: float = 1791983600.0


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var args: PackedStringArray = OS.get_cmdline_user_args()
    var phase: String = args[0] if not args.is_empty() else ""
    var ok: bool = false
    match phase:
        "seed":
            ok = _seed()
        "reopen":
            ok = _reopen()
        "rollback":
            ok = _rollback()
        "verify":
            ok = _verify()
        "recover":
            ok = _recover()
        "recovered":
            ok = _recovered()
        _:
            push_error("G446 unknown phase")
    if ok:
        print("MARICA_G446_PASS phase=" + phase)
    else:
        push_error("MARICA_G446_FAIL phase=" + phase)
    quit(0 if ok else 1)


func _seed() -> bool:
    _cleanup()
    var doc: Dictionary = _fixture()
    doc["pets"].erase(IDS[0])
    doc["pets"].erase(IDS[1])
    doc["succession_events"].clear()
    doc["revision"] = 0
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var saved: Dictionary = store.save(doc, -1, _clock(TIME))
    if not saved.get("ok", false):
        return false
    var created: Dictionary = SUCCESSION.trigger(store, PARENT, IDS, SEED, _clock(TIME))
    return (
        created.get("ok", false)
        and created["created"]
        and created["revision"] == 1
        and FileAccess.file_exists(PATH)
    )


func _reopen() -> bool:
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var loaded: Dictionary = store.load()
    if not loaded.get("ok", false) or not loaded.get("found", false):
        return false
    var hydrated: Dictionary = PETS.hydrate(loaded["snapshot"])
    if not hydrated.get("ok", false):
        return false
    var replay: Dictionary = SUCCESSION.trigger(store, PARENT, IDS, SEED, _clock(TIME))
    return (
        hydrated["pets"].size() == 3
        and hydrated["succession_events"].size() == 1
        and loaded["snapshot"]["revision"] == 1
        and replay.get("ok", false)
        and not replay["created"]
        and replay["revision"] == 1
        and _ids(replay["successors"]) == IDS
    )


func _rollback() -> bool:
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var loaded: Dictionary = store.load()
    if not loaded.get("ok", false) or not loaded.get("found", false):
        return false
    var doc: Dictionary = loaded["snapshot"]
    var previous: float = float(doc["last_observed_at"])
    var saved: Dictionary = store.save(doc, int(doc["revision"]), _clock(TIME - 3600.0))
    if not saved.get("ok", false):
        return false
    var snap: Dictionary = saved["snapshot"]
    var replay: Dictionary = SUCCESSION.trigger(store, PARENT, IDS, SEED, _clock(TIME - 3600.0))
    return (
        snap["last_observed_at"] == previous
        and snap["revision"] == 2
        and replay.get("ok", false)
        and not replay["created"]
        and replay["revision"] == 2
    )


func _verify() -> bool:
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var loaded: Dictionary = store.load()
    if not loaded.get("ok", false) or not loaded.get("found", false):
        return false
    var snap: Dictionary = loaded["snapshot"]
    var hydrated: Dictionary = PETS.hydrate(snap)
    var replay: Dictionary = SUCCESSION.trigger(store, PARENT, IDS, SEED, _clock(TIME))
    return (
        hydrated.get("ok", false)
        and hydrated["pets"].size() == 3
        and snap["revision"] == 2
        and snap["last_observed_at"] == TIME
        and snap["succession_events"].size() == 1
        and replay.get("ok", false)
        and not replay["created"]
        and replay["revision"] == 2
    )


func _recover() -> bool:
    var file: FileAccess = FileAccess.open(PATH, FileAccess.WRITE)
    if file == null:
        return false
    file.store_string("{bad")
    file.close()
    var loaded: Dictionary = STORE.new(PATH).load()
    return (
        loaded.get("ok", false)
        and loaded.get("recovered", false)
        and loaded.get("recovery_source", "") == "verified_backup"
        and loaded["snapshot"]["revision"] == 1
    )


func _recovered() -> bool:
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var loaded: Dictionary = store.load()
    if not loaded.get("ok", false) or not loaded.get("found", false):
        return false
    var replay: Dictionary = SUCCESSION.trigger(store, PARENT, IDS, SEED, _clock(TIME))
    return (
        loaded["snapshot"]["revision"] == 1
        and loaded["snapshot"]["pets"].size() == 3
        and loaded["snapshot"]["succession_events"].size() == 1
        and replay.get("ok", false)
        and not replay["created"]
        and replay["revision"] == 1
    )


func _clock(value: float) -> Callable:
    return func() -> float: return value


func _ids(pets: Array) -> Array:
    var result: Array = []
    for pet in pets:
        result.append(pet.get_id())
    return result


func _fixture() -> Dictionary:
    return JSON.parse_string(
        FileAccess.get_file_as_string("res://tests/fixtures/save_v1_succession.json")
    )


func _cleanup() -> void:
    for suffix in ["", ".bak", ".tmp", ".bak.tmp", ".restore.tmp"]:
        var path: String = PATH + suffix
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
