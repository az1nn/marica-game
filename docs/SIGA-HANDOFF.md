CAVEMAN HANDOFF v1

APP: Maricá Game
WORKSTREAM: SPEC-004 / G440 offline save schema
MODE: ADVANCE
BASE: master@dfc98d337ff49a05c0ab017c2371a75160f0f5da
PR: #91 MERGED (exact candidate head 0242aba5a6eb4d5b714c9a2a0f60a0d180c67300)

DONE:
- SPEC-004 G440 versioned offline-animal save contract, 3 fixtures, cross-record deterministic validator and 9 negative corruption checks.
- Independent merged ARCH V201 technical import probe PR #88 reconciled twice during concurrent master advances without overwriting code/assets. Its ART/SCENE/LENTE/mobile performance gates still OPEN.
- Original founder dog V4 ARTIST draft PR #77 untouched.
- SPEC-007 draft PR #93 for skill-tree reduction is a separate governance lane, not authority to skip SPEC-004.

VERIFY:
- G440 PR #91 final exact HEAD 0242aba5: G440 Save Schema PASS, Godot CI PASS, ARCH V201 Source Import PASS, Validate skills PASS, Roblox CI PASS, Web Preview Contract PASS, Roblox Behavioral SKIPPED/nonrequired.
- Guarded squash merge master@dfc98d337ff49a05c0ab017c2371a75160f0f5da.
- Documentation closeout branch must pass its own exact-head CI before guarded merge. Do not reuse PR #91 checks as a new SHA gate.

CONCURRENCY:
- #77 ARTIST draft and #93 SPEC-007 governance draft have disjoint active ownership from G440/G441; no art acceptance by inference.
- G440 claim closes with verified implementation and documentation closeout; G441 requires a new independent claim and post-claim barrier.

BLOCKERS:
- None for G441 local adapter design.
- G440 is schema-only; G441–G447 persistence, migration, restart replay and offline retention remain not implemented.
- Issue #86 DES/ARCH saturation decision unresolved for release; not a blocker to save architecture.

NEXT:
SPEC-004 **G441** — SIGA dispatch ARCH/GODOT to implement a narrow local versioned SaveStore against the G440 document, fail closed on unsupported schema and protect revision/time semantics, while preserving G442 atomic-write ownership.

## Current SIGA handoff — SPEC-007 skill simplification + interactive RELATORIO (2026-10-14)

MODE: RESUME / MERGE_GATE
BASE: master@896635c30ff97a5bdfe7e263d7b44d4f99f16035
BRANCH: refactor/spec-007-skill-tree-10 / PR #93
VERIFIED: candidate 797da17912257fd2b2c4aee1ad7bc7ce95ee17c3 — Validate skills, Godot CI, Web Preview Contract, ARCH V201 Source Import, G440 Save Schema, Roblox CI PASS; Roblox Behavioral SKIPPED/nonrequired. This is previous exact-head evidence, and MUST be rerun against any new commit.
DONE: SPEC-007 O700–O707 and O709–O710; 10 active discovered skills, 16 advisory routing cases, four archival contracts, SIGA concurrency and QA adversarial mode, reporter manifest/native interactive protocol and fallback tests.
CONCURRENCY: PR #77 ARTIST DRAFT remains untouched. PR #91 G440 merged and incorporated through a two-parent reconciliation; no shared target paths with PR #93.
WAIT: O708 protected merge after fresh exact-head green and expected-head guard.
NEXT: Verify current PR #93 head and all required workflows, then mark Ready and guarded squash merge. Reconcile resulting master, close claim and deliver one interactive RELATORIO from live source.

## Latest SIGA — SPEC-007 verified merge and terminal report

State: ADVANCE after PR #93 merged on master@a02560e67216f46e7d6f7b79aafb42c8fb0411bc.
SPEC-007: 10 discoverable skills, 16 routing cases, QA adversarial mode, SIGA internal concurrency, archived legacy contracts, RELATORIO native interactive and inline-image fallback. O700–O710 checked after protected merge.
Gate evidence: PR head 41b4355464d2931148da05188193204d72d36046: Validate skills, Godot CI, Web Preview, ARCH Source Import, G440 Save Schema and Roblox CI PASS; Roblox Behavioral SKIPPED/nonrequired. This is NOT post-merge master CI evidence.
Concurrency: PR #77 ARTIST draft remains separate; claims on original SPEC-007 closed by this closeout. Master task G441 is next animal-first persistence work; V201/V201a ARTIST runtime prerequisites remain open.
Terminal: Render interactive RELATORIO from freshly re-read GitHub state with default HEAD and branch/PR SHA separated. In clients without controls use one native inline image; never download-only.
Next: SIGA select independently ready SPEC-004 G441 local SaveStore or V201 visual dependency after ownership/gate checks.


## SIGA latest — G441 merged, next G442 (2026-10-14)

MODE: ADVANCE
REPO: az1nn/marica-game master@4f58a8251a4e9ccfd4c89d9a370b913081ccecbd
PR: #96 MERGED after exact-head tests at 42018f778d81405d08bb5b438103b2c2bf19f490
DONE: G441 typed Godot SaveStore for local versioned JSON, strict v1 validation, duplicate key rejection, optimistic revision compare, rollback-clamped injected time and deterministic headless QA/mutation proof.
GATES: G441 SaveStore, Godot CI, G440 Schema, ARCH V201, Validate skills, Roblox CI, Web Preview Contract PASS on exact PR head; master post-merge Godot/skills/Roblox/Web Preview PASS. This closeout PR still has separate exact-head gates.
CONCURRENCY: Visual PRs #77 and #97 remain draft and do not intersect G441 changed paths. G441 claim CLOSED.
BOUNDARY: G441 direct file write is not crash-safe; do not mark G442 atomic/backup or G443-G447 integration as complete. Issue #86 genetic saturation remains unresolved.
NEXT: SPEC-004 G442 — implement crash-safe temp-file replacement, backup/recovery and fault-injection QA without changing pure domain.
