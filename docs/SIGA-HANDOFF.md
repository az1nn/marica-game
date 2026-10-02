CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 Animal Core continuation

STATE:
T016 health/disease/treatment is implemented on a dedicated candidate branch and awaits exact-head delivery gates.

MODE:
RESUME

CANONICAL SOURCE:
az1nn/marica-game master + .agents/skills/siga/SKILL.md + .specify/memory/constitution.md + live specs/tasks/PRs/claims/CI.

BASE / ENV:
master@db458e4b1fcfbff642ad1e28dcd76adeb6fad024 / Roblox-first

ACTIVE PR / CLAIM:
Branch: feat/t016-health-disease-treatment.
Claim: .siga/session-claim-t016-20261002-1110-sol.md (ACTIVE).
PR: pending creation.

SPEC / ADR:
SPEC-001 Animal Core; ADR-0001 runtime; ADR-0002 persistence/time.

DONE:
- deterministic persistent health state is separated from care;
- severe neglect accumulates using explicit elapsed hours;
- short normal absence does not immediately create disease;
- progression covers healthy, neglected, sick and critical;
- established disease requires treatment;
- treatment returns explicit resource cost;
- untreated critical disease can deterministically end lifecycle for health;
- Pet preserves identity, pedigree, care and genetic potential through health transitions;
- behavioral Jest coverage is authored;
- T016 is checked complete on the candidate branch.

VERIFY:
Required exact-head gates are pending for the final PR head:
- Validate skills;
- Roblox CI.

BLOCKERS:
None.

INVARIANTS:
- health and care remain distinct persisted concerns;
- health transitions do not mutate genetic potential, pedigree or identity;
- health terminal transition uses Lifecycle.endLife(..., "health");
- only az1nn/marica-game is authoritative for this project.

NEXT:
Open the T016 PR, verify exact-head gates, merge if green, then close the claim and persist T017 as the single next action.

VERIFY-FIRST:
Before merge, re-read master, PR head, open claims, overlap and exact-head workflows.
