# SIGA G446 — SPEC-004 process restart and rollback

Status: ACTIVE
Owner: GODOT G446
Base: master@d59afb7579fce812ab85e5b11dc17ff3312e8464
Branch: godot/g446-process-restart-20261015
Scope: isolated multi-process runner and exact-head workflow. No modifications to G440–G445, ARTIST, source domain or visual gates.
Guards: 6 independent Godot OS processes, shared user-data-dir, typed hydration, persisted succession replay, monotonic clock rollback, verified G442 backup recovery, GOOD/BAD/RESTORE mutation.
Limit: G447 offline elapsed simulation, power-loss/fsync and visual runtime certification not claimed.
