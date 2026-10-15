class_name MaricaCompactFarmLayout
extends RefCounted

# G450: geometry and walkable cells only. No approved ARTIST assets.
const WIDTH: int = 9
const HEIGHT: int = 7
const TILE_WIDTH: float = 64.0
const TILE_HEIGHT: float = 32.0


static func build() -> Dictionary:
    var ground: Array[Vector2i] = []
    var plots: Array[Vector2i] = []
    var paths: Array[Vector2i] = []
    for y in range(HEIGHT):
        for x in range(WIDTH):
            var cell: Vector2i = Vector2i(x, y)
            ground.append(cell)
            if x >= 3 and x <= 5 and y >= 2 and y <= 4:
                plots.append(cell)
            elif x == 1 or y == 5:
                paths.append(cell)
    return {"ground": ground, "plots": plots, "paths": paths}


static func is_inside(cell: Vector2i) -> bool:
    return cell.x >= 0 and cell.y >= 0 and cell.x < WIDTH and cell.y < HEIGHT


static func to_world(cell: Vector2i) -> Vector2:
    return Vector2(
        (float(cell.x) - float(cell.y)) * TILE_WIDTH * 0.5,
        (float(cell.x) + float(cell.y)) * TILE_HEIGHT * 0.5
    )
