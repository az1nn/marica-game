class_name MaricaSuccession
extends RefCounted

# G431: single-successor primitive. G432: deterministic exactly-two batch.
# G433 idempotency and persistence are separate; these functions are stateless.
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
    # Reject before adding: rounding at 2^53 can hide a one-unit overflow.
    var offset: float = float(ordinal["value"]) - 1.0
    if float(base["value"]) > MAX_SAFE_INTEGER - offset:
        return {"ok": false, "error": "Derived genetic seed exceeds safe integer range"}
    return {"ok": true, "seed": int(base["value"]) + int(ordinal["value"]) - 1}


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


# G432: an all-or-error pair from one ended parent, with ordinals 1 and 2.
# IDs are supplied by the caller; durable event markers are owned by G433.
static func create_successors(
    parent: Variant, successor_ids: Variant, succession_seed: Variant
) -> Dictionary:
    if typeof(successor_ids) != TYPE_ARRAY:
        return {"ok": false, "error": "Exactly two successor IDs are required"}
    var ids: Array = successor_ids
    if ids.size() != 2:
        return {"ok": false, "error": "Exactly two successor IDs are required"}
    if not (ids[0] is String) or not (ids[1] is String):
        return {"ok": false, "error": "Successor IDs must be strings"}
    if ids[0] == ids[1]:
        return {"ok": false, "error": "Successor IDs must be distinct"}
    if parent is MaricaPet and (ids[0] == parent.get_id() or ids[1] == parent.get_id()):
        return {"ok": false, "error": "Successor IDs cannot reuse the parent ID"}

    # Neither a partial batch nor its first child is exposed on a later failure.
    var first: Dictionary = create_successor(parent, ids[0], succession_seed, 1)
    if not first.get("ok", false):
        return first
    var second: Dictionary = create_successor(parent, ids[1], succession_seed, 2)
    if not second.get("ok", false):
        return second
    return {"ok": true, "successors": [first["pet"], second["pet"]]}


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
