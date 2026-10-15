extends SceneTree

const STORE = preload("res://src/adapters/local/save_store.gd")
const OFFLINE = preload("res://src/adapters/local/offline_return.gd")
const PETS = preload("res://src/adapters/local/pet_persistence.gd")
const PATH: String = "user://g447-offline-return.json"
const START: float = 1791983600.0
const HOUR: float = 3600.0
const DAY: float = 86400.0
const PARENT: String = "pet-founder-001"


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var args: PackedStringArray = OS.get_cmdline_user_args()
    var phase: String = args[0] if args.size() == 1 else ""
    var ok: bool = false
    match phase:
        "bootstrap":
            ok = _bootstrap()
        "hours":
            ok = _advance(START + 3.0 * HOUR, 3.0 * HOUR, 0, 1)
        "replay":
            ok = _advance(START + 3.0 * HOUR, 0.0, 1, 1)
        "days":
            ok = _advance(START + 3.0 * HOUR + 4.0 * DAY, 4.0 * DAY, 1, 2)
        "rollback":
            ok = _advance(START, 0.0, 2, 2)
        "future":
            ok = _advance(START + 3.0 * HOUR + 4.0 * DAY + HOUR, HOUR, 2, 3)
        "invalid":
            ok = _invalid()
        "cleanup":
            _cleanup()
            ok = true
        _:
            push_error("MARICA_G447_FAIL unknown phase")
    if ok:
        print("MARICA_G447_PHASE_PASS " + phase)
    else:
        push_error("MARICA_G447_FAIL " + phase)
    quit(0 if ok else 1)


func _bootstrap() -> bool:
    _cleanup()
    var doc: Dictionary = JSON.parse_string(
        FileAccess.get_file_as_string("res://tests/fixtures/save_v1_succession.json")
    )
    doc["revision"] = 0
    doc["last_observed_at"] = START
    var result: Dictionary = STORE.new(PATH).save(doc, -1, _clock(START))
    return result.get("ok", false) and _check(0, START)


func _advance(now: float, expected_elapsed: float, before: int, after: int) -> bool:
    if not _check(before, _timestamp_for_revision(before)):
        return false
    var result: Dictionary = OFFLINE.resume(STORE.new(PATH), _clock(now))
    if not result.get("ok", false):
        return false
    if result["elapsed_seconds"] != expected_elapsed or result["revision"] != after:
        return false
    return _check(after, _timestamp_for_revision(after))


func _invalid() -> bool:
    if not _check(3, _timestamp_for_revision(3)):
        return false
    var bad_clock: Dictionary = OFFLINE.resume(STORE.new(PATH), func() -> float: return -1.0)
    if bad_clock.get("ok", false):
        return false
    var invalid_clock: Dictionary = OFFLINE.resume(
        STORE.new(PATH), func() -> float: return NAN
    )
    if invalid_clock.get("ok", false):
        return false
    var no_clock: Dictionary = OFFLINE.resume(STORE.new(PATH), Callable())
    if no_clock.get("ok", false):
        return false
    var replay: Dictionary = OFFLINE.resume(
        STORE.new(PATH), _clock(_timestamp_for_revision(4))
    )
    return replay.get("ok", false) and replay["elapsed_seconds"] == 0.0 and _check(
        3, _timestamp_for_revision(3)
    )


func _timestamp_for_revision(revision: int) -> float:
    match revision:
        0:
            return START
        1:
            return START + 3.0 * HOUR
        2:
            return START + 3.0 * HOUR + 4.0 * DAY
        _:
            return START + 4.0 * HOUR + 4.0 * DAY


func _check(revision: int, timestamp: float) -> bool:
    var loaded: Dictionary = STORE.new(PATH).load()
    if not loaded.get("ok", false) or not loaded.get("found", false):
        return false
    var doc: Dictionary = loaded["snapshot"]
    if (
        doc["revision"] != revision
        or doc["last_observed_at"] != timestamp
        or doc["pets"].size() != 3
        or doc["succession_events"].size() != 1
    ):
        return false
    var marker: Dictionary = doc["succession_events"][PARENT]
    if marker["successor_ids"] != ["pet-child-001", "pet-child-002"]:
        return false
    var hydrated: Dictionary = PETS.hydrate(doc)
    if not hydrated.get("ok", false):
        return false
    for pet_id in doc["pets"]:
        var actual: Variant = JSON.parse_string(
            JSON.stringify(hydrated["pets"][pet_id].to_snapshot())
        )
        var expected: Variant = JSON.parse_string(JSON.stringify(doc["pets"][pet_id]))
        if actual != expected:
            return false
    return true


func _clock(value: float) -> Callable:
    return func() -> float: return value


func _cleanup() -> void:
    for suffix in ["", ".bak", ".tmp", ".bak.tmp", ".restore.tmp"]:
        var path: String = PATH + suffix
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
