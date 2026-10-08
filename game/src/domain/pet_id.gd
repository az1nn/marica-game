extends RefCounted

# Pure identity contract ported from src/shared/domain/PetId.luau.
# Error results are explicit to keep deterministic tests independent of engine exceptions.


static func from_string(value: Variant) -> Dictionary:
    if typeof(value) != TYPE_STRING:
        return {"ok": false, "error": "PetId must be a string"}
    var text: String = value
    if text.strip_edges().is_empty():
        return {"ok": false, "error": "PetId must not be empty"}
    return {"ok": true, "id": text}


static func generate(generator: Callable) -> Dictionary:
    if not generator.is_valid():
        return {"ok": false, "error": "PetId generator must be a function"}
    return from_string(generator.call())
