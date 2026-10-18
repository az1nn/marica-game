extends Node2D


# QA-only wrapper: proving WebAssembly runtime boot does not approve art or gameplay.
func _ready() -> void:
    if not OS.has_feature("web"):
        return
    await get_tree().process_frame
    if not has_node("FounderScene/FarmIsoView/FounderV4TestCopy"):
        push_error("MARICA_QA001_SCENE_INCOMPLETE")
        return
    JavaScriptBridge.eval("window.__MARICA_QA_GODOT_READY = true")
