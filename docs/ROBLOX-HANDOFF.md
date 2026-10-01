# ROBLOX HANDOFF

Status: ADVANCE

Runtime baseline remains Roblox + Luau under ADR-0001, with engine-neutral domain rules.

## Delivered

- T010 merged via PR #5.
- T011 merged via PR #6.
- T011 delivery SHA: `fec260381caff36ce15ef2202e52d9c690ba1178`.
- `LineageId` is an opaque validated value with injected generation.
- `Pedigree` is immutable and stores lineage id, generation, founder pet and direct parent references.
- `Pet` now requires pedigree at construction.
- Roblox services remain outside the domain modules.

## Next

Execute **T012 — lifecycle state machine** with deterministic, clock-independent transitions in the domain.
