extends Node2D

# SPEC-005 V201: isolated Godot WebAssembly raster probe; never a production scene.
@onready var _founder: Sprite2D = $FarmIsoView/FounderV4TestCopy


func _ready() -> void:
    if _founder.texture == null:
        push_error("MARICA_V201_WEB_PROBE_NO_FOUNDER_TEXTURE")
        return
    if _founder.texture.get_size() != Vector2(344, 378):
        push_error("MARICA_V201_WEB_PROBE_WRONG_SOURCE_SIZE")
        return
    if _founder.texture_filter != CanvasItem.TEXTURE_FILTER_NEAREST:
        push_error("MARICA_V201_WEB_PROBE_NOT_NEAREST")
        return
    if OS.has_feature("web"):
        JavaScriptBridge.eval("window.__MARICA_ARCH_V201_GODOT_READY = true;", true)
    print("MARICA_V201_GODOT_WEB_PROBE_READY")
