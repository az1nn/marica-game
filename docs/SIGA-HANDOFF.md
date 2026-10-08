CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-004 — Godot V1 Transition

STATE:
Phase C — Animal Domain Port. G420 implementation complete on PR #48 candidate, with G421 next after exact-head validation and merge. Godot 4.7.2-stable is canonical offline-first runtime.

MODE:
WATCH — G420 final exact-head CI

DELIVERED:
- G420 pure PetId validation + injected Callable generator and identity-only Pet (validated construction, ID getter and detached snapshot).
- Five source-linked PetId golden fixtures executed with real Godot adapter; eight G421/G423/G430 fixtures still PENDING_PORT.
- Python fixture guard rejects unauthorized active domain parity and G420 headless identity smoke test.
- P0 mutation proof GOOD > BAD > RESTORE passed: whitespace-only-ID mutant detected and reverted.

QUALITY:
- PR #48 preliminary candidate@e9e2ba20490274bdded541a48c390a55c0fce274: Godot CI PASS, Validate Skills PASS, with explicit mutation marker.
- After spec/handoff edits, all required gates must run at the exact latest PR head before guarded merge.
- No general animal, save, succession, visual, full gameplay or G421 pedigree parity claimed.

CONCURRENCY:
Dedicated branch feat/g420-godot-pet-identity and claim .siga/session-claim-g420-20261008-gpt6.md ACTIVE; post-claim barrier CLEAR; no other open PR at claim time.

BLOCKER / WAIT:
Only current PR exact-head CI; no human product gate.

NEXT:
Verify final PR #48 SHA, merge with expected-head guard, close claim, advance G421 — lineage/pedigree.

END FILE
