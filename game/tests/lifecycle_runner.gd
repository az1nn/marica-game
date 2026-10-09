extends SceneTree

# G422: headless lifecycle invariants independent of the G416 golden fixture runner.
const LIFECYCLE = preload("res://src/domain/lifecycle.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    var juvenile: MaricaLifecycle = LIFECYCLE.start()
    if juvenile.to_snapshot() != {"stage": "juvenile", "status": "active"}:
        _fail("fresh lifecycle is not active juvenile")
        return
    var advanced: Dictionary = LIFECYCLE.advance(juvenile, "adult")
    if not advanced.get("ok", false):
        _fail("legal juvenile to adult transition rejected")
        return
    var adult: MaricaLifecycle = advanced["lifecycle"]
    var snapshot: Dictionary = adult.to_snapshot()
    snapshot["stage"] = "senior"
    if adult.to_snapshot()["stage"] != "adult" or juvenile.to_snapshot()["stage"] != "juvenile":
        _fail("transition or snapshot mutated old state")
        return
    var old_age: Dictionary = LIFECYCLE.advance(juvenile, "senior")
    if old_age.get("ok", true):
        _fail("skipped stage accepted")
        return
    var senior_result: Dictionary = LIFECYCLE.advance(adult, "senior")
    if not senior_result.get("ok", false):
        _fail("legal adult to senior transition rejected")
        return
    var senior: MaricaLifecycle = senior_result["lifecycle"]
    var natural_result: Dictionary = LIFECYCLE.end_life(senior, "natural")
    if not natural_result.get("ok", false):
        _fail("natural senior end rejected")
        return
    var ended: MaricaLifecycle = natural_result["lifecycle"]
    if not ended.is_terminal() or ended.to_snapshot().get("endReason") != "natural":
        _fail("terminal state or natural reason not preserved")
        return
    if LIFECYCLE.advance(ended, "senior").get("ok", true):
        _fail("terminal state advanced")
        return
    if LIFECYCLE.end_life(ended, "health").get("ok", true):
        _fail("terminal state ended twice")
        return
    var health_result: Dictionary = LIFECYCLE.end_life(juvenile, "health")
    if not health_result.get("ok", false):
        _fail("health-driven early end rejected")
        return
    var health_end: MaricaLifecycle = health_result["lifecycle"]
    if not health_end.is_terminal() or health_end.to_snapshot().get("endReason") != "health":
        _fail("health early end wrong")
        return
    if not senior.to_snapshot()["status"] == "active" or adult.is_terminal():
        _fail("ending a state mutated its predecessor")
        return
    print("MARICA_G422_LIFECYCLE_PASS")
    quit(0)


func _fail(message: String) -> void:
    push_error("G422 lifecycle: " + message)
    quit(1)
