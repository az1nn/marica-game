extends SceneTree

# V203 technical scene capture/contract. Does not certify a playable pet or ARTIST acceptance.
const PREVIEW = preload("res://scenes/v203_portrait_preview.tscn")
const G451_CAMERA = preload("res://src/presentation/farm_iso_camera.gd")
const SOURCE_PATH: String = "res://assets/arch_probes/S01_A01_v4_original.png"
const SOURCE_SHA256: String = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var output_dir: String = OS.get_environment("V203_CAPTURE_DIR")
    if not output_dir.begins_with("/") or DirAccess.make_dir_recursive_absolute(output_dir) != OK:
        push_error("MARICA_V203_FAIL output directory")
        quit(1)
        return
    if FileAccess.get_sha256(SOURCE_PATH) != SOURCE_SHA256:
        push_error("MARICA_V203_FAIL original PNG SHA")
        quit(1)
        return

    var cases: Array[Dictionary] = [
        {"name": "portrait-390x844", "size": Vector2i(390, 844), "portrait": true},
        {"name": "desktop-1280x960", "size": Vector2i(1280, 960), "portrait": false}
    ]
    var captures: Array[Dictionary] = []
    for config in cases:
        var inspected: Dictionary = await _capture(config, output_dir)
        if not inspected.get("ok", false):
            push_error("MARICA_V203_FAIL " + str(inspected.get("error", "unknown")))
            quit(1)
            return
        captures.append(inspected["capture"])

    var manifest: Dictionary = {
        "schema_version": 1,
        "task": "SPEC-005 V203",
        "status": "CENA_TECHNICAL_PREVIEW_ONLY",
        "head_sha": OS.get_environment("V203_HEAD_SHA"),
        "engine": Engine.get_version_info().get("string", "unknown"),
        "runner": "Xvfb/Mesa software OpenGL; NOT physical device",
        "source_sha256": SOURCE_SHA256,
        "source_git_blob": "da7806ebfcb051c8fd32ccdbad4760b7136f97dd",
        "art_acceptance": "NOT_EVALUATED",
        "physical_mobile_verified": false,
        "g452_save_hydration": false,
        "captures": captures
    }
    var file: FileAccess = FileAccess.open(output_dir.path_join("manifest.json"), FileAccess.WRITE)
    if file == null:
        push_error("MARICA_V203_FAIL manifest")
        quit(1)
        return
    file.store_string(JSON.stringify(manifest, "  ") + "\n")
    file.close()
    print("MARICA_V203_PREVIEW_PASS captures=2 status=UNREVIEWED")
    quit(0)


func _capture(config: Dictionary, output_dir: String) -> Dictionary:
    var size: Vector2i = config["size"]
    var viewport: SubViewport = SubViewport.new()
    viewport.name = str(config["name"])
    viewport.size = size
    viewport.disable_3d = true
    viewport.transparent_bg = false
    viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
    root.add_child(viewport)
    var preview: Node2D = PREVIEW.instantiate()
    viewport.add_child(preview)
    await process_frame
    if not preview.apply_preview_size(Vector2(size)):
        viewport.queue_free()
        return {"ok": false, "error": "composition unavailable"}
    var camera: Camera2D = preview.get_node("FarmIsoView/Camera2D")
    var founder: Sprite2D = preview.get_node("FarmIsoView/FounderV4TestCopy")
    var zoom: float = camera.zoom.x
    var fitted: float = G451_CAMERA.fit_zoom_for_size(Vector2(size))
    if not camera.is_current() or absf(camera.zoom.x - camera.zoom.y) > 0.0001:
        viewport.queue_free()
        return {"ok": false, "error": "invalid camera"}
    if camera.position.distance_to(founder.position) > 0.001:
        viewport.queue_free()
        return {"ok": false, "error": "founder is off pivot"}
    if founder.texture_filter != CanvasItem.TEXTURE_FILTER_NEAREST:
        viewport.queue_free()
        return {"ok": false, "error": "source not nearest"}
    if founder.texture.get_size() != Vector2(344, 378):
        viewport.queue_free()
        return {"ok": false, "error": "unexpected source dimensions"}
    if founder.offset != Vector2(0, -182) or founder.scale != Vector2(0.25, 0.25):
        viewport.queue_free()
        return {"ok": false, "error": "feet/source transform changed"}
    if not founder.get_meta(&"diagnostic_only", false):
        viewport.queue_free()
        return {"ok": false, "error": "missing visual nonproduction gate"}
    if config["portrait"]:
        if zoom < 1.6 or zoom < fitted * 1.5:
            viewport.queue_free()
            return {"ok": false, "error": "portrait remains undersized"}
    elif absf(zoom - fitted) > 0.001:
        viewport.queue_free()
        return {"ok": false, "error": "desktop G451 fit drift"}

    await RenderingServer.frame_post_draw
    await RenderingServer.frame_post_draw
    var image: Image = viewport.get_texture().get_image()
    if image.is_empty() or image.get_width() != size.x or image.get_height() != size.y:
        viewport.queue_free()
        return {"ok": false, "error": "missing in-engine frame"}
    var background: Color = image.get_pixel(2, 2)
    var informative: int = 0
    for y in range(4, size.y, 24):
        for x in range(4, size.x, 24):
            if image.get_pixel(x, y) != background:
                informative += 1
    if informative < 20:
        viewport.queue_free()
        return {"ok": false, "error": "flat/blank Godot frame"}
    var filename: String = str(config["name"]) + ".png"
    if image.save_png(output_dir.path_join(filename)) != OK:
        viewport.queue_free()
        return {"ok": false, "error": "PNG write failed"}
    var capture: Dictionary = {
        "file": filename,
        "viewport": [size.x, size.y],
        "nearest_sampling": true,
        "zoom": zoom,
        "g451_fit_zoom": fitted,
        "projected_founder_width_pixels": founder.texture.get_width() * founder.scale.x * zoom,
        "informative_grid_samples": informative,
        "visual_gate": "UNREVIEWED",
        "physical_mobile": false
    }
    viewport.queue_free()
    return {"ok": true, "capture": capture}
