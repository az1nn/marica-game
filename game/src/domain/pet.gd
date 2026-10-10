class_name MaricaPet
extends RefCounted

# G429: immutable composite of the G420–G428 animal domain contracts.
# G430 succession and G440 persistence adapters remain deliberately outside this type.
const PET_ID = preload("res://src/domain/pet_id.gd")
const SOULBOUND = preload("res://src/domain/soulbound.gd")
const AFFECTION = preload("res://src/domain/affection.gd")
const PEDIGREE = preload("res://src/domain/pedigree.gd")
const LIFECYCLE = preload("res://src/domain/lifecycle.gd")
const GENETICS = preload("res://src/domain/genetics.gd")
const CARE = preload("res://src/domain/care.gd")
const HEALTH = preload("res://src/domain/health.gd")

var _pet_id: String
var _soulbound: bool
var _affection: float
var _composite: bool = false
var _pedigree: MaricaPedigree
var _lifecycle: MaricaLifecycle
var _potential: Dictionary = {}
var _expressed: Dictionary = {}
var _care: MaricaCare
var _health: MaricaHealth


func _init(validated_id: String, bound: bool = false, affection: float = 0.0) -> void:
    var checked: Dictionary = PET_ID.from_string(validated_id)
    assert(checked.get("ok", false), "MaricaPet must be constructed with a validated ID")
    _pet_id = validated_id
    _soulbound = bound
    _affection = affection


static func create(
    value: Variant, soulbound: Variant = null, affection: Variant = null
) -> Dictionary:
    # Backward-compatible G420/G427/G428 isolated shell, not a playable aggregate.
    var parsed: Dictionary = PET_ID.from_string(value)
    if not parsed.get("ok", false):
        return {"ok": false, "error": parsed.get("error", "Invalid PetId")}
    var checked: Dictionary = SOULBOUND.create(soulbound)
    if not checked.get("ok", false):
        return checked
    var bond: Dictionary = AFFECTION.create(affection)
    if not bond.get("ok", false):
        return bond
    return {
        "ok": true,
        "pet": MaricaPet.new(parsed["id"], checked["soulbound"], float(bond["affection"]))
    }


static func create_composite(
    value: Variant,
    pedigree: Variant,
    lifecycle: Variant = null,
    potential: Variant = null,
    care_state: Variant = null,
    health_state: Variant = null,
    soulbound: Variant = null,
    affection: Variant = null
) -> Dictionary:
    var validated: Dictionary = create(value, soulbound, affection)
    if not validated.get("ok", false):
        return validated

    var family: Dictionary = {}
    if pedigree is MaricaPedigree:
        family = {"ok": true, "pedigree": pedigree}
    elif typeof(pedigree) == TYPE_DICTIONARY:
        family = PEDIGREE.create(pedigree)
    else:
        return {"ok": false, "error": "Pet pedigree is invalid"}
    if not family.get("ok", false):
        return family

    var life: MaricaLifecycle = LIFECYCLE.start()
    if lifecycle != null:
        if not (lifecycle is MaricaLifecycle):
            return {"ok": false, "error": "Pet lifecycle is invalid"}
        life = lifecycle

    var traits: Dictionary = GENETICS.new_potential({} if potential == null else potential)
    if not traits.get("ok", false):
        return traits
    var care: Dictionary = CARE.create(care_state)
    if not care.get("ok", false):
        return care
    var health: Dictionary = HEALTH.create(health_state)
    if not health.get("ok", false):
        return health
    var factors: Dictionary = CARE.to_expression_factors(care["care"], traits["traits"])
    if not factors.get("ok", false):
        return factors
    var expressed: Dictionary = GENETICS.express(traits["traits"], factors["factors"])
    if not expressed.get("ok", false):
        return expressed

    var pet: MaricaPet = validated["pet"]
    pet._composite = true
    pet._pedigree = family["pedigree"]
    pet._lifecycle = life
    pet._potential = traits["traits"].duplicate(true)
    pet._expressed = expressed["traits"].duplicate(true)
    pet._care = care["care"]
    pet._health = health["health"]
    return {"ok": true, "pet": pet}


static func _replacement(
    previous: MaricaPet,
    life: MaricaLifecycle,
    expressed: Dictionary,
    care: MaricaCare,
    health: MaricaHealth,
    bond: float
) -> MaricaPet:
    var replacement: MaricaPet = MaricaPet.new(previous._pet_id, previous._soulbound, bond)
    replacement._composite = true
    replacement._pedigree = previous._pedigree
    replacement._lifecycle = life
    replacement._potential = previous._potential.duplicate(true)
    replacement._expressed = expressed.duplicate(true)
    replacement._care = care
    replacement._health = health
    return replacement


func get_id() -> String:
    return _pet_id


