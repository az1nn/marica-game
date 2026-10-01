# ROBLOX HANDOFF

Status: ADVANCE

Runtime baseline is ratified by ADR-0001: Roblox + Luau, Rojo, Wally and Jest Roblox.

## Delivered

- T010 merged via PR #5.
- Delivery SHA: `51667c9be61f558de1e03a53189b77dcb3a6050d`.
- Domain now exposes `PetId` as an opaque validated string contract.
- ID creation accepts an injected generator, keeping the domain independent from Roblox services.
- `Pet` is frozen and exposes no identity mutation path.
- Authoritative ID generation remains a server/application adapter responsibility.

## Next

Execute **T011 — lineage/pedigree** without moving Roblox-specific concerns into the domain.
