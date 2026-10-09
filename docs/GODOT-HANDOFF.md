# GODOT HANDOFF

Status: PRODUCTION / ADVANCE

Authority: Constitution v2.0.0 · SPEC-004 · ADR-0004
Runtime: Godot 4.7.2-stable, typed GDScript, single-player/offline-first; GUT v9.7.1 pinned.

Delivered:
- G410–G416 foundation, exact-head CI, typing/formatting and golden harness.
- G420 Pet identity shell + immutable IDs; G421 LineageId/Pedigree; G422 pure lifecycle.
- G423 MaricaSimulationTime.observe with an injected Callable; validation of numeric, finite, nonnegative previous/current timestamps; rollback clamps logical time; explicit elapsed; no direct system clock, SceneTree, HTTP or save.
- Godot-executed Luau parity: 54 ACTIVE_PARITY cases (5 PetId + 6 LineageId + 15 Pedigree + 19 Lifecycle + 9 SimulationTime), 4 harness selftests, 3 genetics PENDING_PORT.
- G423 standalone headless runner and rollback mutation GOOD→BAD→RESTORE; G420–G422 mutation regressions retained.

Verification:
- PR #54 exact head 4dc5431ab7bc5420ee8133ad081eaeb7c26f57d6 — Godot CI / Validate skills / Roblox CI PASS; Behavioral SKIPPED (non-required).
- Expected-head guarded merge master@da9f4c8919fc4551b88ff6b954e1835f1f3fcb10 — all three required post-merge checks PASS.
- No full Animal Core parity, genetics, care/health, succession, local save, farm playability, visual approval or online dependence claims.

Next: **G424 — port genetic potential and expressed traits, preserve deterministic tests and domain boundary.**
