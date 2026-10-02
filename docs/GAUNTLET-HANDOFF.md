# GAUNTLET HANDOFF

Status: FOUNDATION_CANDIDATE

## Scope

SPEC-003 Agentic Quality Loop adds a bounded adversarial quality specialist under SIGA.

Implemented on branch feat/003-agentic-quality-loop:

- GAUNTLET authority and stop conditions;
- machine-readable manifest validator with positive/negative self-check;
- QA mutation-proof doctrine;
- separate Regression Hunter semantics;
- SIGA routing for applicable P0/high-risk acceptance;
- Jest runner entrypoint inside the Roblox test place;
- T018 shadow calibration.

## Calibration

T018 is recorded as BLOCKED for mutation certification, not because the merged domain feature is being retroactively rejected.

Reason: current CI builds the test place but does not launch it and execute Jest assertions. Authored behavioral specs are therefore not equivalent to runtime behavioral evidence.

## Product boundary

SPEC-001 remains the product roadmap. T020 remains the next Animal Core product task.

SPEC-003 may advance collision-safe quality infrastructure in parallel and must not silently replace product task ordering.

## Next quality action

AQ010 — wire headless Roblox execution of the test place so GOOD -> BAD MUTANT -> RESTORE can become an enforceable exact-head gate.
