class_name MaricaOfflineReturn
extends RefCounted

# G447: commit observed offline time exactly once; no unapproved lifecycle simulation.
const TIME = preload("res://src/domain/simulation_time.gd")
const PETS = preload("res://src/adapters/local/pet_persistence.gd")


static func resume(store: MaricaLocalSaveStore, clock: Callable) -> Dictionary:
    var loaded: Dictionary = store.load()
    if not loaded.get("ok", false):
        return loaded
    if not loaded.get("found", false):
        return {"ok": false, "error": "Existing saved profile required"}
    var doc: Dictionary = loaded["snapshot"]
    var hydrated: Dictionary = PETS.hydrate(doc)
    if not hydrated.get("ok", false):
        return hydrated
    var observed: Dictionary = TIME.observe(clock, doc["last_observed_at"])
    if not observed.get("ok", false):
        return observed
    var elapsed: float = observed["observation"]["elapsed"]
    if elapsed == 0.0:
        return {
            "ok": true,
            "elapsed_seconds": 0.0,
            "revision": doc["revision"],
            "snapshot": doc.duplicate(true)
        }
    # Store.save performs the same monotonic observation, so pin its clock
    # to the already validated logical time and never sample wall clock twice.
    var logical_now: float = observed["observation"]["logicalNow"]
    var saved: Dictionary = store.save(
        doc, int(doc["revision"]), func() -> float: return logical_now
    )
    if not saved.get("ok", false):
        return saved
    return {
        "ok": true,
        "elapsed_seconds": elapsed,
        "revision": saved["revision"],
        "snapshot": saved["snapshot"].duplicate(true)
    }
