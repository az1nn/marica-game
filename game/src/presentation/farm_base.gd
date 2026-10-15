extends Node2D

# G450 placeholder geometry only; approved ARTIST sprites are not substituted.
const LAYOUT = preload("res://src/domain/farm_layout.gd")
const GROUND_COLOR: Color = Color(0.22, 0.42, 0.25)
const PATH_COLOR: Color = Color(0.65, 0.56, 0.39)
const PLOT_COLOR: Color = Color(0.37, 0.26, 0.16)
const STRUCTURE_COLOR: Color = Color(0.32, 0.39, 0.48)

var _layout: Dictionary = {}


func _ready() -> void:
    _layout = LAYOUT.build()
    var checked: Dictionary = LAYOUT.validate(_layout)
    if not checked.get("ok", false):
        push_error("MARICA_G450_LAYOUT_INVALID")
        return
    set_meta(&"marica_g450_ready", true)
    print("MARICA_G450_FARM_READY")
    queue_redraw()


func _draw() -> void:
    if _layout.is_empty():
        return
    for y in range(_layout["height"]):
        for x in range(_layout["width"]):
            var kind: int = _layout["tiles"][y][x]
            var color: Color = GROUND_COLOR
            match kind:
                LAYOUT.PATH:
                    color = PATH_COLOR
                LAYOUT.PLOT:
                    color = PLOT_COLOR
                LAYOUT.STRUCTURE:
                    color = STRUCTURE_COLOR
            var rect: Rect2 = Rect2(
                Vector2(x, y) * float(LAYOUT.TILE_SIZE), Vector2.ONE * float(LAYOUT.TILE_SIZE)
            )
            draw_rect(rect, color)
            draw_rect(rect, Color(0.1, 0.15, 0.12, 0.25), false, 1.0)
