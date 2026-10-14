Task: SPEC-004 G436 holistic P0 GAUNTLET / Phase D Gate D
Owner: SIGA GPT-6 2026-10-14 America/Sao_Paulo
Base: master@6d98f9a549ab93a5c7e1beeffb4ad5494f82dc17
Branch: test/g436-phase-d-gauntlet-20261014
Scope: game/tests/gauntlet_phase_d_runner.gd, .github/workflows/godot-ci.yml, docs/gauntlet G436 evidence/manifest; no production domain mutation, no ARTIST/SCENE runtime and no offline save changes.
Opened: 2026-10-14
Status: ACTIVE / PRE-CANDIDATE
Concurrence: ARTIST draft PR #77 pending human/runtime gates. No overlap with G436 tests/CI.
Forbidden: marking G440–G447 durable persistence, automatic lifespan scheduler, player-facing scene or PR #77 visual acceptance as done.
Verification: new independent holistic runner, known-bad mutant GOOD→BAD→RESTORE, existing G420–G435 regression suite, exact-head Godot CI + repository applicable workflows; fresh critic/regression audit before Gate D.
Next: publish isolated G436 runner and CI mutation proof, verify exact head; do not mark Gate D complete without executable evidence.
