# QA HANDOFF

Status: T017_VERIFIED

## Delivery evidence

T017 delivery HEAD: `46dd15acde656b42c9ce92930e9edb5720f2458d`.
Merged master: `bca1b81410aa79af06c47b052e14478b2e578c03`.
PR: #16.

Authored Jest coverage:
- regular pets default to transferable;
- an explicitly soulbound founder is rejected by the domain transfer guard;
- invalid persisted soulbound values are rejected;
- soulbound survives lifecycle, care and health state transitions;
- descendants do not inherit soulbound automatically and remain eligible for future transfer rules.

Exact delivery gates at `46dd15acde656b42c9ce92930e9edb5720f2458d`:
- Validate skills: PASS;
- Roblox CI: PASS, including lockfile reproducibility, StyLua, Selene and production/test builds.

Merge concurrency:
- master advanced with RELATORIO-only changes;
- classified PARALLEL_SAFE because no T017 files/contracts overlapped.

Known QA gap: CI builds Jest specs but does not execute Jest assertions headlessly. Treat authored behavioral specs as coverage evidence until that harness is wired.

## Next

For T018, cover persistent affection as a separate domain state that survives future ownership transfer without being conflated with care.
