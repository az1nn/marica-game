class_name MaricaAffection
extends RefCounted

# G428: persistent bond is independent of momentary Care.affection.
# Return explicit error dictionaries for invalid persisted values and gains.


static func create(value: Variant = null) -> Dictionary:
    if value == null:
        return {"ok": true, "affection": 0.0}
    if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
        return {"ok": false, "error": "Affection must be a finite number"}
    var amount: float = float(value)
    if is_nan(amount) or is_inf(amount):
        return {"ok": false, "error": "Affection must be a finite number"}
    if amount < 0.0 or amount > 1.0:
        return {"ok": false, "error": "Affection must be between 0 and 1"}
    return {"ok": true, "affection": amount}


static func increase(state: Variant, gain: Variant) -> Dictionary:
    var validated: Dictionary = create(state)
    if not validated.get("ok", false):
        return validated
    if typeof(gain) != TYPE_INT and typeof(gain) != TYPE_FLOAT:
        return {"ok": false, "error": "Affection gain must be a finite number"}
    var delta: float = float(gain)
    if is_nan(delta) or is_inf(delta):
        return {"ok": false, "error": "Affection gain must be a finite number"}
    if delta < 0.0:
        return {"ok": false, "error": "Affection gain must not be negative"}
    var current: float = float(validated["affection"])
    return {"ok": true, "affection": minf(1.0, current + delta)}
