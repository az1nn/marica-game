# ROBLOX HANDOFF

Status: WATCH

## T014 candidate

PR #9 implements the genetics/expression boundary entirely in the shared engine-neutral domain.

Candidate boundary:
- `Genetics.newPotential(...)` creates an immutable normalized trait-potential map;
- `Genetics.express(potential, factors)` derives current expressed traits deterministically;
- factors are bounded to [0, 1] and cannot introduce traits absent from genetic potential;
- `Pet` persists genetic potential and expressed traits as separate fields;
- `Pet.withExpressionFactors(...)` updates expression without changing identity, pedigree, lifecycle or genetic potential;
- no Roblox service or Instance dependency enters the genetics domain.

## Gates

PR #9 must pass the exact final-head Roblox CI and Validate skills workflows before merge.
Known QA gap remains: Jest sources are built into the test place but assertions are not yet run headlessly in CI.

## Boundary

T015 should compute care state in the domain/application layers and translate it into explicit expression factors. Do not put care mutation inside genetic potential and do not move this logic into presentation/runtime code.

## Next

After PR #9 is green and merged, execute **T015 — care state**.
