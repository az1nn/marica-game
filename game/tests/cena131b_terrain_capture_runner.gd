extends SceneTree

# CENA #131B: native-rendered A/B of portrait-only decorative ground continuity.
const PREVIEW = preload("res://scenes/cena131b_terrain_preview.tscn")
const BASELINE = preload("res://scenes/v203_portrait_preview.tscn")
const CAMERA_POLICY = preload("res://src/presentation/farm_iso_camera.gd")
const SOURCE_PATH: String = "res://assets/arch_probes/S01_A01_v4_original.png"
const SOURCE_SHA256: String = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var folder: String = OS.get_environment("CENA131B_CAPTURE_DIR")
    if not folder.begins_with("/") or DirAccess.make_dir_recursive_absolute(folder) != OK:
        push_error("MARICA_CENA131B_FAIL folder")
        quit(1)
        return
    if FileAccess.get_sha256(SOURCE_PATH) != SOURCE_SHA256:
        push_error("MARICA_CENA131B_FAIL original source drift")
        quit(1)
        return
    var cases: Array[Dictionary] = [
        {"name": "portrait-before", "size": Vector2i(390, 844), "pan": 0.0, "candidate": false},
        {"name": "portrait-after", "size": Vector2i(390, 844), "pan": 0.0, "candidate": true},
        {"name": "portrait-left", "size": Vector2i(390, 844), "pan": 100000.0, "candidate": true},
        {"name": "portrait-right", "size": Vector2i(390, 844), "pan": -100000.0, "candidate": true},
        {"name": "landscape", "size": Vector2i(844, 390), "pan": 0.0, "candidate": true},
        {"name": "desktop", "size": Vector2i(1280, 960), "pan": 0.0, "candidate": true}
    ]
    var frames: Array[Dictionary] = []
    for config in cases:
        var result: Dictionary = await _capture(config, folder)
        if not result.get("ok", false):
            push_error("MARICA_CENA131B_FAIL " + str(result.get("error", "frame")))
            quit(1)
            return
        frames.append(result["frame"])
    if not (
        float(frames[2]["camera_x"]) < float(frames[1]["camera_x"])
        and float(frames[1]["camera_x"]) < float(frames[3]["camera_x"])
    ):
        push_error("MARICA_CENA131B_FAIL unable to navigate farm sides")
        quit(1)
        return
    var manifest: Dictionary = {
        "schema_version": 1,
        "task": "SPEC-005 V203 follow-up / issue #131 CENA blockout B",
        "status": "PORTRAIT_BACKGROUND_BLOCKOUT_ONLY_NO_RUNTIME_ACCEPT",
        "head_sha": OS.get_environment("CENA131B_HEAD_SHA"),
        "engine": Engine.get_version_info().get("string", "unknown"),
        "renderer": "Godot Compatibility Xvfb/Mesa; NOT physical device or WebGL",
        "source_sha256": SOURCE_SHA256,
        "source_git_blob": "da7806ebfcb051c8fd32ccdbad4760b7136f97dd",
        "art_runtime": "NOT_EVALUATED",
        "portrait_background_filled_by_nonplayable_placeholder": true,
        "vertical_gameplay_void_resolved": false,
        "human_art_approval": "NOT_EVALUATED",
        "g452_hydrated": false,
        "physical_device": false,
        "frames": frames
    }
    var output: FileAccess = FileAccess.open(folder.path_join("manifest.json"), FileAccess.WRITE)
    if output == null:
        push_error("MARICA_CENA131B_FAIL manifest")
        quit(1)
        return
    output.store_string(JSON.stringify(manifest, "  ") + "\n")
    output.close()
    print("MARICA_CENA131B_CAPTURE_PASS captures=6 status=BLOCKOUT_ONLY")
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
    var candidate: bool = bool(config["candidate"])
    var preview: Node2D = PREVIEW.instantiate() if candidate else BASELINE.instantiate()
    viewport.add_child(preview)
    await process_frame
    var inner: Node2D = preview.get_node("V203PortraitPreview") if candidate else preview
    var camera: Camera2D = inner.get_node("FarmIsoView/Camera2D")
    var founder: Sprite2D = inner.get_node("FarmIsoView/FounderV4TestCopy")

    var problem: String = ""
    var applied: bool = (
        preview.apply_scene_size(Vector2(size))
        if candidate
        else preview.apply_preview_size(Vector2(size))
    )
    if not applied or not camera.is_current():
        problem = "camera not usable"
    var fitted: float = CAMERA_POLICY.fit_zoom_for_size(Vector2(size))
    var limits: Rect2 = inner.pan_limits_for_size(Vector2(size), camera.zoom.x)
    var portrait: bool = size.y > size.x * 1.35
    if problem.is_empty() and founder.texture_filter != CanvasItem.TEXTURE_FILTER_NEAREST:
        problem = "original filtering drift"
    elif (
        problem.is_empty()
        and (founder.offset != Vector2(0, -182) or founder.texture.get_size() != Vector2(344, 378))
    ):
        problem = "source/feet drift"
    elif problem.is_empty() and portrait and (camera.zoom.x < 1.6 or limits.size.x <= 20.0):
        problem = "portrait pan range absent"
    elif problem.is_empty() and not portrait and absf(camera.zoom.x - fitted) > 0.001:
        problem = "landscape/desktop fit regression"

    var pan: float = float(config["pan"])
    if problem.is_empty() and pan != 0.0:
        if not preview.pan_by_screen_delta(Vector2(pan, 0.0), Vector2(size)):
            problem = "drag ignored"
    if problem.is_empty() and pan > 0.0 and absf(camera.position.x - limits.position.x) > 0.01:
        problem = "left boundary or pan direction wrong"
    elif problem.is_empty() and pan < 0.0 and absf(camera.position.x - limits.end.x) > 0.01:
        problem = "right boundary or pan direction wrong"
    if (
        problem.is_empty()
        and (
            camera.position.x < limits.position.x - 0.01 or camera.position.x > limits.end.x + 0.01
        )
    ):
        problem = "camera escaped farm"
    if not problem.is_empty():
        viewport.queue_free()
        return {"ok": false, "error": problem}
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
    var backdrop_pixel: Color = image.get_pixel(2, 2)
    var reference_bg: Color = Color("#4d4d4d")
    var bg_difference: float = absf(backdrop_pixel.r - reference_bg.r)
    bg_difference += absf(backdrop_pixel.g - reference_bg.g)
    bg_difference += absf(backdrop_pixel.b - reference_bg.b)
    if candidate and portrait and bg_difference < 0.12:
        problem = "portrait still has blank external background"
    elif (not candidate or not portrait) and bg_difference > 0.03:
        problem = "baseline/landscape/desktop background changed"
    if not problem.is_empty():
        viewport.queue_free()
        return {"ok": false, "error": problem}
    if foreground < 30 or image.save_png(folder.path_join(str(config["name"]) + ".png")) != OK:
        viewport.queue_free()
        return {"ok": false, "error": "flat image or PNG save failed"}
    var frame: Dictionary = {
        "file": str(config["name"]) + ".png",
        "candidate": candidate,
        "background_corner_rgb": [backdrop_pixel.r, backdrop_pixel.g, backdrop_pixel.b],
        "decorative_background_only": candidate and portrait,
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
