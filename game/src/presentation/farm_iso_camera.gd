extends Camera2D

# G451: a separate technical isometric view. G450 layout remains unchanged.
const LAYOUT = preload("res://src/domain/farm_layout.gd")
const ZOOM_MIN: float = 0.5
const ZOOM_MAX: float = 2.0
const ZOOM_STEP: float = 1.15
const ISO_X: Vector2 = Vector2(0.7071067812, 0.3535533906)
const ISO_Y: Vector2 = Vector2(-0.7071067812, 0.3535533906)

@onready var _world: Node2D = $"../IsometricWorld"


func _ready() -> void:
    _world.transform = Transform2D(ISO_X, ISO_Y, Vector2.ZERO)
    var midpoint: Vector2 = (
        Vector2(float(LAYOUT.GRID_WIDTH), float(LAYOUT.GRID_HEIGHT)) * float(LAYOUT.TILE_SIZE) * 0.5
    )
    position = _world.transform * midpoint
    set_zoom_level(fit_zoom_for_size(get_viewport_rect().size))
    make_current()
    get_viewport().size_changed.connect(_on_viewport_resized)
    set_meta(&"marica_g451_ready", true)
    print("MARICA_G451_CAMERA_READY")


static func fit_zoom_for_size(viewport_size: Vector2) -> float:
    if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
        return ZOOM_MIN
    var projected_width: float = (
        float(LAYOUT.GRID_WIDTH + LAYOUT.GRID_HEIGHT) * float(LAYOUT.TILE_SIZE) * absf(ISO_X.x)
    )
    var projected_height: float = (
        float(LAYOUT.GRID_WIDTH + LAYOUT.GRID_HEIGHT) * float(LAYOUT.TILE_SIZE) * absf(ISO_X.y)
    )
    return clampf(
        minf(0.9 * viewport_size.x / projected_width, 0.9 * viewport_size.y / projected_height),
        ZOOM_MIN,
        ZOOM_MAX
    )


func set_zoom_level(requested: Variant) -> bool:
    if typeof(requested) != TYPE_FLOAT and typeof(requested) != TYPE_INT:
        return false
    var value: float = float(requested)
    if is_nan(value) or is_inf(value) or value <= 0.0:
        return false
    var limited: float = clampf(value, ZOOM_MIN, ZOOM_MAX)
    zoom = Vector2.ONE * limited
    return true


func zoom_by(factor: float) -> bool:
    if is_nan(factor) or is_inf(factor) or factor <= 0.0:
        return false
    return set_zoom_level(zoom.x * factor)


func _on_viewport_resized() -> void:
    set_zoom_level(fit_zoom_for_size(get_viewport_rect().size))


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var wheel: InputEventMouseButton = event as InputEventMouseButton
        if not wheel.pressed:
            return
        if wheel.button_index == MOUSE_BUTTON_WHEEL_UP:
            if zoom_by(ZOOM_STEP):
                get_viewport().set_input_as_handled()
        elif wheel.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            if zoom_by(1.0 / ZOOM_STEP):
                get_viewport().set_input_as_handled()
    elif event is InputEventMagnifyGesture:
        var gesture: InputEventMagnifyGesture = event as InputEventMagnifyGesture
        if zoom_by(gesture.factor):
            get_viewport().set_input_as_handled()
