class_name MaricaSuccession
extends RefCounted

# G431: one deterministic successor per call. Exactly-two orchestration and
# idempotency belong to G432/G433, not this stateless domain primitive.
const PET = preload("res://src/domain/pet.gd")
const GENETICS = preload("res://src/domain/genetics.gd")
const MAX_SAFE_INTEGER: float = 9007199254740991.0


static func derive_genetic_seed(succession_seed: Variant, successor_ordinal: Variant) -> Dictionary:
    var base: Dictionary = _integer(succession_seed, "Succession seed", false)
    if not base.get("ok", false):
        return base
    var ordinal: Dictionary = _integer(successor_ordinal, "Successor ordinal", true)
    if not ordinal.get("ok", false):
        return ordinal
    var derived: float = float(base["value"]) + float(ordinal["value"]) - 1.0
    if is_inf(derived) or derived > MAX_SAFE_INTEGER:
        return {"ok": false, "error": "Derived genetic seed exceeds safe integer range"}
    return {"ok": true, "seed": int(derived)}


static func create_successor(
    parent: Variant, successor_id: Variant, succession_seed: Variant, successor_ordinal: Variant
) -> Dictionary:
    if not (parent is MaricaPet):
        return {"ok": false, "error": "Successor parent must be a Pet"}
    var parent_pet: MaricaPet = parent
    if not parent_pet.is_composite():
        return {"ok": false, "error": "Successor parent must be a composite Pet"}
    if parent_pet.is_active():
        return {"ok": false, "error": "Successor can only be generated from an ended pet"}

    var genetic_seed: Dictionary = derive_genetic_seed(succession_seed, successor_ordinal)
    if not genetic_seed.get("ok", false):
        return genetic_seed

    var old: Dictionary = parent_pet.to_snapshot()
    var inherited: Dictionary = GENETICS.advance_potential(
        old["geneticPotential"], genetic_seed["seed"]
    )
    if not inherited.get("ok", false):
        return inherited

    var old_pedigree: Dictionary = old["pedigree"]
    var current_generation: int = int(old_pedigree["generation"])
    if float(current_generation) >= MAX_SAFE_INTEGER:
        return {"ok": false, "error": "Successor generation exceeds safe integer range"}

    var pedigree: Dictionary = {
        "lineageId": old_pedigree["lineageId"],
        "generation": current_generation + 1,
        "founderPetId": old_pedigree["founderPetId"],
        "parentPetIds": [parent_pet.get_id()],
    }
    # Fresh juvenile/active lifecycle, care and health; affection=0, unbound.
    # All inputs and parent snapshots remain detached from the child aggregate.
    return PET.create_composite(
        successor_id, pedigree, null, inherited["traits"], null, null, false, 0.0
    )


static func _integer(value: Variant, label: String, positive: bool) -> Dictionary:
    if typeof(value) != TYPE_FLOAT and typeof(value) != TYPE_INT:
        return {"ok": false, "error": label + " must be a finite number"}
    var scalar: float = float(value)
    if is_nan(scalar) or is_inf(scalar):
        return {"ok": false, "error": label + " must be a finite number"}
    if scalar < 0.0 or floorf(scalar) != scalar:
        return {"ok": false, "error": label + " must be a non-negative integer"}
    if positive and scalar == 0.0:
        return {"ok": false, "error": label + " must be greater than zero"}
    if scalar > MAX_SAFE_INTEGER:
        return {"ok": false, "error": label + " exceeds safe integer range"}
    return {"ok": true, "value": int(scalar)}
