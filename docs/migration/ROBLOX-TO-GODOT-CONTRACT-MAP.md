# Roblox → Godot Contract Migration Map

**Status:** ACTIVE MIGRATION SOURCE  
**Authority:** Constitution v2.0.0 · SPEC-004 · ADR-0004  
**Captured:** 2026-10-07

This document preserves reusable deterministic contracts from the closed Roblox implementation branches without making Luau/Roblox a V1 production dependency.

## Source classification

| Source | Exact retained head | Classification | Godot target |
|---|---|---|---|
| PR #26 — T020 guaranteed genetic advancement | b12daa4ef419b6e2980c8c71a206128a4db53384 | MIGRATION_SOURCE | G430 |
| PR #34 — T021 deterministic successor generation | 15700a83c4ada4656594e41ff5a18d7f74cdf84b | MIGRATION_SOURCE | G431 |
| PR #29 — AQ011 Roblox Behavioral/Open Cloud gate | 0d6155791e703e1c1bb92ee7d239a3e3c16307c6 | SUPERSEDED | none |

All three PRs are closed without merge. Their branches remain available as historical/migration evidence.

## Contract A — Guaranteed genetic advancement

Source: PR #26, especially `docs/adr/ADR-0003-guaranteed-genetic-advancement.md`, `src/shared/domain/Genetics.luau` and `tests/genetics.spec.luau`.

Pure contract:

~~~text
advance_potential(parent_potential, seed) -> advanced_potential
~~~

V1 semantics to preserve in Godot:

1. potential is a named trait map with values in [0, 1];
2. seed is a finite non-negative integer;
3. at least one trait is required;
4. trait names are sorted lexicographically before selection;
5. nominal advancement step is 0.05;
6. start index is `(seed mod N)`;
7. scan cyclically from that index until the first trait below 1 is found;
8. increase exactly that trait by `min(0.05, 1 - current)`;
9. every other trait remains unchanged;
10. if every trait is already 1, return an equal saturated potential;
11. input state is not mutated.

Required invariants:

~~~text
forall trait: child[trait] >= parent[trait]

if any parent trait < 1:
    sum(child traits) > sum(parent traits)

if all parent traits == 1:
    child == parent
~~~

### Golden fixtures for G430

| Case | Input | Seed | Expected |
|---|---|---:|---|
| first sorted trait | resilience=0.40, size=0.50 | 0 | resilience=0.45, size=0.50 |
| second sorted trait | resilience=0.40, size=0.50 | 1 | resilience=0.40, size=0.55 |
| saturated fallback | resilience=1.00, size=0.50 | 0 | resilience=1.00, size=0.55 |
| near cap | resilience=0.98, size=1.00 | 0 | resilience=1.00, size=1.00 |
| all saturated | resilience=1.00, size=1.00 | 1 | unchanged |
| repeatability | same potential | same seed | byte/field-equivalent result |
| invalid empty | empty map | 0 | reject |
| invalid negative seed | valid map | -1 | reject |
| invalid fractional seed | valid map | 0.5 | reject |

G430 must re-prove these fixtures in Godot; prior Roblox authored tests are evidence of intended behavior, not substitute PASS evidence for the Godot implementation.

## Contract B — Deterministic successor primitive

Source: PR #34, especially `src/shared/domain/Succession.luau` and `tests/succession.spec.luau`.

Seed derivation:

~~~text
derive_genetic_seed(succession_seed, successor_ordinal)
    = succession_seed + successor_ordinal - 1
~~~

Constraints:

- succession seed is a finite non-negative integer;
- successor ordinal is a positive integer.

Single-successor primitive:

~~~text
create_successor(parent, successor_id, succession_seed, successor_ordinal)
~~~

Semantics to preserve in Godot:

1. parent lifecycle must already be terminal;
2. successor ID is explicit and domain-validated;
3. genetic seed is derived using the formula above;
4. genetic potential is produced only through Contract A;
5. pedigree keeps the same `lineage_id`;
6. generation is `parent.generation + 1`;
7. `founder_pet_id` is preserved;
8. direct `parent_pet_ids` contains the ended parent;
9. successor starts juvenile/active;
10. care and health start from their fresh defaults;
11. affection starts at 0;
12. founder `soulbound` does not propagate to descendants;
13. identical explicit inputs produce identical successor state.

### Golden fixtures for G431

| Case | Input | Expected |
|---|---|---|
| seed ordinal 1 | seed=40, ordinal=1 | genetic seed 40 |
| seed ordinal 2 | seed=40, ordinal=2 | genetic seed 41 |
| deterministic repeat | same parent/id/seed/ordinal | equivalent successor |
| sibling direction | seed=0, ordinals 1 and 2 | deterministic distinct advancement direction where capacity permits |
| lineage | ended founder parent | same lineage/founder, generation +1, direct parent set |
| state reset | ended parent with bond/soulbound | juvenile active, affection 0, soulbound false |
| active parent | non-terminal parent | reject |
| zero ordinal | ordinal=0 | reject |
| fractional seed | seed=0.5 | reject |

G431 implements one successor per call. It does **not** absorb the following responsibilities:

- G432: exactly two successors per end-of-life;
- G433: idempotency;
- G434: explicit next-generation pedigree verification.

## Behavioral-evidence caveat

PR #26/#34 had static/build evidence in their Roblox lane, but acceptance was blocked by the missing Open Cloud behavioral environment. The migration therefore preserves **contracts and fixtures**, not a claim that runtime behavior was already fully certified.

Godot must establish fresh exact-head evidence through its own deterministic/headless test lane.

## Decommission rule

Do not delete legacy Roblox source solely because this map exists. Legacy code becomes removable only after the corresponding SPEC-004 parity gates pass and G510 confirms all useful contracts are represented in Godot.
