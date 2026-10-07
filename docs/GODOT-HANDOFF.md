# GODOT HANDOFF

Status: PRODUCTION / ADVANCE

Authority:
- Constitution v2.0.0
- SPEC-004
- ADR-0004

Godot is the canonical V1 runtime.

Delivered:
- G410 established the Godot project lane under `game/`;
- G411 pins the production engine to `4.7.2-stable` in `game/.godot-version`;
- `game/README.md` defines the reproducible runtime contract for local development, tests and CI;
- preview/beta/RC/dev builds do not satisfy the production baseline;
- `game/project.godot` points maintainers to the canonical pin.

Validation:
- PR #38 exact-head `8a73d35`: Validate skills PASS; Roblox CI PASS;
- Roblox Behavioral SKIPPED/non-required under ADR-0004;
- guarded squash merge landed as `9b8852e`;
- G411 claim closed after merge.

Version evidence:
- official Godot archive checked on 2026-10-07;
- Godot 4.7.2-stable is the current stable Godot 4.x release;
- Godot 4.8-dev7 is pre-release and excluded from the baseline.

Boundary:
- G412 owns test-runner selection and must remain compatible with 4.7.2-stable;
- G413 owns Godot CI and must consume the same engine pin.

Next specialist task:
**G412 — choose and pin a test runner compatible with Godot 4.7.2-stable.**
