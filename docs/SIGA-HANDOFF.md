# SIGA HANDOFF

Status: ADVANCE
Repository: az1nn/marica-game
Active spec: SPEC-001 Animal Core
Completed: T005, T006
Active task: T007

## Verified base

- T006 merged through PR #3 at `4aac27ce07c8e48d57dddffcb994ee6aabe6f4f0`.
- T007 branch: `feat/t007-roblox-toolchain`.
- T007 base: `master@f4c6d2e27196c96143a76a65f88cdbadaeb13224`.
- Post-claim barrier: CLEAR.
- No open PR existed at the T007 barrier.

## T007 toolchain

Pinned:

- Rokit 1.2.0
- Rojo 7.7.0
- Wally 0.3.2
- StyLua 2.5.2
- Selene 0.31.0
- Jest Roblox 3.20.0

TestEZ was removed from the baseline before domain implementation because its official repository is archived.

Repository now contains production/test Rojo projects, a minimal src layout, a Jest smoke suite and a GitHub Actions toolchain gate.

## Gate

Run T007 PR CI, capture generated `wally.lock`, commit the lockfile, then require exact-head:

- Wally dependency install with unchanged lockfile
- StyLua check
- Selene
- production Rojo build
- test Rojo build
- existing skill/ARTIST validation

## Next

After T007 merges, execute **T010 — entidade Pet e IDs imutáveis**.
