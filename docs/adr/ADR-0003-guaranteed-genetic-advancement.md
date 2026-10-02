# ADR-0003 — Guaranteed Genetic Advancement

**Status:** Accepted  
**Date:** 2026-10-02  
**Task:** T020 / SPEC-001 Phase C

## Context

SPEC-001 and the Maricá Game constitution require every automatic successor generation to preserve lineage progress and provide guaranteed genetic advancement without unbounded growth.

The current domain represents genetic potential as named normalized traits in the closed interval `[0, 1]`. T021 will generate successors; T020 must freeze the advancement primitive that T021 can call deterministically.

The rule needs to be:

- deterministic for the same parent potential and seed;
- independent from transient care/expression;
- bounded by the normalized trait cap;
- guaranteed to improve when any improvement capacity remains;
- testable without Roblox runtime state or wall-clock time.

## Decision

Introduce the pure domain operation:

~~~text
advancePotential(parentPotential, seed) -> advancedPotential
~~~

with a fixed V1 advancement step of **0.05**.

Algorithm:

1. validate and copy the parent potential;
2. require at least one genetic trait;
3. sort trait names lexicographically to remove table iteration order from the result;
4. map the non-negative integer seed to a starting trait index;
5. scan traits cyclically from that index until the first trait below the cap is found;
6. increase exactly that trait by `min(0.05, 1 - currentValue)`;
7. leave every other trait unchanged;
8. if every trait is already at `1`, return an equal capped potential.

Therefore:

~~~text
for every trait: child[t] >= parent[t]

if any parent[t] < 1:
    sum(child traits) > sum(parent traits)

if all parent[t] == 1:
    child == parent
~~~

Equality is permitted only for a fully saturated potential, because strict improvement is mathematically impossible at the configured cap.

## Seed semantics

The seed selects the first candidate trait, not the amount of gain.

For `N` sorted traits:

~~~text
start_index = (seed mod N) + 1
~~~

If that trait is saturated, the algorithm advances cyclically to the next trait with remaining capacity.

T021 owns how successor-specific seeds are derived. T020 only requires that the supplied seed be a finite non-negative integer.

## Why this rule

This rule keeps V1 legible and auditable:

- every non-saturated generation has measurable forward movement;
- one trait per advancement prevents all stats from racing to cap simultaneously;
- different deterministic seeds can produce distinct successor directions without random mutation;
- the fixed cap prevents infinite power growth;
- the operation is pure and can be exercised in accelerated succession tests.

A more biologically detailed Mendelian genome remains separate future work. It must not weaken this guaranteed lineage-progress invariant.

## Rejected alternatives

### Increase every trait each generation

Rejected because it collapses diversity and reaches the cap too quickly.

### Random percentage growth

Rejected because it makes the guarantee and replay behavior harder to audit.

### Gain proportional only to remaining headroom

Rejected for V1 because near-cap gains become arbitrarily small and stop being a meaningful minimum guarantee.

### Allow regression in exchange for higher aggregate score

Rejected because SPEC-001 requires guaranteed advancement and does not authorize successor traits to become genetically worse than the ended parent.

## Test contract

The domain tests must prove:

- same parent + same seed produces the same trait values;
- seed changes the selected trait deterministically;
- saturated selected traits fall forward deterministically;
- non-selected traits never regress;
- gain is capped at `1`;
- fully saturated potentials remain stable;
- result is immutable;
- empty potentials and invalid seeds are rejected.

T021 may compose this primitive into successor creation but may not redefine it silently.
