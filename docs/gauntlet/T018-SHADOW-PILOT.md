# T018 — GAUNTLET shadow calibration

This is a calibration artifact, not a retroactive rejection of merged T018.

## Baseline

- baseline: 69e798df2c6f9578bf01b7eec65615b934721625
- target: persistent affection independent from transient care
- accepted delivery head: 4a2a74f30b2465bb9a7e9d3e8186930857c2f1bd
- merged at: 11295a68468eb5ac7eb447c1a08b5195db5fd524

## What existing gates proved

The exact T018 delivery head passed:

- Validate skills;
- Roblox CI format gate;
- Selene static analysis;
- production/test place build.

The first candidate had failed formatting before the corrected delivery head passed. This is evidence that exact-head gating catches at least one concrete regression class.

## What the authored behavioral tests intend to prove

tests/affection.spec.luau checks:

- default and persisted affection validation;
- deterministic capped growth;
- separation from transient care affection;
- immutable growth without rewriting identity/pedigree/care/health/soulbound;
- preservation across lifecycle and health transitions.

## Fresh critic result

**Not independently certified.**

This historical shadow review was performed after builder delivery context was visible. It cannot satisfy the strongest fresh-eyes isolation requirement and is recorded that way instead of being promoted to PASS.

## Mutation result

**BLOCKED.**

Current Roblox CI builds a test place containing Jest specs but does not launch the place and execute Jest assertions.

Therefore the repository cannot yet truthfully prove:

~~~text
GOOD -> PASS
BAD MUTANT -> FAIL
RESTORE -> PASS
~~~

for T018.

A known future mutant for this contract is: reset persistent affection during a Pet state transition. The test instrument must reject that mutant once behavioral execution is wired.

## Regression Hunter

Authored specs target adjacent state preservation for:

- identity;
- pedigree;
- care;
- health;
- lifecycle;
- soulbound.

Because those assertions are not headlessly executed in CI, regression status is **PARTIAL**, not NONE.

## Calibration conclusion

T018 exposes the exact reason SPEC-003 is needed:

~~~text
test source exists
        !=
behavioral test executed
        !=
mutation proof
~~~

The first strict mutation proof should be performed on a new measurable P0 invariant after headless Roblox behavioral execution is available.
