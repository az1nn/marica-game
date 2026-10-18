extends SceneTree

# SPEC-008 Q806 native Godot InputEvent tap/drag regression; real Web proof is separate.
const QA = preload("res://scenes/qa_web_preview.tscn")
const SOURCE_PATH: String = "res://assets/arch_probes/S01_A01_v4_original.png"
const SOURCE_SHA256: String = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    if FileAccess.get_sha256(SOURCE_PATH) != SOURCE_SHA256:
        _fail("original S01-A01 V4 PNG drift")
        return
    var viewport: SubViewport = SubViewport.new()
    viewport.disable_3d = true
    viewport.size = Vector2i(390, 844)
    viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
    root.add_child(viewport)
    var qa: Node2D = QA.instantiate()
    viewport.add_child(qa)
    await process_frame
    var founder: Sprite2D = qa.get_node("FounderScene/FarmIsoView/FounderV4TestCopy")
    var center: Vector2 = (
        founder.get_global_transform_with_canvas() * founder.get_rect().get_center()
    )
    if center.x <= 0.0 or center.x >= 390.0 or center.y <= 0.0 or center.y >= 844.0:
        _fail("founder selection center outside portrait")
        return
    var label: Label = qa.get_node("QAOnlyFeedbackLayer/TapFeedback/SelectionStatus")
    var taps: String = _check_mouse_and_touch(qa, center, label)
    if not taps.is_empty():
        _fail(taps)
        return
    var drag: String = _check_drag_and_pan(qa, center)
    if not drag.is_empty():
        _fail(drag)
        return
    print("MARICA_QA002_TAP_PASS mouse=true touch=true dedup=true pan=true")
    quit(0)


func _check_mouse_and_touch(qa: Node2D, center: Vector2, label: Label) -> String:
    if not label.text.contains("QA: toque no cachorro"):
        return "missing initial QA tap instructions"
    qa._input(_mouse(center, true))
    qa._input(_mouse(center, false))
    if qa.qa_tap_count != 1 or qa.qa_selection != "founder":
        return "mouse founder tap not selected"
    if not label.text.contains("Cachorro fundador selecionado"):
        return "founder visual feedback missing"
    qa._input(_touch(center, true))
    qa._input(_touch(center, false))
    if qa.qa_tap_count != 2 or qa.qa_selection != "founder":
        return "real InputEventScreenTouch not selected"
    qa._input(_mouse(center, true))
    qa._input(_mouse(center, false))
    if qa.qa_tap_count != 2:
        return "synthetic touch/mouse counted twice"
    return ""


func _check_drag_and_pan(qa: Node2D, center: Vector2) -> String:
    var composition: Node2D = qa.get_node("FounderScene")
    var camera: Camera2D = qa.get_node("FounderScene/FarmIsoView/Camera2D")
    var start_x: float = camera.position.x
    qa._input(_touch(center, true))
    var drag: InputEventScreenDrag = InputEventScreenDrag.new()
    drag.index = 0
    drag.position = center + Vector2(60, 0)
    drag.relative = Vector2(60, 0)
    qa._input(drag)
    qa._input(_touch(center + Vector2(60, 0), false))
    if qa.qa_tap_count != 2:
        return "drag was misinterpreted as selection tap"
    if absf(start_x - camera.position.x) < 0.01:
        return "QA drag input did not reach bounded CENA pan"
    if not composition.pan_by_screen_delta(Vector2(75, 0), Vector2(390, 844)):
        return "CENA existing drag/pan no longer usable"
    if qa.qa_tap_count != 2:
        return "pan unexpectedly triggered tap feedback"
    return ""


func _mouse(location: Vector2, pressed: bool) -> InputEventMouseButton:
    var event: InputEventMouseButton = InputEventMouseButton.new()
    event.button_index = MOUSE_BUTTON_LEFT
    event.position = location
    event.pressed = pressed
    return event


func _touch(location: Vector2, pressed: bool) -> InputEventScreenTouch:
    var event: InputEventScreenTouch = InputEventScreenTouch.new()
    event.index = 0
    event.position = location
    event.pressed = pressed
    return event


func _fail(reason: String) -> void:
    push_error("MARICA_QA002_TAP_FAIL " + reason)
    quit(1)