func is_soulbound() -> bool:
    return _soulbound


func get_affection() -> float:
    return _affection


func is_composite() -> bool:
    return _composite


func is_transferable() -> bool:
    return not _soulbound


func assert_transferable() -> Dictionary:
    return SOULBOUND.assert_transferable(_soulbound)


func with_affection(value: Variant) -> Dictionary:
    var validated: Dictionary = AFFECTION.create(value)
    if not validated.get("ok", false):
        return validated
    var bond: float = float(validated["affection"])
    if _composite:
        return {"ok": true, "pet": _replacement(self, _lifecycle, _expressed, _care, _health, bond)}
    return {"ok": true, "pet": MaricaPet.new(_pet_id, _soulbound, bond)}


func gain_affection(gain: Variant) -> Dictionary:
    var increased: Dictionary = AFFECTION.increase(_affection, gain)
    if not increased.get("ok", false):
        return increased
    return with_affection(increased["affection"])


func with_lifecycle(lifecycle: Variant) -> Dictionary:
    if not _composite or not (lifecycle is MaricaLifecycle):
        return {"ok": false, "error": "Pet composite lifecycle is required"}
    return {
        "ok": true, "pet": _replacement(self, lifecycle, _expressed, _care, _health, _affection)
    }


func with_expression_factors(factors: Variant) -> Dictionary:
    if not _composite:
        return {"ok": false, "error": "Pet composite state is required"}
    var result: Dictionary = GENETICS.express(_potential, factors)
    if not result.get("ok", false):
        return result
    return {
        "ok": true,
        "pet": _replacement(self, _lifecycle, result["traits"], _care, _health, _affection)
    }


func with_care_state(state: Variant) -> Dictionary:
    if not _composite:
        return {"ok": false, "error": "Pet composite state is required"}
    var care: Dictionary = CARE.create(state)
    if not care.get("ok", false):
        return care
    var factors: Dictionary = CARE.to_expression_factors(care["care"], _potential)
    if not factors.get("ok", false):
        return factors
    var expressed: Dictionary = GENETICS.express(_potential, factors["factors"])
    if not expressed.get("ok", false):
        return expressed
    return {
        "ok": true,
        "pet":
        _replacement(self, _lifecycle, expressed["traits"], care["care"], _health, _affection)
    }


func with_health_state(state: Variant) -> Dictionary:
    if not _composite:
        return {"ok": false, "error": "Pet composite state is required"}
    var health: Dictionary = HEALTH.create(state)
    if not health.get("ok", false):
        return health
    return {
        "ok": true,
        "pet": _replacement(self, _lifecycle, _expressed, _care, health["health"], _affection)
    }


func advance_health(elapsed_hours: Variant) -> Dictionary:
    if not _composite:
        return {"ok": false, "error": "Pet composite state is required"}
    if _lifecycle.is_terminal():
        return {"ok": true, "pet": self}
    var advanced: Dictionary = HEALTH.advance(_health, _care, elapsed_hours)
    if not advanced.get("ok", false):
        return advanced
    var next_lifecycle: MaricaLifecycle = _lifecycle
    var risk: Dictionary = HEALTH.is_terminal_risk(advanced["health"])
    if not risk.get("ok", false):
        return risk
    if risk["terminal"]:
        var ended: Dictionary = LIFECYCLE.end_life(next_lifecycle, "health")
        if not ended.get("ok", false):
            return ended
        next_lifecycle = ended["lifecycle"]
    return {
        "ok": true,
        "pet": _replacement(self, next_lifecycle, _expressed, _care, advanced["health"], _affection)
    }


func apply_treatment(treatment: Variant) -> Dictionary:
    if not _composite:
        return {"ok": false, "error": "Pet composite state is required"}
    if _lifecycle.is_terminal():
        return {"ok": false, "error": "Ended pet cannot receive treatment"}
    var result: Dictionary = HEALTH.treat(_health, treatment)
    if not result.get("ok", false):
        return result
    return {
        "ok": true,
        "pet": _replacement(self, _lifecycle, _expressed, _care, result["health"], _affection),
        "cost": result["cost"],
    }


func is_active() -> bool:
    return not _composite or not _lifecycle.is_terminal()


func to_snapshot() -> Dictionary:
    var snapshot: Dictionary = {
        "id": _pet_id,
        "soulbound": _soulbound,
        "affection": _affection,
    }
    if _composite:
        snapshot["pedigree"] = _pedigree.to_snapshot()
        snapshot["lifecycle"] = _lifecycle.to_snapshot()
        snapshot["geneticPotential"] = _potential.duplicate(true)
        snapshot["expressedTraits"] = _expressed.duplicate(true)
        snapshot["careState"] = _care.to_snapshot()
        snapshot["healthState"] = _health.to_snapshot()
    return snapshot
