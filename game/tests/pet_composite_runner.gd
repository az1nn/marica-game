extends SceneTree

# G429 independent aggregate tests; never reuse the golden fixture runner as the oracle.
const PET = preload("res://src/domain/pet.gd")
const LIFECYCLE = preload("res://src/domain/lifecycle.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if (
        not _create_and_detach()
        or not _care_reexpression()
        or not _health_treatment()
        or not _terminal_and_immutability()
        or not _reject_invalid_state()
    ):
        quit(1)
        return
    print("MARICA_G429_PET_COMPOSITE_PASS")
    quit(0)


func _pedigree() -> Dictionary:
    return {
        "lineageId": "lineage-founder",
        "generation": 0,
        "founderPetId": "pet-founder",
        "parentPetIds": [],
    }


func _create_and_detach() -> bool:
    var potential: Dictionary = {"speed": 0.8, "agility": 0.6}
    var created: Dictionary = PET.create_composite(
        "pet-founder", _pedigree(), null, potential, null, null, true, 0.4
    )
    if not created.get("ok", false):
        return _fail("valid composite rejected")
    var pet: MaricaPet = created["pet"]
    potential["speed"] = 0.0
    var snapshot: Dictionary = pet.to_snapshot()
    if (
        not pet.is_composite()
        or not pet.is_active()
        or pet.is_transferable()
        or snapshot["geneticPotential"]["speed"] != 0.8
        or snapshot["expressedTraits"]["agility"] != 0.6
    ):
        return _fail("founder, potential or trait defaults drifted")
    snapshot["pedigree"]["parentPetIds"].append("tamper")
    snapshot["geneticPotential"]["speed"] = 0.0
    snapshot["careState"]["hunger"] = 1.0
    if (
        pet.to_snapshot()["pedigree"]["parentPetIds"] != []
        or pet.to_snapshot()["geneticPotential"]["speed"] != 0.8
        or pet.to_snapshot()["careState"]["hunger"] != 0.0
    ):
        return _fail("snapshot write-through")
    return true


func _care_reexpression() -> bool:
    var result: Dictionary = PET.create_composite(
        "pet-founder", _pedigree(), null, {"speed": 0.8}
    )
    if not result.get("ok", false):
        return _fail("trait setup failed")
    var original: MaricaPet = result["pet"]
    var cared: Dictionary = original.with_care_state({"hunger": 0.5})
    if not cared.get("ok", false):
        return _fail("care replacement failed")
    var changed: MaricaPet = cared["pet"]
    if (
        changed.to_snapshot()["expressedTraits"]["speed"] != 0.4
        or original.to_snapshot()["expressedTraits"]["speed"] != 0.8
    ):
        return _fail("care/expression coupling or immutability broken")
    var factors: Dictionary = changed.with_expression_factors({"speed": 0.25})
    if not factors.get("ok", false):
        return _fail("factor override rejected")
    if (
        factors["pet"].to_snapshot()["expressedTraits"]["speed"] != 0.2
        or changed.to_snapshot()["careState"]["hunger"] != 0.5
    ):
        return _fail("factor override changed care or produced wrong expression")
    return true


func _health_treatment() -> bool:
    var created: Dictionary = PET.create_composite(
        "pet-founder",
        _pedigree(),
        null,
        {"speed": 0.8},
        {"hunger": 1.0},
        {"neglectHours": 72, "untreatedHours": 2}
    )
    if not created.get("ok", false):
        return _fail("health setup failed")
    var original: MaricaPet = created["pet"]
    var treated: Dictionary = original.apply_treatment("advanced")
    if not treated.get("ok", false) or treated.get("cost") != 30:
        return _fail("advanced treatment or price broken")
    var new_pet: MaricaPet = treated["pet"]
    if (
        original.to_snapshot()["healthState"]["status"] != "critical"
        or new_pet.to_snapshot()["healthState"]["status"] != "neglected"
        or new_pet.to_snapshot()["healthState"]["neglectHours"] != 24.0
        or new_pet.to_snapshot()["expressedTraits"]["speed"] != 0.0
    ):
        return _fail("health treatment incorrectly mutated old composite")
    var progressed: Dictionary = new_pet.advance_health(24)
    if not progressed.get("ok", false):
        return _fail("health advance failed")
    if progressed["pet"].to_snapshot()["healthState"]["status"] != "sick":
        return _fail("health advance does not preserve care quality")
    return true


func _terminal_and_immutability() -> bool:
    var created: Dictionary = PET.create_composite(
        "pet-founder",
        _pedigree(),
        null,
        {"speed": 0.8},
        {"hunger": 1.0},
        {"neglectHours": 72, "untreatedHours": 48},
        true,
        0.3
    )
    if not created.get("ok", false):
        return _fail("critical Pet setup rejected")
    var original: MaricaPet = created["pet"]
    var ended: Dictionary = original.advance_health(1)
    if not ended.get("ok", false):
        return _fail("terminal advance failed")
    var pet: MaricaPet = ended["pet"]
    if (
        pet.is_active()
        or pet.to_snapshot()["lifecycle"].get("endReason") != "health"
        or pet.to_snapshot()["healthState"]["untreatedHours"] != 49.0
        or not original.is_active()
    ):
        return _fail("terminal transition or original immutability drifted")
    if pet.apply_treatment("emergency").get("error") != "Ended pet cannot receive treatment":
        return _fail("ended Pet accepted treatment")
    var repeated: Dictionary = pet.advance_health(-1)
    if not repeated.get("ok", false) or repeated["pet"].to_snapshot() != pet.to_snapshot():
        return _fail("ended Pet advance must be an idempotent no-op")
    var bonded: Dictionary = pet.gain_affection(0.2)
    if (
        not bonded.get("ok", false)
        or bonded["pet"].get_affection() != 0.5
        or not bonded["pet"].is_soulbound()
        or bonded["pet"].is_active()
    ):
        return _fail("bond replacement lost health, lifecycle or Soulbound")
    return true


func _reject_invalid_state() -> bool:
    var invalid: Dictionary = PET.create_composite("pet-founder", {"generation": 0})
    if invalid.get("ok", false):
        return _fail("missing lineage and founder pedigree accepted")
    var shell: Dictionary = PET.create("pet-shell")
    if not shell.get("ok", false) or shell["pet"].advance_health(1).get("ok", true):
        return _fail("isolated shell was mistaken for composite")
    var created: Dictionary = PET.create_composite("pet-founder", _pedigree())
    if not created.get("ok", false):
        return _fail("minimal composite setup failed")
    var pet: MaricaPet = created["pet"]
    if pet.apply_treatment("basic").get("error") != "Healthy pet does not require treatment":
        return _fail("healthy Pet treatment guard broken")
    if pet.advance_health(-1).get("error") != "elapsedHours must not be negative":
        return _fail("invalid elapsed time accepted")
    var end: Dictionary = LIFECYCLE.end_life(LIFECYCLE.start(), "health")
    if not end.get("ok", false):
        return _fail("terminal lifecycle setup failed")
    var updated: Dictionary = pet.with_lifecycle(end["lifecycle"])
    if not updated.get("ok", false) or updated["pet"].is_active() or not pet.is_active():
        return _fail("immutable lifecycle substitution failed")
    return true


func _fail(message: String) -> bool:
    push_error("G429 composite: " + message)
    return false
