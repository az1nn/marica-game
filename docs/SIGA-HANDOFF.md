CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 T020 + SPEC-003 behavioral verification unblock

STATE:
T020 deterministic guaranteed genetic advancement is implemented as PR #26 but is not accepted yet. GAUNTLET landed during the run and now requires behavioral/mutation evidence for this new P0 invariant. AQ010 Open Cloud behavioral execution wiring is the collision-safe unblock candidate.

MODE:
WATCH

CANONICAL SOURCE:
az1nn/marica-game master + repository-local SIGA/GAUNTLET/QA skills + live specs/tasks/PRs/claims/CI.

BASE:
master@fe29ff352baa8b783fbb01cff176833600e50f30

ACTIVE PRODUCT:
T020 / PR #26 / feat/t020-genetic-advancement-algorithm.
Candidate head before reconciliation: 216df7d1217f0eb82a13d92b80feafd30ee16ab1.

T020 CONTRACT:
- normalized potential remains bounded in [0, 1];
- nominal advancement step is 0.05;
- seed selects a deterministic trait over sorted names;
- saturated traits fall forward cyclically;
- no trait regresses;
- strict advancement occurs whenever capacity remains;
- equality is allowed only at full saturation;
- T021 owns successor seed derivation.

QUALITY UNBLOCK:
AQ010 / feat/aq010-open-cloud-behavioral-execution.
- exact test place build and isolated publish;
- stable Roblox Open Cloud Luau Execution against an exact place version;
- explicit Jest runner;
- logs and task failure propagate to CI;
- missing repository Open Cloud configuration stays missing evidence, never PASS.

BLOCKER / WAIT:
T020 cannot merge under the live GAUNTLET contract until executable behavioral evidence exists for its exact candidate and the required mutation cycle can be performed.

CONCURRENCY:
T020 product files and AQ010 quality infrastructure are parallel-safe. No sibling product implementation is open.

NEXT:
Verify and merge AQ010 wiring, then make behavioral Jest execution an exact-head gate (AQ011) and use it to certify T020.
