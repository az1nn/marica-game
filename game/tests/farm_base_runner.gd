extends SceneTree

const LAYOUT = preload("res://src/domain/farm_layout.gd")
const SCENE = preload("res://scenes/farm_base.tscn")


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var passed: bool = await _verify()
    if passed:
        print("MARICA_G450_PASS")
    else:
        push_error("MARICA_G450_FAIL")
    quit(0 if passed else 1)


func _verify() -> bool:
    var layout: Dictionary = LAYOUT.build()
    var result: Dictionary = LAYOUT.validate(layout)
    if not result.get("ok", false):
        return false
    if layout["width"] * layout["height"] != 120:
        return false
    if result["counts"][LAYOUT.PATH] != 21:
        return false
    if result["counts"][LAYOUT.PLOT] != 9:
        return false
    if result["counts"][LAYOUT.STRUCTURE] != 9:
        return false
    var changed: Dictionary = layout.duplicate(true)
    changed["tiles"][5][3] = LAYOUT.GROUND
    if LAYOUT.validate(changed).get("ok", false):
        return false
    changed = layout.duplicate(true)
    changed["tiles"][2][2] = 999
    if LAYOUT.validate(changed).get("ok", false):
        return false
    var farm: Node2D = SCENE.instantiate()
    root.add_child(farm)
    await process_frame
    var ready: bool = farm.get_meta(&"marica_g450_ready", false)
    var bounds: Rect2 = Rect2(Vector2.ZERO, Vector2(384, 320))
    var expected: bool = (
        ready
        and farm is Node2D
        and bounds.size == Vector2(
            LAYOUT.GRID_WIDTH * LAYOUT.TILE_SIZE,
            LAYOUT.GRID_HEIGHT * LAYOUT.TILE_SIZE
        )
    )
    farm.queue_free()
    return expected
