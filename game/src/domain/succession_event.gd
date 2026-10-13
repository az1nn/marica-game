class_name MaricaSuccessionEvent
extends RefCounted

# G433: single-process, once-only coordinator for an ended composite pet.
# G440/G445 own durable serialization, reload safety and atomic save boundaries.
const SUCCESSION = preload("res://src/domain/succession.gd")

var _completed: Dictionary = {}


func trigger_once(parent: Variant, successor_ids: Variant, succession_seed: Variant) -> Dictionary:
    if not (parent is MaricaPet):
        return {"ok": false, "error": "Succession event parent must be a Pet"}
    var pet: MaricaPet = parent
    if not pet.is_composite() or pet.is_active():
        return {"ok": false, "error": "Succession event requires an ended composite Pet"}

    var parent_id: String = pet.get_id()
    var snapshot: Dictionary = pet.to_snapshot()
    if _completed.has(parent_id):
        var previous: Dictionary = _completed[parent_id]
        if (
            previous["parent"] != snapshot
            or previous["ids"] != successor_ids
            or previous["seed"] != succession_seed
        ):
            return {"ok": false, "error": "Conflicting replay for ended Pet"}
        # Return the original two immutable aggregate objects, never generate another pair.
        # Copy only the caller-facing array; callers cannot alter the internal event record.
        return {
            "ok": true, "created": false, "successors": previous["successors"].duplicate()
        }

    # Transaction boundary: no completed marker is published on any failed creation.
    var created: Dictionary = SUCCESSION.create_successors(pet, successor_ids, succession_seed)
    if not created.get("ok", false):
        return created
    var pair: Array = created["successors"]
    _completed[parent_id] = {
        "parent": snapshot,
        "ids": successor_ids.duplicate(true),
        "seed": succession_seed,
        "successors": pair.duplicate(),
    }
    return {"ok": true, "created": true, "successors": pair.duplicate()}


func completed_count() -> int:
    return _completed.size()
