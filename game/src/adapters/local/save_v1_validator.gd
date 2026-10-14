class_name MaricaSaveV1Validator
extends RefCounted

# G441: native fail-closed validation of the G440 wire contract.
# This does not hydrate pet instances, replay events, or migrate a future version.
const MAX_SAFE_INTEGER: int = 9007199254740991


static func validate(snapshot: Variant) -> Dictionary:
    if not _fields(
        snapshot,
        ["schema_version", "revision", "last_observed_at", "pets", "succession_events"]
    ):
        return _fail("Save v1 envelope is invalid")
    var document: Dictionary = snapshot
    if typeof(document["schema_version"]) != TYPE_INT or document["schema_version"] != 1:
        return _fail("Unsupported schema_version")
    if not _integer(document["revision"]) or not _numeric(document["last_observed_at"]):
        return _fail("Save revision or clock is invalid")
    if typeof(document["pets"]) != TYPE_DICTIONARY:
        return _fail("Save pets must be a map")
    if typeof(document["succession_events"]) != TYPE_DICTIONARY:
        return _fail("Save succession events must be a map")
    var pets: Dictionary = document["pets"]
    for key in pets:
        if not _identifier(key) or not _pet(pets[key]):
            return _fail("Invalid pet record")
        var pet: Dictionary = pets[key]
        if pet["id"] != key:
            return _fail("Pet map key differs from Pet ID")
    for key in pets:
        if not _ancestry(pets, pets[key]):
            return _fail("Pet ancestry is inconsistent")
    if not _events(document["succession_events"], pets):
        return _fail("Succession event ledger is inconsistent")
    return {"ok": true, "document": document.duplicate(true)}


static func _events(events: Dictionary, pets: Dictionary) -> bool:
    var used_children: Dictionary = {}
    for parent_id in events:
        if not _identifier(parent_id) or not pets.has(parent_id):
            return false
        var entry: Variant = events[parent_id]
        if not _fields(entry, ["parent_snapshot", "successor_ids", "succession_seed"]):
            return false
        var marker: Dictionary = entry
        if not _integer(marker["succession_seed"]) or not _pet(marker["parent_snapshot"]):
            return false
        var parent: Dictionary = pets[parent_id]
        if marker["parent_snapshot"] != parent or parent["lifecycle"]["status"] != "ended":
            return false
        if typeof(marker["successor_ids"]) != TYPE_ARRAY:
            return false
        var children: Array = marker["successor_ids"]
        if children.size() != 2 or children[0] == children[1]:
            return false
        for child_id in children:
            if not _valid_event_child(pets, parent_id, child_id, used_children):
                return false
    return true


static func _valid_event_child(
    pets: Dictionary, parent_id: String, child_id: Variant, used: Dictionary
) -> bool:
    if not _identifier(child_id) or used.has(child_id) or not pets.has(child_id):
        return false
    used[child_id] = true
    var parent: Dictionary = pets[parent_id]
    var child: Dictionary = pets[child_id]
    var lineage: Dictionary = child["pedigree"]
    var previous: Dictionary = parent["pedigree"]
    return (
        child_id != parent_id
        and lineage["parentPetIds"] == [parent_id]
        and lineage["lineageId"] == previous["lineageId"]
        and lineage["founderPetId"] == previous["founderPetId"]
        and lineage["generation"] == previous["generation"] + 1
    )


static func _ancestry(pets: Dictionary, pet: Dictionary) -> bool:
    var pedigree: Dictionary = pet["pedigree"]
    var founder_id: String = pedigree["founderPetId"]
    if not pets.has(founder_id):
        return false
    var founder: Dictionary = pets[founder_id]
    if founder["pedigree"]["generation"] != 0:
        return false
    if founder["pedigree"]["lineageId"] != pedigree["lineageId"]:
        return false
    if pedigree["generation"] > 0 and pet["soulbound"]:
        return false
    for parent_id in pedigree["parentPetIds"]:
        if not pets.has(parent_id):
            return false
        var parent: Dictionary = pets[parent_id]
        var parent_pedigree: Dictionary = parent["pedigree"]
        if (
            parent_pedigree["generation"] >= pedigree["generation"]
            or parent_pedigree["lineageId"] != pedigree["lineageId"]
            or parent_pedigree["founderPetId"] != founder_id
        ):
            return false
    return true


