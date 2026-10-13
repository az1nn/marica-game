extends SceneTree

# G435: deterministic test-only 14/21/28 day animal-cycle scenarios.
# Checkpoints below are fixture choices, NOT an approved production age-balancing policy.
# Time values are injected hours; no wall clock, save or SceneTree game logic.
const PET = preload("res://src/domain/pet.gd")
const LIFE = preload("res://src/domain/lifecycle.gd")
const TIME = preload("res://src/domain/simulation_time.gd")
const EVENT = preload("res://src/domain/succession_event.gd")

var _clock_value: float = 0.0


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if not _scenario(14) or not _scenario(21) or not _scenario(28):
        quit(1)
        return
    if not _health_terminal_scenario():
        quit(1)
        return
    print("MARICA_G435_ACCELERATED_LIFECYCLE_PASS days=14,21,28")
    quit(0)


func _founder(days: int) -> MaricaPet:
    var pet_id: String = "pet-founder-" + str(days)
    var created: Dictionary = PET.create_composite(
        pet_id,
        {"lineageId": "line-" + str(days), "generation": 0, "founderPetId": pet_id},
        null,
        {"speed": 0.6, "resilience": 0.4},
        null,
        null,
        true,
        0.7
    )
    if not created.get("ok", false):
        return null
    return created["pet"]


func _scenario(days: int) -> bool:
    var founder: MaricaPet = _founder(days)
    if founder == null:
        return _fail("founder fixture")
    var original: Dictionary = founder.to_snapshot()
    var result: Dictionary = _drive_days(founder, days)
    if not result.get("ok", false):
        return _fail("day simulation " + str(days) + ": " + str(result.get("error")))
    return _verify_natural_succession(founder, original, result["pet"], days)


func _drive_days(founder: MaricaPet, days: int) -> Dictionary:
    var life: MaricaLifecycle = LIFE.start()
    var pet: MaricaPet = founder
    var logical_now: float = 0.0
    var adult_day: int = maxi(2, int(float(days) / 4.0))
    var senior_day: int = maxi(adult_day + 2, int(float(days) * 0.75))
    for day in range(1, days + 1):
        var advanced: Dictionary = _tick(pet, logical_now, day)
        if not advanced.get("ok", false):
            return advanced
        pet = advanced["pet"]
        logical_now = advanced["logical"]
        if day == adult_day or day == senior_day:
            var next_stage: String = "adult" if day == adult_day else "senior"
            var stage: Dictionary = _advance_stage(pet, life, next_stage)
            if not stage.get("ok", false):
                return stage
            pet = stage["pet"]
            life = stage["life"]
        if day == adult_day + 1 and LIFE.end_life(life, "natural").get("ok", false):
            return {"ok": false, "error": "early natural end accepted"}
        if day == 8 and not _rollback_safe(logical_now):
            return {"ok": false, "error": "injected clock rollback counted negative time"}
    var ended: Dictionary = LIFE.end_life(life, "natural")
    if not ended.get("ok", false):
        return {"ok": false, "error": "scheduled senior natural end rejected"}
    return pet.with_lifecycle(ended["lifecycle"])


func _tick(pet: MaricaPet, previous: float, day: int) -> Dictionary:
    _clock_value = float(day) * 24.0
    var observation: Dictionary = TIME.observe(Callable(self, "_clock_now"), previous)
    if not observation.get("ok", false):
        return observation
    var sample: Dictionary = observation["observation"]
    if sample["elapsed"] != 24.0 or sample["logicalNow"] != _clock_value:
        return {"ok": false, "error": "non-deterministic 24h tick"}
    var state: MaricaPet = pet
    if day == 2:
        var neglected: Dictionary = state.with_care_state({"hunger": 1.0})
        if not neglected.get("ok", false):
            return neglected
        state = neglected["pet"]
    if day == 4:
        var treatment: Dictionary = state.apply_treatment("advanced")
        if not treatment.get("ok", false) or treatment.get("cost") != 30:
            return {"ok": false, "error": "illness treatment and cost"}
        state = treatment["pet"]
        var fed: Dictionary = state.with_care_state({"hunger": 0.0})
        if not fed.get("ok", false):
            return fed
        state = fed["pet"]
    var advanced: Dictionary = state.advance_health(sample["elapsed"])
    if not advanced.get("ok", false):
        return advanced
    var next_pet: MaricaPet = advanced["pet"]
    var health: Dictionary = next_pet.to_snapshot()["healthState"]
    if day == 3 and health["status"] != "sick":
        return {"ok": false, "error": "neglect did not cause sickness"}
    if day == 4 and health["status"] != "healthy":
        return {"ok": false, "error": "care and treatment failed to recover"}
    return {"ok": true, "pet": next_pet, "logical": sample["logicalNow"]}


