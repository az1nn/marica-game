extends SceneTree

# SPEC-005 V201: technical render evidence, never ARTIST acceptance.
const SOURCE = preload("res://assets/arch_probes/S01_A01_v4_original.png")
var _out_dir: String = ""


func _initialize() -> void:
    call_deferred("_capture")


func _capture() -> void:
    _out_dir = OS.get_environment("V201_CAPTURE_DIR")
    if not _out_dir.begins_with("/"):
        push_error("V201 output directory must be an absolute path")
        quit(1)
        return
    if DirAccess.make_dir_recursive_absolute(_out_dir) != OK:
        push_error("V201 output directory unavailable")
        quit(1)
        return

    if FileAccess.get_sha256("res://assets/arch_probes/S01_A01_v4_original.png") != "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e":
        push_error("V201 original approved source SHA-256 changed")
        quit(1)
        return

    var configs: Array[Dictionary] = [
        {
            "name": "mobile-dark-nearest",
            "size": Vector2i(432, 768),
            "scale": 1.0,
            "filter": CanvasItem.TEXTURE_FILTER_NEAREST,
            "background": Color("#14242b")
        },
        {
            "name": "mobile-light-nearest",
            "size": Vector2i(432, 768),
            "scale": 1.0,
            "filter": CanvasItem.TEXTURE_FILTER_NEAREST,
            "background": Color("#eee0c4")
        },
        {
            "name": "desktop-dark-nearest",
            "size": Vector2i(1280, 960),
            "scale": 2.0,
            "filter": CanvasItem.TEXTURE_FILTER_NEAREST,
            "background": Color("#14242b")
        },
        {
            "name": "desktop-dark-linear-control",
            "size": Vector2i(1280, 960),
            "scale": 2.0,
            "filter": CanvasItem.TEXTURE_FILTER_LINEAR,
            "background": Color("#14242b")
        },
        {
            "name": "mobile-terrain-half-nearest",
            "size": Vector2i(432, 768),
            "scale": 0.5,
            "filter": CanvasItem.TEXTURE_FILTER_NEAREST,
            "background": Color("#65734b")
        },
        {
            "name": "mobile-dark-fractional-nearest",
            "size": Vector2i(432, 768),
            "scale": 1.25,
            "filter": CanvasItem.TEXTURE_FILTER_NEAREST,
            "background": Color("#14242b")
        },
        {
            "name": "mobile-dark-fractional-linear-control",
            "size": Vector2i(432, 768),
            "scale": 1.25,
            "filter": CanvasItem.TEXTURE_FILTER_LINEAR,
            "background": Color("#14242b")
        },
        {
            "name": "desktop-light-integer-nearest",
            "size": Vector2i(1280, 960),
            "scale": 2.0,
            "filter": CanvasItem.TEXTURE_FILTER_NEAREST,
            "background": Color("#eee0c4")
        }
    ]
    var evidence: Array[Dictionary] = []
    for config in configs:
        var captured: Dictionary = await _capture_one(config)
        if not captured.get("ok", false):
            push_error(str(captured.get("error", "V201 capture failed")))
            quit(1)
            return
        evidence.append(captured["evidence"])

    var comparisons: Array[Dictionary] = []
    for pair in [
        ["desktop-dark-nearest", "desktop-dark-linear-control"],
        ["mobile-dark-fractional-nearest", "mobile-dark-fractional-linear-control"]
    ]:
        var comparison: Dictionary = _compare_filter_pair(pair[0], pair[1])
        if not comparison.get("ok", false):
            push_error("V201 filter comparison missing or inconclusive: " + str(pair))
            quit(1)
            return
        comparisons.append(comparison)

    var report: Dictionary = {
        "schema_version": 1,
        "repository": "az1nn/marica-game",
        "task": "SPEC-005 V201",
        "status": "TECHNICAL_PROBE_ONLY",
        "source_asset": "res://assets/arch_probes/S01_A01_v4_original.png",
        "source_git_blob": "da7806ebfcb051c8fd32ccdbad4760b7136f97dd",
        "head_sha": OS.get_environment("V201_HEAD_SHA"),
        "godot_version": Engine.get_version_info().get("string", "unknown"),
        "renderer": "gl_compatibility under Xvfb/Mesa",
        "no_art_approval": true,
        "measurement_scope": "Xvfb/Mesa wall-clock observation only; not mobile FPS, browser performance or a budget pass",
        "filter_comparisons": comparisons,
        "captures": evidence
    }
    var manifest: FileAccess = FileAccess.open(
        _out_dir.path_join("manifest.json"), FileAccess.WRITE
    )
    if manifest == null:
        push_error("V201 manifest cannot be written")
        quit(1)
        return
    manifest.store_string(JSON.stringify(report, "  ") + "\n")
    manifest.close()
    print("MARICA_V201_RENDER_CAPTURE_PASS images=%d status=UNREVIEWED" % evidence.size())
    quit(0)


