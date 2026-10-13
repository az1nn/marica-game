# GODOT HANDOFF

Status: PRODUCTION / ADVANCE — G435 NEXT
Authority: Constitution v2.0.0 · SPEC-004 · ADR-0004.
Runtime: Godot 4.7.2-stable · typed GDScript · single-player/offline-first · GUT v9.7.1 pinned.

Delivered:
- G410–G416 foundation/harness, G420–G429 pure animal domain/composite Pet, G430 deterministic +0.05 genetic potential advancement.
- G431 pure one-successor primitive, G432 exactly-two deterministic batch, G433 in-process idempotent once-only event coordinator.
- **G434 verified**: isolated `tests/succession_pedigree_runner.gd` exercises founder (gen0) → gen1 pair → generation-2 pairs on both sibling branches → generation-3 pair. Validates immutable lineageId/founderPetId, generation+1, immediate parent per branch, reconstructable founder path through retained snapshots, founder-only soulbound, detached snapshots, replay idempotency.
- **238 ACTIVE_PARITY** source-linked executable golden cases (G420–G431) plus 4 harness selftests; G432/G433/G434 are independent regression gates, not new source-Luau parity claims.

Verified:
- G434 feature PR #81 exact head `87fdfb651e9f0afd2f21a74ce18a580eaddf6f82`: Godot CI including G434 regression and GOOD → BAD (replace intermediate direct parent with founder) → RESTORE PASS, Validate skills / Roblox CI / Web Preview Contract PASS. Roblox Behavioral SKIPPED/nonrequired.
- Guarded squash master@ `bac5a15e8ab3f241650477aeecd0a915c19886e2`: Godot CI, Validate skills, Roblox CI, Web Preview Contract PASS.
- PR #77 ARTIST isolated concept draft not integrated into game scene. Initial 3 animals (dog founder, capybara, chicken) and crops (corn, tomato, carrot) concept scope remains unchanged.

Limits:
- G434 traces ancestral chain **only when historical snapshots are retained**. No embedded global-ancestor list, persistent snapshot store, cross-restart guarantees, global-ID registry, or automatic world-level end-of-life hook. G440/G444/G445/G446 own those durability boundaries.
- G435 2–4 week accelerated full lifecycle, G436 full Gate D GAUNTLET, G450 playable scenes, G500 HTML5 export all pending. Vercel root is technical preview only.

Next: **G435** deterministic accelerated animal journey over 2–4 simulated weeks through care/aging/end-of-life/exactly-two successor transition, without relying on real clock or online dependencies.
