extends Node2D

# SPEC-004 G452: opt-in founder runtime diagnostic, NOT the shipping scene/art.
const PERSISTENCE = preload("res://src/adapters/local/pet_persistence.gd")
const STORE = preload("res://src/adapters/local/save_store.gd")
const LAYOUT = preload("res://src/domain/farm_layout.gd")
const SOURCE = preload("res://assets/arch_probes/S01_A01_v4_original.png")
const SOURCE_SHA256: String = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"
const SPRITE_SCALE: float = 0.25

var _founder: Sprite2D


func bind_from_store(path: String = "user://marica-save-v1.json") -> Dictionary:
    var loaded: Dictionary = STORE.new(path).load()
    if not loaded.get("ok", false):
        return {"ok": false, "error": "Founder save unavailable or corrupt"}
    if not loaded.get("found", false):
        return {"ok": false, "error": "No saved founder; no implicit creation"}
    return bind_document(loaded["snapshot"])


func bind_document(snapshot: Variant) -> Dictionary:
    # Strictly validate and hydrate *before* touching the rendered scene.
    var hydrated: Dictionary = PERSISTENCE.hydrate(snapshot)
    if not hydrated.get("ok", false):
        return {"ok": false, "error": "Founder document rejected"}
    var pets: Dictionary = hydrated["pets"]
    var founder_id: String = ""
    for pet_id in pets:
        var pet: MaricaPet = pets[pet_id]
        var record: Dictionary = pet.to_snapshot()
        var pedigree: Dictionary = record["pedigree"]
        if not pet.is_soulbound():
            continue
        if pedigree["generation"] != 0:
            return {"ok": false, "error": "Soulbound non-founder is not allowed"}
        if pedigree["founderPetId"] != pet_id or not pedigree["parentPetIds"].is_empty():
            return {"ok": false, "error": "Founder pedigree mismatch"}
        if not founder_id.is_empty():
            return {"ok": false, "error": "More than one soulbound founder"}
        founder_id = pet_id
    if founder_id.is_empty():
        return {"ok": false, "error": "No soulbound founder in profile"}
    if FileAccess.get_sha256(
        "res://assets/arch_probes/S01_A01_v4_original.png"
    ) != SOURCE_SHA256:
        return {"ok": false, "error": "Approved concept source drift"}

    var farm_view: Node2D = get_node_or_null("FarmIsoView") as Node2D
    if farm_view == null:
        return {"ok": false, "error": "Isometric farm view unavailable"}
    var world: Node2D = farm_view.get_node_or_null("IsometricWorld") as Node2D
    if world == null:
        return {"ok": false, "error": "Isometric world unavailable"}
    if _founder != null:
        _founder.queue_free()
    var sprite: Sprite2D = Sprite2D.new()
    sprite.name = "FounderDiagnostic"
    sprite.texture = SOURCE
    sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    sprite.centered = true
    sprite.offset = Vector2(0, -182)
    sprite.scale = Vector2.ONE * SPRITE_SCALE
    var center: Vector2 = (
        Vector2(float(LAYOUT.GRID_WIDTH), float(LAYOUT.GRID_HEIGHT))
        * float(LAYOUT.TILE_SIZE)
        * 0.5
    )
    sprite.position = world.transform * center
    farm_view.add_child(sprite)
    sprite.set_meta(&"founder_pet_id", founder_id)
    sprite.set_meta(&"soulbound", true)
    sprite.set_meta(&"visual_gate", "UNREVIEWED")
    _founder = sprite
    return {"ok": true, "founder_id": founder_id, "soulbound": true, "visual_gate": "OPEN"}


func get_founder_diagnostic() -> Sprite2D:
    return _founder
