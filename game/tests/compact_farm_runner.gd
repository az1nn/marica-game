extends SceneTree

const LAYOUT = preload("res://src/presentation/compact_farm_layout.gd")
const SCENE = preload("res://scenes/compact_farm.tscn")


func _initialize() -> void:
    call_deferred("_verify")


func _verify() -> void:
    var farm: Node2D = SCENE.instantiate()
    root.add_child(farm)
    var data: Dictionary = farm.get_layout()
    var ok: bool = _check_geometry(data) and _check_scene(farm, data)
    if ok:
        print("MARICA_G450_PASS ground=63 plots=9 path=15")
    else:
        push_error("MARICA_G450_FAIL compact farm geometry")
    farm.queue_free()
    quit(0 if ok else 1)


func _check_geometry(data: Dictionary) -> bool:
    var ground: Array = data["ground"]
    var plots: Array = data["plots"]
    var paths: Array = data["paths"]
    if ground.size() != 63 or plots.size() != 9 or paths.size() != 15:
        return false
    var all_cells: Dictionary = {}
    for cell in ground:
        if not LAYOUT.is_inside(cell) or all_cells.has(cell):
            return false
        all_cells[cell] = true
    var plot_set: Dictionary = {}
    for cell in plots:
        if not all_cells.has(cell) or plot_set.has(cell):
            return false
        plot_set[cell] = true
    for cell in paths:
        if not all_cells.has(cell) or plot_set.has(cell):
            return false
    return _check_projection()


func _check_projection() -> bool:
    if LAYOUT.to_world(Vector2i.ZERO) != Vector2.ZERO:
        return false
    if LAYOUT.to_world(Vector2i(1, 0)) != Vector2(32.0, 16.0):
        return false
    if LAYOUT.to_world(Vector2i(0, 1)) != Vector2(-32.0, 16.0):
        return false
    return LAYOUT.to_world(Vector2i(8, 6)) == Vector2(64.0, 224.0)


func _check_scene(farm: Node2D, data: Dictionary) -> bool:
    if farm.name != "CompactFarm":
        return false
    var copy: Dictionary = farm.get_layout()
    copy["plots"].clear()
    return data["plots"].size() == 9 and farm.get_layout()["plots"].size() == 9
