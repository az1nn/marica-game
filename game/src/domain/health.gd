class_name MaricaHealth
extends RefCounted

# G426: Luau Health state is pure, deterministic, and detached from input dictionaries.
const NEGLECTED_AT_HOURS: float = 24.0
const SICK_AT_HOURS: float = 48.0
const CRITICAL_AT_HOURS: float = 72.0
const TERMINAL_UNTREATED_HOURS: float = 48.0
const NEGLECT_QUALITY_THRESHOLD: float = 0.5
const RECOVERY_QUALITY_THRESHOLD: float = 0.75

var _neglect_hours: float
var _untreated_hours: float
var _status: String


func _init(neglect_hours: float, untreated_hours: float) -> void:
    _neglect_hours = neglect_hours
    _status = _derive_status(neglect_hours)
    _untreated_hours = (
        0.0 if _status in ["healthy", "neglected"] else untreated_hours
    )


func to_snapshot() -> Dictionary:
    return {
        "status": _status,
        "neglectHours": _neglect_hours,
        "untreatedHours": _untreated_hours,
    }


static func create(values: Variant = null) -> Dictionary:
    if values is MaricaHealth:
        var existing: MaricaHealth = values
        values = existing.to_snapshot()
    var raw_values: Variant = {} if values == null else values
    if typeof(raw_values) != TYPE_DICTIONARY:
        return {"ok": false, "error": "Health must be a table"}
    var input_values: Dictionary = raw_values
    var neglect: Dictionary = _nonnegative_hours(
        input_values.get("neglectHours", 0.0), "Health.neglectHours"
    )
    if not neglect.get("ok", false):
        return neglect
    var untreated: Dictionary = _nonnegative_hours(
        input_values.get("untreatedHours", 0.0), "Health.untreatedHours"
    )
    if not untreated.get("ok", false):
        return untreated
    return {
        "ok": true,
        "health": MaricaHealth.new(neglect["hours"], untreated["hours"]),
    }


static func advance(state: Variant, care_state: Variant, elapsed_hours: Variant) -> Dictionary:
    var parsed: Dictionary = create(state)
    if not parsed.get("ok", false):
        return parsed
    var elapsed: Dictionary = _nonnegative_hours(elapsed_hours, "elapsedHours")
    if not elapsed.get("ok", false):
        return elapsed
    var quality: Dictionary = MaricaCare.quality(care_state)
    if not quality.get("ok", false):
        return quality
    var current: MaricaHealth = parsed["health"]
    var hours: float = elapsed["hours"]
    var care_quality: float = quality["quality"]
    var next_neglect: float = current._neglect_hours

    if care_quality < NEGLECT_QUALITY_THRESHOLD:
        next_neglect += hours
    elif (
        current._status in ["healthy", "neglected"]
        and care_quality >= RECOVERY_QUALITY_THRESHOLD
    ):
        next_neglect = maxf(0.0, next_neglect - hours)

    var next_status: String = _derive_status(next_neglect)
    var next_untreated: float = current._untreated_hours
    if next_status in ["sick", "critical"]:
        if current._status in ["sick", "critical"]:
            next_untreated += hours
        elif care_quality < NEGLECT_QUALITY_THRESHOLD:
            next_untreated += maxf(0.0, next_neglect - SICK_AT_HOURS)
    else:
        next_untreated = 0.0

    if is_inf(next_neglect) or is_inf(next_untreated):
        return {"ok": false, "error": "Health durations must be finite"}
    return {"ok": true, "health": MaricaHealth.new(next_neglect, next_untreated)}


static func treat(state: Variant, treatment: Variant) -> Dictionary:
    var parsed: Dictionary = create(state)
    if not parsed.get("ok", false):
        return parsed
    var reductions: Dictionary = {"basic": 24.0, "advanced": 48.0, "emergency": 96.0}
    var costs: Dictionary = {"basic": 10, "advanced": 30, "emergency": 75}
    if typeof(treatment) != TYPE_STRING or not reductions.has(treatment):
        return {"ok": false, "error": "Health treatment is invalid"}
    var current: MaricaHealth = parsed["health"]
    if current._status == "healthy":
        return {"ok": false, "error": "Healthy pet does not require treatment"}
    var remainder: float = maxf(0.0, current._neglect_hours - reductions[treatment])
    return {
        "ok": true,
        "health": MaricaHealth.new(remainder, 0.0),
        "cost": costs[treatment],
    }


static func is_terminal_risk(state: Variant) -> Dictionary:
    var parsed: Dictionary = create(state)
    if not parsed.get("ok", false):
        return parsed
    var current: MaricaHealth = parsed["health"]
    var terminal: bool = (
        current._status == "critical"
        and current._untreated_hours >= TERMINAL_UNTREATED_HOURS
    )
    return {"ok": true, "terminal": terminal}


static func _derive_status(neglect_hours: float) -> String:
    if neglect_hours >= CRITICAL_AT_HOURS:
        return "critical"
    if neglect_hours >= SICK_AT_HOURS:
        return "sick"
    if neglect_hours >= NEGLECTED_AT_HOURS:
        return "neglected"
    return "healthy"


static func _nonnegative_hours(value: Variant, label: String) -> Dictionary:
    if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
        return {"ok": false, "error": label + " must be a finite number"}
    var hours: float = float(value)
    if is_nan(hours) or is_inf(hours):
        return {"ok": false, "error": label + " must be a finite number"}
    if hours < 0.0:
        return {"ok": false, "error": label + " must not be negative"}
    return {"ok": true, "hours": hours}
