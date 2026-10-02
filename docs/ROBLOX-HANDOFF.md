# ROBLOX HANDOFF

Status: T018_CANDIDATE

## T018 candidate

Base master: `69e798df2c6f9578bf01b7eec65615b934721625`.
Implementation branch: `feat/t018-persistent-affection`.

Domain boundary now includes:
- explicit persisted `Pet.affection` state independent from `careState.affection`;
- normalized affection validation at the domain boundary;
- deterministic capped bond growth through `Affection.increase(...)`;
- immutable `Pet.withAffection(...)` / `Pet.gainAffection(...)` transitions;
- affection preservation across lifecycle, care, expression and health transitions.

Required gates are pending for the final PR head.

Known QA gap remains: Jest sources are built into the test place but assertions are not yet run headlessly in CI.

## Boundary

T018 establishes persistent bond only. Ownership history and transfer paths remain T040-T042 and must preserve `Pet.affection` rather than resetting it.

## Next

Verify exact-head gates for **T018 — persistent affection**, merge when green, then advance to **T020 — guaranteed genetic advancement algorithm**.
