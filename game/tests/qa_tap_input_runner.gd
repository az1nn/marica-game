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
    var center: Vector2 = founder.get_global_transform_with_canvas() * founder.get_rect().get_center()
    if center.x <= 0.0 or center.x >= 390.0 or center.y <= 0.0 or center.y >= 844.0:
        _fail("founder selection center outside portrait")
        return
    var label: Label = qa.get_node("QAOnlyFeedbackLayer/TapFeedback/SelectionStatus")
    if not label.text.contains("QA: toque no cachorro"):
        _fail("missing initial QA tap instructions")
        return

    qa._input(_mouse(center, true))
    qa._input(_mouse(center, false))
    if qa.qa_tap_count != 1 or qa.qa_selection != "founder":
        _fail("mouse founder tap not selected")
        return
    if not label.text.contains("Cachorro fundador selecionado"):
        _fail("founder visual feedback missing")
        return

    qa._input(_touch(center, true))
    qa._input(_touch(center, false))
    if qa.qa_tap_count != 2 or qa.qa_selection != "founder":
        _fail("real InputEventScreenTouch not selected")
        return
    # Browsers/Godot can synthesize left mouse events for the same physical touch.
    qa._input(_mouse(center, true))
    qa._input(_mouse(center, false))
    if qa.qa_tap_count != 2:
        _fail("synthetic touch/mouse counted twice")
        return

    qa._input(_touch(center, true))
    var drag: InputEventScreenDrag = InputEventScreenDrag.new()
    drag.index = 0
    drag.position = center + Vector2(60, 0)
    drag.relative = Vector2(60, 0)
    qa._input(drag)
    qa._input(_touch(center + Vector2(60, 0), false))
    if qa.qa_tap_count != 2:
        _fail("drag was misinterpreted as selection tap")
        return
    var composition: Node2D = qa.get_node("FounderScene")
    if not composition.pan_by_screen_delta(Vector2(75, 0), Vector2(390, 844)):
        _fail("CENA existing drag/pan no longer usable")
        return
    if qa.qa_tap_count != 2:
        _fail("pan unexpectedly triggered tap feedback")
        return
    print("MARICA_QA002_TAP_PASS mouse=true touch=true dedup=true pan=true")
    quit(0)


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
