class_name MaricaGenetics
extends RefCounted

# G424/G430: deterministic Luau potential, expression, and seeded advancement parity.
const ADVANCEMENT_STEP: float = 0.05


static func new_potential(values: Variant) -> Dictionary:
    return _copy_traits(values, "Genetic potential")


static func express(potential: Variant, factors: Variant = null) -> Dictionary:
    var potential_result: Dictionary = _copy_traits(potential, "Genetic potential")
    if not potential_result.get("ok", false):
        return potential_result

    var input_factors: Variant = {} if factors == null else factors
    var factor_result: Dictionary = _copy_traits(input_factors, "Expression factors")
    if not factor_result.get("ok", false):
        return factor_result

    var potential_map: Dictionary = potential_result["traits"]
    var factor_map: Dictionary = factor_result["traits"]
    for raw_name in factor_map:
        if not potential_map.has(raw_name):
            return {
                "ok": false,
                "error": 'Expression factor references unknown trait "' + str(raw_name) + '"',
            }

    var expressed: Dictionary = {}
    for raw_name in potential_map:
        var factor: float = float(factor_map.get(raw_name, 1.0))
        expressed[raw_name] = float(potential_map[raw_name]) * factor
    return {"ok": true, "traits": expressed}


static func advance_potential(potential: Variant, seed: Variant) -> Dictionary:
    var potential_result: Dictionary = _copy_traits(potential, "Genetic potential")
    if not potential_result.get("ok", false):
        return potential_result

    var seed_result: Dictionary = _validate_seed(seed)
    if not seed_result.get("ok", false):
        return seed_result

    var traits: Dictionary = potential_result["traits"]
    if traits.is_empty():
        return {
            "ok": false,
            "error": "Genetic potential must contain at least one trait for guaranteed advancement",
        }

    var names: Array = traits.keys()
    names.sort()
    var start_index: int = int(fposmod(float(seed_result["value"]), float(names.size())))
    var advanced: Dictionary = traits.duplicate()
    for offset in range(names.size()):
        var selected: String = str(names[(start_index + offset) % names.size()])
        if float(traits[selected]) < 1.0:
            advanced[selected] = minf(1.0, float(traits[selected]) + ADVANCEMENT_STEP)
            break
    return {"ok": true, "traits": advanced}


static func _validate_seed(seed: Variant) -> Dictionary:
    if typeof(seed) != TYPE_FLOAT and typeof(seed) != TYPE_INT:
        return {"ok": false, "error": "Genetic advancement seed must be a finite number"}
    var scalar: float = float(seed)
    if is_nan(scalar) or is_inf(scalar):
        return {"ok": false, "error": "Genetic advancement seed must be a finite number"}
    if scalar < 0.0 or floorf(scalar) != scalar:
        return {"ok": false, "error": "Genetic advancement seed must be a non-negative integer"}
    return {"ok": true, "value": scalar}


static func _copy_traits(values: Variant, label: String) -> Dictionary:
    if typeof(values) != TYPE_DICTIONARY:
        return {"ok": false, "error": label + " must be a table"}
    var copy: Dictionary = {}
    var trait_values: Dictionary = values
    for raw_name in trait_values:
        if typeof(raw_name) != TYPE_STRING or str(raw_name).strip_edges().is_empty():
            return {"ok": false, "error": label + " trait name must be a non-empty string"}
        var trait_name: String = str(raw_name)
        var scalar_result: Dictionary = _unit_value(
            trait_values[raw_name], label + "." + trait_name
        )
        if not scalar_result.get("ok", false):
            return scalar_result
        copy[trait_name] = scalar_result["value"]
    return {"ok": true, "traits": copy}


static func _unit_value(value: Variant, label: String) -> Dictionary:
    if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
        return {"ok": false, "error": label + " must be a finite number"}
    var scalar: float = float(value)
    if is_nan(scalar) or is_inf(scalar):
        return {"ok": false, "error": label + " must be a finite number"}
    if scalar < 0.0 or scalar > 1.0:
        return {"ok": false, "error": label + " must be between 0 and 1"}
    return {"ok": true, "value": scalar}
