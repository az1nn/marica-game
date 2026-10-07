CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-004 — Godot V1 Transition

STATE:
Phase B — Godot Foundation is active. G410, G411 and G412 are complete; engine and test runner are pinned reproducibly.

MODE:
ADVANCE

DELIVERED:
- PR #39 merged G412;
- canonical test runner is GUT v9.7.1;
- `game/test-runner.lock.json` pins release + exact upstream commit;
- `game/README.md` records the test-runner contract without changing Godot 4.7.2-stable;
- G412 session claim closed.

QUALITY:
- PR #39 exact-head `201207a`: Validate skills PASS; Roblox CI PASS;
- Roblox Behavioral SKIPPED/non-required under ADR-0004;
- merge guarded by expected head SHA;
- implementation merged to master as `5e18228`.

BLOCKER / WAIT:
none.

CONCURRENCY:
No competing open PR or overlapping active claim was present at merge time.

NEXT:
G413 — create Godot CI with import/headless parse on exact SHA.
