extends SceneTree

# G414: executable SceneTree smoke, independent of online services and Roblox.
const SMOKE_SCENE: String = "res://scenes/smoke.tscn"
const READY_MARKER: StringName = &"marica_smoke_ready"


func _initialize() -> void:
    call_deferred("_verify_smoke")


func _verify_smoke() -> void:
    var packed: PackedScene = load(SMOKE_SCENE) as PackedScene
    if packed == null:
        push_error("G414 smoke: scene failed to load")
        quit(1)
        return

    var instance: Node = packed.instantiate()
    if instance == null:
        push_error("G414 smoke: scene failed to instantiate")
        quit(1)
        return

    root.add_child(instance)
    await process_frame

    if instance.name != &"SmokeRoot":
        push_error("G414 smoke: unexpected root node")
        quit(1)
        return

    if instance.get_meta(READY_MARKER, false) != true:
        push_error("G414 smoke: _ready marker not observed")
        quit(1)
        return

    print("MARICA_G414_SMOKE_PASS")
    quit(0)
