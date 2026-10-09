extends SceneTree

# G426: independent state regression and Luau Health thresholds/treatment parity.
const HEALTH = preload("res://src/domain/health.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if (
        not _test_defaults_and_detachment()
        or not _test_progression_and_critical_risk()
        or not _test_recovery_and_treatment()
        or not _test_input_validation()
    ):
        quit(1)
        return
    print("MARICA_G426_HEALTH_PASS")
    quit(0)


func _test_defaults_and_detachment() -> bool:
    var created: Dictionary = HEALTH.create()
    if not created.get("ok", false):
        return _fail("healthy default rejected")
    var health: MaricaHealth = created["health"]
    if health.to_snapshot() != {
        "status": "healthy", "neglectHours": 0.0, "untreatedHours": 0.0
    }:
        return _fail("wrong health defaults")
    var source: Dictionary = {"neglectHours": 72.0, "untreatedHours": 12.0}
    var parsed: Dictionary = HEALTH.create(source)
    if not parsed.get("ok", false):
        return _fail("valid state rejected")
    var critical: MaricaHealth = parsed["health"]
    source["neglectHours"] = 0.0
    var exposed: Dictionary = critical.to_snapshot()
    exposed["untreatedHours"] = 48.0
    if critical.to_snapshot()["untreatedHours"] != 12.0:
        return _fail("health retains a mutable state reference")
    if critical.to_snapshot()["neglectHours"] != 72.0:
        return _fail("health retains a mutable source reference")
    var recovered: Dictionary = HEALTH.create(
        {"neglectHours": 23.0, "untreatedHours": 99.0}
    )
    if recovered["health"].to_snapshot()["untreatedHours"] != 0.0:
        return _fail("healthy status must normalize untreated duration")
    return true


func _test_progression_and_critical_risk() -> bool:
    var severe: Dictionary = {
        "hunger": 1.0, "hygiene": 0.0, "affection": 0.0, "energy": 0.0
    }
    var first: Dictionary = HEALTH.advance({}, severe, 12.0)
    if not first.get("ok", false):
        return _fail("short neglect refused")
    if first["health"].to_snapshot()["status"] != "healthy":
        return _fail("12h must not cause neglect")
    var neglected: Dictionary = HEALTH.advance({}, severe, 24.0)
    if neglected["health"].to_snapshot()["status"] != "neglected":
        return _fail("24h must cause neglect")
    var sick: Dictionary = HEALTH.advance(neglected["health"], severe, 24.0)
    if sick["health"].to_snapshot() != {
        "status": "sick", "neglectHours": 48.0, "untreatedHours": 0.0
    }:
        return _fail("48h sick transition or untreated boundary drift")
    var critical: Dictionary = HEALTH.advance(sick["health"], severe, 24.0)
    if critical["health"].to_snapshot() != {
        "status": "critical", "neglectHours": 72.0, "untreatedHours": 24.0
    }:
        return _fail("72h must become critical with 24h untreated")
    if HEALTH.is_terminal_risk(critical["health"])["terminal"]:
        return _fail("terminal risk triggered too early")
    var longer: Dictionary = HEALTH.advance(critical["health"], {}, 24.0)
    if longer["health"].to_snapshot()["untreatedHours"] != 48.0:
        return _fail("good care cannot automatically cure existing sickness")
    if not HEALTH.is_terminal_risk(longer["health"])["terminal"]:
        return _fail("48h critical untreated must trigger terminal risk")
    var direct: Dictionary = HEALTH.advance({}, severe, 96.0)
    if direct["health"].to_snapshot() != {
        "status": "critical", "neglectHours": 96.0, "untreatedHours": 48.0
    }:
        return _fail("long severe neglect must reach untreated terminal threshold")
    return true


func _test_recovery_and_treatment() -> bool:
    var severe: Dictionary = {"hunger": 1.0}
    var neglected: Dictionary = HEALTH.advance({}, severe, 24.0)
    var recovered: Dictionary = HEALTH.advance(neglected["health"], {}, 24.0)
    if recovered["health"].to_snapshot()["status"] != "healthy":
        return _fail("good care must recover neglected without disease")
    var sick: Dictionary = HEALTH.advance({}, severe, 48.0)
    var still_sick: Dictionary = HEALTH.advance(sick["health"], {}, 12.0)
    if still_sick["health"].to_snapshot() != {
        "status": "sick", "neglectHours": 48.0, "untreatedHours": 12.0
    }:
        return _fail("untreated sickness not retained under good care")
    var basic: Dictionary = HEALTH.treat(sick["health"], "basic")
    var advanced: Dictionary = HEALTH.treat(sick["health"], "advanced")
    var emergency: Dictionary = HEALTH.treat(sick["health"], "emergency")
    if not basic.get("ok", false) or basic["cost"] != 10:
        return _fail("basic treatment cost invalid")
    if basic["health"].to_snapshot()["status"] != "neglected":
        return _fail("basic treatment reduction invalid")
    if advanced["cost"] != 30 or advanced["health"].to_snapshot()["status"] != "healthy":
        return _fail("advanced treatment reduction invalid")
    if emergency["cost"] != 75 or emergency["health"].to_snapshot()["status"] != "healthy":
        return _fail("emergency treatment reduction invalid")
    if sick["health"].to_snapshot()["status"] != "sick":
        return _fail("treatment mutated previous health state")
    return true


func _test_input_validation() -> bool:
    if HEALTH.create({"neglectHours": -1}).get("ok", true):
        return _fail("negative neglect accepted")
    if HEALTH.create({"untreatedHours": INF}).get("ok", true):
        return _fail("nonfinite untreated accepted")
    if HEALTH.create({"neglectHours": NAN}).get("ok", true):
        return _fail("NaN neglect accepted")
    if HEALTH.create({"neglectHours": true}).get("ok", true):
        return _fail("boolean duration accepted")
    if HEALTH.advance({}, {}, -1).get("ok", true):
        return _fail("negative elapsed accepted")
    if HEALTH.advance({}, {}, INF).get("ok", true):
        return _fail("nonfinite elapsed accepted")
    if HEALTH.advance({}, {"hunger": 2.0}, 10).get("ok", true):
        return _fail("invalid care accepted")
    if HEALTH.treat({}, "basic").get("ok", true):
        return _fail("healthy treatment accepted")
    if HEALTH.treat({"neglectHours": 72}, "experimental").get("ok", true):
        return _fail("unknown treatment accepted")
    return true


func _fail(message: String) -> bool:
    push_error("G426 health: " + message)
    return false
