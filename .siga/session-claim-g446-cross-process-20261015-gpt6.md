# SIGA G446 — Cross-process restart and clock rollback
Status: ACTIVE
Owner: GODOT/QA G446 (exclusive on G446 files)
Base: master@d59afb7579fce812ab85e5b11dc17ff3312e8464
Branch: godot/g446-cross-process-clock-20261015
Scope: game/tests/g446_process_restart_runner.gd, .github/workflows/g446-process-restart.yml, game/docs/G446-PROCESS-RESTART.md, this claim.
Guards: G440–G445 preserved; no domain/adapter changes by default; ARTIST PRs #77/#109 non-overlap. Reconcile live PRs, claims, master before every merge; no force updates.
Proof required: isolated Godot OS processes with stable user:// save; typed rehydration + durable two-child replay; rollback with nondecreasing logical time; stale revision rejection; QA GOOD→BAD→RESTORE; exact-head Godot and applicable workflows.
No merge or G446 checkbox until all required exact-head checks PASS and guarded expected-head merge. G447 offline elapsed, real power-loss/cross-platform atomicity and ARTIST runtime gates remain out of scope.
