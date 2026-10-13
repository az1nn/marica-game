extends SceneTree

# G433 independent event-idempotency contract; durable restart safety is G445.
const PET = preload("res://src/domain/pet.gd")
const LIFE = preload("res://src/domain/lifecycle.gd")
const EVENT = preload("res://src/domain/succession_event.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if not _once_only_contract() or not _failed_then_retry_contract():
        quit(1)
        return
    print("MARICA_G433_IDEMPOTENCY_PASS")
    quit(0)


func _ended_parent(parent_id: String) -> MaricaPet:
    var life: MaricaLifecycle = LIFE.start()
    for stage in ["adult", "senior"]:
        var advanced: Dictionary = LIFE.advance(life, stage)
        if not advanced.get("ok", false):
            return null
        life = advanced["lifecycle"]
    var ended: Dictionary = LIFE.end_life(life, "natural")
    if not ended.get("ok", false):
        return null
    var created: Dictionary = PET.create_composite(
        parent_id,
        {"lineageId": "lineage-001", "generation": 0, "founderPetId": parent_id},
        ended["lifecycle"],
        {"resilience": 0.4, "size": 0.5}
    )
    if not created.get("ok", false):
        return null
    return created["pet"]


func _once_only_contract() -> bool:
    var parent: MaricaPet = _ended_parent("pet-founder-001")
    if parent == null:
        return _fail("terminal parent setup")
    var before: Dictionary = parent.to_snapshot()
    var event: MaricaSuccessionEvent = EVENT.new()
    var ids: Array = ["pet-child-001", "pet-child-002"]
    var first: Dictionary = event.trigger_once(parent, ids, 10)
    var second: Dictionary = event.trigger_once(parent, ids, 10)
    if (
        not first.get("ok", false)
        or not first.get("created", false)
        or not second.get("ok", false)
        or second.get("created", true)
        or event.completed_count() != 1
    ):
        return _fail("first/repeated trigger created duplicate succession")
    var pair: Array = first["successors"]
    var replay: Array = second["successors"]
    if (
        pair.size() != 2
        or replay.size() != 2
        or pair[0] != replay[0]
        or pair[1] != replay[1]
        or pair[0].get_id() != "pet-child-001"
        or pair[1].get_id() != "pet-child-002"
        or parent.to_snapshot() != before
    ):
        return _fail("replay identity, cardinality, or parent mutation")
    ids[0] = "input-mutated"
    replay.clear()
    pair[0].to_snapshot()["geneticPotential"]["size"] = 0.0
    var third: Dictionary = event.trigger_once(parent, ["pet-child-001", "pet-child-002"], 10)
    if (
        not third.get("ok", false)
        or third.get("created", true)
        or third["successors"].size() != 2
        or third["successors"][0] != pair[0]
        or event.completed_count() != 1
    ):
        return _fail("caller array or snapshot altered completed marker")
    return _replay_conflict_contract(event, parent)


func _replay_conflict_contract(event: MaricaSuccessionEvent, parent: MaricaPet) -> bool:
    for request in [
        [["other-001", "other-002"], 10],
        [["pet-child-001", "pet-child-002"], 11],
    ]:
        if event.trigger_once(parent, request[0], request[1]).get("ok", false):
            return _fail("conflicting event replay accepted")
    var modified: Dictionary = parent.with_affection(0.3)
    if (
        not modified.get("ok", false)
        or event.trigger_once(
            modified["pet"], ["pet-child-001", "pet-child-002"], 10
        ).get("ok", false)
        or event.completed_count() != 1
    ):
        return _fail("changed terminal parent was treated as same event")
    return true


func _failed_then_retry_contract() -> bool:
    var event: MaricaSuccessionEvent = EVENT.new()
    var parent: MaricaPet = _ended_parent("pet-founder-002")
    if parent == null:
        return _fail("retry terminal parent setup")
    var ids: Array = ["pet-child-003", "pet-child-004"]
    var rejected: Dictionary = event.trigger_once(parent, ids, 9007199254740991)
    if rejected.get("ok", false) or event.completed_count() != 0:
        return _fail("invalid seed created a partial record")
    var valid: Dictionary = event.trigger_once(parent, ids, 5)
    if (
        not valid.get("ok", false)
        or not valid.get("created", false)
        or valid["successors"].size() != 2
        or event.completed_count() != 1
    ):
        return _fail("failed call prevented safe retry")
    var active: Dictionary = PET.create_composite(
        "pet-active-001",
        {"lineageId": "l", "generation": 0, "founderPetId": "pet-active-001"},
        null,
        {"size": 0.5}
    )
    if (
        not active.get("ok", false)
        or event.trigger_once(active["pet"], ids, 5).get("ok", false)
        or event.trigger_once(null, ids, 5).get("ok", false)
        or event.completed_count() != 1
    ):
        return _fail("active/invalid parent accepted or event ledger changed")
    return true


func _fail(message: String) -> bool:
    push_error("MARICA_G433_FAIL " + message)
    return false
