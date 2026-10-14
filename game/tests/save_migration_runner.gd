extends SceneTree

# SPEC-004 G443 deterministic schema-version admission and migration proofs.
const MIGRATION = preload("res://src/adapters/local/save_migration.gd")
const STORE = preload("res://src/adapters/local/save_store.gd")
const PATH: String = "user://g443-migration-runner.json"


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    _cleanup()
    var ok: bool = _test_all()
    _cleanup()
    if ok:
        print("MARICA_G443_MIGRATION_PASS scenarios=12")
    quit(0 if ok else 1)


func _test_all() -> bool:
    if not _check(_identity("save_v1_minimal.json"), "minimal v1 identity"):
        return false
    if not _check(_identity("save_v1_founder.json"), "founder v1 identity"):
        return false
    if not _check(_identity("save_v1_succession.json"), "succession v1 identity"):
        return false
    if not _check(_reject_version(0), "unapproved legacy v0"):
        return false
    if not _check(_reject_version(2), "unknown future v2"):
        return false
    if not _check(_reject_version(9007199254740991), "unapproved high version"):
        return false
    if not _check(_bad_version_values(), "missing/invalid version"):
        return false
    if not _check(_bad_payload(), "invalid v1 payload"):
        return false
    if not _check(_no_mutation(), "detached input"):
        return false
    if not _check(_deterministic(), "deterministic repeated migration"):
        return false
    if not _check(_store_preserved(), "G442 primary/backup compatibility"):
        return false
    return _check(_reject_corrupt_store(), "G442 future save fails closed")


func _identity(name: String) -> bool:
    var original: Dictionary = _fixture(name)
    var result: Dictionary = MIGRATION.migrate(original)
    return (
        result.get("ok", false)
        and not result.get("migrated", true)
        and result.get("from_version", -1) == 1
        and result.get("to_version", -1) == 1
        and result["document"] == original
    )


func _reject_version(version: int) -> bool:
    var original: Dictionary = _fixture("save_v1_minimal.json")
    original["schema_version"] = version
    var before: String = JSON.stringify(original)
    var result: Dictionary = MIGRATION.migrate(original)
    return (
        not result.get("ok", false)
        and result.get("requires_migration_contract", false)
        and result.get("from_version", -1) == version
        and JSON.stringify(original) == before
    )


func _bad_version_values() -> bool:
    var original: Dictionary = _fixture("save_v1_minimal.json")
    for value in ["1", 1.5, -1, null, true, INF, NAN]:
        var candidate: Dictionary = original.duplicate(true)
        candidate["schema_version"] = value
        if MIGRATION.migrate(candidate).get("ok", false):
            return false
    original.erase("schema_version")
    if MIGRATION.migrate(original).get("ok", false):
        return false
    return not MIGRATION.migrate([]).get("ok", false)


func _bad_payload() -> bool:
    var candidate: Dictionary = _fixture("save_v1_founder.json")
    candidate["pets"]["pet-founder-001"]["pedigree"]["founderPetId"] = "missing"
    var result: Dictionary = MIGRATION.migrate(candidate)
    return not result.get("ok", false) and not result.has("document")


func _no_mutation() -> bool:
    var original: Dictionary = _fixture("save_v1_founder.json")
    var before: String = JSON.stringify(original)
    var result: Dictionary = MIGRATION.migrate(original)
    if not result.get("ok", false):
        return false
    result["document"]["pets"]["pet-founder-001"]["affection"] = 0.9
    return JSON.stringify(original) == before


func _deterministic() -> bool:
    var source: Dictionary = _fixture("save_v1_succession.json")
    var first: Dictionary = MIGRATION.migrate(source)
    if not first.get("ok", false):
        return false
    var second: Dictionary = MIGRATION.migrate(first["document"])
    return (
        second.get("ok", false)
        and JSON.stringify(first["document"]) == JSON.stringify(second["document"])
        and not second.get("migrated", true)
    )


func _store_preserved() -> bool:
    _cleanup()
    var source: Dictionary = _fixture("save_v1_founder.json")
    source["revision"] = 0
    var first: Dictionary = MIGRATION.migrate(source)
    if not first.get("ok", false):
        return false
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var saved: Dictionary = store.save(first["document"], -1, Callable(self, "_now"))
    if not saved.get("ok", false):
        return false
    var loaded: Dictionary = store.load()
    if not loaded.get("ok", false):
        return false
    var migrated: Dictionary = MIGRATION.migrate(loaded["snapshot"])
    if not migrated.get("ok", false):
        return false
    var updated: Dictionary = store.save(migrated["document"], 0, Callable(self, "_now"))
    if not updated.get("ok", false):
        return false
    var backup: Dictionary = STORE.new(PATH + ".bak").load()
    return (
        backup.get("ok", false)
        and backup["snapshot"]["revision"] == 0
        and store.load()["snapshot"]["revision"] == 1
    )


func _reject_corrupt_store() -> bool:
    var file: FileAccess = FileAccess.open(PATH, FileAccess.WRITE)
    if file == null:
        return false
    file.store_string('{"schema_version":2}')
    file.close()
    var store: MaricaLocalSaveStore = STORE.new(PATH)
    var recovered: Dictionary = store.load()
    return (
        recovered.get("ok", false)
        and recovered.get("recovered", false)
        and recovered["snapshot"]["schema_version"] == 1
        and not MIGRATION.migrate({"schema_version": 2}).get("ok", false)
    )


func _now() -> float:
    return 1791980000.0


func _fixture(name: String) -> Dictionary:
    return JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/" + name))


func _cleanup() -> void:
    for suffix in ["", ".bak", ".tmp", ".bak.tmp", ".restore.tmp"]:
        var path: String = PATH + suffix
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _check(ok: bool, label: String) -> bool:
    if not ok:
        push_error("MARICA_G443_FAIL " + label)
    return ok
