class_name MaricaGenetics
extends RefCounted

# G424: Luau Genetics.newPotential and Genetics.express, without G430 advancement.


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
                "error": "Expression factor references unknown trait \"" + str(raw_name) + "\"",
            }

    var expressed: Dictionary = {}
    for raw_name in potential_map:
        var factor: float = float(factor_map.get(raw_name, 1.0))
        expressed[raw_name] = float(potential_map[raw_name]) * factor
    return {"ok": true, "traits": expressed}


static func _copy_traits(values: Variant, label: String) -> Dictionary:
    if typeof(values) != TYPE_DICTIONARY:
        return {"ok": false, "error": label + " must be a table"}
    var copy: Dictionary = {}
    var input: Dictionary = values
    for raw_name in input:
        if typeof(raw_name) != TYPE_STRING or str(raw_name).strip_edges().is_empty():
            return {"ok": false, "error": label + " trait name must be a non-empty string"}
        var trait: String = str(raw_name)
        var scalar_result: Dictionary = _unit_value(input[raw_name], label + "." + trait)
        if not scalar_result.get("ok", false):
            return scalar_result
        copy[trait] = scalar_result["value"]
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
