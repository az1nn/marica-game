extends Node2D

# SPEC-005 V203 CENA: opt-in framing study; NOT gameplay, production art or runtime approval.
const CAMERA_POLICY = preload("res://src/presentation/farm_iso_camera.gd")
const LAYOUT = preload("res://src/domain/farm_layout.gd")
const SOURCE_PATH: String = "res://assets/arch_probes/S01_A01_v4_original.png"
const SOURCE_SHA256: String = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"
const PORTRAIT_ASPECT_LIMIT: float = 1.35
const PORTRAIT_FOCUS_WIDTH: float = 220.0
const PORTRAIT_MAX_ZOOM: float = 1.75

var _mouse_dragging: bool = false
var _active_touch: int = -1

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
    _camera.position = clamp_preview_position(_founder.position, viewport_size, _camera.zoom.x)
    return true


func _on_viewport_resized() -> void:
    apply_preview_size(get_viewport_rect().size)


# V206: diagnostic navigation for LENTE's lateral-crop REVISE; not HUD acceptance.
static func farm_projection_bounds() -> Rect2:
    var width: float = float(LAYOUT.GRID_WIDTH * LAYOUT.TILE_SIZE)
    var height: float = float(LAYOUT.GRID_HEIGHT * LAYOUT.TILE_SIZE)
    var projection: Transform2D = Transform2D(
        CAMERA_POLICY.ISO_X, CAMERA_POLICY.ISO_Y, Vector2.ZERO
    )
    var corners: Array[Vector2] = [
        projection * Vector2.ZERO,
        projection * Vector2(width, 0.0),
        projection * Vector2(0.0, height),
        projection * Vector2(width, height)
    ]
    var lower: Vector2 = corners[0]
    var upper: Vector2 = corners[0]
    for corner in corners:
        lower = Vector2(minf(lower.x, corner.x), minf(lower.y, corner.y))
        upper = Vector2(maxf(upper.x, corner.x), maxf(upper.y, corner.y))
    return Rect2(lower, upper - lower)


static func pan_limits_for_size(viewport_size: Vector2, zoom_level: float) -> Rect2:
    var bounds: Rect2 = farm_projection_bounds()
    if viewport_size.x <= 0.0 or viewport_size.y <= 0.0 or zoom_level <= 0.0:
        return Rect2(bounds.get_center(), Vector2.ZERO)
    var half_visible: Vector2 = viewport_size / (2.0 * zoom_level)
    var lower: Vector2 = bounds.position + half_visible
    var upper: Vector2 = bounds.end - half_visible
    if lower.x > upper.x:
        lower.x = bounds.get_center().x
        upper.x = lower.x
    if lower.y > upper.y:
        lower.y = bounds.get_center().y
        upper.y = lower.y
    return Rect2(lower, upper - lower)


static func clamp_preview_position(
    requested: Vector2, viewport_size: Vector2, zoom_level: float
) -> Vector2:
    var limits: Rect2 = pan_limits_for_size(viewport_size, zoom_level)
    return requested.clamp(limits.position, limits.end)


func pan_by_screen_delta(screen_delta: Vector2, viewport_size: Vector2) -> bool:
    if _camera == null or screen_delta.length_squared() < 0.25:
        return false
    if not screen_delta.is_finite() or viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
        return false
    var previous: Vector2 = _camera.position
    var target: Vector2 = _camera.position - screen_delta / _camera.zoom.x
    _camera.position = clamp_preview_position(target, viewport_size, _camera.zoom.x)
    return _camera.position.distance_squared_to(previous) > 0.000001


func _unhandled_input(event: InputEvent) -> void:
    var size: Vector2 = get_viewport_rect().size
    if size.y <= size.x * PORTRAIT_ASPECT_LIMIT:
        return
    if event is InputEventScreenTouch:
        var touch: InputEventScreenTouch = event as InputEventScreenTouch
        if touch.pressed and _active_touch < 0:
            _active_touch = touch.index
        elif not touch.pressed and _active_touch == touch.index:
            _active_touch = -1
    elif event is InputEventScreenDrag:
        var drag: InputEventScreenDrag = event as InputEventScreenDrag
        if drag.index == _active_touch and pan_by_screen_delta(drag.relative, size):
            get_viewport().set_input_as_handled()
    elif event is InputEventMouseButton:
        var mouse: InputEventMouseButton = event as InputEventMouseButton
        if mouse.button_index == MOUSE_BUTTON_LEFT:
            _mouse_dragging = mouse.pressed
    elif event is InputEventMouseMotion and _mouse_dragging:
        var motion: InputEventMouseMotion = event as InputEventMouseMotion
        if pan_by_screen_delta(motion.relative, size):
            get_viewport().set_input_as_handled()