func _capture_one(config: Dictionary) -> Dictionary:
    var size: Vector2i = config["size"]
    var name: String = config["name"]
    var viewport: SubViewport = SubViewport.new()
    viewport.name = "V201_" + name
    viewport.size = size
    viewport.disable_3d = true
    viewport.transparent_bg = false
    viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
    root.add_child(viewport)

    var backdrop: ColorRect = ColorRect.new()
    backdrop.color = config["background"]
    backdrop.size = Vector2(size)
    backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
    viewport.add_child(backdrop)

    var founder: Sprite2D = Sprite2D.new()
    founder.name = "FounderProbe"
    founder.texture = SOURCE
    founder.texture_filter = config["filter"]
    founder.scale = Vector2.ONE * float(config["scale"])
    founder.position = Vector2(size) * 0.5
    backdrop.add_child(founder)

    var start_usec: int = Time.get_ticks_usec()
    await RenderingServer.frame_post_draw
    await RenderingServer.frame_post_draw
    var render_wall_ms: float = float(Time.get_ticks_usec() - start_usec) / 1000.0
    var image: Image = viewport.get_texture().get_image()
    if image.is_empty() or image.get_width() != size.x or image.get_height() != size.y:
        viewport.queue_free()
        return {"ok": false, "error": "No GPU frame: " + name}

    var baseline: Color = image.get_pixel(4, 4)
    var informative: int = 0
    # Dense enough to find content at 0.5x without mistaking a small sprite for a blank frame.
    for y in range(4, size.y, 16):
        for x in range(4, size.x, 16):
            if image.get_pixel(x, y) != baseline:
                informative += 1
    if informative < 8:
        viewport.queue_free()
        return {"ok": false, "error": "Empty/flat render: " + name}

    var output_path: String = _out_dir.path_join(name + ".png")
    if image.save_png(output_path) != OK:
        viewport.queue_free()
        return {"ok": false, "error": "PNG save failed: " + name}

    var sampling: String = "nearest"
    if config["filter"] == CanvasItem.TEXTURE_FILTER_LINEAR:
        sampling = "linear"
    var result: Dictionary = {
        "name": name,
        "file": name + ".png",
        "viewport": [size.x, size.y],
        "scale": config["scale"],
        "sampling": sampling,
        "render_wall_ms": render_wall_ms,
        "render_wall_ms_is_fps": false,
        "png_sha256": FileAccess.get_sha256(output_path),
        "projected_sprite_width_px": 344.0 * float(config["scale"]),
        "projected_sprite_height_px": 378.0 * float(config["scale"]),
        "informative_grid_samples": informative,
        "art_acceptance": "NOT_EVALUATED",
        "mobile_device_verified": false
    }
    viewport.queue_free()
    return {"ok": true, "evidence": result}


# Controls must differ in actual rendered pixels, rather than merely in scene metadata.
func _compare_filter_pair(nearest_name: String, linear_name: String) -> Dictionary:
    var nearest_image: Image = Image.load_from_file(_out_dir.path_join(nearest_name + ".png"))
    var linear_image: Image = Image.load_from_file(_out_dir.path_join(linear_name + ".png"))
    if nearest_image == null or linear_image == null:
        return {"ok": false}
    if nearest_image.get_size() != linear_image.get_size():
        return {"ok": false}
    var different_samples: int = 0
    for y in range(0, nearest_image.get_height(), 4):
        for x in range(0, nearest_image.get_width(), 4):
            if nearest_image.get_pixel(x, y) != linear_image.get_pixel(x, y):
                different_samples += 1
    return {
        "ok": different_samples > 10,
        "nearest": nearest_name,
        "linear": linear_name,
        "different_grid_samples": different_samples,
        "sampling_stride": 4
    }
