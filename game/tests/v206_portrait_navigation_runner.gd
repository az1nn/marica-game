extends SceneTree

# V206: native-rendered technical viewport/pan evidence only.
const PREVIEW = preload("res://scenes/v203_portrait_preview.tscn")
const CAMERA_POLICY = preload("res://src/presentation/farm_iso_camera.gd")
const SOURCE_PATH: String = "res://assets/arch_probes/S01_A01_v4_original.png"
const SOURCE_SHA256: String = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var folder: String = OS.get_environment("V206_CAPTURE_DIR")
    if not folder.begins_with("/") or DirAccess.make_dir_recursive_absolute(folder) != OK:
        push_error("MARICA_V206_FAIL folder")
        quit(1)
        return
    if FileAccess.get_sha256(SOURCE_PATH) != SOURCE_SHA256:
        push_error("MARICA_V206_FAIL original source drift")
        quit(1)
        return
    var cases: Array[Dictionary] = [
        {"name": "portrait-center", "size": Vector2i(390, 844), "pan": 0.0},
        {"name": "portrait-left", "size": Vector2i(390, 844), "pan": 100000.0},
        {"name": "portrait-right", "size": Vector2i(390, 844), "pan": -100000.0},
        {"name": "landscape", "size": Vector2i(844, 390), "pan": 0.0},
        {"name": "desktop", "size": Vector2i(1280, 960), "pan": 0.0}
    ]
    var frames: Array[Dictionary] = []
    for config in cases:
        var result: Dictionary = await _capture(config, folder)
        if not result.get("ok", false):
            push_error("MARICA_V206_FAIL " + str(result.get("error", "frame")))
            quit(1)
            return
        frames.append(result["frame"])
    if not (
        float(frames[1]["camera_x"]) < float(frames[0]["camera_x"])
        and float(frames[0]["camera_x"]) < float(frames[2]["camera_x"])
    ):
        push_error("MARICA_V206_FAIL unable to navigate farm sides")
        quit(1)
        return
    var manifest: Dictionary = {
        "schema_version": 1,
        "task": "SPEC-005 V206 / issue #131",
        "status": "NAVIGATION_TECHNICAL_ONLY_VERTICAL_VOID_OPEN",
        "head_sha": OS.get_environment("V206_HEAD_SHA"),
        "engine": Engine.get_version_info().get("string", "unknown"),
        "renderer": "Godot Compatibility Xvfb/Mesa; NOT physical device or WebGL",
        "source_sha256": SOURCE_SHA256,
        "source_git_blob": "da7806ebfcb051c8fd32ccdbad4760b7136f97dd",
        "art_runtime": "NOT_EVALUATED",
        "portrait_vertical_void_resolved": false,
        "g452_hydrated": false,
        "physical_device": false,
        "frames": frames
    }
    var output: FileAccess = FileAccess.open(folder.path_join("manifest.json"), FileAccess.WRITE)
    if output == null:
        push_error("MARICA_V206_FAIL manifest")
        quit(1)
        return
    output.store_string(JSON.stringify(manifest, "  ") + "\n")
    output.close()
    print("MARICA_V206_NAVIGATION_PASS captures=5 status=REVISE_PENDING")
    quit(0)


