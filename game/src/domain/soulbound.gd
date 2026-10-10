class_name MaricaSoulbound
extends RefCounted

# G427: Luau Soulbound.new/isTransferable/assertTransferable, with explicit errors.
# Null maps to the legacy optional default false; persisted non-booleans fail closed.


static func create(value: Variant = null) -> Dictionary:
    if value == null:
        return {"ok": true, "soulbound": false}
    if typeof(value) != TYPE_BOOL:
        return {"ok": false, "error": "Soulbound state must be a boolean"}
    return {"ok": true, "soulbound": value}


static func is_transferable(value: Variant) -> Dictionary:
    var state: Dictionary = create(value)
    if not state.get("ok", false):
        return state
    return {"ok": true, "transferable": not bool(state["soulbound"])}


static func assert_transferable(value: Variant) -> Dictionary:
    var status: Dictionary = is_transferable(value)
    if not status.get("ok", false):
        return status
    if not status["transferable"]:
        return {"ok": false, "error": "Soulbound pet cannot be transferred"}
    return {"ok": true, "transferable": true}
