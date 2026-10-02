CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 Animal Core / Domain P0

STATE:
T014 merged and complete. T015 is the next executable task.

MODE:
ADVANCE

CANONICAL SOURCE:
az1nn/marica-game master + specs/001-animal-core/tasks.md; SIGA procedure remains canonical in az1nn/cpxlabs-admin/.agents/skills/siga/SKILL.md.

CURRENT VERSION / HEAD:
T014 delivery merge master@d16423c51b5ebbe0282fd95c5b0a990a1f069136

BASE:
master

BRANCH / ENV:
master / Roblox-first

PR / MR / TASK:
PR #9 merged / T014 complete / T015 next

SPEC / ADR:
SPEC-001 Animal Core; ADR-0001 runtime; ADR-0002 persistence/time

DONE:
- engine-neutral Genetics module separates immutable genetic potential from current expression;
- genetic potential uses bounded normalized trait scores in [0, 1];
- expressed traits are derived deterministically from potential plus explicit expression factors;
- expression factors cannot invent traits or mutate genetic potential;
- Pet stores geneticPotential and expressedTraits separately;
- Pet.withExpressionFactors recalculates expression while preserving identity, pedigree, lifecycle and genetic potential;
- Pet.withLifecycle preserves both genetic layers;
- T014 is marked complete in the executable backlog.

VERIFY:
- T014 delivery HEAD ed48ca025a138ca6796d6e6de34571dbcb8afaa8;
- Validate skills PASS on the exact delivery HEAD;
- Roblox CI PASS on the exact delivery HEAD, including StyLua, Selene, production build and test-place build;
- PR #9 had no unresolved review threads;
- master had no base drift at merge.

GATES:
Exact-head merge gates PASS. Known QA gap remains: Jest specs are built into the test place but are not yet executed headlessly by CI.

BLOCKERS:
None.

INVARIANTS:
- genetic potential is distinct from current expressed traits;
- expression may reduce/shape realized traits but never rewrites genetic potential;
- expression factors are explicit inputs and cannot create non-genetic traits;
- pedigree remains untouched by expression changes;
- domain remains engine-neutral.

NEXT:
Execute T015 — care state.

VERIFY-FIRST:
Re-read master HEAD, open PRs, active .siga claims and exact-head workflows. Confirm this handoff-maintenance commit is green, then classify ADVANCE and claim T015 before mutation.
