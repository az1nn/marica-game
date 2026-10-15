extends SceneTree

const SCENE = preload("res://scenes/farm_iso_view.tscn")
const CAMERA = preload("res://src/presentation/farm_iso_camera.gd")
const LAYOUT = preload("res://src/domain/farm_layout.gd")


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var passed: bool = await _verify()
    if passed:
        print("MARICA_G451_CAMERA_PASS")
    else:
        push_error("MARICA_G451_CAMERA_FAIL")
    quit(0 if passed else 1)


func _verify() -> bool:
    var view: Node2D = SCENE.instantiate()
    root.add_child(view)
    await process_frame
    var world: Node2D = view.get_node("IsometricWorld")
    var farm: Node2D = view.get_node("IsometricWorld/FarmBase")
    var camera: Camera2D = view.get_node("Camera2D")
    if not farm.get_meta(&"marica_g450_ready", false):
        return false
    if not camera.get_meta(&"marica_g451_ready", false) or not camera.is_current():
        return false
    if world.transform.x.distance_to(CAMERA.ISO_X) > 0.0001:
        return false
    if world.transform.y.distance_to(CAMERA.ISO_Y) > 0.0001:
        return false
    var midpoint: Vector2 = (
        Vector2(float(LAYOUT.GRID_WIDTH), float(LAYOUT.GRID_HEIGHT)) * float(LAYOUT.TILE_SIZE) * 0.5
    )
    if camera.position.distance_to(world.transform * midpoint) > 0.0001:
        return false
    var mobile_zoom: float = CAMERA.fit_zoom_for_size(Vector2(320.0, 568.0))
    if mobile_zoom <= CAMERA.ZOOM_MIN or mobile_zoom >= CAMERA.ZOOM_MAX:
        return false
    if not camera.set_zoom_level(99.0) or camera.zoom != Vector2.ONE * CAMERA.ZOOM_MAX:
        return false
    if not camera.set_zoom_level(0.01) or camera.zoom != Vector2.ONE * CAMERA.ZOOM_MIN:
        return false
    if not camera.set_zoom_level(1.0):
        return false
    if camera.set_zoom_level("invalid") or camera.set_zoom_level(-1.0):
        return false
    if camera.zoom != Vector2.ONE or camera.zoom_by(0.0):
        return false
    var wheel: InputEventMouseButton = InputEventMouseButton.new()
    wheel.pressed = true
    wheel.button_index = MOUSE_BUTTON_WHEEL_UP
    camera._unhandled_input(wheel)
    if absf(camera.zoom.x - CAMERA.ZOOM_STEP) > 0.0001:
        return false
    if absf(camera.zoom.y - CAMERA.ZOOM_STEP) > 0.0001:
        return false
    view.queue_free()
    return true
