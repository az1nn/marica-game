extends SceneTree

# ARCH V201/V201a: source-preserving, headless Godot import/scene contract probe.
# NOT an on-screen rendering, mobile-device, artist or LENTE acceptance test.
const PNG_PATH: String = "res://assets/arch_probes/S01_A01_v4_original.png"
const SCENE_PATH: String = "res://scenes/arch_v201_founder_probe.tscn"
const SOURCE_SHA256: String = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"


func _initialize() -> void:
    call_deferred("_verify")


func _verify() -> void:
    var bytes: PackedByteArray = FileAccess.get_file_as_bytes(PNG_PATH)
    if not _check(bytes.size() == 174947, "source PNG byte length drifted"):
        return
    if not _check(bytes.sha256_text() == SOURCE_SHA256, "source PNG hash drifted"):
        return

    var image: Image = Image.new()
    if not _check(image.load_png_from_buffer(bytes) == OK, "PNG decoder rejected approved source"):
        return
    if not _check(image.get_width() == 344 and image.get_height() == 378, "source dimensions"):
        return
    if not _check(image.get_used_rect() == Rect2i(6, 6, 332, 366), "alpha silhouette bounds"):
        return

    var transparent_count: int = 0
    var opaque_count: int = 0
    var partial_count: int = 0
    for y in range(image.get_height()):
        for x in range(image.get_width()):
            var alpha: float = image.get_pixel(x, y).a
            if alpha == 0.0:
                transparent_count += 1
            elif alpha == 1.0:
                opaque_count += 1
            else:
                partial_count += 1

    if not _check(transparent_count == 48609, "unexpected transparent pixels"):
        return
    if not _check(opaque_count == 81423, "unexpected opaque pixels"):
        return
    if not _check(partial_count == 0, "unexpected intermediate alpha"):
        return

    var packed: PackedScene = load(SCENE_PATH) as PackedScene
    if not _check(packed != null, "isolated Godot scene import"):
        return
    var probe: Node2D = packed.instantiate() as Node2D
    if not _check(probe != null, "isolated Godot scene instantiate"):
        return
    var sprite: Sprite2D = probe.get_node_or_null("FounderSprite") as Sprite2D
    if not _check(sprite != null, "founder sprite missing from probe"):
        return
    if not _check(probe.y_sort_enabled, "2.5D y-sort root is disabled"):
        return
    if not _check(
        sprite.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST,
        "nearest filter must be explicit"
    ):
        return
    if not _check(sprite.centered and sprite.offset == Vector2(0, -182), "feet pivot"):
        return
    if not _check(sprite.texture != null, "original texture failed to import"):
        return
    if not _check(sprite.texture.get_size() == Vector2(344, 378), "import texture size"):
        return
    if not _check(
        sprite.get_rect() == Rect2(-172, -371, 344, 378),
        "expected local rect and feet origin"
    ):
        return

    root.add_child(probe)
    await process_frame
    var mobile_half: float = sprite.get_rect().size.x * 0.5
    var desktop_full: float = sprite.get_rect().size.x
    if not _check(
        is_equal_approx(mobile_half, 172.0) and is_equal_approx(desktop_full, 344.0),
        "candidate projection math"
    ):
        return

    print(
        "MARICA_ARCH_V201_IMPORT_PASS source_sha256=", SOURCE_SHA256,
        " rgba=344x378 alpha=48609/81423/0",
        " nearest=true ysort=true foot_anchor=true",
        " candidate_390w_half_scale_width=", mobile_half,
        " candidate_1280w_full_scale_width=", desktop_full,
        " runtime_capture=NOT_RUN"
    )
    quit(0)


func _check(condition: bool, reason: String) -> bool:
    if condition:
        return true
    push_error("MARICA_ARCH_V201_FAIL " + reason)
    quit(1)
    return false
