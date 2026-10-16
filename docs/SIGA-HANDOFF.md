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

## SIGA G443 — migration harness verified merge / handoff (2026-10-14)

STATE: ADVANCE after protected PR #103 merge master@445a32084b1ad73f4ef5d814f9d20ebef3691324.
DONE: schema_version admission harness ratifies v1 identity only, validates complete v1 records, returns detached documents, rejects unknown legacy/future versions without inventing migrations, preserves G442 SaveStore and backups.
VERIFY: PR head dbcaeea6d69098b9945126fd6654af2614cf5dd4: G443 Save Migration (12 cases, QA GOOD/BAD/RESTORE), G442 Atomic Save, G441 SaveStore, G440 Schema, Godot CI, Validate skills, ARCH V201, Web Preview Contract, Roblox CI PASS. Roblox Behavioral SKIPPED. No post-merge master CI claimed.
CONCURRENCY: dedicated claim closed by separate docs PR; ARTIST #77 untouched. Historical G440–G442 preserved.
LIMIT: No approved v0/v2 schema or real cross-version conversion; no G444 pet hydration, G445 durable event replay, G446 restart or G447 offline catch-up.
NEXT: G444 persist animals/pedigree/care/health/affection/lifecycle after fresh claims/guards.

## SIGA — PET-ALT-001 isolated capybara concept V1 accepted (2026-10-14)

STATE: ADVANCE for bounded SPEC-005/V202 ARTIST concept-evidence precursor; V202 production sprite set remains unchecked.
DONE: Human ACCEPT of PET-ALT-001 isolated V1 recorded append-only, preserving prior approved 2026-10-09 concept board and two 2026-10-14 rejected cat/collage candidates. PR #105 protected squash merged at `master@2bda4979f9610f660522a9288b01f7cab35f31f5` with approved review file; SIGA claim closure is tracked in a separate docs closeout.
VERIFY: exact PR #105 head `3d52222c47e821a80eb353604fa2e59c44b422da` has Godot CI, Validate skills, Roblox CI, Web Preview Contract, ARCH V201 Source Import, G440/G441/G442/G443 PASS; Roblox Behavioral SKIPPED/nonrequired. Approved concept is **not** verified Godot sprite, runtime, ARCH filter/grid, SCENE scene, LENTE A/B or exported build. No post-merge master CI asserted.
CONCURRENCY: #77 founder V4 remains draft and untouched. Separate G444 ARCH/GODOT work continues in PR #106; this closeout does not touch pet/save files, SPEC-004 tasks or other active claims. Claim `.siga/session-claim-pet-alt-001-concept-20261014-gpt6.md` closed by independent PR with its own exact-head CI.
NEXT: SIGA reconcile and resume already-owned SPEC-004 G444 through PR #106 (without duplicating its claim); keep ARTIST PET-ALT-001 materialization gated behind separate provenance/ARCH/SCENE/LENTE review.

## SIGA G444 — verified Pet persistence handoff (2026-10-14)

STATE: ADVANCE after protected feature PR #106 merge to master@802bd53314ce6974340445d4c0d9b1cb22529e20.
DONE: G444 typed MaricaPet hydration/serialization for complete v1 envelope, archived ancestors, pedigree, care/health/affection/lifecycle, historical expressed traits, soulbound and ledger retention. G440 cross-record checks, G443 version admission and G442 local disk roundtrip. 12 tests and QA mutation GOOD/BAD/RESTORE.
VERIFY: exact feature PR HEAD eacc033ba5227c84e147888fe7d821351401e812 — G444, G443, G442, G441, G440, Godot CI, Validate skills, ARCH V201, Web Preview, Roblox CI PASS. Roblox Behavioral SKIPPED. Not equivalent to independent post-merge master CI.
CONCURRENCY: reconciled intervening ARTIST PET-ALT-001 merges without changing visual gates. PR #77 still draft, no overlapping files. Claim CLOSED in this docs PR.
LIMIT: G445 durable event replay, G446 process restart/clock rollback, G447 offline elapsed and gameplay/visual ARTIST/LENTE remain pending. G444 test runner is an isolated adapter proof, not a playable Godot scene.
NEXT: G445 persist durable idempotency markers of succession, only after new ownership/claims/master reconciliation.

## SIGA G445 — durable succession marker closeout (2026-10-14)

STATE: ADVANCE. Feature PR #110 exact-head ef0f5807bfadd2b47c19d38e8ee7ebaabca024f7 verified 11 applicable PASS checks (G445, G444, G443, G442, G441, G440, Godot CI, Validate skills, ARCH V201, Web Preview, Roblox CI), Roblox Behavioral SKIPPED. Protected merge master@cb87ada6ad4cf6bd770063098c46669e1beff5ab.
DONE: Persist pair + frozen parent marker atomically via G442; replay saved pair with created=false and unchanged revision, fail-closed conflicting seed/IDs, missing/corrupt marker, duplicate IDs and invalid clock. QA GOOD/BAD/RESTORE and 12 cases.
CONCURRENCY: isolated claim released in docs closeout; ARTIST PR #77 no file overlap or visual gate changes. G440–G444 unchanged.
LIMIT: G446 cross-process restart and clock rollback, G447 offline catch-up, production scene and ARTIST runtime not certified.
NEXT: G446 save/load roundtrip and clock rollback with independent process harness.

## SIGA G446 — process restart + rollback (2026-10-15)

