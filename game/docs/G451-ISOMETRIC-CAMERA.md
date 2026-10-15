# G451 — Isometric/Elevated Camera with Zoom

- Opt-in `res://scenes/farm_iso_view.tscn` wraps the canonical G450 `FarmBase` under `IsometricWorld`; the G450 tile layout remains 12×10 and unchanged.
- A Godot Camera2D tracks the projected farm midpoint. Its sibling world transform uses a diamond/elevated orthographic basis: (0.7071068, 0.3535534) and (-0.7071068, 0.3535534). This produces an isometric-like 2.5D tile view; it is not a 3D perspective camera.
- Zoom accepts wheel and magnify gestures, clamps finite positive scales to [0.5, 2.0], and fits a small viewport with 10% margin. No tile positions, animal/save data, gameplay balance or default bootstrap scene are modified.
- The independent G451 runner validates G450 initialization, camera midpoint, projection, small-screen fit, input zoom and invalid bounds. CI mutates upper clamping (GOOD→BAD→RESTORE), restores the exact source, and runs the existing Godot/G450 checks.
- Provisional technical scaffolding only. The approved founder V4 binary and ARTIST/SCENE/LENTE decisions remain gated. G452 pet, HUD, live screenshots/mobile browser and end-to-end player UX are separate.
