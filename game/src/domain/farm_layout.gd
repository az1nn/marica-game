class_name MaricaFarmLayout
extends RefCounted

# G450 spatial-only compact farm. No animals, art imports, economy or save mutations.
const GRID_WIDTH: int = 12
const GRID_HEIGHT: int = 10
const TILE_SIZE: int = 32
const GROUND: int = 0
const PATH: int = 1
const PLOT: int = 2
const STRUCTURE: int = 3


static func build() -> Dictionary:
    var tiles: Array = []
    for y in range(GRID_HEIGHT):
        var row: Array = []
        for x in range(GRID_WIDTH):
            var kind: int = GROUND
            if x == 5 or y == 5:
                kind = PATH
            if x >= 1 and x <= 3 and y >= 1 and y <= 3:
                kind = PLOT
            if x >= 8 and x <= 10 and y >= 1 and y <= 3:
                kind = STRUCTURE
            row.append(kind)
        tiles.append(row)
    return {"width": GRID_WIDTH, "height": GRID_HEIGHT, "tile_size": TILE_SIZE, "tiles": tiles}


static func validate(layout: Variant) -> Dictionary:
    if typeof(layout) != TYPE_DICTIONARY:
        return {"ok": false, "error": "Layout must be a dictionary"}
    if (
        layout.get("width") != GRID_WIDTH
        or layout.get("height") != GRID_HEIGHT
        or layout.get("tile_size") != TILE_SIZE
    ):
        return {"ok": false, "error": "Unexpected farm geometry"}
    var tiles: Variant = layout.get("tiles")
    if typeof(tiles) != TYPE_ARRAY or tiles.size() != GRID_HEIGHT:
        return {"ok": false, "error": "Invalid row count"}
    var counts: Dictionary = {GROUND: 0, PATH: 0, PLOT: 0, STRUCTURE: 0}
    for row in tiles:
        if typeof(row) != TYPE_ARRAY or row.size() != GRID_WIDTH:
            return {"ok": false, "error": "Invalid row width"}
        for kind in row:
            if typeof(kind) != TYPE_INT or not counts.has(kind):
                return {"ok": false, "error": "Invalid tile"}
            counts[kind] += 1
    if counts[PATH] != 21 or counts[PLOT] != 9 or counts[STRUCTURE] != 9:
        return {"ok": false, "error": "Required farm zones missing"}
    for x in range(GRID_WIDTH):
        if tiles[5][x] != PATH:
            return {"ok": false, "error": "East-west path disconnected"}
    for y in range(GRID_HEIGHT):
        if tiles[y][5] != PATH:
            return {"ok": false, "error": "North-south path disconnected"}
    return {"ok": true, "counts": counts}
