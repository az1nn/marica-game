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
- G410–G414: canonical Godot project, pinned engine/test runner, exact-head CI and deterministic smoke.
- G415: typed conventions; gdtoolkit 4.5.0 formatting/linting; typed declaration guard.
- G416: versioned golden fixture catalog at game/tests/fixtures/golden.json; schema/provenance validator; GDScript headless fixture runner; Python regression tests and exact-head Godot CI integration.
- G416 executes four harness selftests; ten domain fixtures stay PENDING_PORT (PetId, LineageId, SimulationTime, Genetics). PASS for harness != PASS for domain parity.

Verification:
- PR #46 final head f05ed10d1a1057013fb225e3dad9622bfa813b80: Godot CI PASS (harness, import, parse, smoke, format/lint), Validate skills PASS, Roblox CI PASS.
- PR #46 merged with expected-head guard into master@0b43c1de4baa93483aef860a27d86df57d7290dc.
- Post-merge master@0b43c1de4baa93483aef860a27d86df57d7290dc: Godot CI PASS, Validate skills PASS, Roblox CI PASS.
- Roblox Behavioral SKIPPED/non-required. No animal parity, persistence, playable farm or visual acceptance asserted.

Boundary:
- Godot V1 remains single-player/offline-first; source provenance is legacy reference, not proof.
- Actual Pet/ID fixture parity requires Godot domain implementation and exact-head adapter execution in G420.
- Legacy Luau cannot be removed until the applicable migration parity gates pass.

Next specialist task:
**G420 — port Pet + immutable IDs with real parity cases.**
