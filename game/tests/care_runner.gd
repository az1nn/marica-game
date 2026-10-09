extends SceneTree

# G425: independent care-state regression beyond the G416 Luau golden catalog.
const CARE = preload("res://src/domain/care.gd")
const GENETICS = preload("res://src/domain/genetics.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if (
        not _test_defaults_and_isolation()
        or not _test_quality()
        or not _test_factors()
        or not _test_invalid_inputs()
        or not _test_nonfinite()
    ):
        quit(1)
        return
    print("MARICA_G425_CARE_PASS")
    quit(0)


func _test_defaults_and_isolation() -> bool:
    var defaults: Dictionary = CARE.create()
    if not defaults.get("ok", false):
        return _fail("default care rejected")
    var state: MaricaCare = defaults["care"]
    var values: Dictionary = state.to_snapshot()
    if values != {"hunger": 0.0, "hygiene": 1.0, "affection": 1.0, "energy": 1.0}:
        return _fail("incorrect default needs")
    var source: Dictionary = {"hunger": 0.25, "affection": 0.5}
    var result: Dictionary = CARE.create(source)
    if not result.get("ok", false):
        return _fail("valid partial care rejected")
    var original: MaricaCare = result["care"]
    source["hunger"] = 1.0
    var snapshot: Dictionary = original.to_snapshot()
    snapshot["affection"] = 1.0
    if original.to_snapshot()["hunger"] != 0.25:
        return _fail("care retained mutable source")
    if original.to_snapshot()["affection"] != 0.5:
        return _fail("care snapshot did not detach")
    return true


func _test_quality() -> bool:
    var state: Dictionary = CARE.create(
        {"hunger": 0.25, "hygiene": 0.75, "affection": 0.5, "energy": 1.0}
    )
    if not state.get("ok", false):
        return _fail("valid care invalid")
    var quality: Dictionary = CARE.quality(state["care"])
    if not quality.get("ok", false) or quality["quality"] != 0.5:
        return _fail("quality must be weakest essential need")
    var hungry: Dictionary = CARE.quality({"hunger": 1.0})
    if not hungry.get("ok", false) or hungry["quality"] != 0.0:
        return _fail("hunger inversion failed")
    return true


func _test_factors() -> bool:
    var genes: Dictionary = {"size": 0.8, "resilience": 0.6}
    var result: Dictionary = CARE.to_expression_factors({"affection": 0.5}, genes)
    if not result.get("ok", false):
        return _fail("valid factors rejected")
    var factors: Dictionary = result["factors"]
    if factors != {"size": 0.5, "resilience": 0.5}:
        return _fail("care factors must cover each genetic trait")
    return _test_genetic_compatibility(genes, factors)


func _test_genetic_compatibility(genes: Dictionary, factors: Dictionary) -> bool:
    var expression: Dictionary = GENETICS.express(genes, factors)
    if not expression.get("ok", false):
        return _fail("factors incompatible with G424 genetics")
    var traits: Dictionary = expression["traits"]
    if not is_equal_approx(traits["size"], 0.4):
        return _fail("care failed to suppress size expression")
    if not is_equal_approx(traits["resilience"], 0.3):
        return _fail("care failed to suppress resilience expression")
    factors["size"] = 0.0
    if genes["size"] != 0.8:
        return _fail("potential mutated by factor generation")
    return true


func _test_invalid_inputs() -> bool:
    if CARE.create({"hunger": 1.1}).get("ok", true):
        return _fail("hunger > 1 accepted")
    if CARE.create({"energy": -0.25}).get("ok", true):
        return _fail("negative energy accepted")
    if CARE.create({"affection": "low"}).get("ok", true):
        return _fail("nonnumeric affection accepted")
    if CARE.create({"hygiene": true}).get("ok", true):
        return _fail("boolean hygiene accepted")
    if CARE.to_expression_factors({}, {"size": 1.1}).get("ok", true):
        return _fail("invalid genetic potential accepted")
    return true


func _test_nonfinite() -> bool:
    if CARE.create({"hunger": NAN}).get("ok", true):
        return _fail("NaN hunger accepted")
    if CARE.create({"energy": INF}).get("ok", true):
        return _fail("infinite energy accepted")
    if CARE.quality({"affection": -INF}).get("ok", true):
        return _fail("nonfinite quality state accepted")
    return true


func _fail(message: String) -> bool:
    push_error("G425 care: " + message)
    return false
