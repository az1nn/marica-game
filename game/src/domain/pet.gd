class_name MaricaPet
extends RefCounted

# Identity-only Pet port (G420). Composite fields are assigned to G421-G428.
const PET_ID = preload("res://src/domain/pet_id.gd")
const SOULBOUND = preload("res://src/domain/soulbound.gd")

var _pet_id: String
var _soulbound: bool


func _init(validated_id: String, bound: bool = false) -> void:
    var checked: Dictionary = PET_ID.from_string(validated_id)
    assert(checked.get("ok", false), "MaricaPet must be constructed with a validated ID")
    _pet_id = validated_id
    _soulbound = bound


static func create(value: Variant, soulbound: Variant = null) -> Dictionary:
    var parsed: Dictionary = PET_ID.from_string(value)
    if not parsed.get("ok", false):
        return {"ok": false, "error": parsed.get("error", "Invalid PetId")}
    var checked: Dictionary = SOULBOUND.create(soulbound)
    if not checked.get("ok", false):
        return checked
    return {"ok": true, "pet": MaricaPet.new(parsed["id"], checked["soulbound"])}


func get_id() -> String:
    return _pet_id


func is_soulbound() -> bool:
    return _soulbound


func is_transferable() -> bool:
    return not _soulbound


func assert_transferable() -> Dictionary:
    return SOULBOUND.assert_transferable(_soulbound)


func to_snapshot() -> Dictionary:
    # Every caller gets a detached, serializable value; the Pet's ID has no public setter.
    return {"id": _pet_id, "soulbound": _soulbound}
