CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-004 — Godot V1 Transition

STATE:
Phase A — Constitution & Governance is complete (G400-G406). Godot is the canonical V1 production runtime; the V1 core is single-player/offline-first.

MODE:
ADVANCE

DELIVERED:
- PR #35 merged Constitution v2.0.0 + SPEC-004 + ADR-0004;
- PR #36 merged G404/G405 governance closeout;
- PR #29 closed SUPERSEDED;
- PR #26/#34 closed MIGRATION_SOURCE without merge;
- genetics/succession contracts preserved in docs/migration/ROBLOX-TO-GODOT-CONTRACT-MAP.md;
- both SPEC-004 transition claims closed.

QUALITY:
- PR #35 exact-head Validate skills PASS; Roblox CI PASS;
- PR #36 exact-head Validate skills PASS; Roblox CI PASS;
- Roblox Behavioral SKIPPED/non-required after ADR-0004;
- no missing human/product gate for Godot foundation bootstrap.

BLOCKER / WAIT:
none.

CONCURRENCY:
No open legacy Roblox PR remains. Retained branches are migration evidence only.

NEXT:
G410 — create game/project.godot and the domain/application/adapters/presentation/scenes/tests structure.
