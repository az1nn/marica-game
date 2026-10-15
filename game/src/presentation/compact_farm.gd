class_name MaricaCompactFarm
extends Node2D

# Provisional debug geometry. SPEC-005/ARTIST remains an independent visual gate.
const LAYOUT = preload("res://src/presentation/compact_farm_layout.gd")
var _cells: Dictionary = {}


func _ready() -> void:
    _cells = LAYOUT.build()
    queue_redraw()


func get_layout() -> Dictionary:
    return _cells.duplicate(true)


func _draw() -> void:
    for cell in _cells.get("ground", []):
        _draw_cell(cell, Color(0.29, 0.44, 0.32))
    for cell in _cells.get("paths", []):
        _draw_cell(cell, Color(0.55, 0.48, 0.34))
    for cell in _cells.get("plots", []):
        _draw_cell(cell, Color(0.42, 0.30, 0.22))


func _draw_cell(cell: Vector2i, fill: Color) -> void:
    var center: Vector2 = LAYOUT.to_world(cell)
    var half_width: float = LAYOUT.TILE_WIDTH * 0.5
    var half_height: float = LAYOUT.TILE_HEIGHT * 0.5
    var points: PackedVector2Array = PackedVector2Array(
        [
            center + Vector2(0.0, -half_height),
            center + Vector2(half_width, 0.0),
            center + Vector2(0.0, half_height),
            center + Vector2(-half_width, 0.0)
        ]
    )
    draw_colored_polygon(points, fill)
    draw_polyline(
        PackedVector2Array([points[0], points[1], points[2], points[3], points[0]]),
        Color(0.12, 0.19, 0.13),
        1.0
    )
