extends SceneTree

# G416: headless, offline fixture transport. Domain parity remains PENDING_PORT.
const CATALOG_PATH: String = "res://tests/fixtures/golden.json"
const PET_ID = preload("res://src/domain/pet_id.gd")
const LINEAGE_ID = preload("res://src/domain/lineage_id.gd")
const PEDIGREE = preload("res://src/domain/pedigree.gd")


func _initialize() -> void:
    call_deferred("_run_catalog")


func _run_catalog() -> void:
    if not FileAccess.file_exists(CATALOG_PATH):
        _fail("fixture catalog is missing")
        return

    var document: Variant = JSON.parse_string(FileAccess.get_file_as_string(CATALOG_PATH))
    if typeof(document) != TYPE_DICTIONARY:
        _fail("fixture catalog must contain a JSON object")
        return

    var catalog: Dictionary = document
    if catalog.get("schema_version") != 1:
        _fail("unsupported fixture schema")
        return
    var contracts_value: Variant = catalog.get("contracts")
    if typeof(contracts_value) != TYPE_ARRAY:
        _fail("missing contract list")
        return

    var contracts: Array = contracts_value
    var active_count: int = 0
    var pending_count: int = 0
    var verified_count: int = 0
    for contract_value in contracts:
        var result: Dictionary = _check_contract(contract_value)
        if result.is_empty():
            return
        active_count += result["active"]
        pending_count += result["pending"]
        verified_count += result["verified"]

    if active_count == 0 or pending_count == 0 or verified_count == 0:
        _fail("both harness self-tests and deferred domain fixtures are required")
        return

    print(
        "MARICA_G416_HARNESS_PASS active=",
        active_count,
        " verified=",
        verified_count,
        " pending=",
        pending_count,
        " parity=NOT_YET_PROVEN"
    )
    quit(0)


func _check_contract(contract_value: Variant) -> Dictionary:
    if typeof(contract_value) != TYPE_DICTIONARY:
        _fail("contract entry must be an object")
        return {}
    var contract: Dictionary = contract_value
    var identifier: String = str(contract.get("id", ""))
    var status: String = str(contract.get("status", ""))
    var cases_value: Variant = contract.get("cases")
    if typeof(cases_value) != TYPE_ARRAY:
        _fail("missing cases for " + identifier)
        return {}
    var cases: Array = cases_value
    if status == "PENDING_PORT":
        print("MARICA_G416_PENDING_PORT ", identifier, " cases=", cases.size())
        return {"active": 0, "verified": 0, "pending": cases.size()}
    if status == "ACTIVE_SELFTEST" and identifier == "harness.deep_equal":
        return _verify_selftests(cases)
    if (
        status == "ACTIVE_PARITY"
        and identifier in ["pet_id.from_string", "lineage_id.from_string", "pedigree.create"]
    ):
        return _verify_domain_cases(identifier, cases)
    _fail("unregistered ACTIVE contract: " + identifier)
    return {}


func _verify_selftests(cases: Array) -> Dictionary:
    for case_value in cases:
        if not _check_selftest_case(case_value):
            return {}
    return {"active": cases.size(), "verified": 0, "pending": 0}


func _verify_domain_cases(identifier: String, cases: Array) -> Dictionary:
    for case_value in cases:
        if not _check_domain_case(identifier, case_value):
            return {}
    if identifier == "pet_id.from_string":
        print("MARICA_G420_PET_ID_PARITY_PASS cases=", cases.size())
    elif identifier == "lineage_id.from_string":
        print("MARICA_G421_LINEAGE_ID_PARITY_PASS cases=", cases.size())
    elif identifier == "pedigree.create":
        print("MARICA_G421_PEDIGREE_PARITY_PASS cases=", cases.size())
    return {"active": 0, "verified": cases.size(), "pending": 0}


func _check_domain_case(identifier: String, case_value: Variant) -> bool:
    if typeof(case_value) != TYPE_DICTIONARY:
        _fail("invalid domain fixture: " + identifier)
        return false
    var fixture: Dictionary = case_value
    var case_input: Dictionary = fixture.get("input", {})
    var actual: Dictionary = _run_domain_operation(identifier, case_input)
    var expected: Dictionary = fixture.get("expected", {})
    if fixture.has("expected_error"):
        expected = {"error": fixture["expected_error"]}
    if not _deep_equal(actual, expected):
        _fail(identifier + " golden mismatch: " + str(fixture.get("id", "unknown")))
        return false
    var repeat: Dictionary = _run_domain_operation(identifier, case_input)
    if not _deep_equal(actual, repeat):
        _fail(identifier + " golden nondeterminism")
        return false
    return true


func _run_domain_operation(identifier: String, case_input: Dictionary) -> Dictionary:
    var result: Dictionary = {}
    if identifier == "pet_id.from_string":
        result = PET_ID.from_string(case_input.get("value"))
    elif identifier == "lineage_id.from_string":
        result = LINEAGE_ID.from_string(case_input.get("value"))
    elif identifier == "pedigree.create":
        result = PEDIGREE.create(case_input)
    if not result.get("ok", false):
        return {"error": result.get("error", "")}
    if identifier == "pedigree.create":
        var record: MaricaPedigree = result["pedigree"]
        return record.to_snapshot()
    return {"id": result.get("id")}


func _check_selftest_case(case_value: Variant) -> bool:
    if typeof(case_value) != TYPE_DICTIONARY:
        _fail("malformed self-test case")
        return false
    var fixture: Dictionary = case_value
    var case_input: Dictionary = fixture.get("input", {})
    var expected: Dictionary = fixture.get("expected", {})
    var actual: Dictionary = {"equal": _deep_equal(case_input.get("left"), case_input.get("right"))}
    if not _deep_equal(expected, actual):
        _fail("fixture mismatch: " + str(fixture.get("id", "<unknown>")))
        return false
    var repeat: Dictionary = {"equal": _deep_equal(case_input.get("left"), case_input.get("right"))}
    if not _deep_equal(actual, repeat):
        _fail("nondeterministic harness result")
        return false
    return true


func _deep_equal(left: Variant, right: Variant) -> bool:
    # Luau and JSON use numeric scalars; GDScript distinguishes int and float.
    # Permit exact numeric equality, never coercion of strings or booleans.
    var left_number: bool = typeof(left) == TYPE_INT or typeof(left) == TYPE_FLOAT
    var right_number: bool = typeof(right) == TYPE_INT or typeof(right) == TYPE_FLOAT
    if left_number and right_number:
        return left == right
    if typeof(left) != typeof(right):
        return false
    if typeof(left) == TYPE_DICTIONARY:
        return _equal_dicts(left, right)
    if typeof(left) == TYPE_ARRAY:
        return _equal_arrays(left, right)
    return left == right


func _equal_dicts(left: Dictionary, right: Dictionary) -> bool:
    if left.size() != right.size():
        return false
    for key in left:
        if not right.has(key):
            return false
        if not _deep_equal(left[key], right[key]):
            return false
    return true


func _equal_arrays(left: Array, right: Array) -> bool:
    if left.size() != right.size():
        return false
    for index in range(left.size()):
        if not _deep_equal(left[index], right[index]):
            return false
    return true


func _fail(message: String) -> void:
    push_error("G416 fixture harness: " + message)
    quit(1)
