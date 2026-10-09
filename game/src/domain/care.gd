class_name MaricaCare
extends RefCounted

# G425: pure, deterministic care-state port of Luau Care.new / quality / toExpressionFactors.
# Mutable Dictionary inputs never become the state object; snapshots are detached.
var _hunger: float
var _hygiene: float
var _affection: float
var _energy: float


func _init(hunger: float, hygiene: float, affection: float, energy: float) -> void:
    _hunger = hunger
    _hygiene = hygiene
    _affection = affection
    _energy = energy


static func create(values: Variant = null) -> Dictionary:
    var raw_values: Variant = {} if values == null else values
    if typeof(raw_values) != TYPE_DICTIONARY:
        return {"ok": false, "error": "Care must be a table"}
    var input_values: Dictionary = raw_values
    var defaults: Dictionary = {
        "hunger": 0.0,
        "hygiene": 1.0,
        "affection": 1.0,
        "energy": 1.0,
    }
    var validated: Dictionary = {}
    for field in defaults:
        var value: Variant = input_values.get(field, defaults[field])
        var result: Dictionary = _unit_value(value, "Care." + str(field))
        if not result.get("ok", false):
            return result
        validated[field] = result["value"]
    return {
        "ok": true,
        "care":
        MaricaCare.new(
            validated["hunger"], validated["hygiene"], validated["affection"], validated["energy"]
        ),
    }


func to_snapshot() -> Dictionary:
    return {
        "hunger": _hunger,
        "hygiene": _hygiene,
        "affection": _affection,
        "energy": _energy,
    }


static func quality(state: Variant) -> Dictionary:
    var normalized: Dictionary = _state_snapshot(state)
    if not normalized.get("ok", false):
        return normalized
    var snapshot: Dictionary = normalized["values"]
    var fed: float = 1.0 - float(snapshot["hunger"])
    var minimum: float = minf(
        fed,
        minf(
            float(snapshot["hygiene"]),
            minf(float(snapshot["affection"]), float(snapshot["energy"]))
        )
    )
    return {"ok": true, "quality": minimum}


static func to_expression_factors(state: Variant, potential: Variant) -> Dictionary:
    var quality_result: Dictionary = quality(state)
    if not quality_result.get("ok", false):
        return quality_result
    var potential_result: Dictionary = MaricaGenetics.new_potential(potential)
    if not potential_result.get("ok", false):
        return potential_result
    var factors: Dictionary = {}
    var potential_values: Dictionary = potential_result["traits"]
    for trait_name in potential_values:
        factors[trait_name] = quality_result["quality"]
    return {"ok": true, "factors": factors}


static func _state_snapshot(state: Variant) -> Dictionary:
    if state is MaricaCare:
        var care: MaricaCare = state
        return {"ok": true, "values": care.to_snapshot()}
    var created: Dictionary = create(state)
    if not created.get("ok", false):
        return created
    var care: MaricaCare = created["care"]
    return {"ok": true, "values": care.to_snapshot()}


static func _unit_value(value: Variant, label: String) -> Dictionary:
    if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
        return {"ok": false, "error": label + " must be a finite number"}
    var scalar: float = float(value)
    if is_nan(scalar) or is_inf(scalar):
        return {"ok": false, "error": label + " must be a finite number"}
    if scalar < 0.0 or scalar > 1.0:
        return {"ok": false, "error": label + " must be between 0 and 1"}
    return {"ok": true, "value": scalar}