static func _pet(value: Variant) -> bool:
    if not _fields(
        value,
        [
            "id", "soulbound", "affection", "pedigree", "lifecycle", "geneticPotential",
            "expressedTraits", "careState", "healthState"
        ]
    ):
        return false
    var pet: Dictionary = value
    if (
        not _identifier(pet["id"])
        or typeof(pet["soulbound"]) != TYPE_BOOL
        or not _unit(pet["affection"])
        or not _pedigree(pet["pedigree"])
        or not _lifecycle(pet["lifecycle"])
        or not _care(pet["careState"])
        or not _health(pet["healthState"])
    ):
        return false
    if not _traits(pet["geneticPotential"]) or not _traits(pet["expressedTraits"]):
        return false
    var potential: Dictionary = pet["geneticPotential"]
    var expressed: Dictionary = pet["expressedTraits"]
    if potential.size() != expressed.size():
        return false
    for trait in potential:
        if not expressed.has(trait) or float(expressed[trait]) > float(potential[trait]):
            return false
    return true


static func _pedigree(value: Variant) -> bool:
    if not _fields(value, ["lineageId", "generation", "founderPetId", "parentPetIds"]):
        return false
    var item: Dictionary = value
    if (
        not _identifier(item["lineageId"])
        or not _identifier(item["founderPetId"])
        or not _integer(item["generation"])
        or typeof(item["parentPetIds"]) != TYPE_ARRAY
    ):
        return false
    var parents: Array = item["parentPetIds"]
    if parents.size() > 2 or ((item["generation"] == 0) != parents.is_empty()):
        return false
    var used: Dictionary = {}
    for parent_id in parents:
        if not _identifier(parent_id) or used.has(parent_id):
            return false
        used[parent_id] = true
    return true


static func _lifecycle(value: Variant) -> bool:
    if typeof(value) != TYPE_DICTIONARY:
        return false
    var state: Dictionary = value
    if not state.has("status") or not state.has("stage"):
        return false
    var ended: bool = state["status"] == "ended"
    if state["status"] != "active" and not ended:
        return false
    if state["stage"] not in ["juvenile", "adult", "senior"]:
        return false
    if ended and state.get("endReason") not in ["natural", "health"]:
        return false
    return _fields(state, ["stage", "status"], ["endReason"] if ended else [])


static func _care(value: Variant) -> bool:
    if not _fields(value, ["hunger", "hygiene", "affection", "energy"]):
        return false
    var state: Dictionary = value
    for field in state:
        if not _unit(state[field]):
            return false
    return true


static func _health(value: Variant) -> bool:
    if not _fields(value, ["status", "neglectHours", "untreatedHours"]):
        return false
    var state: Dictionary = value
    return (
        state["status"] in ["healthy", "neglected", "sick", "critical"]
        and _numeric(state["neglectHours"])
        and _numeric(state["untreatedHours"])
    )


static func _traits(value: Variant) -> bool:
    if typeof(value) != TYPE_DICTIONARY:
        return false
    var traits: Dictionary = value
    for trait in traits:
        if not _identifier(trait) or not _unit(traits[trait]):
            return false
    return true


static func _fields(value: Variant, required: Array, optional: Array = []) -> bool:
    if typeof(value) != TYPE_DICTIONARY:
        return false
    var item: Dictionary = value
    for key in required:
        if not item.has(key):
            return false
    for key in item:
        if key not in required and key not in optional:
            return false
    return true


static func _identifier(value: Variant) -> bool:
    return typeof(value) == TYPE_STRING and not str(value).strip_edges().is_empty()


static func _integer(value: Variant) -> bool:
    return typeof(value) == TYPE_INT and value >= 0 and value <= MAX_SAFE_INTEGER


static func _unit(value: Variant) -> bool:
    return _numeric(value) and value <= 1.0


static func _numeric(value: Variant) -> bool:
    if typeof(value) != TYPE_FLOAT and typeof(value) != TYPE_INT:
        return false
    var scalar: float = float(value)
    return not is_nan(scalar) and not is_inf(scalar) and scalar >= 0.0


static func _fail(reason: String) -> Dictionary:
    return {"ok": false, "error": reason}