func _advance_stage(pet: MaricaPet, life: MaricaLifecycle, stage: String) -> Dictionary:
    var transition: Dictionary = LIFE.advance(life, stage)
    if not transition.get("ok", false):
        return transition
    var replaced: Dictionary = pet.with_lifecycle(transition["lifecycle"])
    if not replaced.get("ok", false):
        return replaced
    return {"ok": true, "pet": replaced["pet"], "life": transition["lifecycle"]}


func _rollback_safe(logical_now: float) -> bool:
    _clock_value = logical_now - 6.0
    var rollback: Dictionary = TIME.observe(Callable(self, "_clock_now"), logical_now)
    _clock_value = logical_now
    var replay: Dictionary = TIME.observe(Callable(self, "_clock_now"), logical_now)
    return (
        rollback.get("ok", false)
        and rollback["observation"]["elapsed"] == 0.0
        and rollback["observation"]["logicalNow"] == logical_now
        and replay.get("ok", false)
        and replay["observation"]["elapsed"] == 0.0
    )


func _verify_natural_succession(
    founder: MaricaPet, original: Dictionary, ended: MaricaPet, days: int
) -> bool:
    var end_snapshot: Dictionary = ended.to_snapshot()
    if (
        ended.is_active()
        or end_snapshot["lifecycle"]["stage"] != "senior"
        or end_snapshot["lifecycle"]["endReason"] != "natural"
        or end_snapshot["healthState"]["status"] != "healthy"
        or founder.to_snapshot() != original
        or not founder.is_soulbound()
    ):
        return _fail("natural end, recovery, or immutable founder")
    return _verify_pair(ended, days)


func _verify_pair(ended: MaricaPet, days: int) -> bool:
    var event: MaricaSuccessionEvent = EVENT.new()
    var ids: Array = ["child-" + str(days) + "-a", "child-" + str(days) + "-b"]
    var first: Dictionary = event.trigger_once(ended, ids, days)
    var repeat: Dictionary = event.trigger_once(ended, ids, days)
    if (
        not first.get("ok", false)
        or not first.get("created", false)
        or not repeat.get("ok", false)
        or repeat.get("created", true)
        or event.completed_count() != 1
    ):
        return _fail("event once-only/idempotency")
    var children: Array = first["successors"]
    if children.size() != 2 or children[0] == children[1]:
        return _fail("exactly two distinct successors")
    for child in children:
        var pet: MaricaPet = child
        var data: Dictionary = pet.to_snapshot()
        if (
            not pet.is_active()
            or pet.is_soulbound()
            or data["lifecycle"]["stage"] != "juvenile"
            or data["pedigree"]["generation"] != 1
            or data["pedigree"]["parentPetIds"] != [ended.get_id()]
            or data["pedigree"]["founderPetId"] != ended.get_id()
            or data["affection"] != 0.0
        ):
            return _fail("successor freshness, parentage or soulbound")
    if (
        repeat["successors"][0] != children[0]
        or repeat["successors"][1] != children[1]
        or event.trigger_once(ended, ids, days + 1).get("ok", false)
    ):
        return _fail("replay identity or conflicting trigger")
    return true


func _health_terminal_scenario() -> bool:
    var founder: MaricaPet = _founder(99)
    if founder == null:
        return _fail("health fixture")
    var sick: Dictionary = founder.with_care_state({"hunger": 1.0})
    if not sick.get("ok", false):
        return _fail("health neglect")
    var advanced: Dictionary = sick["pet"].advance_health(120.0)
    if not advanced.get("ok", false):
        return _fail("health terminal advance")
    var ended: MaricaPet = advanced["pet"]
    if ended.is_active() or ended.to_snapshot()["lifecycle"].get("endReason") != "health":
        return _fail("untreated illness did not end life")
    return _verify_pair(ended, 99)


func _clock_now() -> float:
    return _clock_value


func _fail(message: String) -> bool:
    push_error("MARICA_G435_FAIL " + message)
    return false
