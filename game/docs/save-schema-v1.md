# SPEC-004 / G440 — Offline Save Schema v1 (animal-first)

**Status:** NORMATIVE CONTRACT PROPOSED — not an implemented SaveStore or runtime load.
**Authority:** Constitution v2.0.0 §§ III, IX, X, XII; SPEC-004 Phase E; ADR-0004. The Roblox-specific storage/lease paragraphs of ADR-0002 are superseded; its logical clock and durable-idempotency invariants survive.
**Owner:** ARCH (data boundaries) + GODOT (engine adapter); DESIGN retains gameplay semantics; QA validates persistence in G446/G447.

## Scope / data envelope

`game/docs/save-schema-v1.schema.json` (JSON Schema Draft 2020-12) defines the **animal-only, offline v1 document**:

| Key | Type | Contract |
| --- | --- | --- |
| `schema_version` | literal integer `1` | Reject unknown/future version before gameplay; upgrades by G443, never silent field coercion. |
| `revision` | nonnegative safe integer | Monotonically increases once per committed state update; G441/G442 enforce this. |
| `last_observed_at` | finite nonnegative number | Unix seconds from injected clock; G423 computes `max(now, previous)`; never derive negative elapsed time. |
| `pets` | map `petId → composite Pet.to_snapshot()` | Includes ACTIVE and historical TERMINAL parents to preserve pedigree and succession replay. Keys must equal internal `id`. |
| `succession_events` | map `terminalParentPetId → event record` | Durable completed-event ledger; event stores exact ended `parent_snapshot`, `succession_seed` and **exactly two ordered** `successor_ids`. |

No speculative `session` or Roblox lease, network identity or online scoreboard belongs in v1. No farm/crop/inventory/progression shape is invented by G440: their later respective specs/tasks must add a **versioned migration** rather than silently widening this closed v1 document. An empty map is valid only for a new save; the real founder initialization belongs to future application use cases. There is no default founder magically created on load.

### Pet wire format

The persisted pet value is precisely a detached composite `MaricaPet.to_snapshot()`, not a Node or Resource serialization: `id`, `soulbound`, `affection`, `pedigree`, `lifecycle`, `geneticPotential`, `expressedTraits`, `careState`, `healthState`. Use the existing camelCase snapshot names, not renamed aliases.

- Pedigree: `lineageId`, `generation`, `founderPetId`, `parentPetIds`. Parents must be unique (0 for founder, 1–2 for descendants), resolvable from archived `pets`, have the same lineage and earlier generation. Descendants must not inherit founder soulbound. `founderPetId` is a historical identity, not ownership.
- Lifecycle: stage `juvenile|adult|senior`, status `active|ended`; `endReason` (`natural|health`) is present **only** for ended pets.
- Genetic potential / expression and care / affection remain bounded [0,1]. Both trait maps carry the same keys, and expressed value cannot exceed potential (existing G424/G425 domain rule).
- Health: `status`, `neglectHours`, `untreatedHours` as existing G426 snapshot. No derived clock/status rewrite on serialization.

**JSON Schema guards structure only.** Cross-record referential integrity, pair event membership, and domain semantics require the separate G440 checker now and ultimately native G441/G445/G446 validation. JSON numbers cannot carry NaN/Infinity. Save loaders must additionally reject duplicate JSON object keys rather than silently accepting the last write; parser behavior must be tested in G441.

## Durable succession transaction boundary (contract, not implementation)

The only admissible completed event transition is **one logical atomic revision** that writes (1) ended parent snapshot, (2) two freshly created child snapshots with distinct IDs, and (3) `succession_events[parentId]` with the same exact frozen parent and ordered pair. A marker without both children, or children without their corresponding completed marker after an exposed terminal event, is a recoverable/corrupt state **not** a new entitlement to mint another pair.

On identical retry/load, return the recorded pair without minting two more. A conflicting seed, event parent snapshot or pair IDs for the same parent ID must fail closed. Do not hydrate the process-local G433 coordinator by assuming its private dictionary is persistent; G445 supplies a dedicated durable replay adapter and G446 proves restart semantics.

`parent_snapshot` should match `pets[parentId]` at event commit and remain frozen. Later read-only historical queries may reference the archived snapshot. For any future event ledgers with different semantics, migrate schema explicitly.

## Clock / revision / corruption

- Serialize JSON with stable, detached primitive values; never serialize `RefCounted`, `Node`, `Callable`, runtime assets or object references.
- `logical_now = max(injected_clock.now(), last_observed_at)` from G423. A negative elapsed delta is forbidden. Clock rollback is not anti-cheat; it is local save integrity.
- Parser/load must validate exact schema_version before mutation; refuse incompatible future schema rather than dropping unknown fields.
- Storage file path, temp/fsync/rename, backup and crash recovery are G441/G442 decisions. `revision` must advance only after a durable commit with backup semantics.
- G443 owns schema migration chain. G444 hydrates/serializes real Pet domain records. G445 stores succession ledger. G446/G447 prove round-trip, replay, rollback and offline elapsed hours/days. **None of these gates passes by approving this document.**
- Issue #86 genetic saturation (all traits at 1.0) remains a DESIGN/ARCH policy conflict. This schema preserves bounded traits but does not certify guaranteed advancement in saturated cases.

## Example fixtures and bounded validation

- `game/tests/fixtures/save_v1_minimal.json`: new save, no animals or events.
- `game/tests/fixtures/save_v1_founder.json`: detached founder snapshot; founder remains soulbound.
- `game/tests/fixtures/save_v1_succession.json`: archived ended founder, two fresh successors, completed event marker, deterministic seed and lineage continuity.
- `tools/godot/validate_save_schema_v1.py`: structural JSON Schema validation, cross-record checks and expected-negative mutations. `G440 Save Schema` CI runs the same verifier on exact PR HEAD, separate from later Godot runtime tests.

This is **a schema design and fixture proof**, not Godot runtime integration, a save on disk, a visual accept, a migration pass, or production persistence.

## Follow-up contract

**G441** implements the narrow local SaveStore boundary against this document; expose `load(): Result<Snapshot>` and `save(snapshot, expected_revision): Result<Revision>` through application/adapters, never domain direct filesystem calls. G442 must add atomic replacement/backup. Mark G440 done only after independent fixture validation + exact-head CI and guarded PR merge.
