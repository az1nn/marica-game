# SPEC-004 G443 — migration harness by schema_version

G440 ratified **only schema_version 1**. No v0 contract, historic fixture or v2 format is approved. This harness intentionally does **not invent** migrations. `MaricaSaveMigration.migrate(Variant)` checks version first, validates v1 via G440/G441 strict validator, returns detached document, `migrated:false`, `from_version:1`, `to_version:1`; repeated calls are idempotent.

Missing, fractional, negative, unsafe, nonnumeric and unknown versions reject. Future version **2** rejects even when other fields resemble v1; legacy **0** rejects until a historical schema and deterministic transform are approved. Malformed v1 and broken pedigree/ledger reject. Unknown versions carry `requires_migration_contract:true` for explicit human/spec decisions, never silent reset.

G443 is an independent, pure **migration admission harness**, not a new on-disk schema or an automatic rewrite of saves. G442's `load`/`save` remain unchanged and continue to protect primary/backup, CAS, clock and fail-closed recovery. Do not migrate a corrupt primary over a verified backup. No G444 animal hydration, G445 event replay, G446 restart or G447 offline catchup is claimed.

Evidence: `game/tests/save_migration_runner.gd` 12 bounded scenarios, `G443 Save Migration` exact-head workflow, adversarial mutation GOOD→BAD→RESTORE disabling future-version rejection. To introduce v2 later: ratify versioned source+target schemas and golden fixtures, implement explicit `v1→v2` step, validate both ends, prove deterministic idempotence, backup and recovery, replay and clock constraints; never reinterpret unknown JSON as a valid version.
