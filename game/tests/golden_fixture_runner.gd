extends SceneTree

# G416: headless, offline fixture transport. Domain parity remains PENDING_PORT.
const CATALOG_PATH: String = "res://tests/fixtures/golden.json"


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
    var contracts: Variant = catalog.get("contracts")
    if typeof(contracts) != TYPE_ARRAY:
        _fail("missing contract list")
        return

    var active_count: int = 0
    var pending_count: int = 0
    for contract_value in contracts:
        if typeof(contract_value) != TYPE_DICTIONARY:
            _fail("contract entry must be an object")
            return
        var contract: Dictionary = contract_value
        var identifier: String = str(contract.get("id", ""))
        var status: String = str(contract.get("status", ""))
        var cases_value: Variant = contract.get("cases")
        if typeof(cases_value) != TYPE_ARRAY:
            _fail("missing cases for " + identifier)
            return
        var cases: Array = cases_value
        if status == "PENDING_PORT":
            pending_count += cases.size()
            print("MARICA_G416_PENDING_PORT ", identifier, " cases=", cases.size())
            continue
        if status != "ACTIVE_SELFTEST" or identifier != "harness.deep_equal":
            _fail("unregistered ACTIVE contract: " + identifier)
            return

        for case_value in cases:
            if typeof(case_value) != TYPE_DICTIONARY:
                _fail("malformed self-test case")
                return
            var fixture: Dictionary = case_value
            var case_input: Dictionary = fixture.get("input", {})
            var expected: Dictionary = fixture.get("expected", {})
            var actual: Dictionary = {
                "equal": _deep_equal(case_input.get("left"), case_input.get("right"))
            }
            if not _deep_equal(expected, actual):
                _fail("fixture mismatch: " + str(fixture.get("id", "<unknown>")))
                return
            # Same exact inputs must be stable across repeated execution.
            var repeat: Dictionary = {
                "equal": _deep_equal(case_input.get("left"), case_input.get("right"))
            }
            if not _deep_equal(actual, repeat):
                _fail("nondeterministic harness result")
                return
            active_count += 1

    if active_count == 0 or pending_count == 0:
        _fail("both harness self-tests and deferred domain fixtures are required")
        return

    print(
        "MARICA_G416_HARNESS_PASS active=", active_count,
        " pending=", pending_count, " parity=NOT_YET_PROVEN"
    )
    quit(0)


func _deep_equal(left: Variant, right: Variant) -> bool:
    if typeof(left) != typeof(right):
        return false
    if typeof(left) == TYPE_DICTIONARY:
        var left_map: Dictionary = left
        var right_map: Dictionary = right
        if left_map.size() != right_map.size():
            return false
        for key in left_map:
            if not right_map.has(key):
                return false
            if not _deep_equal(left_map[key], right_map[key]):
                return false
        return true
    if typeof(left) == TYPE_ARRAY:
        var left_array: Array = left
        var right_array: Array = right
        if left_array.size() != right_array.size():
            return false
        for index in range(left_array.size()):
            if not _deep_equal(left_array[index], right_array[index]):
                return false
        return true
    return left == right


func _fail(message: String) -> void:
    push_error("G416 fixture harness: " + message)
    quit(1)
