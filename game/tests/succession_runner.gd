extends SceneTree

# G431 independent regression: does not use the golden JSON as an oracle.
const PET = preload("res://src/domain/pet.gd")
const LIFECYCLE = preload("res://src/domain/lifecycle.gd")
const SUCCESSION = preload("res://src/domain/succession.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if not _seed_contract() or not _successor_contract() or not _rejection_contract():
        quit(1)
        return
    print("MARICA_G431_SINGLE_SUCCESSOR_PASS")
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


func _seed_contract() -> bool:
    var first: Dictionary = SUCCESSION.derive_genetic_seed(40, 1)
    var second: Dictionary = SUCCESSION.derive_genetic_seed(40, 2)
    if (
        not first.get("ok", false)
        or first["seed"] != 40
        or not second.get("ok", false)
        or second["seed"] != 41
    ):
        return _fail("seed ordinal parity")
    for pair in [[40, 0], [0.5, 1], [-1, 1], [40, 1.5], [40, -1], [INF, 1]]:
        if SUCCESSION.derive_genetic_seed(pair[0], pair[1]).get("ok", false):
            return _fail("invalid seed or ordinal accepted")
    if SUCCESSION.derive_genetic_seed(9007199254740991, 2).get("ok", false):
        return _fail("seed arithmetic overflow accepted")
    return true


func _successor_contract() -> bool:
    var parent: MaricaPet = _ended_parent()
    if parent == null:
        return _fail("ended parent setup")
    var before: Dictionary = parent.to_snapshot()
    var one: Dictionary = SUCCESSION.create_successor(parent, "pet-child-001", 0, 1)
    var repeat: Dictionary = SUCCESSION.create_successor(parent, "pet-child-001", 0, 1)
    var two: Dictionary = SUCCESSION.create_successor(parent, "pet-child-002", 0, 2)
    if not one.get("ok", false) or not repeat.get("ok", false) or not two.get("ok", false):
        return _fail("successor construction failed")
    var a: Dictionary = one["pet"].to_snapshot()
    var b: Dictionary = two["pet"].to_snapshot()
    if (
        a != repeat["pet"].to_snapshot()
        or a["geneticPotential"] != {"resilience": 0.45, "size": 0.5}
        or b["geneticPotential"] != {"resilience": 0.4, "size": 0.55}
        or a["pedigree"]["generation"] != 1
        or a["pedigree"]["lineageId"] != "lineage-001"
        or a["pedigree"]["founderPetId"] != "pet-founder-001"
        or a["pedigree"]["parentPetIds"] != ["pet-founder-001"]
        or a["lifecycle"] != {"stage": "juvenile", "status": "active"}
        or a["soulbound"] != false
        or a["affection"] != 0.0
        or a["careState"]["hunger"] != 0.0
        or a["healthState"]["status"] != "healthy"
        or a["healthState"]["neglectHours"] != 0.0
        or a["expressedTraits"] != a["geneticPotential"]
    ):
        return _fail("inheritance, fresh state or ordinal direction drifted")
    a["pedigree"]["parentPetIds"].append("tampered")
    a["geneticPotential"]["resilience"] = 0.0
    if (
        parent.to_snapshot() != before
        or one["pet"].to_snapshot()["pedigree"]["parentPetIds"] != ["pet-founder-001"]
        or one["pet"].to_snapshot()["geneticPotential"]["resilience"] != 0.45
    ):
        return _fail("successor or parent snapshot mutability")
    return true


func _rejection_contract() -> bool:
    var parent: MaricaPet = _ended_parent()
    if parent == null:
        return _fail("ended parent for validation")
    var active: Dictionary = PET.create_composite(
        "pet-active",
        {"lineageId": "l", "generation": 0, "founderPetId": "pet-active"},
        null,
        {"size": 0.5}
    )
    var shell: Dictionary = PET.create("pet-shell")
    var empty_potential: Dictionary = PET.create_composite(
        "pet-empty",
        {"lineageId": "l", "generation": 0, "founderPetId": "pet-empty"},
        LIFECYCLE.end_life(LIFECYCLE.start(), "health")["lifecycle"],
        {}
    )
    if (
        not active.get("ok", false)
        or not shell.get("ok", false)
        or not empty_potential.get("ok", false)
    ):
        return _fail("rejection setup")
    if SUCCESSION.create_successor(active["pet"], "child", 0, 1).get("ok", false):
        return _fail("active parent accepted")
    if SUCCESSION.create_successor(shell["pet"], "child", 0, 1).get("ok", false):
        return _fail("isolated shell accepted")
    if SUCCESSION.create_successor(empty_potential["pet"], "child", 0, 1).get("ok", false):
        return _fail("empty potential accepted")
    if SUCCESSION.create_successor(parent, "   ", 0, 1).get("ok", false):
        return _fail("invalid child id accepted")
    return true


func _fail(message: String) -> bool:
    push_error("MARICA_G431_FAIL " + message)
    return false
