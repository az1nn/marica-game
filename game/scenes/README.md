# Scenes

Godot scenes for the playable V1 live here.

G414 will add the first reproducible smoke scene. Player-facing scene work remains subject to the ARTIST/CENA/LENTE gates defined by the active spec.

## G414 runtime smoke (infrastructure only)

`scenes/smoke.tscn` is the temporary Godot main scene and contains only a Node2D with a typed `_ready()` marker. It is not a playable farm and does not define art direction.

Run reproducibly, after importing the project with the pinned Godot editor:

```sh
godot --headless --path game --quit-after 3
godot --headless --path game --script res://tests/smoke_runner.gd
```

The first command must log `MARICA_G414_SCENE_READY`; the second must emit `MARICA_G414_SMOKE_PASS` and exit zero. The smoke runner exits nonzero if loading, instantiation or `_ready` fails. CI enforces both markers and exit codes on the exact PR head.
