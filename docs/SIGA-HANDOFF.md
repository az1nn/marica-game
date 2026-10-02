# SIGA HANDOFF

Status: ADVANCE
Repository: az1nn/marica-game
Active spec: SPEC-001 Animal Core
Completed: T005, T006, T007, T010, T011, T012
Next task: T013

## Verified baseline before T012

- master: `9e92adbfe559a2c054087339cd71b00b5b828344`.
- PR #5 / T010 merged.
- PR #6 / T011 merged.
- No competing open PR or active overlapping claim existed when T012 started.

## T012 delivery

- Added engine-neutral `Lifecycle` state machine.
- Active life stages progress `juvenile -> adult -> senior` exactly one step at a time.
- Natural end is only legal from `senior`; health-driven early end is allowed from an active stage.
- Ended lifecycle is terminal and cannot advance or end again.
- `Pet` now owns lifecycle state and remains immutable through replacement with `Pet.withLifecycle`.
- Jest source covers legal/illegal transitions, terminal irreversibility, natural vs health end, and immutable Pet replacement.

## Gate expectation

Required exact-head gates:
- Validate skills.
- Roblox CI: Wally reproducibility, StyLua, Selene, production/test Rojo builds.
- no unresolved review thread or semantic overlap.

Known QA gap remains: Jest specs are built into the test place but are not yet executed headlessly by CI.

## Next

Execute **T013 — Implementar relógio/simulação injetável**.
