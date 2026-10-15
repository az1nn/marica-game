extends SceneTree

# Each phase MUST run in a new Godot OS process, sharing user:// files.
const STORE = preload("res://src/adapters/local/save_store.gd")
const PETS = preload("res://src/adapters/local/pet_persistence.gd")
const SUCCESSION = preload("res://src/adapters/local/durable_succession.gd")
const TIME = preload("res://src/domain/simulation_time.gd")
const PATH: String = "user://g446-process-roundtrip.json"
const PARENT: String = "pet-founder-001"
const IDS: Array = ["pet-child-001", "pet-child-002"]
const SEED: int = 9
const BASE_TIME: float = 1791983600.0
const ADVANCED_TIME: float = 1791987200.0


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var args: PackedStringArray = OS.get_cmdline_user_args()
    var phase: String = args[0] if args.size() == 1 else ""
    var passed: bool = false
    match phase:
        "bootstrap":
            passed = _bootstrap()
        "restart":
            passed = _restart()
        "rollback":
            passed = _rollback()
        "verify":
            passed = _verify()
        "recover":
            passed = _recover()
        "final":
            passed = _final()
        "cleanup":
            _cleanup()
            passed = true
        _:
            push_error("MARICA_G446_FAIL unknown process phase")
    if passed:
        print("MARICA_G446_PHASE_PASS " + phase)
    else:
        push_error("MARICA_G446_FAIL " + phase)
    quit(0 if passed else 1)


func _bootstrap() -> bool:
    _cleanup()
    var doc: Dictionary = _fixture()
    doc["revision"] = 0
    var initial: Dictionary = STORE.new(PATH).save(doc, -1, _clock(BASE_TIME))
    if not initial.get("ok", false):
        print("G446_DIAG initial=", initial)
        return false
    var created: Dictionary = SUCCESSION.trigger(
        STORE.new(PATH), PARENT, IDS, SEED, _clock(BASE_TIME)
    )
    if not created.get("ok", false) or not created["created"]:
        print("G446_DIAG created=", created)
        return false
    return _snapshot_is(1, BASE_TIME, true)


func _restart() -> bool:
    # Fresh process: all state must originate from disk, not static memory.
    if not _snapshot_is(1, BASE_TIME, true):
        return false
    var replay: Dictionary = SUCCESSION.trigger(
        STORE.new(PATH), PARENT, IDS, SEED, _clock(ADVANCED_TIME)
    )
    if not replay.get("ok", false) or replay["created"] or replay["revision"] != 1:
        return false
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var loaded: Dictionary = store.load()
    var saved: Dictionary = store.save(loaded["snapshot"], 1, _clock(ADVANCED_TIME))
    return saved.get("ok", false) and _snapshot_is(2, ADVANCED_TIME, true)


func _rollback() -> bool:
    if not _snapshot_is(2, ADVANCED_TIME, true):
        return false
    var observation: Dictionary = TIME.observe(_clock(BASE_TIME), ADVANCED_TIME)
    if (
        not observation.get("ok", false)
        or observation["observation"]["elapsed"] != 0.0
        or observation["observation"]["logicalNow"] != ADVANCED_TIME
    ):
        return false
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var loaded: Dictionary = store.load()
    var saved: Dictionary = store.save(loaded["snapshot"], 2, _clock(BASE_TIME))
    if not saved.get("ok", false) or not _snapshot_is(3, ADVANCED_TIME, true):
        return false
    var stale: Dictionary = store.save(loaded["snapshot"], 2, _clock(BASE_TIME))
    return not stale.get("ok", false)


func _verify() -> bool:
    if not _snapshot_is(3, ADVANCED_TIME, true):
        return false
    var replay: Dictionary = SUCCESSION.trigger(
        STORE.new(PATH), PARENT, IDS, SEED, _clock(BASE_TIME)
    )
    if not replay.get("ok", false) or replay["created"] or replay["revision"] != 3:
        return false
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var loaded: Dictionary = store.load()
    var saved: Dictionary = store.save(loaded["snapshot"], 3, _clock(ADVANCED_TIME + 1.0))
    return saved.get("ok", false) and _snapshot_is(4, ADVANCED_TIME + 1.0, true)


func _recover() -> bool:
    if not _snapshot_is(4, ADVANCED_TIME + 1.0, true):
        return false
    var file: FileAccess = FileAccess.open(PATH, FileAccess.WRITE)
    if file == null:
        return false
    file.store_string("{corrupt")
    file.close()
    var recovered: Dictionary = STORE.new(PATH).load()
    return (
        recovered.get("ok", false)
        and recovered.get("recovered", false)
        and recovered["recovery_source"] == "verified_backup"
        and _snapshot_is(3, ADVANCED_TIME, true)
    )


func _final() -> bool:
    if not _snapshot_is(3, ADVANCED_TIME, true):
        return false
    var replay: Dictionary = SUCCESSION.trigger(
        STORE.new(PATH), PARENT, IDS, SEED, _clock(BASE_TIME)
    )
    if not replay.get("ok", false) or replay["created"] or replay["revision"] != 3:
        return false
    var loaded: Dictionary = STORE.new(PATH).load()
    var invalid: Dictionary = loaded["snapshot"].duplicate(true)
    invalid["succession_events"][PARENT]["successor_ids"] = [IDS[0], "ghost"]
    var refused: Dictionary = STORE.new(PATH).save(invalid, 3, _clock(BASE_TIME))
    return not refused.get("ok", false) and _snapshot_is(3, ADVANCED_TIME, true)


func _snapshot_is(revision: int, timestamp: float, has_marker: bool) -> bool:
    var loaded: Dictionary = STORE.new(PATH).load()
    if not loaded.get("ok", false) or not loaded.get("found", false):
        return false
    var doc: Dictionary = loaded["snapshot"]
    var restored: Dictionary = PETS.hydrate(doc)
    if not restored.get("ok", false):
        print("G446_DIAG hydration=", restored)
        return false
    if (
        doc["revision"] != revision
        or doc["last_observed_at"] != timestamp
        or doc["pets"].size() != 3
        or doc["succession_events"].has(PARENT) != has_marker
    ):
        return false
    print("G446_DIAG state revision=", doc["revision"], " timestamp=", doc["last_observed_at"], " pets=", doc["pets"].size())
    var marker: Dictionary = doc["succession_events"][PARENT]
    if marker["successor_ids"] != IDS or marker["succession_seed"] != SEED:
        return false
    for pet_id in doc["pets"]:
        var actual: Variant = JSON.parse_string(
            JSON.stringify(restored["pets"][pet_id].to_snapshot())
        )
        var expected: Variant = JSON.parse_string(JSON.stringify(doc["pets"][pet_id]))
        if actual != expected:
            print("G446_DIAG mismatch pet=", pet_id, " actual=", actual, " expected=", expected)
            return false
    return true


func _fixture() -> Dictionary:
    var doc: Dictionary = JSON.parse_string(
        FileAccess.get_file_as_string("res://tests/fixtures/save_v1_succession.json")
    )
    doc["pets"].erase(IDS[0])
    doc["pets"].erase(IDS[1])
    doc["succession_events"].clear()
    return doc


func _clock(value: float) -> Callable:
    return func() -> float: return value


func _cleanup() -> void:
    for suffix in ["", ".bak", ".tmp", ".bak.tmp", ".restore.tmp"]:
        var path: String = PATH + suffix
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
