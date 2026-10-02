CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SIGA orchestration hardening / SPEC-001 Animal Core continuation

STATE:
T014 is merged and complete. T015 remains the next product task. A bounded SIGA protocol-maintenance branch is active to hard-lock orchestration to this repository and remove stale cross-repository authority.

MODE:
RESUME

CANONICAL SOURCE:
az1nn/marica-game master + .agents/skills/siga/SKILL.md + .specify/memory/constitution.md + live specs/tasks/PRs/claims/CI.

CURRENT VERSION / HEAD:
Base master@c49bdd4756e16a079a2d0c69cc8441bcf51d5d9d.
Protocol branch chore/siga-marica-orchestrator-lock.

BASE:
master

BRANCH / ENV:
chore/siga-marica-orchestrator-lock / Roblox-first

PR / MR / TASK:
Protocol maintenance claim OPS-SIGA-ORCHESTRATOR-LOCK active. No product PR is active. T015 remains next after protocol maintenance is delivered.

SPEC / ADR:
SPEC-001 Animal Core; ADR-0001 runtime; ADR-0002 persistence/time.

DONE:
- T014 genetic trait expression is merged;
- SIGA repository identity is locked to az1nn/marica-game;
- orchestration flow is being hardened around live-state reconciliation, specialist routing, concurrency barrier, exact-head validation and guarded merge;
- static/current task IDs are being removed from the SIGA protocol so next work is always derived from live repository state;
- skill-system validation is being extended to reject cross-repository authority regressions.

VERIFY:
Protocol branch must pass python tools/skills/validate.py and repository CI on its exact delivery HEAD before merge.

GATES:
Exact-head skills validation required.
Applicable repository CI required.
No semantic overlap with active product work.

BLOCKERS:
None.

INVARIANTS:
- az1nn/marica-game is the only canonical repository for this project's orchestration state;
- live repository evidence outranks handoff/chat memory;
- SIGA selects tasks; specialists execute bounded concerns and return control;
- no mutation without the concurrency barrier;
- no merge using stale validation;
- SIGA must not hard-code a current/next task ID.

NEXT:
Finish validator + protocol self-check, open/verify/merge the maintenance PR, close the maintenance claim, then reconcile live SPEC-001 tasks and advance the next executable product task.

VERIFY-FIRST:
Re-read master HEAD, protocol branch HEAD, open PRs, active .siga claims and exact-head workflows before each write/merge.
