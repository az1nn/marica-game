# GODOT HANDOFF

Status: PRODUCTION / G416 candidate — VERIFY

Authority:
- Constitution v2.0.0
- SPEC-004
- ADR-0004

Runtime:
- Godot 4.7.2-stable / typed GDScript / single-player offline-first.
- GUT v9.7.1 pinned to aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605.

Delivered:
- G410–G414: canonical project skeleton, pinned engine/test runner, exact-head CI and deterministic main-scene smoke.
- G415: typed conventions, gdtoolkit 4.5.0 formatter/linter, declaration guard with four unit tests.
- G416: game/tests/fixtures/golden.json versioned catalog; headless GDScript runner; Python fixture schema/provenance validator and eight negative/positive tests; CI gate.
- G416 has four passing harness selftests and ten deferred source-backed domain cases. Deferred fixtures are explicitly marked PENDING_PORT and **must never count as animal parity**.

Verification:
- PR #46 candidate head 70c6527e49c7c02cf2722548790c9b8444962371: Godot CI PASS (format, lint, engine import/parse/boot, G414 smoke, G416 harness), Validate skills PASS, Roblox CI PASS, Roblox Behavioral SKIPPED/non-required.
- G416 runner output: MARICA_G416_HARNESS_PASS active=4 pending=10 parity=NOT_YET_PROVEN.
- New documentation commits require fresh exact-head checks. No merge or post-merge check is asserted yet.
- Animal logic parity, persistence, save/load, release export and visual acceptance are unverified.

Boundaries:
- G416 certifies only fixture infrastructure. Source references are legacy evidence, not runtime parity.
- G420 is the next Animal Domain Port task: Pet identity + immutable IDs in pure GDScript with actual golden test adapters.
- Remain offline-first and preserve legacy Luau until G429/G510 evidence proves applicable parity.

Next specialist task:
**G420 — port Pet + immutable IDs and execute matching golden fixtures after G416 merge.**
