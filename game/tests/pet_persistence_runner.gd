extends SceneTree

# G444: strict Pet domain hydrate/serialize, including terminal ancestors and ledger.
const ADAPTER = preload("res://src/adapters/local/pet_persistence.gd")
const STORE = preload("res://src/adapters/local/save_store.gd")
const PATH: String = "user://g444-pet-hydration.json"


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    _cleanup()
    var ok: bool = _scenarios()
    _cleanup()
    if ok:
        print("MARICA_G444_PET_HYDRATION_PASS scenarios=12")
    quit(0 if ok else 1)


func _scenarios() -> bool:
    var empty: Dictionary = _fixture("save_v1_minimal.json")
    var founder: Dictionary = _fixture("save_v1_founder.json")
    var succession: Dictionary = _fixture("save_v1_succession.json")
    if not _check(_positive_cases(empty, founder, succession), "positive hydration"):
        return false
    return _check(_negative_cases(founder), "invalid snapshots fail closed")


func _positive_cases(empty: Dictionary, founder: Dictionary, succession: Dictionary) -> bool:
    if not _check(_roundtrip(empty, 0), "empty v1"):
        return false
    if not _check(_roundtrip(founder, 1), "founder soulbound"):
        return false
    if not _check(_roundtrip(succession, 3), "terminal parent and children"):
        return false
    if not _check(_detached(succession), "detached hydrate"):
        return false
    if not _check(_reject_expression(founder), "expressed traits preserved"):
        return false
    return _check(_disk_roundtrip(succession), "G442 persisted roundtrip")


func _negative_cases(founder: Dictionary) -> bool:
    if not _check(_reject_bad(founder), "invalid v1 rejected"):
        return false
    if not _check(_reject_future(founder), "unknown schema rejected"):
        return false
    if not _check(_reject_missing(founder), "missing pedigree rejected"):
        return false
    if not _check(_reject_rekey(founder), "key mismatch rejected"):
        return false
    if not _check(_reject_bond(founder), "soulbound invariant rejected"):
        return false
    return _check(_reject_health(founder), "health drift rejected")

func _roundtrip(document: Dictionary, count: int) -> bool:
    var hydrated: Dictionary = ADAPTER.hydrate(document)
    if not hydrated.get("ok", false):
        print("MARICA_G444_DIAGNOSTIC hydrate=", hydrated)
        return false
    if hydrated["pets"].size() != count:
        print("MARICA_G444_DIAGNOSTIC count=", hydrated["pets"].size(), " expected=", count)
        return false
    var encoded: Dictionary = ADAPTER.serialize(hydrated["pets"], document)
    if not encoded.get("ok", false):
        print("MARICA_G444_DIAGNOSTIC serialize=", encoded)
        return false
    if _wire(encoded["document"]) != _wire(document):
        print("MARICA_G444_DIAGNOSTIC wire mismatch")
        return false
    return true


func _detached(document: Dictionary) -> bool:
    var original: Dictionary = document.duplicate(true)
    var restored: Dictionary = ADAPTER.hydrate(document)
    if not restored.get("ok", false):
        return false
    var pet: MaricaPet = restored["pets"]["pet-founder-001"]
    var first: Dictionary = pet.to_snapshot()
    first["pedigree"]["generation"] = 100
    return (
        document == original
        and pet.to_snapshot()["pedigree"]["generation"] == 0
        and restored["succession_events"] == document["succession_events"]
    )


func _reject_bad(document: Dictionary) -> bool:
    var bad: Dictionary = document.duplicate(true)
    bad["revision"] = -1
    return not ADAPTER.hydrate(bad).get("ok", false)


func _reject_future(document: Dictionary) -> bool:
    var bad: Dictionary = document.duplicate(true)
    bad["schema_version"] = 2
    return not ADAPTER.hydrate(bad).get("ok", false)


func _reject_missing(document: Dictionary) -> bool:
    var bad: Dictionary = document.duplicate(true)
    bad["pets"]["pet-founder-001"].erase("pedigree")
    return not ADAPTER.hydrate(bad).get("ok", false)


func _reject_rekey(document: Dictionary) -> bool:
    var bad: Dictionary = document.duplicate(true)
    bad["pets"]["pet-founder-001"]["id"] = "other"
    return not ADAPTER.hydrate(bad).get("ok", false)


func _reject_bond(document: Dictionary) -> bool:
    var bad: Dictionary = document.duplicate(true)
    bad["pets"]["pet-founder-001"]["pedigree"]["generation"] = 1
    return not ADAPTER.hydrate(bad).get("ok", false)


func _reject_health(document: Dictionary) -> bool:
    var bad: Dictionary = document.duplicate(true)
    bad["pets"]["pet-founder-001"]["healthState"]["status"] = "critical"
    return not ADAPTER.hydrate(bad).get("ok", false)


func _reject_expression(document: Dictionary) -> bool:
    var changed: Dictionary = document.duplicate(true)
    changed["pets"]["pet-founder-001"]["expressedTraits"]["speed"] = 0.2
    return _roundtrip(changed, 1)


func _disk_roundtrip(document: Dictionary) -> bool:
    var candidate: Dictionary = document.duplicate(true)
    candidate["revision"] = 0
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var saved: Dictionary = store.save(candidate, -1, func() -> float: return 1791983600.0)
    if not saved.get("ok", false):
        return false
    var loaded: Dictionary = store.load()
    if not loaded.get("ok", false) or not loaded.get("found", false):
        return false
    var hydrated: Dictionary = ADAPTER.hydrate(loaded["snapshot"])
    if not hydrated.get("ok", false):
        return false
    var encoded: Dictionary = ADAPTER.serialize(hydrated["pets"], loaded["snapshot"])
    return encoded.get("ok", false) and _wire(encoded["document"]) == _wire(loaded["snapshot"])


func _fixture(name: String) -> Dictionary:
    return JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/" + name))


func _wire(value: Variant) -> Variant:
    return JSON.parse_string(JSON.stringify(value))


func _cleanup() -> void:
    for suffix in ["", ".bak", ".tmp", ".bak.tmp", ".restore.tmp"]:
        var path: String = PATH + suffix
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _check(condition: bool, label: String) -> bool:
    if not condition:
        push_error("MARICA_G444_FAIL " + label)
    return condition
