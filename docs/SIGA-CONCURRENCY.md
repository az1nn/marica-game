# SIGA Concurrency Model

The repository may be modified by multiple sessions. Safe concurrency requires live-state reconciliation rather than chat coordination.

## Invariant

~~~text
snapshot -> claim -> post-claim barrier -> mutate -> re-read -> exact-head verify -> guarded merge
~~~

## Drift states

- CLEAR
- PARALLEL_SAFE
- RECONCILE
- COLLISION
- SUPERSEDED
- GATE_STALE

## Safety

- dedicated branches for bounded work;
- claims under .siga/;
- blob/head guards for writes;
- semantic overlap checks, not file-only checks;
- no force overwrite as normal conflict handling;
- CI belongs to a commit SHA;
- merge must use the current expected head when supported.

See docs/skills/archive/siga-concurrency.md (historical); current barrier lives in SIGA for the executable protocol.
