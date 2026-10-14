# SPEC-004 G441 — Godot local versioned SaveStore

**Scope:** Godot 4.7.2-stable offline single-player. G440 closed animal-only JSON Schema v1 is the wire authority. This is an **adapter**, not a new domain model.

## Entry point

`res://src/adapters/local/save_store.gd` — `MaricaLocalSaveStore.new("user://marica-save-v1.json")`.

- `load()` returns `{ok:true, found:false}` on absent storage, never creates a silent founder/reset. On success with existing data returns `{ok:true, found:true, snapshot:detached_dictionary}`.
- `save(snapshot, expected_revision, injected_clock)` returns `{ok:true, revision:int, snapshot:detached_dictionary}` only if the currently persisted revision matches `expected_revision`, and the candidate snapshot itself carries that old revision.
- For a **new profile**, `expected_revision=-1`, candidate `revision=0`; first saved revision remains 0. For existing documents, revision increments by exactly one; on stale/invalid inputs, returns `{ok:false,error:...}` **without writing**.
- `MaricaSimulationTime.observe(clock, previous)` clamps logical time to `max(injected_now, stored_last_observed_at)` before write. Caller must supply a valid injected clock. This is local integrity, not anti-cheat.
- `user://` **flat filenames only**, no arbitrary absolute/user traversal. No network/backend and no access from pure domain.
- Loads reject invalid JSON, nested duplicate keys, unsupported `schema_version`, invalid records, mismatched pet keys, broken pedigree and event marker references. Parser rejection is fail-closed: corrupted/future saves are **not** treated as missing/empty.
- In-memory input and returned dictionaries are detached, so callers cannot mutate a previously validated stored dictionary without an explicit save.

## What G441 deliberately does not certify

The adapter currently writes the target file **directly**. It is not crash-safe, encrypted, transactionally atomic, backed up, or production-ready: **G442** owns temp/rename, backup and corruption recovery. Simultaneous multi-process writes are not serialized; expected-revision guards work for normal sequential reads only.

**G443** owns migration and future-schema upgrades. **G444** owns rehydrating actual MaricaPet objects and composing application lifecycle data; the adapter reads/writes JSON dictionaries only. **G445** owns durable in-game succession event integration/replay. **G446/G447** own re-open-after-process-exit, clock rollback, offline elapsed-time and power-failure regression. The G441 headless fixture tests do **not** pass those future gates.

Existing G440 fixture values and the authored JSON Schema remain unchanged. Issue #86 all-traits-saturated genetic guarantee remains a separate DESIGN/ARCH decision.

## G441 validation

`game/tests/save_store_runner.gd`: absent file, new-profile write, disk reload, detached snapshot, revision increase, injected-clock rollback clamp, stale/CAS rejected, no silent overwrite, malformed/future/duplicate-key file rejected, founder/succession v1 fixture acceptance and invalid path.

The dedicated `G441 Local SaveStore` workflow uses pinned Godot 4.7.2-stable on exact PR HEAD. QA adversarial mutation removes the stale-revision guard and requires **GOOD → BAD → RESTORE**, with unmodified source after restoration. Godot CI provides GDScript format/lint, import, domain parity/GAUNTLET regression independently.

**Merge gate:** no merge on authored tests alone. Wait for exact-head G441 Local SaveStore + Godot CI + Validate skills + other required checks; reconcile open claims/PRs and master. G441 completion and handoff persisted **after** code merge in a separate checked closeout PR.

**Next:** G442 atomic save + backup/recovery. Do not expose G441 direct writer as a safe player save API until G442.
