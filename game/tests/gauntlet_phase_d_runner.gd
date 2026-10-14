extends SceneTree

# G436: independent Phase D P0 critic, not a save/restart or playable scene gate.
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
    var built: Dictionary = _founder_after_care()
    if not built.get("ok", false):
        return _fail(str(built.get("error")))
    var founder: MaricaPet = built["founder"]
    var ended: Dictionary = _end_founder(built["cared"], founder)
    if not ended.get("ok", false):
        return _fail(str(ended.get("error")))
    var pair: Dictionary = _verify_event(ended["parent"])
    if not pair.get("ok", false):
        return _fail(str(pair.get("error")))
    if not _verify_generation2(pair["children"][0]):
        return false
    if founder.to_snapshot() != built["before"]:
        return _fail("founder mutated by succession")
    return true


func _founder_after_care() -> Dictionary:
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
        return {"ok": false, "error": "founder creation"}
    var founder: MaricaPet = created["pet"]
    var before: Dictionary = founder.to_snapshot()
    var neglected: Dictionary = founder.with_care_state({"hunger": 0.5})
    if not neglected.get("ok", false):
        return {"ok": false, "error": "neglect application"}
    var weakened: MaricaPet = neglected["pet"]
    if (
        weakened.to_snapshot()["expressedTraits"]["speed"] != 0.4
        or weakened.to_snapshot()["geneticPotential"]["speed"] != 0.8
    ):
        return {"ok": false, "error": "care expression coupling"}
    var recovered: Dictionary = weakened.with_care_state({"hunger": 0.0})
    if not recovered.get("ok", false):
        return {"ok": false, "error": "care recovery"}
    var cared: MaricaPet = recovered["pet"]
    if cared.to_snapshot()["expressedTraits"]["speed"] != 0.8 or founder.to_snapshot() != before:
        return {"ok": false, "error": "care recovery or founder immutability"}
    return {"ok": true, "founder": founder, "cared": cared, "before": before}


func _end_founder(cared: MaricaPet, founder: MaricaPet) -> Dictionary:
    var life: MaricaLifecycle = LIFE.start()
    if LIFE.end_life(life, "natural").get("ok", false):
        return {"ok": false, "error": "juvenile natural end"}
    for stage in ["adult", "senior"]:
        var advanced: Dictionary = LIFE.advance(life, stage)
        if not advanced.get("ok", false):
            return {"ok": false, "error": "ordered age stage"}
        life = advanced["lifecycle"]
    var ended: Dictionary = LIFE.end_life(life, "natural")
    if not ended.get("ok", false):
        return {"ok": false, "error": "senior terminal"}
    var replaced: Dictionary = cared.with_lifecycle(ended["lifecycle"])
    if not replaced.get("ok", false):
        return {"ok": false, "error": "terminal aggregate"}
    var parent: MaricaPet = replaced["pet"]
    if parent.is_active() or not parent.is_soulbound() or not founder.is_active():
        return {"ok": false, "error": "terminal and founder Soulbound invariants"}
    return {"ok": true, "parent": parent}


func _verify_event(parent: MaricaPet) -> Dictionary:
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
        return {"ok": false, "error": "exactly-once deterministic event"}
    var children: Array = generated["successors"]
    if children.size() != 2 or children[0].get_id() == children[1].get_id():
        return {"ok": false, "error": "successor cardinality and distinct IDs"}
    for index in range(2):
        var child: MaricaPet = children[index]
        var data: Dictionary = child.to_snapshot()
        var child_traits: Dictionary = data["geneticPotential"]
        var parent_traits: Dictionary = parent.to_snapshot()["geneticPotential"]
        if (
            not child.is_active()
            or child.is_soulbound()
            or child.get_affection() != 0.0
            or data["pedigree"]["lineageId"] != "g436-lineage"
            or data["pedigree"]["generation"] != 1
            or data["pedigree"]["parentPetIds"] != ["g436-founder"]
            or data["pedigree"]["founderPetId"] != "g436-founder"
            or data["lifecycle"]["stage"] != "juvenile"
            or data["healthState"]["status"] != "healthy"
        ):
            return {"ok": false, "error": "successor freshness/pedigree/Soulbound"}
        if (
            float(child_traits["speed"]) <= float(parent_traits["speed"])
            and float(child_traits["resilience"]) <= float(parent_traits["resilience"])
        ):
            return {"ok": false, "error": "guaranteed genetic advance"}
        if (
            data != independent["successors"][index].to_snapshot()
            or child != replay["successors"][index]
        ):
            return {"ok": false, "error": "independent determinism or replay identity"}
    return {"ok": true, "children": children}


func _verify_generation2(child: MaricaPet) -> bool:
    var life: MaricaLifecycle = LIFE.start()
    for stage in ["adult", "senior"]:
        var advanced: Dictionary = LIFE.advance(life, stage)
        if not advanced.get("ok", false):
            return _fail("next-generation aging")
        life = advanced["lifecycle"]
    var ended: Dictionary = LIFE.end_life(life, "natural")
    if not ended.get("ok", false):
        return _fail("next-generation end")
    var replaced: Dictionary = child.with_lifecycle(ended["lifecycle"])
    if not replaced.get("ok", false):
        return _fail("next-generation terminal aggregate")
    var second: Dictionary = EVENT.new().trigger_once(
        replaced["pet"], ["g436-grandchild-1", "g436-grandchild-2"], 11
    )
    if not second.get("ok", false) or second["successors"].size() != 2:
        return _fail("second-generation successor pair")
    for grandchild in second["successors"]:
        var data: Dictionary = grandchild.to_snapshot()
        if (
            data["pedigree"]["generation"] != 2
            or data["pedigree"]["lineageId"] != "g436-lineage"
            or data["pedigree"]["parentPetIds"] != ["g436-child-1"]
            or data["pedigree"]["founderPetId"] != "g436-founder"
            or grandchild.is_soulbound()
        ):
            return _fail("second-generation direct parentage")
    return true


func _fail(message: String) -> bool:
    push_error("MARICA_G436_FAIL " + message)
    return false
