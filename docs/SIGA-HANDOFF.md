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
