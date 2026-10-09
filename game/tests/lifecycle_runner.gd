extends SceneTree

# G422: headless lifecycle invariants independent of the G416 golden fixture runner.
const LIFECYCLE = preload("res://src/domain/lifecycle.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if not _test_stages() or not _test_termination() or not _test_snapshot_isolation():
        quit(1)
        return
    print("MARICA_G422_LIFECYCLE_PASS")
    quit(0)


func _test_stages() -> bool:
    var juvenile: MaricaLifecycle = LIFECYCLE.start()
    if juvenile.to_snapshot() != {"stage": "juvenile", "status": "active"}:
        return _fail("fresh lifecycle is not active juvenile")
    var adult_result: Dictionary = LIFECYCLE.advance(juvenile, "adult")
    if not adult_result.get("ok", false):
        return _fail("legal juvenile to adult transition rejected")
    var adult: MaricaLifecycle = adult_result["lifecycle"]
    if LIFECYCLE.advance(juvenile, "senior").get("ok", true):
        return _fail("skipped stage accepted")
    var senior_result: Dictionary = LIFECYCLE.advance(adult, "senior")
    if not senior_result.get("ok", false):
        return _fail("legal adult to senior transition rejected")
    if LIFECYCLE.advance(adult, "juvenile").get("ok", true):
        return _fail("backwards transition accepted")
    return true


func _test_termination() -> bool:
    var juvenile: MaricaLifecycle = LIFECYCLE.start()
    if LIFECYCLE.end_life(juvenile, "natural").get("ok", true):
        return _fail("natural juvenile end accepted")
    var adult: MaricaLifecycle = LIFECYCLE.advance(juvenile, "adult")["lifecycle"]
    var senior: MaricaLifecycle = LIFECYCLE.advance(adult, "senior")["lifecycle"]
    var natural_result: Dictionary = LIFECYCLE.end_life(senior, "natural")
    if not natural_result.get("ok", false):
        return _fail("natural senior end rejected")
    var ended: MaricaLifecycle = natural_result["lifecycle"]
    if not ended.is_terminal() or ended.to_snapshot().get("endReason") != "natural":
        return _fail("terminal state or natural reason not preserved")
    if LIFECYCLE.advance(ended, "senior").get("ok", true):
        return _fail("terminal state advanced")
    if LIFECYCLE.end_life(ended, "health").get("ok", true):
        return _fail("terminal state ended twice")
    return true


func _test_snapshot_isolation() -> bool:
    var juvenile: MaricaLifecycle = LIFECYCLE.start()
    var adult: MaricaLifecycle = LIFECYCLE.advance(juvenile, "adult")["lifecycle"]
    var snapshot: Dictionary = adult.to_snapshot()
    snapshot["stage"] = "senior"
    if adult.to_snapshot()["stage"] != "adult" or juvenile.to_snapshot()["stage"] != "juvenile":
        return _fail("transition or snapshot mutated predecessor")
    var health_result: Dictionary = LIFECYCLE.end_life(juvenile, "health")
    if not health_result.get("ok", false):
        return _fail("health-driven early end rejected")
    var ended: MaricaLifecycle = health_result["lifecycle"]
    if not ended.is_terminal() or ended.to_snapshot().get("endReason") != "health":
        return _fail("health early end wrong")
    if adult.is_terminal() or juvenile.is_terminal():
        return _fail("ending a state mutated a predecessor")
    return true


func _fail(message: String) -> bool:
    push_error("G422 lifecycle: " + message)
    return false
