# GODOT HANDOFF

Status: PRODUCTION / ADVANCE

Authority:
- Constitution v2.0.0
- SPEC-004
- ADR-0004

Runtime:
- Godot 4.7.2-stable / typed GDScript / single-player offline-first.
- GUT v9.7.1 pinned to aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605.

Delivered:
- G410: Godot project skeleton + layered directories.
- G411–G413: pinned stable engine/test runner and exact-head import/parse CI.
- G414: temporary smoke main scene, typed _ready marker and deterministic SceneTree smoke.
- G415: typed declaration guard + four regression tests; first-party gdformat/gdlint pinned to gdtoolkit 4.5.0; conventions in game/docs/GDSCRIPT-CONVENTIONS.md; exact-head CI quality gate.

Verification:
- PR #44 final head f4153041c436dd9177306f0647f662309cd601ce — Godot CI PASS (typed guard, formatting, lint, import, parse, boot, runtime smoke), Validate skills PASS, Roblox CI PASS.
- PR #44 merged with expected-head guard into master@10f4ce70d0ae908cea734f92db44ed17a2135159.
- Post-merge master@10f4ce70d0ae908cea734f92db44ed17a2135159: Godot CI PASS; Validate skills PASS; Roblox CI PASS.
- Roblox Behavioral SKIPPED/non-required. Gameplay parity, persistence, playability and visual acceptance remain unverified and are not claimed.

Boundary:
- First-party GDScript only; do not lint/format vendored addons or generated Godot caches.
- Godot single-player runtime remains offline-first.
- G416 owns golden fixtures and deterministic parity; not part of G415.

Next specialist task:
**G416 — create golden-fixture harness for Luau → Godot contract parity.**
