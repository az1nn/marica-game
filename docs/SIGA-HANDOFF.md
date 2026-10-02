CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 Animal Core continuation

STATE:
T018 persistent affection is implemented on a dedicated candidate branch and awaits exact-head delivery gates.

MODE:
RESUME

CANONICAL SOURCE:
az1nn/marica-game master + .agents/skills/siga/SKILL.md + .specify/memory/constitution.md + live specs/tasks/PRs/claims/CI.

BASE / ENV:
master@69e798df2c6f9578bf01b7eec65615b934721625 / Roblox-first

ACTIVE PR / CLAIM:
Branch: feat/t018-persistent-affection.
Claim: .siga/session-claim-t018-20261002-1327-sol.md (ACTIVE).
PR: pending creation.

SPEC / ADR:
SPEC-001 Animal Core; ADR-0001 runtime; ADR-0002 persistence/time.

DONE:
- affection is persisted on Pet independently from transient care affection;
- invalid affection values are rejected;
- affection gain is deterministic and capped;
- Pet state transitions preserve affection;
- behavioral Jest coverage documents the invariant;
- T018 is checked complete on the candidate branch.

VERIFY:
Required exact-head gates are pending for the final PR head:
- Validate skills;
- Roblox CI.

CONCURRENCY:
- pre-mutation snapshot found no open PRs;
- all prior repository claims were CLOSED;
- post-claim barrier found master unchanged at 69e798df2c6f9578bf01b7eec65615b934721625;
- classification: CLEAR.

BLOCKERS:
None.

INVARIANTS:
- persistent affection is not the same state as momentary care affection;
- future ownership transfer must preserve persistent affection;
- T018 does not implement ownership transfer;
- only az1nn/marica-game is authoritative for this project.

NEXT:
Open the T018 PR, verify exact-head gates, merge if green, then close the claim and persist T020 as the single next action.

VERIFY-FIRST:
Before merge, re-read master, PR head, open claims, overlap and exact-head workflows.
