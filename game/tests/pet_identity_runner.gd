extends SceneTree

const PET = preload("res://src/domain/pet.gd")
const PET_ID = preload("res://src/domain/pet_id.gd")


func _initialize() -> void:
    call_deferred("_run_identity_tests")


func _run_identity_tests() -> void:
    if not _check_pet_creation():
        quit(1)
        return
    if not _check_rejections():
        quit(1)
        return
    if not _check_generation():
        quit(1)
        return
    print("MARICA_G420_PET_IDENTITY_PASS")
    quit(0)


func _check_pet_creation() -> bool:
    var created: Dictionary = PET.create(" pet-001 ")
    if not created.get("ok", false):
        push_error("G420 Pet.create failed for valid ID")
        return false
    var pet: MaricaPet = created["pet"]
    if pet.get_id() != " pet-001 ":
        push_error("G420 Pet ID must preserve source bytes, including valid whitespace")
        return false
    var snapshot: Dictionary = pet.to_snapshot()
    snapshot["id"] = "tampered"
    if pet.get_id() != " pet-001 " or pet.to_snapshot()["id"] != " pet-001 ":
        push_error("G420 exposed snapshot mutation to Pet identity")
        return false
    return true


func _check_rejections() -> bool:
    var invalid: Dictionary = PET.create("  \t ")
    if invalid.get("ok", true) or invalid.get("error") != "PetId must not be empty":
        push_error("G420 Pet accepted invalid whitespace-only identity")
        return false
    var non_string: Dictionary = PET_ID.from_string(17)
    if non_string.get("ok", true) or non_string.get("error") != "PetId must be a string":
        push_error("G420 PetId accepted non-string identity")
        return false
    return true


func _check_generation() -> bool:
    var result: Dictionary = PET_ID.generate(Callable(self, "_fixed_id"))
    if not result.get("ok", false) or result.get("id") != "pet-generated":
        push_error("G420 deterministic callable ID generation failed")
        return false
    var invalid: Dictionary = PET_ID.generate(Callable())
    if invalid.get("ok", true) or invalid.get("error") != "PetId generator must be a function":
        push_error("G420 invalid generator was accepted")
        return false
    return true


func _fixed_id() -> String:
    return "pet-generated"
