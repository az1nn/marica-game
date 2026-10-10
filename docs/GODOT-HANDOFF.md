# GODOT HANDOFF

Status: PRODUCTION / ADVANCE — G428 NEXT
Authority: Constitution v2.0.0 · SPEC-004 · ADR-0004.
Runtime: Godot 4.7.2-stable · typed GDScript · single-player/offline-first · GUT v9.7.1 pinned.

Delivered:
- G410–G416 foundation; G420–G426 identity, pedigree, lifecycle, clock, genetics, care, health (133 executable ACTIVE_PARITY cases).
- **G427**: pure `MaricaSoulbound` port of Luau Soulbound.new / isTransferable / assertTransferable; nil defaults false, persisted non-boolean fails closed; bound founder untransferable; regular/descendant pets default transferable. Immutable `MaricaPet` snapshot carries explicit `soulbound` bool and transfer checks.
- **155 ACTIVE_PARITY** domain fixtures: +22 in G427 (Soulbound 16 + Pet 6); 4 harness selftests; G430 genetic advancement 3 cases PENDING_PORT.
- Independent G427 runner verifies source validation, transfer guard, detachment, descendant default; GOOD→BAD→RESTORE inversion mutation proof succeeded.
- V1 concept roster: tricolor dog founder / capybara / chicken and corn / tomato / carrot, approved documentation merged through PR #62. ARTIST concept approval is not runtime asset acceptance.

Verified gates:
- PR #65 exact HEAD `cdeaa7d04b5ccec38b785296d8061570e15f0b13`: Godot CI, Validate skills, Roblox CI PASS; Roblox Behavioral SKIPPED/nonrequired.
- Guarded squash merge into `master@ee30eef23b2ec59451dfd93fcc27638ed385213f`.
- Post-merge master exact-head Godot CI, Validate skills, Roblox CI all PASS. Mutation gate G427 explicitly PASS on PR and master runs.
- Full composite Pet lifecycle/care/health/affection integration and complete Animal Core parity (G429), succession, save, ARTIST V2 visuals and Godot Web export remain NOT PROVEN.

Next: **G428 — persistent affection invariant** in pure Godot domain with Luau-derived golden parity, independent regression and exact-head mutation proof. G429 remains responsible for composite integration and parity.
