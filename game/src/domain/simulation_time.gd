class_name MaricaSimulationTime
extends RefCounted

# G423: pure observation of an injected clock, independent of wall time and SceneTree.


static func observe(clock: Callable, last_observed_at: Variant) -> Dictionary:
    if not clock.is_valid():
        return {"ok": false, "error": "Clock must provide now()"}

    var previous_result: Dictionary = _validate_timestamp(last_observed_at, "lastObservedAt")
    if not previous_result.get("ok", false):
        return previous_result

    var raw_result: Dictionary = _validate_timestamp(clock.call(), "Clock.now()")
    if not raw_result.get("ok", false):
        return raw_result

    var previous: float = previous_result["value"]
    var raw_now: float = raw_result["value"]
    var logical_now: float = maxf(raw_now, previous)
    return {
        "ok": true,
        "observation": {
            "rawNow": raw_now,
            "logicalNow": logical_now,
            "elapsed": logical_now - previous,
        },
    }


static func _validate_timestamp(value: Variant, label: String) -> Dictionary:
    if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
        return {"ok": false, "error": label + " must be a finite number"}
    var numeric: float = float(value)
    if is_nan(numeric) or is_inf(numeric):
        return {"ok": false, "error": label + " must be a finite number"}
    if numeric < 0.0:
        return {"ok": false, "error": label + " must not be negative"}
    return {"ok": true, "value": numeric}
