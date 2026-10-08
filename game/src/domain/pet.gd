class_name MaricaPet
extends RefCounted

# Identity-only Pet port (G420). Composite fields are assigned to G421-G428.
const PET_ID = preload("res://src/domain/pet_id.gd")

var _pet_id: String


func _init(validated_id: String) -> void:
    var checked: Dictionary = PET_ID.from_string(validated_id)
    assert(checked.get("ok", false), "MaricaPet must be constructed with a validated ID")
    _pet_id = validated_id


static func create(value: Variant) -> Dictionary:
    var parsed: Dictionary = PET_ID.from_string(value)
    if not parsed.get("ok", false):
        return {"ok": false, "error": parsed.get("error", "Invalid PetId")}
    return {"ok": true, "pet": MaricaPet.new(parsed["id"])}


func get_id() -> String:
    return _pet_id


func to_snapshot() -> Dictionary:
    # Every caller gets a detached, serializable value; the Pet's ID has no public setter.
    return {"id": _pet_id}
