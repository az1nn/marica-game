CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 Animal Core continuation

STATE:
T016 health/disease/treatment is merged and complete. Live task order advances to T017 soulbound domain invariant.

MODE:
ADVANCE

CANONICAL SOURCE:
az1nn/marica-game master + .agents/skills/siga/SKILL.md + .specify/memory/constitution.md + live specs/tasks/PRs/claims/CI.

DELIVERY:
PR #14 merged.
Delivery HEAD: 0117998903c7331b8dd6d7a79b8f88340ef4e3b3.
Merge commit: 43ee6e2d9191bf9a7e271bc0cede35f4b8fb72de.

BASE / ENV:
master / Roblox-first

ACTIVE PR / CLAIM:
No product PR after #14 merge. T016 claim is CLOSED by this handoff closure.

SPEC / ADR:
SPEC-001 Animal Core; ADR-0001 runtime; ADR-0002 persistence/time.

DONE:
- persistent health remains separate from care;
- explicit elapsed time drives deterministic neglect and disease progression;
- normal short absence remains below the disease boundary;
- established disease requires treatment;
- treatment exposes an explicit resource-cost hook;
- untreated critical disease can end lifecycle with reason health;
- Pet preserves identity, pedigree, care and genetic potential across health transitions;
- behavioral Jest coverage documents health validation, progression, treatment and Pet integration;
- T016 is checked complete in the executable SPEC-001 backlog.

VERIFY:
PR #14 exact-head gates PASS at 0117998903c7331b8dd6d7a79b8f88340ef4e3b3:
- Validate skills: PASS;
- Roblox CI: PASS, including lockfile reproducibility, StyLua, Selene and production/test builds.

BLOCKERS:
None.

INVARIANTS:
- health and care remain distinct persisted concerns;
- health transitions do not mutate genetic potential, pedigree or identity;
- health terminal transition uses Lifecycle.endLife(..., "health");
- soulbound remains T017 scope;
- only az1nn/marica-game is authoritative for this project.

NEXT:
Execute T017 — soulbound domain invariant — from fresh master state, enforcing the restriction in the domain rather than presentation/UI.

VERIFY-FIRST:
Re-read master HEAD, open PRs, active .siga claims, T017 task contract and exact-head workflows before mutation.
