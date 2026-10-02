# QA HANDOFF

Status: T017_CANDIDATE

## Candidate evidence

Base master: `837e29fbae0acdd5b1e51ee093dcb3e96cdc3671`.
Implementation branch: `feat/t017-soulbound-domain-invariant`.
Behavioral test source: `tests/soulbound.spec.luau`.

Authored Jest coverage:
- regular pets default to transferable;
- an explicitly soulbound founder is rejected by the domain transfer guard;
- invalid persisted soulbound values are rejected;
- soulbound survives lifecycle, care and health state transitions;
- descendants do not inherit soulbound automatically and remain eligible for future transfer rules.

Required exact-head gates:
- Validate skills;
- Roblox CI, including lockfile reproducibility, StyLua, Selene and production/test builds.

Status: pending on final PR head.

Known QA gap: CI builds Jest specs but does not execute Jest assertions headlessly. Treat authored behavioral specs as coverage evidence until that harness is wired.

## Next

Verify the final T017 PR head, then merge only if all required gates are green.