STATE: ADVANCE. Feature PR #112 exact HEAD 57d045a47c366b1ccc8420ab3f5cc74f4bdcdb39 verified 12 applicable workflows PASS: G446/G445/G444/G443/G442/G441/G440, Godot CI, Validate skills, ARCH V201, Web Preview Contract, Roblox CI; Roblox Behavioral skipped. Guarded merge master@2266ee23b90442d4a61bcadd20af6d1b10813cda.
DONE: Six fresh Godot OS processes share one disk profile and prove save/load hydration, idempotent two-child marker replay, forward timestamp, backward-clock clamp, stale revision rejection, verified backup recovery and corrupt ledger fail closed. Independent GOOD→BAD→RESTORE clock mutation detected. Existing G440–G445 source untouched; ARTIST concurrent work untouched.
LIMITS: No full production scene close/reopen UX or G447 elapsed hours/days offline certification; filesystem power-loss guarantees not asserted. Next: G447 offline catch-up.

## SIGA G447 — offline elapsed return (2026-10-15)

STATE: ADVANCE. Feature PR #115 exact HEAD 7a6c16657277492261f24201ca0202305d93f0d0 verified 13 applicable workflows PASS (G440–G447, Godot CI, Validate skills, ARCH V201, Web Preview, Roblox CI), Roblox Behavioral skipped. Guarded merge master@c866395378f25952f650a2472d2d0b465954cca2.
DONE: seven independent Godot processes test 3h, same-time replay, 4d, rollback, forward observation, invalid clocks, hydrated pet snapshots and succession ledger preservation. GOOD→BAD→RESTORE elapsed-zero mutant detected. G440–G446 and ARTIST unchanged.
LIMITS: Only offline elapsed observation and persistence, not applying offline elapsed to hunger, health, lifecycle, crops or scene/UI. No fsync/power loss or concurrent multi-process transaction claim. Next work: Phase F G450 farm slice and subsequent gameplay integration, subject to roadmap priority and ARTIST gates.

## SIGA G450 — compact farm base (2026-10-15)

STATE: ADVANCE. Feature PR #117 exact HEAD 479b6d95379e0e82623e8da15208b65469f6ce9f verified 14 applicable workflows PASS (G440–G447, G450, Godot CI, Validate skills, ARCH V201, Web Preview, Roblox CI), Roblox Behavioral skipped. Guarded merge master@656ea45dc80a3f4791af6d1ffb0fb6591a059a02.
DONE: standalone 12×10 farm Node2D scene with cross-shaped path (21 cells), planting plot (9), structure placeholder (9), deterministic layout contract, headless scene boot, mutation GOOD→BAD→RESTORE on path continuity. Existing smoke bootstrap retained; G440–G447, ARTIST PRs and visual approvals untouched.
LIMITS: Geometry is temporary debug color scaffold, not approved ARTIST sprites or V201 production validation; no G451 camera, G452 pets, UI or playable Gate F claim. Next G451 isometric/elevated camera zoom with separate claim and visual gates.

## SIGA G451 — elevated/isometric farm camera (2026-10-15)

STATE: ADVANCE after guarded G451 feature PR #120 merge master@`90855cf6c6a669d836f090fe8f13c35568e09f53`.
DONE: optional `FarmIsoView` composes unchanged 12×10 G450 farm scene through a deterministic 2.5D diamond projection; Camera2D centers the farm with viewport-fit, bounded [0.5,2.0] zoom, wheel and magnify inputs. Does not replace `smoke.tscn`, touch animal/persistence or create approved art.
VERIFY: PR #120 HEAD `631d91bc0b495a6f0e3862543acc6c17ad55be0b` — G451, G450, Godot CI, G440–G447, Validate skills, ARCH V201, Web Preview and Roblox CI PASS. Independent G451 runner and zoom-clamp GOOD→BAD→RESTORE proof PASS. Nonrequired Roblox Behavioral skipped. No claim of device visual approval or production Game View.
CONCURRENCY: isolated G451 claim closed by this separate docs change; ARTIST #77/#109 do not overlap; G450 farm source and G440–G447 retained.
NEXT: G452 — integrate founding pet in bounded Godot runtime slice, preserving founder identity, Soulbound, G451 camera and independent ARTIST/CENA/LENTE acceptance gates.

## SIGA — G452 founder diagnostic draft (2026-10-15)

CLASSIFICATION: WATCH. Canonical `az1nn/marica-game`; master reference `bbfc4a24`. Current dedicated PR [#125](https://github.com/az1nn/marica-game/pull/125) is **draft**. Bounded technical implementation is complete (opt-in `g452_founder_probe.tscn`, strict saved soulbound G0 hydration, isometric position, no default game/persistence modifications), but **G452 full scene and V201/V201a gates remain OPEN**. Prior technical HEAD `f4c371b7`: 17 SUCCESS/1 optional SKIPPED; new docs commits require new exact-head verification. Active G452 source claim released; any future write must re-claim.

CONCURRENCY: ARTIST #77 and ARCH #123/#124 are independent draft owners; no modification of PNG or other branches. No production merge or human runtime acceptance. The diagnostic uses an unchanged approved V4 concept via the test-copy PNG and does not certify distribution rights or final pixel-grid settings.

NEXT SINGLE ACTION: **SIGA -> ARCH V201/V201a** complete real web/mobile measurement and frozen import/atlas/pixel-scale constraints, then dispatch independent CENA/LENTE/ARTIST review of S01-A01 V4. Do not merge #125/#77 or mark G452/visual tasks complete prematurely. G453 waits for compatible runtime boundaries.
