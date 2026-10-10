class_name MaricaPet
extends RefCounted

# G420 identity shell with G427 Soulbound and G428 persistent Affection.
# Complete Care/Health/Lifecycle composite transitions belong to G429.
const PET_ID = preload("res://src/domain/pet_id.gd")
const SOULBOUND = preload("res://src/domain/soulbound.gd")
const AFFECTION = preload("res://src/domain/affection.gd")

var _pet_id: String
var _soulbound: bool
var _affection: float


func _init(validated_id: String, bound: bool = false, affection: float = 0.0) -> void:
    var checked: Dictionary = PET_ID.from_string(validated_id)
    assert(checked.get("ok", false), "MaricaPet must be constructed with a validated ID")
    _pet_id = validated_id
    _soulbound = bound
    _affection = affection


static func create(value: Variant, soulbound: Variant = null, affection: Variant = null) -> Dictionary:
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


func get_id() -> String:
    return _pet_id


func is_soulbound() -> bool:
    return _soulbound


func get_affection() -> float:
    return _affection


func with_affection(value: Variant) -> Dictionary:
    var validated: Dictionary = AFFECTION.create(value)
    if not validated.get("ok", false):
        return validated
    return {
        "ok": true,
        "pet": MaricaPet.new(_pet_id, _soulbound, float(validated["affection"]))
    }


func gain_affection(gain: Variant) -> Dictionary:
    var increased: Dictionary = AFFECTION.increase(_affection, gain)
    if not increased.get("ok", false):
        return increased
    return with_affection(increased["affection"])


func is_transferable() -> bool:
    return not _soulbound


func assert_transferable() -> Dictionary:
    return SOULBOUND.assert_transferable(_soulbound)


func to_snapshot() -> Dictionary:
    # Every caller gets a detached, serializable value; the Pet's ID has no public setter.
    return {"id": _pet_id, "soulbound": _soulbound, "affection": _affection}
