class_name MaricaSaveMigration
extends RefCounted

# SPEC-004 G443: explicit migration harness. Only v1 is a ratified wire schema.
# No legacy v0 adapter exists; unknown versions must never be guessed or rewritten.
const VALIDATOR = preload("res://src/adapters/local/save_v1_validator.gd")
const CURRENT_VERSION: int = 1


static func migrate(source: Variant) -> Dictionary:
    var version: Dictionary = _source_version(source)
    if not version.get("ok", false):
        return version
    if version["schema_version"] != CURRENT_VERSION:
        return _unsupported(version["schema_version"])
    var checked: Dictionary = VALIDATOR.validate(source)
    if not checked.get("ok", false):
        return {"ok": false, "error": "Current v1 save is invalid: " + str(checked["error"])}
    return {
        "ok": true,
        "migrated": false,
        "from_version": CURRENT_VERSION,
        "to_version": CURRENT_VERSION,
        "document": checked["document"].duplicate(true)
    }


static func _source_version(source: Variant) -> Dictionary:
    if typeof(source) != TYPE_DICTIONARY:
        return {"ok": false, "error": "Migration source must be an object"}
    var envelope: Dictionary = source
    if not envelope.has("schema_version"):
        return {"ok": false, "error": "Missing schema_version; cannot infer legacy schema"}
    var raw: Variant = envelope["schema_version"]
    if typeof(raw) != TYPE_INT and typeof(raw) != TYPE_FLOAT:
        return {"ok": false, "error": "schema_version must be an exact nonnegative integer"}
    var number: float = float(raw)
    if is_nan(number) or is_inf(number) or number < 0.0 or number > 9007199254740991.0:
        return {"ok": false, "error": "schema_version outside safe integer range"}
    if floorf(number) != number:
        return {"ok": false, "error": "schema_version must be an integer"}
    return {"ok": true, "schema_version": int(number)}


static func _unsupported(version: int) -> Dictionary:
    # A migration edge requires a versioned source schema, fixtures and explicit approval.
    return {
        "ok": false,
        "error": "No approved migration path from schema_version " + str(version),
        "from_version": version,
        "to_version": CURRENT_VERSION,
        "requires_migration_contract": true
    }
