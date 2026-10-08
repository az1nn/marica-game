extends Node2D

# Infrastructure-only scene. Player-facing content begins in SPEC-004 Phase F.
const READY_MARKER: StringName = &"marica_smoke_ready"


func _ready() -> void:
    set_meta(READY_MARKER, true)
    print("MARICA_G414_SCENE_READY")
