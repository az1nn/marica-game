# SPEC-010 validation record — 2026-10-20

- Repository lock: az1nn/marica-game.
- Stale local command: `C:\Users\alans\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe tools/skills/validate.py`.
- Stale local result: `SKILLS VALIDATION: PASS`; routing fixtures 16 PASS; report contract tests PASS; SIGA flow markers PASS; cross-repository authority scan PASS.
- Local checkout used by the stale command: `fa7c56a72dba91587b33144ae5a575177b86e655` on `feat/spec-008-github-work-dashboard`.
- Stale classification: useful repository evidence, but not an exact-head acceptance gate for PR #143.

## Exact-head certification

- PR #143 base: `master@42a9e26df571b0d6dc19d3ad36110709955167e4`.
- PR #143 exact head: `3a03bad27ac7857e666fd63e08966427f59bb18d`.
- Workflow: `SPEC-010 Chain Certification`.
- Run: https://github.com/az1nn/marica-game/actions/runs/39521147382.
- Result: PASS.
- The workflow checked out the event SHA, executed `python tools/skills/validate.py`, verified the SPEC-010 evidence files, verified the R920 marker and verified the current master SHA.
- Exact-head conclusion: R920 is satisfied for the governance PR. This does not certify any product, visual, physical-device, source-rights, runtime-hosting or manual-browser gate in the other PRs.

## Boundary

- No merge is authorized by this record. PR #143 remains draft.
- Human and unavailable capability gates remain fail-closed.
- Next action: execute one owning specialist root lane with a separate claim, or surface the next human block when the lane cannot progress technically.