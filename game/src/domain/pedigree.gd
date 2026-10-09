class_name MaricaPedigree
extends RefCounted

# G421: self-contained deterministic pedigree record. G422+ own life state.
const LINEAGE_ID = preload("res://src/domain/lineage_id.gd")
const PET_ID = preload("res://src/domain/pet_id.gd")

var _lineage_id: String
var _generation: int
var _founder_pet_id: String
var _parent_pet_ids: Array[String]


func _init(lineage: String, generation: int, founder: String, parents: Array[String]) -> void:
    _lineage_id = lineage
    _generation = generation
    _founder_pet_id = founder
    _parent_pet_ids = parents.duplicate()


static func create(args: Dictionary) -> Dictionary:
    var lineage: Dictionary = LINEAGE_ID.from_string(args.get("lineageId"))
    if not lineage.get("ok", false):
        return lineage
    var founder: Dictionary = PET_ID.from_string(args.get("founderPetId"))
    if not founder.get("ok", false):
        return founder

    var raw_generation: Variant = args.get("generation")
    if not _valid_generation(raw_generation):
        return {"ok": false, "error": "Pedigree generation must be a non-negative integer"}
    var generation: int = int(raw_generation)

    var checked: Dictionary = _validate_parents(args.get("parentPetIds", []))
    if not checked.get("ok", false):
        return checked
    var parents: Array[String] = checked["parents"]
    if generation == 0 and not parents.is_empty():
        return {"ok": false, "error": "Generation zero pedigree must not have parents"}
    if generation > 0 and parents.is_empty():
        return {"ok": false, "error": "Descendant pedigree must have at least one direct parent"}

    var pedigree: MaricaPedigree = MaricaPedigree.new(
        lineage["id"], generation, founder["id"], parents
    )
    return {"ok": true, "pedigree": pedigree}


static func _valid_generation(value: Variant) -> bool:
    if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
        return false
    var number: float = float(value)
    if is_nan(number) or is_inf(number) or number < 0:
        return false
    return number == floor(number) and number < 9223372036854775807.0


static func _validate_parents(values: Variant) -> Dictionary:
    if typeof(values) != TYPE_ARRAY:
        return {"ok": false, "error": "Pedigree parent ids must be an array"}
    var parents: Array[String] = []
    var seen: Dictionary = {}
    for raw_id in values:
        var valid: Dictionary = PET_ID.from_string(raw_id)
        if not valid.get("ok", false):
            return valid
        var parent_id: String = valid["id"]
        if seen.has(parent_id):
            return {"ok": false, "error": "Pedigree parent ids must be unique"}
        seen[parent_id] = true
        parents.append(parent_id)
    if parents.size() > 2:
        return {"ok": false, "error": "Pedigree supports at most two direct parents"}
    return {"ok": true, "parents": parents}


func to_snapshot() -> Dictionary:
    return {
        "lineageId": _lineage_id,
        "generation": _generation,
        "founderPetId": _founder_pet_id,
        "parentPetIds": _parent_pet_ids.duplicate()
    }


func get_lineage_id() -> String:
    return _lineage_id


func get_generation() -> int:
    return _generation


func get_founder_pet_id() -> String:
    return _founder_pet_id


func get_parent_ids() -> Array[String]:
    return _parent_pet_ids.duplicate()
