extends SceneTree

# G432 independent executable contract: exactly two successors per terminal parent.
# This does not prove G433 event idempotency, durable IDs or save integration.
const PET = preload("res://src/domain/pet.gd")
const LIFECYCLE = preload("res://src/domain/lifecycle.gd")
const SUCCESSION = preload("res://src/domain/succession.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if not _pair_contract() or not _rejection_contract():
        quit(1)
        return
    print("MARICA_G432_EXACTLY_TWO_PASS")
    quit(0)


func _ended_parent() -> MaricaPet:
    var life: MaricaLifecycle = LIFECYCLE.start()
    for next_stage in ["adult", "senior"]:
        var advanced: Dictionary = LIFECYCLE.advance(life, next_stage)
        if not advanced.get("ok", false):
            return null
        life = advanced["lifecycle"]
    var ended: Dictionary = LIFECYCLE.end_life(life, "natural")
    if not ended.get("ok", false):
        return null
    var parent: Dictionary = PET.create_composite(
        "pet-founder-001",
        {"lineageId": "lineage-001", "generation": 0, "founderPetId": "pet-founder-001"},
        ended["lifecycle"],
        {"resilience": 0.4, "size": 0.5},
        {"hunger": 0.85},
        {"neglectHours": 72, "untreatedHours": 12},
        true,
        0.8
    )
    if not parent.get("ok", false):
        return null
    return parent["pet"]


func _pair_contract() -> bool:
    var parent: MaricaPet = _ended_parent()
    if parent == null:
        return _fail("terminal parent setup")
    var before: Dictionary = parent.to_snapshot()
    var ids: Array = ["pet-child-001", "pet-child-002"]
    var result: Dictionary = SUCCESSION.create_successors(parent, ids, 0)
    var repeated: Dictionary = SUCCESSION.create_successors(parent, ids, 0)
    if not result.get("ok", false) or not repeated.get("ok", false):
        return _fail("pair creation failed")
    var children: Array = result["successors"]
    var replay: Array = repeated["successors"]
    if children.size() != 2 or replay.size() != 2:
        return _fail("expected exactly two successors")
    return _verify_pair_data(parent, before, ids, children, replay)


func _verify_pair_data(
    parent: MaricaPet, before: Dictionary, ids: Array, children: Array, replay: Array
) -> bool:
    if children[0] == children[1] or children[0] == replay[0]:
        return _fail("successor instances were shared")
    var first: Dictionary = children[0].to_snapshot()
    var second: Dictionary = children[1].to_snapshot()
    if (
        first != replay[0].to_snapshot()
        or second != replay[1].to_snapshot()
        or first["id"] != ids[0]
        or second["id"] != ids[1]
        or first["geneticPotential"] != {"resilience": 0.45, "size": 0.5}
        or second["geneticPotential"] != {"resilience": 0.4, "size": 0.55}
    ):
        return _fail("ordinals, identities, advancement or replay drifted")
    for child in children:
        var snapshot: Dictionary = child.to_snapshot()
        if (
            snapshot["pedigree"]["lineageId"] != "lineage-001"
            or snapshot["pedigree"]["founderPetId"] != "pet-founder-001"
            or snapshot["pedigree"]["generation"] != 1
            or snapshot["pedigree"]["parentPetIds"] != ["pet-founder-001"]
            or snapshot["lifecycle"] != {"stage": "juvenile", "status": "active"}
            or snapshot["affection"] != 0.0
            or snapshot["soulbound"] != false
            or snapshot["healthState"]["status"] != "healthy"
            or snapshot["careState"]["hunger"] != 0.0
        ):
            return _fail("pair ancestry or juvenile defaults drifted")
    first["pedigree"]["parentPetIds"].append("tampered")
    first["geneticPotential"]["size"] = 0.0
    if (
        children[0].to_snapshot()["pedigree"]["parentPetIds"] != ["pet-founder-001"]
        or children[1].to_snapshot() != second
        or parent.to_snapshot() != before
        or ids != ["pet-child-001", "pet-child-002"]
    ):
        return _fail("parent, sibling or input was mutated")
    return true


func _rejection_contract() -> bool:
    var parent: MaricaPet = _ended_parent()
    if parent == null:
        return _fail("rejection setup")
    var invalid_ids: Array = [
        null,
        [],
        ["one"],
        ["one", "two", "three"],
        ["dup", "dup"],
        ["pet-founder-001", "child"],
        ["child", "pet-founder-001"],
        [" ", "child"],
        ["child", " "],
        [1, "child"],
    ]
    for ids in invalid_ids:
        if SUCCESSION.create_successors(parent, ids, 0).get("ok", false):
            return _fail("invalid pair IDs accepted")
    var active: Dictionary = PET.create_composite(
        "active-parent",
        {"lineageId": "lineage-001", "generation": 0, "founderPetId": "active-parent"},
        null,
        {"resilience": 0.4, "size": 0.5}
    )
    if not active.get("ok", false):
        return _fail("active parent setup")
    if (
        SUCCESSION.create_successors(null, ["one", "two"], 0).get("ok", false)
        or SUCCESSION.create_successors(active["pet"], ["one", "two"], 0).get("ok", false)
        or SUCCESSION.create_successors(parent, ["one", "two"], -1).get("ok", false)
        or SUCCESSION.create_successors(parent, ["one", "two"], 9007199254740991).get("ok", false)
    ):
        return _fail("invalid parent or seed accepted")
    return true


func _fail(message: String) -> bool:
    push_error("MARICA_G432_FAIL " + message)
    return false
