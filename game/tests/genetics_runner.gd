extends SceneTree

# G424: independent deterministic domain regression beyond the G416 catalog.
const GENETICS = preload("res://src/domain/genetics.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if (
        not _test_potential_copy()
        or not _test_expression()
        or not _test_invalid_values()
        or not _test_nonfinite()
    ):
        quit(1)
        return
    print("MARICA_G424_GENETICS_PASS")
    quit(0)


func _test_potential_copy() -> bool:
    var source: Dictionary = {"size": 1.0, "resilience": 0.5}
    var result: Dictionary = GENETICS.new_potential(source)
    if not result.get("ok", false):
        return _fail("valid genetic potential rejected")
    var snapshot: Dictionary = result["traits"]
    source["size"] = 0.0
    if snapshot["size"] != 1.0:
        return _fail("input mutation corrupted potential snapshot")
    snapshot["resilience"] = 0.0
    if GENETICS.new_potential({"size": 1.0, "resilience": 0.5})["traits"]["resilience"] != 0.5:
        return _fail("detached potential failed repeatability")
    return true


func _test_expression() -> bool:
    var source: Dictionary = {"size": 1.0, "resilience": 0.5}
    var factors: Dictionary = {"size": 0.25}
    var result: Dictionary = GENETICS.express(source, factors)
    if not result.get("ok", false):
        return _fail("valid expression rejected")
    var traits: Dictionary = result["traits"]
    if traits["size"] != 0.25 or traits["resilience"] != 0.5:
        return _fail("expression did not apply default factor 1")
    factors["size"] = 0.0
    traits["size"] = 0.0
    if source["size"] != 1.0 or source["resilience"] != 0.5:
        return _fail("expression mutated genetic potential")
    if GENETICS.express(source, {"size": 0.25})["traits"]["size"] != 0.25:
        return _fail("expression result retained mutated factor state")
    return true


func _test_invalid_values() -> bool:
    if GENETICS.new_potential({"size": 1.01}).get("ok", true):
        return _fail("trait greater than one accepted")
    if GENETICS.new_potential({"size": -0.01}).get("ok", true):
        return _fail("negative trait accepted")
    if GENETICS.new_potential({" ": 0.4}).get("ok", true):
        return _fail("blank trait name accepted")
    if GENETICS.express({"size": 1.0}, {"speed": 0.5}).get("ok", true):
        return _fail("unknown expression trait accepted")
    if GENETICS.express({"size": 1.0}, {"size": -0.5}).get("ok", true):
        return _fail("negative expression factor accepted")
    return true


func _test_nonfinite() -> bool:
    if GENETICS.new_potential({"size": NAN}).get("ok", true):
        return _fail("NaN potential accepted")
    if GENETICS.new_potential({"size": INF}).get("ok", true):
        return _fail("infinite potential accepted")
    if GENETICS.express({"size": 0.5}, {"size": NAN}).get("ok", true):
        return _fail("NaN factor accepted")
    if GENETICS.express({"size": 0.5}, {"size": INF}).get("ok", true):
        return _fail("infinite factor accepted")
    return true


func _fail(message: String) -> bool:
    push_error("G424 genetics: " + message)
    return false
