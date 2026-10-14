# SIGA G443 — SPEC-004 schema_version migration harness

Status: ACTIVE
Owner: SIGA → ARCH/GODOT, QA
Date: 2026-10-14 (Brasília)
Base: master@3c7918aa94b32a85ff23f229737c483af3055a08
Branch: godot/g443-schema-migration-20261014
Scope: game/src/adapters/local/save_migration.gd, game/tests/save_migration_runner.gd, game/docs/G443-MIGRATION-HARNESS.md, .github/workflows/g443-save-migration.yml, claim file.

Admission: G440/G441/G442 DONE, G443 next. Open PR #77 ARTIST is separate visual ownership. No other open G443 PR at admission. Post-claim master/PR barrier before implementation.

Policy: v1 is the sole approved schema; v1 identity roundtrip, reject unknown older/newer/missing/noninteger schema_version, reject corrupt v1, reject mutation of source and ensure deterministic idempotence. Future migration registry explicit and disabled until a real historical contract is specified; never fabricate v0 or accept v2 as v1. G442 SaveStore unchanged; no auto migration during load/save. G444–G447 unaffected. Adversarial mutation GOOD/BAD/RESTORE; exact-head gates before guarded merge. Human gate only if a genuine legacy schema is proposed.
