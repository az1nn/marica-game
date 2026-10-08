# GODOT HANDOFF

Status: PRODUCTION / G420 candidate — VERIFY

Authority:
- Constitution v2.0.0
- SPEC-004
- ADR-0004

Runtime:
- Godot 4.7.2-stable; single-player/offline-first.
- GUT v9.7.1 pinned at aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605.

Delivered:
- G410–G416: Godot foundation, pinned tools, headless smoke, typed GDScript, versioned golden harness.
- G420: game/src/domain/pet_id.gd (deterministic type/nonblank validation and explicit Callable ID generation), game/src/domain/pet.gd (validated identity-only Pet, getter, detached serializable snapshot), game/tests/pet_identity_runner.gd.
- Golden catalog now contains five ACTIVE_PARITY PetId cases (source: src/shared/domain/PetId.luau); eight fixtures for G421/G423/G430 remain PENDING_PORT.
- Python validator rejects fake/unauthorized parity. Exact-head CI runs Godot executable golden fixture and identity tests.

Verification:
- PR #48 preliminary head e9e2ba20490274bdded541a48c390a55c0fce274: Godot CI PASS; Validate skills PASS. Roblox CI applicable, await latest final head evidence.
- G420 good/bad/restore mutation proof: PASS. Real whitespace-only PetId validation mutant causes golden failure and is not merged; restored source produces the PASS marker.
- Spec/task/handoff changes after the preliminary check require fresh exact-head gates.
- G420 parity covers PetId only; the Pet shell has no fields from G421–G428. No complete Animal Core parity, succession, save, playability or visual acceptance asserted.

Boundary:
- Godot domain has no scene/online/Roblox dependency.
- The Pet identity has no public setter; detached snapshots protect against caller-side snapshot mutation.
- G421 owns lineage/pedigree; no unknown domain behavior silently imported from Luau.

Next specialist task:
**G421 — port lineage and pedigree with genuine Godot golden parity, after G420 merge.**
