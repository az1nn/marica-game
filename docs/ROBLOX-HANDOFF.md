# ROBLOX HANDOFF

Status: T017_CANDIDATE

## T017 candidate

Base master: `837e29fbae0acdd5b1e51ee093dcb3e96cdc3671`.
Implementation branch: `feat/t017-soulbound-domain-invariant`.

Domain boundary now includes:
- explicit immutable `Pet.soulbound` state;
- validated boolean persistence boundary for soulbound;
- `Pet.isTransferable(...)` as a domain eligibility query;
- `Pet.assertTransferable(...)` as the mandatory domain guard for future ownership/marketplace transfer paths;
- soulbound persistence across lifecycle, care and health state transitions;
- descendants default to non-soulbound unless explicitly marked.

Required gates are pending for the final PR head.

Known QA gap remains: Jest sources are built into the test place but assertions are not yet run headlessly in CI.

## Boundary

T017 establishes the invariant only. T040-T042 will implement ownership history and transfer use cases and must route every transfer-capable path through the domain guard rather than duplicating the rule in UI/runtime code.

## Next

After exact-head gates and merge, advance to **T018 — persistent affection**.
