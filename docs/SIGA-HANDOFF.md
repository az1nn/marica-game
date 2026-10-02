CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 Animal Core / Domain P0

STATE:
T014 implementation is on PR #9. Final exact-head gates are pending.

MODE:
WATCH

CANONICAL SOURCE:
az1nn/marica-game master + specs/001-animal-core/tasks.md; SIGA procedure remains canonical in az1nn/cpxlabs-admin/.agents/skills/siga/SKILL.md.

BASE:
master@cad484b687d9ed795e4cd7d37bd1223b13b7428a

BRANCH / ENV:
feat/t014-genetic-trait-expression / Roblox-first

PR / MR / TASK:
PR #9 open / T014 candidate / T015 blocked until T014 merge

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
- T014 marked complete in the executable backlog inside the candidate branch.

VERIFY:
- authored Jest coverage checks immutability, bounded values, deterministic expression, unknown-trait rejection and Pet integration;
- final Validate skills and Roblox CI must pass on the exact final PR head;
- review threads and base drift must be rechecked immediately before merge.

GATES:
Pending exact-head PR #9 validation. Known QA gap remains: Jest specs are built into the test place but are not yet executed headlessly by CI.

BLOCKERS:
No product blocker. Merge remains gated on exact-head CI.

INVARIANTS:
- genetic potential is distinct from current expressed traits;
- expression may reduce/shape realized traits but never rewrites genetic potential;
- expression factors are explicit inputs and cannot create non-genetic traits;
- pedigree remains untouched by expression changes;
- domain remains engine-neutral.

NEXT:
If PR #9 is green and drift-free, merge T014, close the claim, then execute T015 — care state.

VERIFY-FIRST:
Before merge, verify PR #9 exact head workflows, review threads and base SHA against master.
