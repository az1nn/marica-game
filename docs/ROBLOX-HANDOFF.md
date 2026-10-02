# ROBLOX HANDOFF

Status: ADVANCE

Runtime baseline remains Roblox + Luau under ADR-0001, with engine-neutral domain rules.

## Delivered

- T010 Pet identity and T011 lineage/pedigree are merged.
- T012 adds `Lifecycle` as a pure domain state machine with no Roblox service dependency.
- Life-stage progression is deterministic and explicit.
- Natural end requires senior stage; health-driven early end is supported.
- Terminal lifecycle state is irreversible.
- `Pet.withLifecycle` replaces immutable pet state without changing ID or pedigree.

## Boundary

T012 deliberately does not read wall-clock or Roblox time. Time-derived progression belongs to T013 and must inject time into deterministic domain functions.

## Next

Execute **T013 — injectable clock/simulation** and derive lifecycle progression from persisted time without introducing frame/client authority.
