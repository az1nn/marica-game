extends RefCounted

# Luau LineageId.fromString semantics, with deterministic explicit error results.


static func from_string(value: Variant) -> Dictionary:
    if typeof(value) != TYPE_STRING:
        return {"ok": false, "error": "LineageId must be a string"}
    var text: String = value
    if text.strip_edges().is_empty():
        return {"ok": false, "error": "LineageId must not be empty"}
    return {"ok": true, "id": text}


static func generate(generator: Callable) -> Dictionary:
    if not generator.is_valid():
        return {"ok": false, "error": "LineageId generator must be a function"}
    return from_string(generator.call())
