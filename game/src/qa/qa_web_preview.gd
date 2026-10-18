extends Node2D

# SPEC-008 Q806: opt-in QA tap feedback. NEVER gameplay, pet care, ART acceptance or save.
const LAYOUT = preload("res://src/domain/farm_layout.gd")
const TAP_DRIFT_SQUARED: float = 324.0
const SYNTHETIC_MOUSE_SUPPRESSION_MS: int = 700
const QA_TAPS_ENABLED: bool = true

var qa_tap_count: int = 0
var qa_selection: String = "none"

var _touch_down: Dictionary = {}
var _touch_dragged: Dictionary = {}
var _last_touch_event_ms: int = -100000
var _mouse_pressed: bool = false
var _mouse_down: Vector2 = Vector2.ZERO
var _mouse_dragged: bool = false
var _feedback: Label
var _last_published_camera: Vector2 = Vector2.INF

@onready var _founder: Sprite2D = $FounderScene/FarmIsoView/FounderV4TestCopy
@onready var _world: Node2D = $FounderScene/FarmIsoView/IsometricWorld
@onready var _camera: Camera2D = $FounderScene/FarmIsoView/Camera2D


func _ready() -> void:
    _create_qa_overlay()
    if not OS.has_feature("web"):
        return
    await get_tree().process_frame
    if _founder == null or _founder.texture == null or _world == null:
        push_error("MARICA_QA001_SCENE_INCOMPLETE")
        return
    JavaScriptBridge.eval("window.__MARICA_QA_GODOT_READY = true")
    _publish_web_state()
    get_viewport().size_changed.connect(_publish_web_state)


func _process(_delta: float) -> void:
    if OS.has_feature("web") and _camera != null and _camera.position != _last_published_camera:
        _publish_web_state()


func _create_qa_overlay() -> void:
    var layer: CanvasLayer = CanvasLayer.new()
    layer.name = "QAOnlyFeedbackLayer"
    layer.layer = 20
    add_child(layer)
    var panel: PanelContainer = PanelContainer.new()
    panel.name = "TapFeedback"
    panel.position = Vector2(14, 14)
    panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
    var background: StyleBoxFlat = StyleBoxFlat.new()
    background.bg_color = Color(0.06, 0.12, 0.17, 0.92)
    background.set_corner_radius_all(9)
    background.content_margin_left = 11
    background.content_margin_right = 11
    background.content_margin_top = 7
    background.content_margin_bottom = 7
    panel.add_theme_stylebox_override("panel", background)
    layer.add_child(panel)
    _feedback = Label.new()
    _feedback.name = "SelectionStatus"
    _feedback.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _feedback.add_theme_font_size_override("font_size", 14)
    _feedback.add_theme_color_override("font_color", Color.WHITE)
    _feedback.text = "QA: toque no cachorro\nArraste para mover a fazenda"
    panel.add_child(_feedback)


func _input(event: InputEvent) -> void:
    # Do NOT handle input: CENA's _unhandled_input must still receive camera drags.
    if event is InputEventScreenTouch:
        var touch: InputEventScreenTouch = event as InputEventScreenTouch
        _last_touch_event_ms = Time.get_ticks_msec()
        if touch.pressed:
            _touch_down[touch.index] = touch.position
            _touch_dragged[touch.index] = false
        elif _touch_down.has(touch.index):
            var start: Vector2 = _touch_down[touch.index]
            var moved: bool = bool(_touch_dragged.get(touch.index, true))
            _touch_down.erase(touch.index)
            _touch_dragged.erase(touch.index)
            if not moved and start.distance_squared_to(touch.position) <= TAP_DRIFT_SQUARED:
                _select_at(touch.position)
    elif event is InputEventScreenDrag:
        var drag: InputEventScreenDrag = event as InputEventScreenDrag
        _last_touch_event_ms = Time.get_ticks_msec()
        if _touch_down.has(drag.index):
            var start: Vector2 = _touch_down[drag.index]
            if start.distance_squared_to(drag.position) > TAP_DRIFT_SQUARED:
                _touch_dragged[drag.index] = true
    elif event is InputEventMouseButton:
        var mouse: InputEventMouseButton = event as InputEventMouseButton
        if mouse.button_index != MOUSE_BUTTON_LEFT:
            return
        if Time.get_ticks_msec() - _last_touch_event_ms < SYNTHETIC_MOUSE_SUPPRESSION_MS:
            _mouse_pressed = false
            return
        if mouse.pressed:
            _mouse_pressed = true
            _mouse_down = mouse.position
            _mouse_dragged = false
        elif _mouse_pressed:
            _mouse_pressed = false
            if not _mouse_dragged and _mouse_down.distance_squared_to(mouse.position) <= TAP_DRIFT_SQUARED:
                _select_at(mouse.position)
    elif event is InputEventMouseMotion and _mouse_pressed:
        var motion: InputEventMouseMotion = event as InputEventMouseMotion
        if _mouse_down.distance_squared_to(motion.position) > TAP_DRIFT_SQUARED:
            _mouse_dragged = true


func _select_at(screen_position: Vector2) -> void:
    if not QA_TAPS_ENABLED or _founder == null or _world == null:
        return
    var local_founder: Vector2 = (
        _founder.get_global_transform_with_canvas().affine_inverse() * screen_position
    )
    var source_rect: Rect2 = _founder.get_rect()
    if source_rect.has_point(local_founder):
        qa_selection = "founder"
        _feedback.text = "Cachorro fundador selecionado\nQA: cuidado ainda nao implementado"
    else:
        var farm_local: Vector2 = (
            _world.get_global_transform_with_canvas().affine_inverse() * screen_position
        )
        var farm_size: Vector2 = Vector2(
            float(LAYOUT.GRID_WIDTH * LAYOUT.TILE_SIZE),
            float(LAYOUT.GRID_HEIGHT * LAYOUT.TILE_SIZE)
        )
        if Rect2(Vector2.ZERO, farm_size).has_point(farm_local):
            qa_selection = "farm"
            _feedback.text = "Fazenda selecionada\nQA: arraste para navegar"
        else:
            qa_selection = "outside"
            _feedback.text = "Fora da fazenda\nQA: toque no cachorro"
    qa_tap_count += 1
    _publish_web_state()


func _publish_web_state() -> void:
    if not OS.has_feature("web") or _founder == null:
        return
    var center: Vector2 = (
        _founder.get_global_transform_with_canvas() * _founder.get_rect().get_center()
    )
    _last_published_camera = _camera.position
    var data: Dictionary = {
        "camera_x": _camera.position.x,
        "count": qa_tap_count,
        "selection": qa_selection,
        "founder_center": [center.x, center.y],
        "source": "Godot InputEvent (QA-only)",
        "gameplay_enabled": false
    }
    JavaScriptBridge.eval("window.__MARICA_QA_TAP_STATE = " + JSON.stringify(data))
