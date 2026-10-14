extends SceneTree

# G436 GAUNTLET: fresh cross-contract critic of the Phase D animal path.
# No save/restart, automatic age scheduler, scene or artwork is certified here.
const PET = preload("res://src/domain/pet.gd")
const LIFE = preload("res://src/domain/lifecycle.gd")
const EVENT = preload("res://src/domain/succession_event.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if not _holistic_contract():
        quit(1)
        return
    print("MARICA_G436_PHASE_D_GAUNTLET_PASS")
    quit(0)


func _holistic_contract() -> bool:
    var created: Dictionary = PET.create_composite(
        "g436-founder",
        {"lineageId": "g436-lineage", "generation": 0, "founderPetId": "g436-founder"},
        null,
        {"speed": 0.8, "resilience": 0.4},
        null,
        null,
        true,
        0.6
    )
    if not created.get("ok", false):
        return _fail("founder creation")
    var founder: MaricaPet = created["pet"]
    var immutable_before: Dictionary = founder.to_snapshot()

    # The same potential must express differently after neglect and recovery.
    var neglected: Dictionary = founder.with_care_state({"hunger": 0.5})
    if not neglected.get("ok", false):
        return _fail("neglect application")
    var weakened: MaricaPet = neglected["pet"]
    if (
        weakened.to_snapshot()["expressedTraits"]["speed"] != 0.4
        or weakened.to_snapshot()["geneticPotential"]["speed"] != 0.8
    ):
        return _fail("care expression coupling")
    var recovered: Dictionary = weakened.with_care_state({"hunger": 0.0})
    if not recovered.get("ok", false):
        return _fail("care recovery")
    var cared: MaricaPet = recovered["pet"]
    if (
        cared.to_snapshot()["expressedTraits"]["speed"] != 0.8
        or founder.to_snapshot() != immutable_before
    ):
        return _fail("care recovery or founder immutability")

    var lifecycle: MaricaLifecycle = LIFE.start()
    if LIFE.end_life(lifecycle, "natural").get("ok", false):
        return _fail("juvenile natural end")
    for stage in ["adult", "senior"]:
        var advanced: Dictionary = LIFE.advance(lifecycle, stage)
        if not advanced.get("ok", false):
            return _fail("ordered age stage")
        lifecycle = advanced["lifecycle"]
    var ended: Dictionary = LIFE.end_life(lifecycle, "natural")
    if not ended.get("ok", false):
        return _fail("senior terminal")
    var replacement: Dictionary = cared.with_lifecycle(ended["lifecycle"])
    if not replacement.get("ok", false):
        return _fail("terminal aggregate")
    var parent: MaricaPet = replacement["pet"]
    if parent.is_active() or not parent.is_soulbound() or not founder.is_active():
        return _fail("terminal and founder Soulbound invariants")

    var ids: Array = ["g436-child-1", "g436-child-2"]
    var ledger: MaricaSuccessionEvent = EVENT.new()
    var generated: Dictionary = ledger.trigger_once(parent, ids, 9)
    var replay: Dictionary = ledger.trigger_once(parent, ids, 9)
    var independent: Dictionary = EVENT.new().trigger_once(parent, ids, 9)
    if (
        not generated.get("ok", false)
        or not generated.get("created", false)
        or not replay.get("ok", false)
        or replay.get("created", true)
        or not independent.get("ok", false)
        or ledger.completed_count() != 1
    ):
        return _fail("exactly-once deterministic event")
    var children: Array = generated["successors"]
    if children.size() != 2 or children[0].get_id() == children[1].get_id():
        return _fail("successor cardinality and distinct IDs")
    for index in range(2):
        var child: MaricaPet = children[index]
        var child_state: Dictionary = child.to_snapshot()
        var parent_state: Dictionary = parent.to_snapshot()
        var child_traits: Dictionary = child_state["geneticPotential"]
        var parent_traits: Dictionary = parent_state["geneticPotential"]
        if (
            not child.is_active()
            or child.is_soulbound()
            or child.get_affection() != 0.0
            or child_state["pedigree"]["lineageId"] != "g436-lineage"
            or child_state["pedigree"]["generation"] != 1
            or child_state["pedigree"]["parentPetIds"] != ["g436-founder"]
            or child_state["pedigree"]["founderPetId"] != "g436-founder"
            or child_state["lifecycle"]["stage"] != "juvenile"
            or child_state["healthState"]["status"] != "healthy"
        ):
            return _fail("successor freshness/pedigree/Soulbound")
        if (
            float(child_traits["speed"]) <= float(parent_traits["speed"])
            and float(child_traits["resilience"]) <= float(parent_traits["resilience"])
        ):
            return _fail("guaranteed genetic advance")
        if (
            child_state != independent["successors"][index].to_snapshot()
            or child != replay["successors"][index]
        ):
            return _fail("independent determinism or replay identity")

    # New parenthood must point to generation 1, not skip to the founder.
    var next_life: MaricaLifecycle = LIFE.start()
    for stage in ["adult", "senior"]:
        var next_stage: Dictionary = LIFE.advance(next_life, stage)
        if not next_stage.get("ok", false):
            return _fail("next-generation aging")
        next_life = next_stage["lifecycle"]
    var next_end: Dictionary = LIFE.end_life(next_life, "natural")
    if not next_end.get("ok", false):
        return _fail("next-generation end")
    var ended_child: Dictionary = children[0].with_lifecycle(next_end["lifecycle"])
    if not ended_child.get("ok", false):
        return _fail("next-generation terminal aggregate")
    var second: Dictionary = EVENT.new().trigger_once(
        ended_child["pet"], ["g436-grandchild-1", "g436-grandchild-2"], 11
    )
    if not second.get("ok", false) or second["successors"].size() != 2:
        return _fail("second-generation successor pair")
    for grandchild in second["successors"]:
        var grandchild_state: Dictionary = grandchild.to_snapshot()
        if (
            grandchild_state["pedigree"]["generation"] != 2
            or grandchild_state["pedigree"]["lineageId"] != "g436-lineage"
            or grandchild_state["pedigree"]["parentPetIds"] != ["g436-child-1"]
            or grandchild_state["pedigree"]["founderPetId"] != "g436-founder"
            or grandchild.is_soulbound()
        ):
            return _fail("second-generation direct parentage")
    if founder.to_snapshot() != immutable_before:
        return _fail("founder mutated by succession")
    return true


func _fail(message: String) -> bool:
    push_error("MARICA_G436_FAIL " + message)
    return false
