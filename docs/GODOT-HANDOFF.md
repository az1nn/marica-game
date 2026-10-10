# GODOT HANDOFF

Status: PRODUCTION / ADVANCE — G430 NEXT
Authority: Constitution v2.0.0 · SPEC-004 · ADR-0004.
Runtime: Godot 4.7.2-stable · typed GDScript · single-player/offline-first · GUT v9.7.1 pinned.

Delivered:
- G410–G416 baseline and exact-head harness.
- G420–G428 independently tested animal domain ports: identity, pedigree/lineage, lifecycle, clock, potential/expression, care, health, Soulbound, and persistent Affection.
- **G429:** `MaricaPet.create_composite` combines validated pedigree/lifecycle/genetics, care, health, Soulbound and affection; detached snapshots and immutable with_* transitions, care→expression coupling, treatment cost, terminal risk and no-op after ended life. Legacy G420/G427/G428 isolated shell APIs remain compatible.
- 21 G429 Luau-source cases yield **209 ACTIVE_PARITY** fixtures (188 prior + 21 new), 4 harness selftests and 3 genetics advancement cases **G430 PENDING_PORT**. Independent composite runner + GOOD→BAD→RESTORE terminal risk mutation proof passed.
- ARTIST initial roster remains tricolor dog founder / capybara / chicken and milho / tomate / cenoura; approved visual concepts are not production sprites.

Verified:
- PR #69 exact candidate head `9edde5513bef35974480e10ce2c1ec072781203a`: Godot CI / Validate skills / Roblox CI **PASS**, including G429 regression, fixture harness and terminal-risk mutation; Roblox Behavioral SKIPPED/nonrequired.
- Guarded squash merge master@`66604001dd20182755b9b3120cf1aa892e50d807`: same three required master push workflows **PASS**.
- Phase C G420–G429 domain contract parity is complete within SPEC-004 boundaries; complete animal lifecycle and generation **NOT** implied.
- G430+ deterministic genetic advancement, successor creation / exactly two, offline save, gameplay scenes, production assets/LENTE and Web export **NOT YET PROVEN**.

Next: **G430 — deterministic genetic potential advancement** using Luau `Genetics.advancePotential` / legacy PR #26 as source, preserving offline deterministic parity.
