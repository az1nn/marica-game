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
- G412 selects GUT `v9.7.1` as the canonical Godot test runner;
- `game/test-runner.lock.json` pins both the GUT release tag and upstream commit `aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605`;
- `game/README.md` records the engine and test-runner reproducibility contracts.

Validation:
- PR #39 exact-head `201207a`: Validate skills PASS; Roblox CI PASS;
- Roblox Behavioral SKIPPED/non-required under ADR-0004;
- merge guarded by expected head SHA;
- G412 implementation merged to master as `5e18228`.

Compatibility evidence:
- project runtime remains Godot `4.7.2-stable`;
- GUT `v9.7.1` is the upstream line designated for Godot `4.7.x`;
- the runner pin does not change engine version or add a competing framework.

Boundary:
- G413 owns Godot CI, runner installation/bootstrap, headless import/parse and exact-head execution;
- G414 owns the first reproducible smoke scene;
- domain code remains independent from Node/SceneTree/UI/HTTP/storage concrete.

Next specialist task:
**G413 — create Godot CI with import/headless parse on exact SHA.**
