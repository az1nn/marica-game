CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-004 — Godot V1 Transition / governance

STATE:
Constitution v2.0.0, SPEC-004 and ADR-0004 establish Godot as canonical V1 runtime. SPEC-001 executable Roblox backlog is redirected to SPEC-004. ADR-0001 is superseded for V1; ADR-0002 keeps only portable time/idempotency semantics.

MODE:
ADVANCE

BASE:
master@16a0bd8016dfd33c4c2245248f00799a4e6db9be

WORKING BRANCH:
spec/004-godot-v1-transition

CONCURRENCY:
PARALLEL_SAFE for governance/docs. PR #26 and #34 are migration sources and must not merge into V1 Luau. PR #29 is superseded by the platform decision.

DELIVERED THIS UNIT:
- Constitution v2.0.0: Godot-first, single-player, offline-first;
- SPEC-004 spec/plan/complete executable migration roadmap;
- ADR-0004 superseding ADR-0001;
- SPEC-001 future executable tasks redirected to SPEC-004;
- SIGA/GODOT/ROBLOX routing updated;
- README and specialist handoffs aligned;
- ADR-0002 marked partially superseded.

VERIFY REQUIRED:
- Validate skills on exact PR head;
- applicable repository CI on exact PR head;
- review changed-file diff for accidental Roblox/Godot authority conflicts.

WAIT:
none before PR checks.

BLOCKER:
none.

NEXT:
G404 — after governance PR is accepted on master, close/reclassify PR #29 as SUPERSEDED and PRs #26/#34 as MIGRATION_SOURCE, preserving their branches/contracts for G405.
