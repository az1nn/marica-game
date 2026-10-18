extends Node2D

# CENA-B isolated option: environmental continuity behind V203/V206 diagnostic farm.
# This is NOT an interactive world extension, approved art, HUD or final runtime.
const UNDERLAY = preload("res://src/presentation/cena131b_terrain_underlay.gd")
const SOURCE_PATH: String = "res://assets/arch_probes/S01_A01_v4_original.png"
const SOURCE_SHA256: String = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"
const PORTRAIT_ASPECT_LIMIT: float = 1.35

var _terrain: Node2D
@onready var _preview: Node2D = $V203PortraitPreview
@onready var _world: Node2D = $V203PortraitPreview/FarmIsoView/IsometricWorld


func _ready() -> void:
    if FileAccess.get_sha256(SOURCE_PATH) != SOURCE_SHA256:
        push_error("MARICA_CENA131B_SOURCE_DRIFT")
        return
    _terrain = Node2D.new()
    _terrain.name = "DecorativeExteriorNotPlayable"
    _terrain.set_script(UNDERLAY)
    _terrain.z_index = -5
    _world.add_child(_terrain)
    _world.move_child(_terrain, 0)
    set_meta(&"blockout_only", true)
    apply_scene_size(get_viewport_rect().size)
    get_viewport().size_changed.connect(_on_viewport_resized)


static func is_portrait_size(size: Vector2) -> bool:
    return size.x > 0.0 and size.y > size.x * PORTRAIT_ASPECT_LIMIT


func apply_scene_size(size: Vector2) -> bool:
    if _terrain == null or not _preview.apply_preview_size(size):
        return false
    _terrain.visible = is_portrait_size(size)
    return true


func pan_by_screen_delta(delta: Vector2, size: Vector2) -> bool:
    return _preview.pan_by_screen_delta(delta, size)


func _on_viewport_resized() -> void:
    apply_scene_size(get_viewport_rect().size)
