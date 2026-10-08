# GODOT HANDOFF

Status: PRODUCTION / G415 candidate — VERIFY

Authority:
- Constitution v2.0.0
- SPEC-004
- ADR-0004

Runtime:
- Godot 4.7.2-stable / typed GDScript / single-player offline-first.
- GUT v9.7.1 pinned to aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605.

Delivered:
- G410–G414: project foundation, pinned engine/test runner, exact-head Godot import/parse/runtime smoke.
- G415: game/docs/GDSCRIPT-CONVENTIONS.md; pinned gdtoolkit 4.5.0; gdformat/gdlint configuration; Python typed-declaration guard with four positive/negative tests; Godot CI checks first-party scripts before engine import.

Verification:
- PR #44 candidate 835d0af9d5e8c20c377e1afcb5426fd307d78526: Godot CI PASS (typing tests, formatting, lint, import/parse/boot/smoke), Validate skills PASS, Roblox CI PASS, Roblox Behavioral SKIPPED/non-required.
- Later task/handoff commits require **new exact-head CI** before merge; the earlier candidate SHA is not delivery proof.
- No gameplay parity, save, real animal slice or visual acceptance asserted.

Boundary:
- No vendor changes to game/addons.
- Godot core remains offline-only independent of online provider/Roblox.
- G416 owns deterministic Luau → Godot golden-fixture harness, not G415.

Next specialist task:
**G416 — create golden-fixture harness after PR #44 is verified and merged.**
