# SIGA HANDOFF

Status: ADVANCE
Repository: az1nn/marica-game
Active spec: SPEC-001 Animal Core
Completed: T005
Active delivery: T006
Next task: T007

## Verified base

- T005 merged through PR #2.
- Current T006 base: `master@b62f3f0319e7fe03663f9601d065ec3801e5dfc8`.
- ADR-0001 ratifies Roblox runtime.
- T005 claim is CLOSED.
- No open PR existed at T006 claim barrier.

## T006 decision

ADR-0002 selects:

- DataStoreService for durable player state;
- UpdateAsync for concurrent/current-state writes;
- one/few deterministic player keys;
- server-only authoritative time through an injected Clock port;
- Workspace:GetServerTimeNow() for the Roblox clock adapter;
- logical time clamp to prevent rollback;
- leases for mutable profile sessions;
- idempotent critical operations and exactly-two successor replay safety;
- MemoryStore only for ephemeral coordination;
- separate dev/staging/prod namespaces.

## Backlog repair

Added T007 because ADR-0001 ratified the Roblox/Rojo/TestEZ workflow but the executable backlog had no task to create that reproducible toolchain before domain implementation.

## Gate

Open PR for T006, validate exact head, merge when green, close claim.

## Next

Execute **T007 — Bootstrap do toolchain Roblox/Rojo/TestEZ e CI reproduzível**.
