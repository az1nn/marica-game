CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 Animal Core continuation

STATE:
T015 care state is merged and complete. Live task order advances to T016 health/disease/treatment.

MODE:
ADVANCE

CANONICAL SOURCE:
az1nn/marica-game master + .agents/skills/siga/SKILL.md + .specify/memory/constitution.md + live specs/tasks/PRs/claims/CI.

DELIVERY:
PR #12 merged.
Delivery HEAD: e391441d62034721f849f08fb420dc96faf762a5.
Merge commit: 195d628ede8dc090753765b9f5a967cc5590b547.

BASE / ENV:
master / Roblox-first

ACTIVE PR / CLAIM:
No product PR after #12 merge. T015 claim is closing with this handoff.

SPEC / ADR:
SPEC-001 Animal Core; ADR-0001 runtime; ADR-0002 persistence/time.

DONE:
- immutable measurable care state covers hunger, hygiene, affection and energy;
- default care is fully satisfied and normalized to [0, 1];
- care quality is deterministic and bounded by the weakest essential need;
- care maps deterministically to genetic-expression factors;
- Pet persists care state and recalculates expressed traits without changing genetic potential, identity, pedigree or lifecycle;
- behavioral Jest coverage documents care validation, immutability, quality and Pet integration;
- T015 is checked complete in the executable SPEC-001 backlog.

VERIFY:
PR #12 exact-head gates PASS at e391441d62034721f849f08fb420dc96faf762a5:
- Validate skills: PASS;
- Roblox CI: PASS, including lockfile reproducibility, StyLua, Selene and production/test builds.

BLOCKERS:
None.

INVARIANTS:
- genetic potential remains immutable;
- care affects expression, not pedigree or identity;
- health/disease/treatment remains T016 scope;
- only az1nn/marica-game is authoritative for this project.

NEXT:
Execute T016 — health/disease/treatment — from fresh master state, using care/neglect as an input without collapsing health into care.

VERIFY-FIRST:
Re-read master HEAD, open PRs, active .siga claims, T016 task contract and exact-head workflows before mutation.
