# QA HANDOFF

Status: T018_CANDIDATE

## Candidate evidence

Base master: `69e798df2c6f9578bf01b7eec65615b934721625`.
Implementation branch: `feat/t018-persistent-affection`.
Behavioral test source: `tests/affection.spec.luau`.

Authored Jest coverage:
- affection defaults independently from momentary care;
- persisted affection rejects invalid normalized values;
- deterministic affection gain accumulates and caps at 1;
- care-state updates do not overwrite persistent bond;
- lifecycle and health transitions preserve persistent affection.

Required exact-head gates:
- Validate skills;
- Roblox CI, including lockfile reproducibility, StyLua, Selene and production/test builds.

Status: pending on final PR head.

Known QA gap: CI builds Jest specs but does not execute Jest assertions headlessly. Treat authored behavioral specs as coverage evidence until that harness is wired.

## Next

Verify the final T018 PR head, then merge only if all required gates are green.
