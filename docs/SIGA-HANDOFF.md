# SIGA HANDOFF

Status: ADVANCE
Repository: az1nn/marica-game
Active spec: SPEC-001 Animal Core
Completed: T005, T006
Active delivery: T007 complete on branch
Next task: T010

## T007 delivery

Branch: `feat/t007-roblox-toolchain`

Pinned toolchain:

- Rokit 1.2.0
- Rojo 7.7.0
- Wally 0.3.2
- StyLua 2.5.2
- Selene 0.31.0
- Jest Roblox 3.20.0

Implemented:

- `rokit.toml`
- `wally.toml` + generated `wally.lock`
- production and test Rojo projects
- client/server/shared Luau bootstrap
- Jest smoke suite
- StyLua/Selene config
- generated-artifact ignore rules
- `Roblox CI` workflow
- lockfile reproducibility gate
- ADR-0001/ROBLOX baseline corrected from archived TestEZ to Jest Roblox

## First runtime gate

PR #4 first head proved:

- Rokit setup: PASS
- Wally dependency resolution: PASS
- StyLua: PASS
- Selene: PASS
- production Rojo build: PASS
- test Rojo build: PASS
- existing skills/ARTIST gate: PASS

The generated lockfile from that runner is now tracked. Final exact-head CI must prove that re-installing dependencies does not change it.

## Next

After PR #4 merges, execute **T010 — Implementar entidade Pet e IDs imutáveis**.
