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
        or not _test_advancement_seed()
        or not _test_advancement_detached()
        or not _test_advancement_saturation()
        or not _test_advancement_rejections()
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


func _test_advancement_seed() -> bool:
    var parent: Dictionary = {"size": 0.5, "resilience": 0.4}
    var first: Dictionary = GENETICS.advance_potential(parent, 0)
    var second: Dictionary = GENETICS.advance_potential(parent, 1)
    if not first.get("ok", false) or not second.get("ok", false):
        return _fail("advancement rejected valid sorted traits")
    if first["traits"] != {"size": 0.5, "resilience": 0.45}:
        return _fail("seed 0 must improve first sorted trait")
    if second["traits"] != {"size": 0.55, "resilience": 0.4}:
        return _fail("seed 1 must improve second sorted trait")
    return true


func _test_advancement_detached() -> bool:
    var parent: Dictionary = {"size": 0.5, "resilience": 0.4}
    var first: Dictionary = GENETICS.advance_potential(parent, 0)
    if parent != {"size": 0.5, "resilience": 0.4}:
        return _fail("advancement changed parent potential")
    if GENETICS.advance_potential(parent, 0)["traits"] != first["traits"]:
        return _fail("repeatability failed")
    first["traits"]["resilience"] = 0.0
    if GENETICS.advance_potential(parent, 0)["traits"]["resilience"] != 0.45:
        return _fail("mutation leaked across advancement snapshots")
    return true


func _test_advancement_saturation() -> bool:
    var fallback: Dictionary = GENETICS.advance_potential({"resilience": 1.0, "size": 0.5}, 0)
    if fallback.get("traits", {}) != {"resilience": 1.0, "size": 0.55}:
        return _fail("saturated trait did not fall forward")
    var capped: Dictionary = GENETICS.advance_potential({"size": 1.0, "resilience": 0.98}, 0)
    if capped.get("traits", {}) != {"size": 1.0, "resilience": 1.0}:
        return _fail("advancement exceeded normalized cap")
    var full: Dictionary = GENETICS.advance_potential({"a": 1.0, "b": 1.0}, 1)
    if full.get("traits", {}) != {"a": 1.0, "b": 1.0}:
        return _fail("fully saturated potential changed")
    return true


func _test_advancement_rejections() -> bool:
    for invalid_seed in [-1, 0.5, NAN, INF, "1"]:
        if GENETICS.advance_potential({"size": 0.5}, invalid_seed).get("ok", true):
            return _fail("invalid advancement seed accepted")
    if GENETICS.advance_potential({}, 0).get("ok", true):
        return _fail("empty advancement potential accepted")
    if GENETICS.advance_potential({"size": 1.1}, 0).get("ok", true):
        return _fail("unbounded potential accepted")
    return true


func _fail(message: String) -> bool:
    push_error("G424 genetics: " + message)
    return false
