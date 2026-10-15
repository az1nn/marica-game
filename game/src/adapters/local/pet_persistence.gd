class_name MaricaPetPersistence
extends RefCounted

# G444: validate a complete G440 envelope before any Pet is exposed.
# G445 durable replay and G446 process-restart are deliberately not implemented.
const VALIDATOR = preload("res://src/adapters/local/save_v1_validator.gd")
const MIGRATION = preload("res://src/adapters/local/save_migration.gd")
const PET = preload("res://src/domain/pet.gd")


static func hydrate(source: Variant) -> Dictionary:
    var admitted: Dictionary = MIGRATION.migrate(source)
    if not admitted.get("ok", false):
        return admitted
    var document: Dictionary = admitted["document"]
    var pets: Dictionary = {}
    for pet_id in document["pets"]:
        var restored: Dictionary = PET.from_snapshot(document["pets"][pet_id])
        if not restored.get("ok", false):
            return {"ok": false, "error": "Pet hydration failed: " + str(pet_id)}
        pets[pet_id] = restored["pet"]
    return {
        "ok": true,
        "pets": pets,
        "revision": document["revision"],
        "last_observed_at": document["last_observed_at"],
        "succession_events": document["succession_events"].duplicate(true)
    }


static func serialize(pets: Variant, previous: Variant) -> Dictionary:
    var admitted: Dictionary = MIGRATION.migrate(previous)
    if not admitted.get("ok", false):
        return admitted
    if typeof(pets) != TYPE_DICTIONARY:
        return {"ok": false, "error": "Pet aggregate must be a dictionary"}
    var document: Dictionary = admitted["document"]
    var snapshots: Dictionary = {}
    for pet_id in pets:
        var pet: Variant = pets[pet_id]
        if typeof(pet_id) != TYPE_STRING or not (pet is MaricaPet):
            return {"ok": false, "error": "Invalid Pet aggregate"}
        if not pet.is_composite() or pet.get_id() != pet_id:
            return {"ok": false, "error": "Pet ID or composite state mismatch"}
        snapshots[pet_id] = pet.to_snapshot()
    document["pets"] = snapshots
    # G440 requires the frozen parent marker to match the persisted parent exactly.
    # Compare canonical JSON values before normalization; never repair a mismatch.
    var events: Dictionary = document["succession_events"]
    for parent_id in events:
        var marker: Dictionary = events[parent_id]
        if not snapshots.has(parent_id):
            return {"ok": false, "error": "Succession parent missing"}
        var frozen: Variant = JSON.parse_string(JSON.stringify(marker["parent_snapshot"]))
        var current: Variant = JSON.parse_string(JSON.stringify(snapshots[parent_id]))
        if frozen != current:
            return {"ok": false, "error": "Frozen parent differs from persisted aggregate"}
        marker["parent_snapshot"] = snapshots[parent_id].duplicate(true)
    var checked: Dictionary = VALIDATOR.validate(document)
    if not checked.get("ok", false):
        return checked
    return {"ok": true, "document": checked["document"]}
