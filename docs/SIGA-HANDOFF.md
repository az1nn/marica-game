CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-004 — Godot V1 Transition

STATE:
Constitution/ADR/runtime migration governance is complete. Godot is the canonical V1 production runtime; the core is single-player/offline-first.

MODE:
ADVANCE

BASE:
master@82a5c7c5a41f87a0768a4e94088b383b9e39a9c9

DELIVERED:
- PR #35 merged Constitution v2.0.0 + SPEC-004 + ADR-0004;
- Phase A G400-G406 complete;
- PR #29 closed SUPERSEDED;
- PR #26 and #34 closed MIGRATION_SOURCE without merge;
- reusable genetics/succession contracts captured in docs/migration/ROBLOX-TO-GODOT-CONTRACT-MAP.md;
- legacy Roblox branches retained until Godot parity/decommission gates.

QUALITY:
- Governance PR #35 exact-head Validate skills PASS;
- Governance PR #35 exact-head Roblox CI PASS;
- Roblox Behavioral SKIPPED/non-required after ADR-0004;
- follow-up closeout still requires its own exact-head PR gates before merge.

BLOCKER / WAIT:
none.

CONCURRENCY:
Legacy Roblox PRs are closed; no production sibling implementation remains open.

NEXT:
G410 — create game/project.godot and the domain/application/adapters/presentation/scenes/tests structure.
