CAVEMAN HANDOFF v1

APP: Maricá Game
WORKSTREAM: SPEC-004 · Phase E Offline Persistence
MODE: ADVANCE
BASE: master@4f58a8251a4e9ccfd4c89d9a370b913081ccecbd
FEATURE: PR #96 MERGED (exact feature head 42018f778d81405d08bb5b438103b2c2bf19f490)

DONE:
- G440 schema v1 was merged and retained, with closed envelope plus cross-record pet/pedigree/succession invariants.
- G441 typed local SaveStore adapter, fail-closed load, optimistic revision checking, monotonic injected clock and strict JSON integrity are merged.
- Independent G441 runner verifies minimal/founder/succession fixtures, corrupt/future/duplicate-key rejection and stale-revision GOOD→BAD→RESTORE mutation.

VERIFY:
- PR #96 exact head: G441 Local SaveStore, Godot CI, G440 Save Schema, ARCH V201 Source Import, Validate skills, Roblox CI, Web Preview Contract PASS.
- Guarded squash merged master@4f58a8251a4e9ccfd4c89d9a370b913081ccecbd; Godot CI, Validate skills, Roblox CI, Web Preview Contract **PASS** on this exact master head.
- G441 closeout docs own exact-head CI is required before merging docs.

CONCURRENCY:
- G441 feature claim CLOSED; G441 closeout claim closes on a disjoint docs branch.
- ARTIST #77 V4 concept and V201 screenshot #97 remain draft, separate from G441 persistence scope.
- Founder concept ACCEPT is not Godot runtime ART/LENTE approval.
- Issue #86 saturated genetic potential remains a release-level DESIGN/ARCH decision, not a save blocker.

BOUNDARIES:
- G441 writes directly to the local path; no crash-atomic replacement, backup/recovery, migration or persisted Pet hydration/replay guarantee.
- Godot V1 remains offline-first; Vercel technical page is not evidence of playable Godot export.

NEXT:
G442 — atomic local save + backup/recovery; use G441 guarded adapter as baseline, add crash/corruption recovery evidence, preserve v1 wire schema and revision semantics.

## SIGA parallel lane — V201 render evidence completed (2026-10-14)

Classification: ADVANCE for bounded V201 screenshot instrumentation, WATCH for full V201/V201a art/runtime contract. PR #97 merged at `master@10670f712e2b8862f05d6daef3d155cb4f004389` with eight exact-feature-head workflows green (candidate ae973848) and independent LENTE/ARCH visual acceptance still open. G441 SaveStore and closeout completed separately; G442 is the next P0 persistence task. ARTIST draft PR #77 remains isolated. Source images are GitHub Actions artifacts for [V201 render run 38613081336](https://github.com/az1nn/marica-game/actions/runs/38613081336), not a native/mobile release proof.

No claims of V201/V201a, V203 or V205 completion. Claim for technical capture closed in its own PR; post-closeout CI must target that new SHA. Next SIGA safely picks G442 as the P0 animal-first task or the first independent V201 technical dependency without overlapping active claims.

## SIGA G442 verified merge and handoff (2026-10-14)

STATE: ADVANCE. PR #101 guarded merge master@e90173f3bb8c720101cdbe9511b3970f0f30b41d.
DONE: G442 stages and verifies local JSON, rotates previous valid primary to backup, promotes primary by rename, recovers only verified backup with explicit recovered flag. No silent founder creation from incomplete/corrupt files.
VERIFY: PR head 29543918db2ed3afb12f61dc561225275deb95e6 — G442 Atomic Save 12 scenarios and QA mutation GOOD/BAD/RESTORE, G441 SaveStore, G440 Schema, Godot CI, Validate skills, ARCH V201, Web Preview, Roblox CI PASS. Roblox Behavioral SKIPPED. No false claim of master post-merge CI.
CONCURRENCY: G442 claim closed in separate documentation PR; ARTIST PR #77 untouched, disjoint ownership. V201/V201a artist gates remain separate.
LIMIT: platform/physical fsync and power loss, true multiprocess CAS, G443 migration, G444 hydration, G445 event replay, G446 restart, G447 offline return are not certified. Vercel build-rate limit unrelated to gameplay/save test.
NEXT: G443 schema_version migration harness after new live SIGA reconciliation.
