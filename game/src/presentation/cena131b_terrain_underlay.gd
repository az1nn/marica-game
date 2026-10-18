extends Node2D

# Issue #131 CENA-B: noninteractive placeholder terrain beyond G450's compact farm.
# Never changes domain tile bounds, farm content, source art or navigation limits.
const LAYOUT = preload("res://src/domain/farm_layout.gd")
const MARGIN_TILES: int = 12
const OUTER_GROUND: Color = Color(0.135, 0.267, 0.174)
const OUTER_VARIANT: Color = Color(0.147, 0.278, 0.183)
const SPARSE_PATCH: Color = Color(0.170, 0.308, 0.198)


func _ready() -> void:
    set_meta(&"decorative_only", true)
    set_meta(&"not_a_playable_world_extension", true)
    queue_redraw()


func _draw() -> void:
    var tile_size: float = float(LAYOUT.TILE_SIZE)
    for y in range(-MARGIN_TILES, LAYOUT.GRID_HEIGHT + MARGIN_TILES):
        for x in range(-MARGIN_TILES, LAYOUT.GRID_WIDTH + MARGIN_TILES):
            # Never overpaint or replace any G450 farm cells, including paths and plots.
            if x >= 0 and y >= 0 and x < LAYOUT.GRID_WIDTH and y < LAYOUT.GRID_HEIGHT:
                continue
            var color: Color = OUTER_GROUND
            if posmod(x * 7 + y * 3, 13) < 3:
                color = OUTER_VARIANT
            var tile_rect: Rect2 = Rect2(
                Vector2(float(x), float(y)) * tile_size, Vector2.ONE * tile_size
            )
            draw_rect(tile_rect, color)
            if posmod(x * 3 - y * 5, 23) == 0:
                # Deterministic micro-patch: a blockout texture cue, not vegetation canon.
                draw_rect(Rect2(tile_rect.position + Vector2(8, 12), Vector2(8, 5)), SPARSE_PATCH)
