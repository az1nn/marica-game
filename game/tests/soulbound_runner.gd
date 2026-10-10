extends SceneTree

# G427: independent Luau Soulbound contract regression for the founder and descendants.
const SOULBOUND = preload("res://src/domain/soulbound.gd")
const PET = preload("res://src/domain/pet.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if (
        not _defaults_and_types()
        or not _transfer_guard()
        or not _pet_binding_and_detachment()
        or not _descendant_is_not_implicitly_bound()
    ):
        quit(1)
        return
    print("MARICA_G427_SOULBOUND_PASS")
    quit(0)


func _defaults_and_types() -> bool:
    if SOULBOUND.create() != {"ok": true, "soulbound": false}:
        return _fail("legacy default must be false")
    if SOULBOUND.create(true) != {"ok": true, "soulbound": true}:
        return _fail("boolean true must be preserved")
    if SOULBOUND.create(false) != {"ok": true, "soulbound": false}:
        return _fail("boolean false must be preserved")
    for bad in ["true", "false", 0, 1, {}, []]:
        var rejected: Dictionary = SOULBOUND.create(bad)
        if rejected.get("ok", true) or rejected.get("error") != "Soulbound state must be a boolean":
            return _fail("invalid persisted soulbound value accepted")
    if PET.create("pet-invalid", "true").get("ok", true):
        return _fail("invalid persisted Pet binding must reject")
    return true


func _transfer_guard() -> bool:
    if SOULBOUND.is_transferable(null) != {"ok": true, "transferable": true}:
        return _fail("regular pets must be transferable")
    if SOULBOUND.is_transferable(true) != {"ok": true, "transferable": false}:
        return _fail("soulbound founder must not be transferable")
    if (
        SOULBOUND.assert_transferable(true)
        != {"ok": false, "error": "Soulbound pet cannot be transferred"}
    ):
        return _fail("assertTransferable must block soulbound pets")
    if SOULBOUND.assert_transferable(false) != {"ok": true, "transferable": true}:
        return _fail("assertTransferable must allow unbound pets")
    if SOULBOUND.assert_transferable("true").get("ok", true):
        return _fail("invalid persisted state must fail closed")
    return true


func _pet_binding_and_detachment() -> bool:
    var created: Dictionary = PET.create("pet-founder-001", true)
    if not created.get("ok", false):
        return _fail("founder with explicit binding cannot be created")
    var founder: MaricaPet = created["pet"]
    if not founder.is_soulbound() or founder.is_transferable():
        return _fail("bound founder incorrectly transferable")
    if founder.assert_transferable().get("ok", true):
        return _fail("bound founder transfer assertion must fail")
    var snapshot: Dictionary = founder.to_snapshot()
    if snapshot != {"id": "pet-founder-001", "soulbound": true}:
        return _fail("founder soulbound missing from detached snapshot")
    snapshot["soulbound"] = false
    snapshot["id"] = "pet-tampered"
    if not founder.is_soulbound() or founder.get_id() != "pet-founder-001":
        return _fail("mutating snapshot modified immutable founder identity/binding")
    var restored: Dictionary = PET.create("pet-founder-001", true)
    if not restored.get("ok", false) or not restored["pet"].is_soulbound():
        return _fail("restoration of explicit binding failed")
    return true


func _descendant_is_not_implicitly_bound() -> bool:
    var child_created: Dictionary = PET.create("pet-descendant-001")
    if not child_created.get("ok", false):
        return _fail("descendant could not be created")
    var child: MaricaPet = child_created["pet"]
    if child.is_soulbound() or not child.is_transferable():
        return _fail("descendant inherited founder binding without explicit assignment")
    if not child.assert_transferable().get("ok", false):
        return _fail("regular descendant must pass transfer assertion")
    return true


func _fail(message: String) -> bool:
    push_error("G427 soulbound: " + message)
    return false
