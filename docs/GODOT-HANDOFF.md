# GODOT HANDOFF

Status: PRODUCTION / ADVANCE

Authority:
- Constitution v2.0.0
- SPEC-004
- ADR-0004

Runtime:
- Canonical V1: Godot 4.7.2-stable / GDScript typed / single-player offline-first.
- Runner: GUT v9.7.1 pinned to upstream commit aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605.

Delivered:
- G410: bootstrap game/project.godot + layered project tree.
- G411: game/.godot-version pins Godot 4.7.2-stable.
- G412: game/test-runner.lock.json pins compatible GUT v9.7.1.
- G413: .github/workflows/godot-ci.yml installs checksum-verified Godot and commit-verified GUT; checks out the exact PR head and executes headless import + editor parse/load.

Validation:
- PR #40 head 84cf076e9047d0534f01896129219a6909985931: Godot 4.7.2 import and parse PASS; Validate skills PASS; Roblox CI PASS; Roblox Behavioral SKIPPED/non-required.
- Merge guarded by expected head SHA, master merge commit bdc6901d5cc888bcdcae890badd343c76e7b836b.
- Godot CI artifact includes version/import/parse diagnostic logs.
- G413 validates Godot bootstrap/import, not gameplay or GUT test cases; no unimplemented runtime capability is claimed.

Boundary:
- G414 owns first minimal smoke scene with deterministic headless runtime execution.
- G415 owns typed GDScript lint/format conventions.
- G416 owns golden fixtures for Luau-to-Godot parity.
- No Roblox Studio, backend, or leaderboard requirement may block the offline V1.

Next specialist task:
**G414 — create minimal smoke scene and reproducible headless execution.**
