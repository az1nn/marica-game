extends SceneTree

# G452: opt-in Godot diagnostic. NO live game/ARTIST/runtime acceptance.
const SCENE = preload("res://scenes/g452_founder_probe.tscn")
const STORE = preload("res://src/adapters/local/save_store.gd")
const SOURCE_HASH = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"
const PATH: String = "user://g452-founder-probe.json"


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    _cleanup()
    var passed: bool = await _verify()
    _cleanup()
    if passed:
        print("MARICA_G452_FOUNDER_PROBE_PASS scenarios=8 visual_gate=OPEN")
    else:
        push_error("MARICA_G452_FOUNDER_PROBE_FAIL")
    quit(0 if passed else 1)


func _verify() -> bool:
    var view: Node2D = SCENE.instantiate()
    root.add_child(view)
    await process_frame
    var ok: bool = true
    var source: String = "res://assets/arch_probes/S01_A01_v4_original.png"
    if FileAccess.get_sha256(source) != SOURCE_HASH:
        ok = false

    # No save, founder, or write is invented on entering the scene.
    if view.get_founder_diagnostic() != null:
        ok = false
    if view.bind_from_store(PATH).get("ok", false) or FileAccess.file_exists(PATH):
        ok = false

    var fixture: Dictionary = _fixture()
    var result: Dictionary = view.bind_document(fixture)
    if not result.get("ok", false) or result.get("founder_id") != "pet-founder-001":
        ok = false
    var sprite: Sprite2D = view.get_founder_diagnostic()
    if sprite == null:
        view.queue_free()
        return false
    var farm: Node2D = view.get_node("FarmIsoView")
    var world: Node2D = view.get_node("FarmIsoView/IsometricWorld")
    var camera: Camera2D = view.get_node("FarmIsoView/Camera2D")
    if (
        sprite.get_parent() != farm
        or sprite.texture_filter != CanvasItem.TEXTURE_FILTER_NEAREST
        or sprite.texture == null
        or sprite.texture.get_size() != Vector2(344, 378)
        or sprite.offset != Vector2(0, -182)
        or sprite.scale != Vector2.ONE * 0.25
        or sprite.get_meta(&"founder_pet_id", "") != "pet-founder-001"
        or sprite.get_meta(&"soulbound", false) != true
        or sprite.get_meta(&"visual_gate", "") != "UNREVIEWED"
    ):
        ok = false
    var center: Vector2 = Vector2(192.0, 160.0)
    if sprite.position.distance_to(world.transform * center) > 0.001:
        ok = false
    if not camera.is_current():
        ok = false

    # Fail closed: invalid schema, founder demotion and duplicate founders.
    var bad: Dictionary = fixture.duplicate(true)
    bad["schema_version"] = 2
    if view.bind_document(bad).get("ok", false):
        ok = false
    bad = fixture.duplicate(true)
    bad["pets"]["pet-founder-001"]["soulbound"] = false
    if view.bind_document(bad).get("ok", false):
        ok = false
    bad = fixture.duplicate(true)
    var sibling: Dictionary = bad["pets"]["pet-founder-001"].duplicate(true)
    sibling["id"] = "pet-founder-002"
    sibling["pedigree"]["founderPetId"] = "pet-founder-002"
    bad["pets"]["pet-founder-002"] = sibling
    if view.bind_document(bad).get("ok", false):
        ok = false
    if view.get_founder_diagnostic() != sprite:
        ok = false

    # Persisted profile is loaded read-only; never auto-creates a founder.
    var stored: Dictionary = fixture.duplicate(true)
    stored["revision"] = 0
    var save: Dictionary = STORE.new(PATH).save(
        stored, -1, func() -> float: return 1791980000.0
    )
    if not save.get("ok", false):
        ok = false
    if not view.bind_from_store(PATH).get("ok", false):
        ok = false
    var loaded: Dictionary = STORE.new(PATH).load()
    if not loaded.get("ok", false) or not loaded.get("found", false):
        ok = false
    elif loaded["snapshot"]["revision"] != 0:
        ok = false
    view.queue_free()
    return ok


func _fixture() -> Dictionary:
    return JSON.parse_string(
        FileAccess.get_file_as_string("res://tests/fixtures/save_v1_founder.json")
    )


func _cleanup() -> void:
    for suffix in ["", ".bak", ".tmp", ".bak.tmp", ".restore.tmp"]:
        var path: String = PATH + suffix
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
