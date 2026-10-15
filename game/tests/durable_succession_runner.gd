extends SceneTree

const ADAPTER = preload("res://src/adapters/local/durable_succession.gd")
const STORE = preload("res://src/adapters/local/save_store.gd")
const PATH: String = "user://g445-durable-succession.json"
const PARENT: String = "pet-founder-001"
const IDS: Array = ["pet-child-001", "pet-child-002"]
const SEED: int = 9


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var ok: bool = _scenarios()
    _cleanup()
    if ok:
        print("MARICA_G445_DURABLE_MARKERS_PASS scenarios=12")
    quit(0 if ok else 1)


func _scenarios() -> bool:
    if not _check(_existing(), "existing marker replay"):
        return false
    if not _check(_new(), "new marker persisted"):
        return false
    return _negative()


func _existing() -> bool:
    _cleanup()
    if not _seed(_fixture()):
        return false
    var first: Dictionary = _trigger()
    var second: Dictionary = _trigger()
    var doc: Dictionary = STORE.new(PATH).load()["snapshot"]
    return (
        first.get("ok", false)
        and not first["created"]
        and second.get("ok", false)
        and not second["created"]
        and doc["revision"] == 0
        and _ids(second["successors"]) == IDS
    )


func _new() -> bool:
    _cleanup()
    if not _seed(_without_marker()):
        return false
    var first: Dictionary = _trigger()
    if not first.get("ok", false) or not first["created"]:
        return false
    var second: Dictionary = _trigger()
    var doc: Dictionary = STORE.new(PATH).load()["snapshot"]
    return (
        second.get("ok", false)
        and not second["created"]
        and doc["revision"] == 1
        and doc["pets"].size() == 3
        and doc["succession_events"].size() == 1
        and _ids(second["successors"]) == IDS
    )


func _negative() -> bool:
    if not _check(_conflict(IDS, 10), "seed conflict"):
        return false
    if not _check(_conflict(["other-a", "other-b"], SEED), "IDs conflict"):
        return false
    if not _check(_missing_parent(), "missing parent"):
        return false
    if not _check(_missing_profile(), "missing profile"):
        return false
    if not _check(_corrupt_marker(), "corrupt marker"):
        return false
    if not _check(_duplicate_id(), "duplicate child"):
        return false
    if not _check(_invalid_ids(), "invalid cardinality"):
        return false
    if not _check(_bad_clock(), "clock rejection"):
        return false
    if not _check(_stale(), "revision guard"):
        return false
    return _check(_backup(), "backup replay")


func _conflict(ids: Array, seed: int) -> bool:
    _cleanup()
    if not _seed(_fixture()):
        return false
    return not ADAPTER.trigger(STORE.new(PATH), PARENT, ids, seed, _clock()).get("ok", false)


func _missing_parent() -> bool:
    _cleanup()
    if not _seed(_fixture()):
        return false
    return not ADAPTER.trigger(STORE.new(PATH), "missing", IDS, SEED, _clock()).get("ok", false)


func _missing_profile() -> bool:
    _cleanup()
    return not _trigger().get("ok", false)


func _corrupt_marker() -> bool:
    _cleanup()
    if not _seed(_fixture()):
        return false
    var doc: Dictionary = _fixture()
    doc["succession_events"][PARENT]["successor_ids"] = ["missing", IDS[1]]
    var file: FileAccess = FileAccess.open(PATH, FileAccess.WRITE)
    file.store_string(JSON.stringify(doc))
    file.close()
    return not _trigger().get("ok", false)


func _duplicate_id() -> bool:
    _cleanup()
    var doc: Dictionary = _without_marker()
    doc["pets"][IDS[0]] = _fixture()["pets"][IDS[0]]
    if not _seed(doc):
        return false
    return not _trigger().get("ok", false)


func _invalid_ids() -> bool:
    _cleanup()
    if not _seed(_without_marker()):
        return false
    return not ADAPTER.trigger(STORE.new(PATH), PARENT, [IDS[0]], SEED, _clock()).get("ok", false)


func _bad_clock() -> bool:
    _cleanup()
    if not _seed(_without_marker()):
        return false
    var result: Dictionary = ADAPTER.trigger(
        STORE.new(PATH), PARENT, IDS, SEED, func() -> float: return -1.0
    )
    return not result.get("ok", false) and STORE.new(PATH).load()["snapshot"]["succession_events"].is_empty()


func _stale() -> bool:
    _cleanup()
    if not _seed(_without_marker()):
        return false
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var current: Dictionary = store.load()["snapshot"]
    return (
        not store.save(current, 99, _clock()).get("ok", false)
        and _trigger().get("ok", false)
    )


func _backup() -> bool:
    _cleanup()
    if not _seed(_fixture()):
        return false
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var saved: Dictionary = store.save(_fixture(), 0, _clock())
    if not saved.get("ok", false):
        return false
    var file: FileAccess = FileAccess.open(PATH, FileAccess.WRITE)
    file.store_string("{bad")
    file.close()
    var replay: Dictionary = _trigger()
    return replay.get("ok", false) and not replay["created"]


func _trigger() -> Dictionary:
    return ADAPTER.trigger(STORE.new(PATH), PARENT, IDS, SEED, _clock())


func _seed(doc: Dictionary) -> bool:
    doc["revision"] = 0
    return STORE.new(PATH).save(doc, -1, _clock()).get("ok", false)


func _without_marker() -> Dictionary:
    var doc: Dictionary = _fixture()
    doc["pets"].erase(IDS[0])
    doc["pets"].erase(IDS[1])
    doc["succession_events"].clear()
    return doc


func _clock() -> Callable:
    return func() -> float: return 1791983600.0


func _ids(pets: Array) -> Array:
    var result: Array = []
    for pet in pets:
        result.append(pet.get_id())
    return result


func _fixture() -> Dictionary:
    return JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/save_v1_succession.json"))


func _cleanup() -> void:
    for suffix in ["", ".bak", ".tmp", ".bak.tmp", ".restore.tmp"]:
        var path: String = PATH + suffix
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _check(ok: bool, label: String) -> bool:
    if not ok:
        push_error("MARICA_G445_FAIL " + label)
    return ok
