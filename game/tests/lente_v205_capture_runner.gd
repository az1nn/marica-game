extends SceneTree

# LENTE V205: independent actual-Godot technical A/B of CENA #128.
# No gameplay, physical-device, WebGL export, HUD or ARTIST acceptance.
const PREVIEW = preload("res://scenes/v203_portrait_preview.tscn")
const CAMERA_POLICY = preload("res://src/presentation/farm_iso_camera.gd")
const SOURCE_PATH: String = "res://assets/arch_probes/S01_A01_v4_original.png"
const SOURCE_SHA256: String = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var output_dir: String = OS.get_environment("LENTE_V205_CAPTURE_DIR")
	if not output_dir.begins_with("/") or DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("MARICA_LENTE_V205_FAIL invalid output directory")
		quit(1)
		return
	if FileAccess.get_sha256(SOURCE_PATH) != SOURCE_SHA256:
		push_error("MARICA_LENTE_V205_FAIL changed approved source")
		quit(1)
		return

	var cases: Array[Dictionary] = [
		{
			"name": "portrait-current-nearest-dark",
			"size": Vector2i(390, 844),
			"mode": "current",
			"sampling": "nearest",
			"background": "#4d4d4d"
		},
		{
			"name": "portrait-baseline-nearest-dark",
			"size": Vector2i(390, 844),
			"mode": "baseline",
			"sampling": "nearest",
			"background": "#4d4d4d"
		},
		{
			"name": "portrait-current-linear-dark",
			"size": Vector2i(390, 844),
			"mode": "current",
			"sampling": "linear",
			"background": "#4d4d4d"
		},
		{
			"name": "portrait-current-nearest-light",
			"size": Vector2i(390, 844),
			"mode": "current",
			"sampling": "nearest",
			"background": "#eadfcb"
		},
		{
			"name": "portrait-fractional-nearest-dark",
			"size": Vector2i(390, 844),
			"mode": "fractional",
			"sampling": "nearest",
			"background": "#4d4d4d"
		},
		{
			"name": "desktop-current-nearest-dark",
			"size": Vector2i(1280, 960),
			"mode": "current",
			"sampling": "nearest",
			"background": "#4d4d4d"
		},
		{
			"name": "desktop-current-linear-dark",
			"size": Vector2i(1280, 960),
			"mode": "current",
			"sampling": "linear",
			"background": "#4d4d4d"
		}
	]
	var frames: Array[Dictionary] = []
	for config in cases:
		var result: Dictionary = await _capture(config, output_dir)
		if not result.get("ok", false):
			push_error("MARICA_LENTE_V205_FAIL " + str(result.get("error", "capture")))
			quit(1)
			return
		frames.append(result["frame"])

	var manifest: Dictionary = {
		"schema_version": 1,
		"run": "LENTE SPEC-005 V205 founder V4 independent technical A/B",
		"source_pr": 128,
		"source_cena_head": "001e0469b4d848e4c005a62e888e4de12af767f4",
		"lente_head": OS.get_environment("LENTE_V205_HEAD_SHA"),
		"engine": Engine.get_version_info().get("string", "unknown"),
		"renderer": "Godot 4.7.2 native Compatibility under hosted Xvfb/Mesa",
		"device": "Linux CI virtual display; NOT mobile handset",
		"browser": "NOT_TESTED",
		"source_sha256": SOURCE_SHA256,
		"source_git_blob": "da7806ebfcb051c8fd32ccdbad4760b7136f97dd",
		"status": "VISUAL_REVISE_TECHNICAL_ONLY",
		"art_concept_v4": "ACCEPT_HISTORICAL",
		"art_runtime": "NOT_EVALUATED",
		"hud_available": false,
		"g452_hydrated_founder": false,
		"occlusion_contact_proven": false,
		"frames": frames
	}
	var file: FileAccess = FileAccess.open(output_dir.path_join("manifest.json"), FileAccess.WRITE)
	if file == null:
		push_error("MARICA_LENTE_V205_FAIL could not write manifest")
		quit(1)
		return
	file.store_string(JSON.stringify(manifest, "  ") + "\n")
	file.close()
	print("MARICA_LENTE_V205_CAPTURE_PASS frames=7 status=REVISE")
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

	# Background must remain fixed to the viewport, not transformed by Camera2D.
	var background_layer: CanvasLayer = CanvasLayer.new()
	background_layer.layer = -10
	viewport.add_child(background_layer)
	var backdrop: ColorRect = ColorRect.new()
	backdrop.color = Color(str(config["background"]))
	backdrop.size = Vector2(size)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background_layer.add_child(backdrop)

	var scene: Node2D = PREVIEW.instantiate()
	viewport.add_child(scene)
	await process_frame
	var camera: Camera2D = scene.get_node("FarmIsoView/Camera2D")
	var founder: Sprite2D = scene.get_node("FarmIsoView/FounderV4TestCopy")
	var error: String = ""
	if not scene.apply_preview_size(Vector2(size)):
		error = "no candidate preview"
	elif founder.texture == null or founder.texture.get_size() != Vector2(344, 378):
		error = "unexpected source texture"
	elif founder.offset != Vector2(0, -182) or founder.scale != Vector2(0.25, 0.25):
		error = "founder transform drift"
	elif not camera.is_current():
		error = "camera not current"
	if not error.is_empty():
		viewport.queue_free()
		return {"ok": false, "error": error}

	var requested_zoom: float = camera.zoom.x
	if config["mode"] == "baseline":
		requested_zoom = CAMERA_POLICY.fit_zoom_for_size(Vector2(size))
	elif config["mode"] == "fractional":
		requested_zoom = 1.25
	if not camera.set_zoom_level(requested_zoom):
		viewport.queue_free()
		return {"ok": false, "error": "camera zoom rejected"}
	founder.texture_filter = (
		CanvasItem.TEXTURE_FILTER_LINEAR
		if config["sampling"] == "linear"
		else CanvasItem.TEXTURE_FILTER_NEAREST
	)

	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var image: Image = viewport.get_texture().get_image()
	error = ""
	var informative: int = 0
	if image.is_empty() or image.get_width() != size.x or image.get_height() != size.y:
		error = "missing real Godot GPU frame"
	else:
		var background: Color = image.get_pixel(2, 2)
		for y in range(4, size.y, 32):
			for x in range(4, size.x, 32):
				if image.get_pixel(x, y) != background:
					informative += 1
		if informative < 10:
			error = "flat frame"
		elif image.save_png(output_dir.path_join(str(config["name"]) + ".png")) != OK:
			error = "failed to save png"
	if not error.is_empty():
		viewport.queue_free()
		return {"ok": false, "error": error}

	var result: Dictionary = {
		"name": config["name"],
		"file": str(config["name"]) + ".png",
		"viewport": [size.x, size.y],
		"mode": config["mode"],
		"filter": config["sampling"],
		"background": config["background"],
		"zoom": camera.zoom.x,
		"projected_founder_width_px": 344.0 * 0.25 * camera.zoom.x,
		"informative_grid_samples": informative,
		"physical_mobile": false,
		"art_runtime": "NOT_EVALUATED"
	}
	viewport.queue_free()
	return {"ok": true, "frame": result}
