# GODOT HANDOFF

Status: PRODUCTION / ADVANCE

Authority:
- Constitution v2.0.0
- SPEC-004
- ADR-0004

Runtime:
- Godot 4.7.2-stable; single-player/offline-first.
- GUT v9.7.1 pinned at aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605.

Delivered:
- G410–G416: foundation, exact-head CI, smoke, typed GDScript, deterministic golden harness.
- G420: pure GDScript PetId validates string and whitespace, accepts explicit Callable generator; identity-only MaricaPet validates ID and exports detached serializable snapshots without public ID setter.
- Five ACTIVE_PARITY PetId fixtures executed from src/shared/domain/PetId.luau; eight G421/G423/G430 fixtures remain PENDING_PORT.
- CI checks actual Godot PetId behavior, negative cases, headless Pet identity, and mutation proof GOOD > BAD > RESTORE.

Verification:
- PR #48 final head 10c803ce38c3308018c6601db9f933d9a0df2552: Godot CI PASS, Validate Skills PASS, Roblox CI PASS; Roblox Behavioral SKIPPED/non-required.
- PR #48 merged with expected-head guard into master@a889f9132720ab251ae2b60c99d7c6115341a826.
- Post-merge master@a889f9132720ab251ae2b60c99d7c6115341a826: Godot CI PASS, Validate Skills PASS, Roblox CI PASS.
- Mutation proof: whitespace-only PetId bad mutant failed golden parity, original code restored and passed.
- Scope only ID validation/identity shell; no full Pet composite, pedigree, lifecycle, care, health, genetics, succession, persistence, playability or visual acceptance asserted.

Boundary:
- No online/Roblox runtime dependency enters Godot domain.
- Pet identity-only shell is intentionally extended by G421–G428.
- Legacy sources preserved for future golden ports.

Next specialist task:
**G421 — port lineage and pedigree with executable Godot golden parity.**
