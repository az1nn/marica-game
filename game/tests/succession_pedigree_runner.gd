extends SceneTree

# G434: independent multigeneration pedigree regression (not save/restart parity).
const PET = preload("res://src/domain/pet.gd")
const LIFE = preload("res://src/domain/lifecycle.gd")
const EVENT = preload("res://src/domain/succession_event.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if not _multigeneration_contract():
        quit(1)
        return
    print("MARICA_G434_MULTIGENERATION_PEDIGREE_PASS")
    quit(0)


func _end_pet(pet: MaricaPet) -> MaricaPet:
    var life: MaricaLifecycle = LIFE.start()
    for stage in ["adult", "senior"]:
        var advanced: Dictionary = LIFE.advance(life, stage)
        if not advanced.get("ok", false):
            return null
        life = advanced["lifecycle"]
    var ended: Dictionary = LIFE.end_life(life, "natural")
    if not ended.get("ok", false):
        return null
    var updated: Dictionary = pet.with_lifecycle(ended["lifecycle"])
    if not updated.get("ok", false):
        return null
    return updated["pet"]


func _founder() -> MaricaPet:
    var created: Dictionary = PET.create_composite(
        "dog-founder",
        {"lineageId": "dog-line", "generation": 0, "founderPetId": "dog-founder"},
        null,
        {"resilience": 0.4, "size": 0.5},
        null,
        null,
        true,
        0.9
    )
    if not created.get("ok", false):
        return null
    return _end_pet(created["pet"])


func _multigeneration_contract() -> bool:
    var founder: MaricaPet = _founder()
    if founder == null:
        return _fail("founder setup")
    var original: Dictionary = founder.to_snapshot()
    var event: MaricaSuccessionEvent = EVENT.new()
    var g1_result: Dictionary = event.trigger_once(founder, ["dog-g1a", "dog-g1b"], 10)
    if not g1_result.get("ok", false) or not g1_result.get("created", false):
        return _fail("first generation creation")
    var g1: Array = g1_result["successors"]
    if g1.size() != 2:
        return _fail("first generation cardinality")

    var ended_g1a: MaricaPet = _end_pet(g1[0])
    var ended_g1b: MaricaPet = _end_pet(g1[1])
    if ended_g1a == null or ended_g1b == null:
        return _fail("first generation terminal transitions")
    var g1a_before: Dictionary = ended_g1a.to_snapshot()
    var g2a_result: Dictionary = event.trigger_once(ended_g1a, ["dog-g2a", "dog-g2b"], 12)
    var g2b_result: Dictionary = event.trigger_once(ended_g1b, ["dog-g2c", "dog-g2d"], 14)
    if not g2a_result.get("ok", false) or not g2b_result.get("ok", false):
        return _fail("second generation creation")
    var g2a: Array = g2a_result["successors"]
    var g2b: Array = g2b_result["successors"]
    if g2a.size() != 2 or g2b.size() != 2:
        return _fail("second generation cardinality")

    var ended_g2a: MaricaPet = _end_pet(g2a[0])
    if ended_g2a == null:
        return _fail("second generation terminal transition")
    var g2a_before: Dictionary = ended_g2a.to_snapshot()
    var g3_result: Dictionary = event.trigger_once(ended_g2a, ["dog-g3a", "dog-g3b"], 16)
    if not g3_result.get("ok", false):
        return _fail("third generation creation")
    var g3: Array = g3_result["successors"]
    if g3.size() != 2 or event.completed_count() != 4:
        return _fail("third generation cardinality/event count")

    var checks: Array = [
        [g1[0], 1, "dog-founder"],
        [g1[1], 1, "dog-founder"],
        [g2a[0], 2, "dog-g1a"],
        [g2a[1], 2, "dog-g1a"],
        [g2b[0], 2, "dog-g1b"],
        [g2b[1], 2, "dog-g1b"],
        [g3[0], 3, "dog-g2a"],
        [g3[1], 3, "dog-g2a"],
    ]
    for item in checks:
        var child: MaricaPet = item[0]
        var pedigree: Dictionary = child.to_snapshot()["pedigree"]
        if (
            pedigree
            != {
                "lineageId": "dog-line",
                "generation": item[1],
                "founderPetId": "dog-founder",
                "parentPetIds": [item[2]],
            }
        ):
            return _fail("direct-parent link or founder continuity")

    var records: Dictionary = {"dog-founder": original["pedigree"]}
    for pet in [g1[0], g1[1], g2a[0], g2a[1], g2b[0], g2b[1], g3[0], g3[1]]:
        var snapshot: Dictionary = pet.to_snapshot()
        records[snapshot["id"]] = snapshot["pedigree"]
    if (
        _trace_to_founder("dog-g3a", records) != ["dog-g3a", "dog-g2a", "dog-g1a", "dog-founder"]
        or _trace_to_founder("dog-g2c", records) != ["dog-g2c", "dog-g1b", "dog-founder"]
        or _trace_to_founder("dog-g2b", records) != ["dog-g2b", "dog-g1a", "dog-founder"]
    ):
        return _fail("multigeneration ancestor trace")

    var replay: Dictionary = event.trigger_once(ended_g1a, ["dog-g2a", "dog-g2b"], 12)
    if (
        not replay.get("ok", false)
        or replay.get("created", true)
        or replay["successors"][0] != g2a[0]
        or event.completed_count() != 4
        or founder.to_snapshot() != original
        or ended_g1a.to_snapshot() != g1a_before
        or ended_g2a.to_snapshot() != g2a_before
        or not founder.is_soulbound()
    ):
        return _fail("replay, immutable ancestors or founder soulbound")

    var tampered: Dictionary = g3[0].to_snapshot()
    tampered["pedigree"]["parentPetIds"].append("not-a-parent")
    tampered["pedigree"]["founderPetId"] = "fake-founder"
    if (
        g3[0].to_snapshot()["pedigree"]["parentPetIds"] != ["dog-g2a"]
        or g3[0].to_snapshot()["pedigree"]["founderPetId"] != "dog-founder"
        or g3[1].to_snapshot()["pedigree"]["parentPetIds"] != ["dog-g2a"]
        or not g3[0].is_transferable()
    ):
        return _fail("detached descendant snapshots or soulbound inheritance")
    return true


func _trace_to_founder(leaf_id: String, records: Dictionary) -> Array:
    var chain: Array = []
    var seen: Dictionary = {}
    var current: String = leaf_id
    var expected_generation: int = -1
    for _step in range(5):
        if seen.has(current) or not records.has(current):
            return []
        seen[current] = true
        var pedigree: Dictionary = records[current]
        var generation: int = pedigree["generation"]
        if (
            pedigree["lineageId"] != "dog-line"
            or pedigree["founderPetId"] != "dog-founder"
            or (expected_generation >= 0 and generation != expected_generation)
        ):
            return []
        chain.append(current)
        var parents: Array = pedigree["parentPetIds"]
        if generation == 0:
            if current != "dog-founder" or not parents.is_empty():
                return []
            return chain
        if parents.size() != 1:
            return []
        expected_generation = generation - 1
        current = parents[0]
    return []


func _fail(message: String) -> bool:
    push_error("MARICA_G434_FAIL " + message)
    return false
