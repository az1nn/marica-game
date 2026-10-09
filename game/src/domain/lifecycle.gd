class_name MaricaLifecycle
extends RefCounted

# G422: pure, deterministic state transitions. G423 owns elapsed-time simulation.
var _stage: String
var _status: String
var _end_reason: String


func _init(stage: String, status: String, end_reason: String) -> void:
    _stage = stage
    _status = status
    _end_reason = end_reason


static func start() -> MaricaLifecycle:
    return MaricaLifecycle.new("juvenile", "active", "")


static func advance(current: MaricaLifecycle, next_stage: Variant) -> Dictionary:
    if current == null or _stage_index(current._stage) == -1:
        return {"ok": false, "error": "Lifecycle stage is invalid"}
    var next_index: int = _stage_index(next_stage)
    if next_index == -1:
        return {"ok": false, "error": "Lifecycle stage is invalid"}
    if current._status != "active":
        return {"ok": false, "error": "Ended lifecycle cannot advance"}
    if next_index != _stage_index(current._stage) + 1:
        return {"ok": false, "error": "Lifecycle stages must advance exactly one step"}
    return {"ok": true, "lifecycle": MaricaLifecycle.new(next_stage, "active", "")}


static func end_life(current: MaricaLifecycle, reason: Variant) -> Dictionary:
    if current == null or _stage_index(current._stage) == -1:
        return {"ok": false, "error": "Lifecycle stage is invalid"}
    if current._status != "active":
        return {"ok": false, "error": "Ended lifecycle is terminal"}
    if reason != "natural" and reason != "health":
        return {"ok": false, "error": "Lifecycle end reason is invalid"}
    if reason == "natural" and current._stage != "senior":
        return {"ok": false, "error": "Natural end of life requires senior stage"}
    return {"ok": true, "lifecycle": MaricaLifecycle.new(current._stage, "ended", reason)}


static func _stage_index(value: Variant) -> int:
    if typeof(value) != TYPE_STRING:
        return -1
    match value:
        "juvenile":
            return 1
        "adult":
            return 2
        "senior":
            return 3
    return -1


func is_terminal() -> bool:
    return _status == "ended"


func to_snapshot() -> Dictionary:
    var snapshot: Dictionary = {"stage": _stage, "status": _status}
    if not _end_reason.is_empty():
        snapshot["endReason"] = _end_reason
    return snapshot