func _capture(config: Dictionary, folder: String) -> Dictionary:
    var size: Vector2i = config["size"]
    var viewport: SubViewport = SubViewport.new()
    viewport.name = str(config["name"])
    viewport.size = size
    viewport.disable_3d = true
    viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
    root.add_child(viewport)
    var backdrop_layer: CanvasLayer = CanvasLayer.new()
    backdrop_layer.layer = -10
    viewport.add_child(backdrop_layer)
    var backdrop: ColorRect = ColorRect.new()
    backdrop.color = Color("#4d4d4d")
    backdrop.size = Vector2(size)
    backdrop_layer.add_child(backdrop)
    var preview: Node2D = PREVIEW.instantiate()
    viewport.add_child(preview)
    await process_frame
    var camera: Camera2D = preview.get_node("FarmIsoView/Camera2D")
    var founder: Sprite2D = preview.get_node("FarmIsoView/FounderV4TestCopy")
    if not preview.apply_preview_size(Vector2(size)) or not camera.is_current():
        viewport.queue_free()
        return {"ok": false, "error": "camera not usable"}
    var fitted: float = CAMERA_POLICY.fit_zoom_for_size(Vector2(size))
    var limits: Rect2 = preview.pan_limits_for_size(Vector2(size), camera.zoom.x)
    var portrait: bool = size.y > size.x * 1.35
    if founder.texture_filter != CanvasItem.TEXTURE_FILTER_NEAREST:
        viewport.queue_free()
        return {"ok": false, "error": "original filtering drift"}
    if founder.offset != Vector2(0, -182) or founder.texture.get_size() != Vector2(344, 378):
        viewport.queue_free()
        return {"ok": false, "error": "source/feet drift"}
    if portrait and (camera.zoom.x < 1.6 or limits.size.x <= 20.0):
        viewport.queue_free()
        return {"ok": false, "error": "portrait pan range absent"}
    if not portrait and absf(camera.zoom.x - fitted) > 0.001:
        viewport.queue_free()
        return {"ok": false, "error": "landscape/desktop fit regression"}
    var pan: float = float(config["pan"])
    if pan != 0.0 and not preview.pan_by_screen_delta(Vector2(pan, 0.0), Vector2(size)):
        viewport.queue_free()
        return {"ok": false, "error": "drag ignored"}
    if pan > 0.0 and absf(camera.position.x - limits.position.x) > 0.01:
        viewport.queue_free()
        return {"ok": false, "error": "left boundary or pan direction wrong"}
    if pan < 0.0 and absf(camera.position.x - limits.end.x) > 0.01:
        viewport.queue_free()
        return {"ok": false, "error": "right boundary or pan direction wrong"}
    if camera.position.x < limits.position.x - 0.01 or camera.position.x > limits.end.x + 0.01:
        viewport.queue_free()
        return {"ok": false, "error": "camera escaped farm"}
    await RenderingServer.frame_post_draw
    await RenderingServer.frame_post_draw
    var image: Image = viewport.get_texture().get_image()
    if image.is_empty() or image.get_size() != size:
        viewport.queue_free()
        return {"ok": false, "error": "no rendered Godot frame"}
    var background: Color = image.get_pixel(2, 2)
    var foreground: int = 0
    var bounds: Rect2i = Rect2i(size.x, size.y, 0, 0)
    var rightmost: int = -1
    var bottommost: int = -1
    for y in range(0, size.y, 4):
        for x in range(0, size.x, 4):
            var pixel: Color = image.get_pixel(x, y)
            var difference: float = (
                absf(pixel.r - background.r)
                + absf(pixel.g - background.g)
                + absf(pixel.b - background.b)
            )
            if difference > 0.08:
                foreground += 1
                bounds.position.x = mini(bounds.position.x, x)
                bounds.position.y = mini(bounds.position.y, y)
                rightmost = maxi(rightmost, x)
                bottommost = maxi(bottommost, y)
    if foreground < 30 or image.save_png(folder.path_join(str(config["name"]) + ".png")) != OK:
        viewport.queue_free()
        return {"ok": false, "error": "flat image or PNG save failed"}
    var frame: Dictionary = {
        "file": str(config["name"]) + ".png",
        "viewport": [size.x, size.y],
        "zoom": camera.zoom.x,
        "g451_fit_zoom": fitted,
        "camera_x": camera.position.x,
        "pan_limits_x": [limits.position.x, limits.end.x],
        "founder_projected_width_px": 344.0 * 0.25 * camera.zoom.x,
        "foreground_samples_4px": foreground,
        "approx_bbox_4px": [bounds.position.x, bounds.position.y, rightmost, bottommost],
        "approx_top_blank_px": bounds.position.y,
        "approx_bottom_blank_px": size.y - 1 - bottommost
    }
    viewport.queue_free()
    return {"ok": true, "frame": frame}
