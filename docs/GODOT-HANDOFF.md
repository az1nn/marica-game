# GODOT HANDOFF

Status: PRODUCTION / ADVANCE

Authority:
- Constitution v2.0.0
- SPEC-004
- ADR-0004

Godot is the canonical V1 runtime.

Delivered:
- G410 merged through PR #37;
- `game/project.godot` and the domain/application/adapters/presentation/scenes/tests structure are present on master;
- domain boundary explicitly excludes Node, SceneTree, UI, HTTP and concrete storage.

Validation:
- PR #37 exact-head `167a55e`: Validate skills PASS; Roblox CI PASS;
- merge landed as `53af599`;
- no open PR remains.

G411 preflight:
- official Godot archive checked on 2026-10-07;
- `4.7.2-stable` is the current stable Godot 4.x release;
- `4.8-dev7` is pre-release and is not a production baseline candidate.

Next specialist task:
**G411 — pin Godot 4.7.2-stable and document the reproducible runtime version contract.**
