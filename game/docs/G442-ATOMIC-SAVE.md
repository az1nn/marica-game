# SPEC-004 G442 — staged atomic SaveStore + backup/recovery

**Authority:** SPEC-004 G442 / Godot 4.7.2 / v1 G440 JSON Schema, without gameplay/domain changes.

## Protocol
The existing G441 \`MaricaLocalSaveStore\` keeps the public \`load()\` and \`save(snapshot, expected_revision, injected_clock)\` contracts, optimistic revision compare-and-set and monotonic injected simulation clock.

1. G441 fully validates the candidate and current primary or recovered backup, rejecting future/invalid schema and stale revisions.
2. G442 serializes to \`user://<filename>.tmp\`, flushes the file, reopens it and validates schema and content before publishing.
3. If a previous valid primary exists, G442 verifies and stages its prior revision in \`.bak.tmp\`, then renames to \`.bak\`. Failure to prepare/publish a backup **aborts** the new primary write.
4. Only after a safe previous revision exists, G442 renames the verified \`.tmp\` to the primary. It does not delete a good primary on rename failure.
5. On read: valid primary is authoritative. If primary is missing/corrupt, a valid backup is staged into \`.restore.tmp\` and promoted, returning \`recovered:true\`, \`recovery_source:"verified_backup"\`. Never trust an orphan temp as committed state.
6. No valid primary/backup with orphan staging **fails closed** rather than creating a founder; invalid primary and backup fails closed without wiping either.

Suffixes are confined to flat \`user://\` paths, and every decoded JSON is checked for duplicate keys and closed v1 schema consistency. A backup is the **prior committed revision**, not the new revision. Recovery rolls back to the last verified backup; the caller must surface the recovery flag rather than hiding it. G442 does not automatically merge newer data from corrupt files.

## Test evidence / limits

\`game/tests/atomic_save_runner.gd\` probes 12 bounded scenarios: interruption after temp, initial commit, verified backup, interrupted update before promotion, next revision, corrupt primary, stale CAS after recovery, missing primary, both files corrupt, orphan staging, founder fixture, succession-ledger fixture. \`G442 Atomic Save\` uses exact-head Godot to prove PASS and mutation GOOD→BAD→RESTORE by disabling backup rotation; the mutant must fail the backup test, then the original file is restored. \`Godot CI\` runs independent styling/domain checks. Existing G441 runner now corrupts both primary and backup when testing fail-closed behavior, preserving its stated semantic contract.

**Durability limitations (important):** FileAccess.flush + same-volume filesystem rename are used. Atomic replacement may vary by platform (e.g. Windows rename onto an existing destination). On unsupported rename, G442 fails closed and preserves the last valid data. This test suite does **not** claim physical power-loss fsync guarantees, true multi-process CAS, arbitrary OS/filesystem atomicity, anti-cheat, encrypted saves, complete process-restart testing (G446), offline catch-up (G447), schema migration (G443), pet hydration (G444), nor succession-event application/replay (G445). The primary and backup are separate files; recovery is bounded to the prior verified revision.

G442 cannot approve merge without \`G442 Atomic Save\`, \`G441 Local SaveStore\`, \`Godot CI\`, \`G440 Save Schema\`, \`Validate skills\`, \`ARCH V201 Source Import\`, \`Web Preview Contract\` and any other applicable exact-head gate passing on the **current** PR head.

Next task after guarded G442 merge: SPEC-004 G443 migration harness, with separate ownership and CI.
