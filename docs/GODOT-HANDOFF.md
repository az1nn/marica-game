# GODOT HANDOFF

Status: PRODUCTION / ADVANCE

Authority:
- Constitution v2.0.0
- SPEC-004
- ADR-0004

Godot is the canonical V1 runtime.

Delivered:
- G410 bootstrap implemented in `game/`;
- `game/project.godot` created without prematurely pinning the engine minor;
- domain/application/adapters/presentation/scenes/tests boundaries are repository-visible;
- domain boundary explicitly excludes Node, SceneTree, UI, HTTP and concrete storage.

Validation:
- required G410 paths are present on the exact branch head;
- branch is based directly on current master with no base drift at implementation time;
- G411 remains responsible for researching and pinning the exact stable Godot 4.x minor.

Next specialist task:
**G411 — research and pin the stable Godot 4.x version for the project.**
