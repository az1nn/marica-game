# GODOT HANDOFF

Status: PRODUCTION / ADVANCE

Authority: Constitution v2.0.0 · SPEC-004 · ADR-0004
Runtime: Godot 4.7.2-stable, typed GDScript, single-player/offline-first; GUT v9.7.1 pinned.

Delivered:
- G410–G416: foundational engine, exact-head CI, deterministic headless runtime smoke and golden fixture harness.
- G420: pure PetId, identity-only Pet, five verified golden fixtures and whitespace-ID mutation proof.
- G421: pure LineageId validation and generator, pure Pedigree with founder/descendant generation and parent cardinality/uniqueness rules; detached snapshots prevent caller-side alias mutation.
- 4 harness selftests, 26 ACTIVE_PARITY domain fixtures (5 PetId, 6 LineageId, 15 Pedigree); six future simulation time/genetics cases remain PENDING_PORT.
- G421 mutation proof rejects an illegal founder with a direct parent; CI restores exact source and reruns fixtures.

Verification:
- PR #50 final head 358cf82ba2bba9a12f77607fbfea76feba4092aa: Godot CI PASS, Validate skills PASS, Roblox CI PASS, Roblox Behavioral SKIPPED/non-required.
- Guarded merge to master@664f6e5d9126af81505d59760b412209ae9e4fdb.
- Post-merge master@664f6e5d9126af81505d59760b412209ae9e4fdb: Godot CI PASS, Validate skills PASS, Roblox CI PASS.
- No full animal domain parity, lifecycle, health, care, genetics, succession, save, farm playability or visuals asserted.

Boundaries:
- Pure Godot domain remains independent from Roblox, UI, SceneTree and online providers.
- Pedigree structural parity precedes lifecycle; semantic authority remains with the approved Luau contracts and SPEC-004 migration map.
- G429 eventually proves aggregate Animal Core parity, and G430+ own succession.

Next: **G422 — port lifecycle state machine, with executable golden fixtures.**


G422 candidate in `feat/g422-godot-lifecycle`:
- Pure lifecycle transitions implemented from `Lifecycle.luau`, with 19 new `ACTIVE_PARITY` fixtures, headless unit runner, natural-end mutation gate.
- Status: IMPLEMENTED / awaiting exact-HEAD CI. G423 owns simulation time; no claim of full Animal Core parity.
- Orchestrator must only mark G422 complete after current PR SHA passes all required CI and mutation proof.
