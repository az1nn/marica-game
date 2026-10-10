CAVEMAN HANDOFF v1

APP: Maricá Game
WORKSTREAM: SPEC-004 · Phase C Animal Domain
MODE: ADVANCE
BASE: master@ee30eef23b2ec59451dfd93fcc27638ed385213f

DONE:
- G427 — Soulbound Luau→Godot port: null defaults unbound, strict persisted boolean, explicit founder binding blocks transfers, descendants default unbound.
- New pure Soulbound domain + `MaricaPet` binding state; +22 Luau-provenance ACTIVE_PARITY cases (155 total); 4 harness selftests; 3 G430 fixtures still PENDING_PORT.
- Independent regression + transfer-inversion GOOD→BAD→RESTORE mutation proof.

VERIFY:
- PR #65 head `cdeaa7d04b5ccec38b785296d8061570e15f0b13` — Godot CI PASS, Validate skills PASS, Roblox CI PASS. Roblox Behavioral skipped/non-required.
- Squash merged guarded to master@ee30eef23b2ec59451dfd93fcc27638ed385213f; master post-merge Godot CI / Validate skills / Roblox CI PASS.
- G429 full Pet aggregate parity, G430+ genetic succession, offline save, ARTIST runtime visual acceptance, web export NOT PROVEN.

CONCURRENCY:
- #65 merged; no conflicting open PR at closeout start.
- G427 claim being closed by this documentation follow-up. Any newer default-branch edits require reconcile before merge.
- V1 ARTIST roster documented as concepts via merged PR #62, not production binary assets.

WAIT / BLOCKER:
No human product decision required to start G428. No current artifact import or cloud deploy gate on Phase C.

NEXT:
G428 — port persistent affection Luau→typed pure GDScript, fixtures + deterministic regression + mutation proof, exact-head CI.
