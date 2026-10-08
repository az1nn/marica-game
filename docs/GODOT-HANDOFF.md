# GODOT HANDOFF

Status: PRODUCTION / ADVANCE

Authority:
- Constitution v2.0.0
- SPEC-004
- ADR-0004

Runtime:
- Godot 4.7.2-stable / typed GDScript / single-player offline-first.
- GUT v9.7.1 pinned to commit aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605.

Delivered:
- G410: Godot project skeleton and layered runtime directories.
- G411: stable engine version pinned in game/.godot-version.
- G412: exact GUT runner pinned in game/test-runner.lock.json.
- G413: CI downloads/checks pinned Godot and GUT, runs headless import + parse on exact commit.
- G414: game/scenes/smoke.tscn is temporary main scene; typed Node2D _ready marker, standalone SceneTree smoke runner, reproducible headless boot and explicit exit code test; CI captures logs.

Verification:
- PR #42 head 33bf078116bc465395960b4b630e9237a763d5de: Godot CI PASS (engine/import/parse/scene boot/runner), Validate skills PASS, Roblox CI PASS; Roblox Behavioral SKIPPED and non-required by ADR-0004.
- PR #42 merged with expected-head guard: master@2ba00afe358d42e9d50f8ab029142112c0f619bd.
- Post-merge Godot CI PASS at master@2ba00afe358d42e9d50f8ab029142112c0f619bd.
- Scope limited to smoke/bootstrap; no playable Animal Core, visual acceptance, fixture parity, save, or offline gameplay asserted.

Boundary:
- G415 owns typed GDScript coding standards and lint/format gates where applicable.
- G416 owns golden-fixture harness before animal-domain migration.
- No online/Roblox requirement can block the V1 Godot core.

Next specialist task:
**G415 — establish typed GDScript conventions and automated validation.**
