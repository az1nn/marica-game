extends Node2D

# SPEC-005 V203 CENA: opt-in framing study; NOT gameplay, production art or runtime approval.
const CAMERA_POLICY = preload("res://src/presentation/farm_iso_camera.gd")
const SOURCE_PATH: String = "res://assets/arch_probes/S01_A01_v4_original.png"
const SOURCE_SHA256: String = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"
const PORTRAIT_ASPECT_LIMIT: float = 1.35
const PORTRAIT_FOCUS_WIDTH: float = 220.0
const PORTRAIT_MAX_ZOOM: float = 1.75

@onready var _camera: Camera2D = $FarmIsoView/Camera2D
@onready var _founder: Sprite2D = $FarmIsoView/FounderV4TestCopy


func _ready() -> void:
    if FileAccess.get_sha256(SOURCE_PATH) != SOURCE_SHA256:
        push_error("MARICA_V203_SOURCE_DRIFT")
        return
    _founder.set_meta(&"visual_gate", "UNREVIEWED")
    _founder.set_meta(&"diagnostic_only", true)
    apply_preview_size(get_viewport_rect().size)
    get_viewport().size_changed.connect(_on_viewport_resized)


static func preview_zoom_for_size(viewport_size: Vector2) -> float:
    var fitted: float = CAMERA_POLICY.fit_zoom_for_size(viewport_size)
    if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
        return fitted
    if viewport_size.y <= viewport_size.x * PORTRAIT_ASPECT_LIMIT:
        return fitted
    # In portrait, intentionally crop farm margins to keep the founding pet legible.
    # This is camera-only: no texture resampling, sprite derivation or HUD acceptance.
    var focus_zoom: float = clampf(
        viewport_size.x / PORTRAIT_FOCUS_WIDTH, CAMERA_POLICY.ZOOM_MIN, PORTRAIT_MAX_ZOOM
    )
    return maxf(fitted, focus_zoom)


func apply_preview_size(viewport_size: Vector2) -> bool:
    if _camera == null or _founder == null:
        return false
    if not _camera.set_zoom_level(preview_zoom_for_size(viewport_size)):
        return false
    _camera.position = _founder.position
    return true


func _on_viewport_resized() -> void:
    apply_preview_size(get_viewport_rect().size)
