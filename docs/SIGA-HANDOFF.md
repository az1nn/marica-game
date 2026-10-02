# SIGA HANDOFF

Status: ADVANCE
Repository: az1nn/marica-game
Active spec: SPEC-001 Animal Core
Completed: T005, T006, T007, T010, T011, T012
Next task: T013

## Verified delivery

- PR #7: T012 lifecycle state machine — merged.
- T012 delivery SHA: `4669c0b4a0672fa9bad8ed5ba08830edabc100b3`.
- Merge SHA: `b44d46b78fc8ae1a15b9970d3ca41ef9e0884940`.
- T012 claim: CLOSED.
- No competing open PR, active overlapping claim or unresolved review thread existed at merge time.

## Domain baseline

- `PetId`: opaque validated identity with injected generation.
- `LineageId`: opaque validated lineage identity.
- `Pedigree`: immutable lineage id + generation + founder pet + direct parent refs.
- `Lifecycle`: engine-neutral state machine.
- Active stages progress `juvenile -> adult -> senior` one step at a time.
- Natural end is legal only from `senior`; health-driven early end is supported.
- Ended lifecycle is terminal.
- `Pet` owns immutable pedigree and lifecycle state.

## Exact-head delivery gates — T012

Head: `4669c0b4a0672fa9bad8ed5ba08830edabc100b3`

- Validate skills: PASS.
- Roblox CI: PASS.
- review threads: none.
- base drift: none.

Post-merge master `b44d46b78fc8ae1a15b9970d3ca41ef9e0884940`:
- Validate skills: PASS.
- Roblox CI: PASS.

Known QA gap: Jest specs are built into the test place but are not yet executed headlessly by CI.

## Next

Execute **T013 — Implementar relógio/simulação injetável**.
