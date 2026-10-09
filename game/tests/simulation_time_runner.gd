extends SceneTree

# G423: independent headless regression for injected clock and rollback semantics.
const SIMULATION_TIME = preload("res://src/domain/simulation_time.gd")
var _clock_value: Variant = 0


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if (
        not _test_forward_and_repeat()
        or not _test_rollback()
        or not _test_validation()
        or not _test_fractional()
    ):
        quit(1)
        return
    print("MARICA_G423_SIMULATION_TIME_PASS")
    quit(0)


func _test_forward_and_repeat() -> bool:
    var first: Dictionary = _observe(1000, 900)
    if first.get("observation") != {"rawNow": 1000, "logicalNow": 1000, "elapsed": 100}:
        return _fail("forward observation differs from injected time")
    var second: Dictionary = _observe(1250, first["observation"]["logicalNow"])
    if second.get("observation") != {"rawNow": 1250, "logicalNow": 1250, "elapsed": 250}:
        return _fail("offline elapsed time is not deterministic")
    if second != _observe(1250, 1000):
        return _fail("repeated observations differ for identical inputs")
    return true


func _test_rollback() -> bool:
    var rollback: Dictionary = _observe(900, 1000)
    if rollback.get("observation") != {"rawNow": 900, "logicalNow": 1000, "elapsed": 0}:
        return _fail("clock rollback moved logical time backwards")
    var recovery: Dictionary = _observe(1100, rollback["observation"]["logicalNow"])
    if recovery.get("observation") != {"rawNow": 1100, "logicalNow": 1100, "elapsed": 100}:
        return _fail("clock recovery double-counted elapsed time")
    return true


func _test_validation() -> bool:
    return _test_basic_validation() and _test_nonfinite_validation() and _test_clock_injection()


func _test_basic_validation() -> bool:
    if _observe(-1, 0).get("error") != "Clock.now() must not be negative":
        return _fail("negative clock value accepted")
    if _observe(1, -1).get("error") != "lastObservedAt must not be negative":
        return _fail("negative previous observation accepted")
    if _observe("invalid", 0).get("error") != "Clock.now() must be a finite number":
        return _fail("non-numeric clock accepted")
    if _observe(1, "invalid").get("error") != "lastObservedAt must be a finite number":
        return _fail("non-numeric previous observation accepted")
    return true


func _test_nonfinite_validation() -> bool:
    if _observe(NAN, 0).get("error") != "Clock.now() must be a finite number":
        return _fail("NaN clock accepted")
    if _observe(INF, 0).get("error") != "Clock.now() must be a finite number":
        return _fail("infinite clock accepted")
    if _observe(0, INF).get("error") != "lastObservedAt must be a finite number":
        return _fail("infinite previous observation accepted")
    return true


func _test_clock_injection() -> bool:
    if SIMULATION_TIME.observe(Callable(), 0).get("error") != "Clock must provide now()":
        return _fail("missing injected clock accepted")
    return true


func _test_fractional() -> bool:
    if (
        _observe(101.75, 100.25).get("observation")
        != {"rawNow": 101.75, "logicalNow": 101.75, "elapsed": 1.5}
    ):
        return _fail("fractional elapsed time truncated")
    if _observe(0, 0).get("observation") != {"rawNow": 0, "logicalNow": 0, "elapsed": 0}:
        return _fail("zero timestamps were rejected")
    return true


func _observe(raw_now: Variant, last_observed_at: Variant) -> Dictionary:
    _clock_value = raw_now
    return SIMULATION_TIME.observe(Callable(self, "_clock_now"), last_observed_at)


func _clock_now() -> Variant:
    return _clock_value


func _fail(message: String) -> bool:
    push_error("G423 simulation time: " + message)
    return false
