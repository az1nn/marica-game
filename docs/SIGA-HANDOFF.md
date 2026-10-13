CAVEMAN HANDOFF v1

APP: Maricá Game
WORKSTREAM: SPEC-004 · Phase D Succession P0
MODE: ADVANCE
BASE: master@bac5a15e8ab3f241650477aeecd0a915c19886e2
PR: #81 MERGED (exact feature head 87fdfb651e9f0afd2f21a74ce18a580eaddf6f82)

DONE:
- G434 verifies existing pure Godot succession across founder → G1 → G2 in two independent branches → G3; every child keeps same lineage/founder, correct generation and immediate parent.
- Snapshot-recorded pedigree permits deterministic ancestor-path reconstruction when intermediate historical Pet snapshots are retained. Founder remains soulbound; descendants are transferable and snapshots are detached.
- G434 independent headless regression and direct-parent BAD mutation GOOD → BAD → RESTORE PASS. G433 session-local replay remains once-only. No changes to existing runtime APIs or 238 source-linked ACTIVE_PARITY cases.

VERIFY:
- PR #81 exact head @87fdfb65: Godot CI including G434 runner/mutation, Validate skills, Roblox CI, Web Preview Contract PASS; Roblox Behavioral SKIPPED/nonrequired.
- Guarded squash merge master@bac5a15e: Godot CI / Validate skills / Roblox CI / Web Preview Contract PASS at exact merge SHA.

CONCURRENCY:
- Feature G434 claim closed after merge and post-merge CI. Documentation closeout isolated from PR #77 ARTIST, whose latest draft touches only art documentation and the isolated V4 binary.
- Human accepted isolated S01-A01 V4 concept; its production ARCH V201/V201a, SCENE and LENTE gates remain pending. No ARTIST scope changed by G434.

WAIT / BLOCKER:
- No product/human blocker for G435. No wait on the Godot pure-domain chain.
- Offline save / cross-restart durable pedigree or idempotency remain G440/G444/G445/G446. Web preview remains technical, not Godot gameplay.

NEXT:
G435 — accelerated deterministic simulation covering a full 2–4-week animal lifecycle through one succession. Preserve G430–G434 and add exact-head QA/GAUNTLET evidence before claiming Gate D.
