extends SceneTree

# G428: independent persistent Affection / Pet shell verification.
const AFFECTION = preload("res://src/domain/affection.gd")
const PET = preload("res://src/domain/pet.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if (
        not _valid_persistence()
        or not _gain_and_cap()
        or not _invalid_inputs()
        or not _pet_immutability()
        or not _founder_and_descendant_separation()
    ):
        quit(1)
        return
    print("MARICA_G428_AFFECTION_PASS")
    quit(0)


func _valid_persistence() -> bool:
    for value in [0.0, 0.25, 0.65, 1.0]:
        var created: Dictionary = AFFECTION.create(value)
        if not created.get("ok", false) or created["affection"] != value:
            return _fail("normalized persistent value changed")
    if AFFECTION.create() != {"ok": true, "affection": 0.0}:
        return _fail("default affection must be zero")
    return true


func _gain_and_cap() -> bool:
    if AFFECTION.increase(0.4, 0.25) != {"ok": true, "affection": 0.65}:
        return _fail("fractional gain drifted")
    if AFFECTION.increase(0.65, 1) != {"ok": true, "affection": 1.0}:
        return _fail("bond exceeded normalized cap")
    if AFFECTION.increase(0.3, 0) != {"ok": true, "affection": 0.3}:
        return _fail("zero gain changed affection")
    return true


func _invalid_inputs() -> bool:
    for value in [-0.01, 1.01, NAN, INF, -INF, true, "0.8", [], {}]:
        if AFFECTION.create(value).get("ok", true):
            return _fail("invalid persisted affection accepted")
    for gain in [-0.01, NAN, INF, -INF, true, "0.2", [], null]:
        if AFFECTION.increase(0.2, gain).get("ok", true):
            return _fail("invalid gain accepted")
    return true


func _pet_immutability() -> bool:
    var created: Dictionary = PET.create("pet-affection-001", true, 0.4)
    if not created.get("ok", false):
        return _fail("valid bonded pet rejected")
    var original: MaricaPet = created["pet"]
    var increased: Dictionary = original.gain_affection(0.25)
    if not increased.get("ok", false):
        return _fail("gain failed for valid bonded pet")
    var bonded: MaricaPet = increased["pet"]
    if (
        original.get_affection() != 0.4
        or bonded.get_affection() != 0.65
        or original.get_id() != bonded.get_id()
        or not bonded.is_soulbound()
    ):
        return _fail("immutable affection, Pet ID or founder binding regressed")
    if original.gain_affection(-0.1).get("ok", true):
        return _fail("invalid gain mutated Pet")
    return _snapshot_roundtrip(bonded)


func _snapshot_roundtrip(bonded: MaricaPet) -> bool:
    var snapshot: Dictionary = bonded.to_snapshot()
    snapshot["id"] = "tampered"
    snapshot["affection"] = 0.0
    snapshot["soulbound"] = false
    if bonded.to_snapshot() != {"id": "pet-affection-001", "soulbound": true, "affection": 0.65}:
        return _fail("snapshot mutation wrote through to Pet")
    var restored: Dictionary = PET.create(
        bonded.get_id(), bonded.is_soulbound(), bonded.to_snapshot()["affection"]
    )
    if not restored.get("ok", false) or restored["pet"].get_affection() != 0.65:
        return _fail("serialized affection did not restore")
    return true

func _founder_and_descendant_separation() -> bool:
    var founder: Dictionary = PET.create("pet-f", true, 0.9)
    var child: Dictionary = PET.create("pet-c", false)
    if not founder.get("ok", false) or not child.get("ok", false):
        return _fail("founder/descendant test setup failed")
    var first: MaricaPet = founder["pet"]
    var second: MaricaPet = child["pet"]
    if (
        not first.is_soulbound()
        or first.get_affection() != 0.9
        or second.is_soulbound()
        or second.get_affection() != 0.0
    ):
        return _fail("descendant incorrectly inherited binding or affection")
    var replaced: Dictionary = first.with_affection(0.1)
    if not replaced.get("ok", false) or replaced["pet"].get_affection() != 0.1:
        return _fail("bond replacement did not work")
    if first.get_affection() != 0.9 or not replaced["pet"].is_soulbound():
        return _fail("bond replacement changed founder identity or original state")
    return true


func _fail(message: String) -> bool:
    push_error("G428 affection: " + message)
    return false
