# GODOT HANDOFF

Status: G440 SAVE SCHEMA v1 VERIFIED / ADVANCE G441
Authority: Constitution v2.0.0 · SPEC-004 · ADR-0004.
Runtime: Godot 4.7.2-stable · typed GDScript · offline-first single-player · GUT v9.7.1 pinned.

Delivered:
- G410–G436: deterministic animal foundation, care/health/lifecycle, exactly two successors, in-session replay, pedigree, 14/21/28-day accelerated fixtures and bounded GAUNTLET.
- G440 PR #91: `game/docs/save-schema-v1.{md,schema.json}` normative versioned JSON persistence envelope for detached animals, historical pedigree, clock/revision and completed two-successor event ledger; valid minimal/founder/succession fixtures.
- G440 independent verifier checks JSON Schema structure and cross-record invariants; nine intentionally corrupted fixtures must fail. No new production adapter or runtime assets.

Verified:
- G440 exact PR HEAD `0242aba5a6eb4d5b714c9a2a0f60a0d180c67300`: G440 Save Schema, Godot CI, ARCH V201 Source Import, Validate skills, Roblox CI and Web Preview Contract all PASS; Roblox Behavioral SKIPPED/nonrequired.
- PR #91 guarded squash merged as `master@dfc98d337ff49a05c0ab017c2371a75160f0f5da`. This documentary closeout still requires its own exact-head gates.

Limits:
- G440 is a data contract, **not** file IO: no local SaveStore, atomic write, backup, migration, actual Pet hydration, restart idempotency or offline catch-up yet.
- ARTIST concept PR #77 remains draft/no runtime visual acceptance; V201 ARCH technical import proof merged in #88 but render/A-B/mobile budget remain open.
- Issue #86: saturated genetic potential still needs DESIGN/ARCH decision; do not certify universal advancement.

Next: SPEC-004 **G441** implement local versioned SaveStore behind an application/adapter boundary with fail-closed load on unknown versions, injected clock and revision integrity, without changing the pure domain.


## Latest verification — G441 (2026-10-14)

- PR #96 exact head `42018f778d81405d08bb5b438103b2c2bf19f490`: G441 Local SaveStore, Godot CI, G440 Save Schema, ARCH V201 Source Import, Validate skills, Roblox CI and Web Preview Contract PASS. Optional Roblox Behavioral SKIPPED.
- Guarded squash merged to `master@4f58a8251a4e9ccfd4c89d9a370b913081ccecbd`; post-merge Godot CI/skills/Roblox/Web Preview PASS.
- Typed `MaricaLocalSaveStore`: versioned local JSON file I/O, fail-closed schema, malformed/duplicate JSON key rejection, optimistic revision, monotonic injected simulation time. Independent QA runner and stale-revision GOOD-BAD-RESTORE proof PASS.
- Important boundary: writes are **not atomic or backed up**. G442 must implement crash-safe temp/swap/backup and recovery; G443 migration, G444 hydration, G445 durable replay, G446/G447 offline restart/catch-up remain pending.
- No visual/runtime art gate is implied for ARTIST PR #77 or V201 screenshot PR #97. Genetics saturation issue #86 remains open.
- NEXT: SPEC-004 G442 atomic save + backup/recovery.
