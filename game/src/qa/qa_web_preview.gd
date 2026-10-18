extends Node2D

# QA-only wrapper. A selected founder proves native Godot input, not gameplay.
const TOUCH_DRAG_PX: float = 24.0
const MOUSE_DRAG_PX: float = 12.0
const SYNTHETIC_MOUSE_SUPPRESS_MS: int = 850
const FEEDBACK_TEXT: String = "Cachorro fundador selecionado"

var _touch_index: int = -1
var _touch_down: Vector2 = Vector2.ZERO
var _touch_moved: bool = false
var _last_touch_ms: int = -100000
var _mouse_down: bool = false
var _mouse_down_position: Vector2 = Vector2.ZERO
var _mouse_moved: bool = false
var _select_count: int = 0

@onready var _founder: Sprite2D = $FounderScene/FarmIsoView/FounderV4TestCopy
var _feedback: Label


func _ready() -> void:
    _install_feedback()
    if not OS.has_feature("web"):
        return
    await get_tree().process_frame
    if _founder == null or _founder.texture == null:
        push_error("MARICA_QA001_SCENE_INCOMPLETE")
        return
    _publish_input_state()
    JavaScriptBridge.eval("window.__MARICA_QA_GODOT_READY = true")


func _install_feedback() -> void:
    var layer: CanvasLayer = CanvasLayer.new()
    layer.name = "QAOnlyInputFeedback"
    layer.layer = 10
    add_child(layer)
    _feedback = Label.new()
    _feedback.name = "SelectionLabel"
    _feedback.position = Vector2(16, 28)
    _feedback.size = Vector2(350, 64)
    _feedback.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _feedback.add_theme_font_size_override("font_size", 20)
    _feedback.add_theme_color_override("font_color", Color.WHITE)
    _feedback.add_theme_color_override("font_outline_color", Color.BLACK)
    _feedback.add_theme_constant_override("outline_size", 5)
    _feedback.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _feedback.visible = false
    layer.add_child(_feedback)


func _founder_hit(screen_point: Vector2) -> bool:
    if _founder == null or _founder.texture == null:
        return false
    var local_point: Vector2 = (
        _founder.get_global_transform_with_canvas().affine_inverse() * screen_point
    )
    return _founder.get_rect().has_point(local_point)


func _select_founder() -> void:
    _select_count += 1
    _feedback.text = FEEDBACK_TEXT
    _feedback.visible = true
    _publish_input_state()
    print("MARICA_QA002_FOUNDER_SELECTED count=%d" % _select_count)


func _publish_input_state() -> void:
    if not OS.has_feature("web") or _founder == null:
        return
    var center: Vector2 = (
        _founder.get_global_transform_with_canvas() * _founder.get_rect().get_center()
    )
    # Read-only diagnostics originate in Godot; JS must not fake selection or draw UI.
    JavaScriptBridge.eval(
        "window.__MARICA_QA_FOUNDER_CENTER = " + JSON.stringify([center.x, center.y])
    )
    JavaScriptBridge.eval("window.__MARICA_QA_SELECTIONS = " + str(_select_count))
    JavaScriptBridge.eval("window.__MARICA_QA_SELECTION_TEXT = " + JSON.stringify(_feedback.text))


func _input(event: InputEvent) -> void:
    # Do not set input as handled: V206 camera pan keeps ownership of drag.
    if event is InputEventScreenTouch:
        var touch: InputEventScreenTouch = event as InputEventScreenTouch
        _last_touch_ms = Time.get_ticks_msec()
        if touch.pressed and _touch_index < 0:
            _touch_index = touch.index
            _touch_down = touch.position
            _touch_moved = false
        elif not touch.pressed and touch.index == _touch_index:
            if not _touch_moved and touch.position.distance_to(_touch_down) <= TOUCH_DRAG_PX:
                if _founder_hit(touch.position):
                    _select_founder()
            _touch_index = -1
    elif event is InputEventScreenDrag:
        var drag: InputEventScreenDrag = event as InputEventScreenDrag
        _last_touch_ms = Time.get_ticks_msec()
        if drag.index == _touch_index and drag.position.distance_to(_touch_down) > TOUCH_DRAG_PX:
            _touch_moved = true
    elif event is InputEventMouseButton:
        var mouse: InputEventMouseButton = event as InputEventMouseButton
        if mouse.button_index != MOUSE_BUTTON_LEFT:
            return
        if Time.get_ticks_msec() - _last_touch_ms < SYNTHETIC_MOUSE_SUPPRESS_MS:
            _mouse_down = false
            return
        if mouse.pressed:
            _mouse_down = true
            _mouse_down_position = mouse.position
            _mouse_moved = false
        elif _mouse_down:
            if (
                not _mouse_moved
                and mouse.position.distance_to(_mouse_down_position) <= MOUSE_DRAG_PX
            ):
                if _founder_hit(mouse.position):
                    _select_founder()
            _mouse_down = false
    elif event is InputEventMouseMotion and _mouse_down:
        var motion: InputEventMouseMotion = event as InputEventMouseMotion
        if motion.position.distance_to(_mouse_down_position) > MOUSE_DRAG_PX:
            _mouse_moved = true
