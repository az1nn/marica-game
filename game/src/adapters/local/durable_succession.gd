class_name MaricaDurableSuccession
extends RefCounted

const PETS = preload("res://src/adapters/local/pet_persistence.gd")
const SUCCESSION = preload("res://src/domain/succession.gd")


static func trigger(
    store: MaricaLocalSaveStore, parent_id: Variant, ids: Variant, seed: Variant, clock: Callable
) -> Dictionary:
    var loaded: Dictionary = store.load()
    if not loaded.get("ok", false):
        return loaded
    if not loaded.get("found", false):
        return {"ok": false, "error": "Existing saved profile required"}
    var doc: Dictionary = loaded["snapshot"]
    var hydrated: Dictionary = PETS.hydrate(doc)
    if not hydrated.get("ok", false):
        return hydrated
    if typeof(parent_id) != TYPE_STRING or not hydrated["pets"].has(parent_id):
        return {"ok": false, "error": "Unknown parent"}
    var parent: MaricaPet = hydrated["pets"][parent_id]
    if doc["succession_events"].has(parent_id):
        return _replay(doc, parent, ids, seed)
    return _create(store, doc, hydrated["pets"], parent, ids, seed, clock)


static func _replay(doc: Dictionary, parent: MaricaPet, ids: Variant, seed: Variant) -> Dictionary:
    var marker: Dictionary = doc["succession_events"][parent.get_id()]
    if (
        typeof(ids) != TYPE_ARRAY
        or marker["successor_ids"] != ids
        or marker["succession_seed"] != seed
        or (
            JSON.parse_string(JSON.stringify(marker["parent_snapshot"]))
            != JSON.parse_string(JSON.stringify(parent.to_snapshot()))
        )
    ):
        return {"ok": false, "error": "Conflicting durable replay"}
    var restored: Dictionary = PETS.hydrate(doc)
    if not restored.get("ok", false):
        return restored
    var pair: Array = []
    for child_id in marker["successor_ids"]:
        pair.append(restored["pets"][child_id])
    return {"ok": true, "created": false, "successors": pair, "revision": doc["revision"]}


static func _create(
    store: MaricaLocalSaveStore,
    doc: Dictionary,
    pets: Dictionary,
    parent: MaricaPet,
    ids: Variant,
    seed: Variant,
    clock: Callable
) -> Dictionary:
    var generated: Dictionary = SUCCESSION.create_successors(parent, ids, seed)
    if not generated.get("ok", false):
        return generated
    var pair: Array = generated["successors"]
    for child in pair:
        if pets.has(child.get_id()):
            return {"ok": false, "error": "Existing successor ID"}
        pets[child.get_id()] = child
    var candidate: Dictionary = doc.duplicate(true)
    for child in pair:
        candidate["pets"][child.get_id()] = child.to_snapshot()
    candidate["succession_events"][parent.get_id()] = {
        "parent_snapshot": doc["pets"][parent.get_id()].duplicate(true),
        "successor_ids": ids.duplicate(true),
        "succession_seed": seed
    }
    var serialized: Dictionary = PETS.serialize(pets, candidate)
    if not serialized.get("ok", false):
        return serialized
    var saved: Dictionary = store.save(serialized["document"], int(doc["revision"]), clock)
    if not saved.get("ok", false):
        return saved
    return {
        "ok": true,
        "created": true,
        "successors": pair.duplicate(),
        "revision": saved["snapshot"]["revision"]
    }
