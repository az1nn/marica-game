# GODOT HANDOFF

Status: PRODUCTION / ADVANCE — G431 NEXT
Authority: Constitution v2.0.0 · SPEC-004 · ADR-0004.
Runtime: Godot 4.7.2-stable · typed GDScript · single-player/offline-first · GUT v9.7.1 pinned.

Delivered:
- G410–G416 exact-head foundation and 4 harness selftests.
- G420–G429 pure animal domain parity: identity/pedigree, lifecycle/clock, genetics expression, care/health, Soulbound/affection and composed Pet.
- **G430:** typed `MaricaGenetics.advance_potential(potential, seed)` ports PR #26's finite nonnegative integral seed, lexicographic cyclic selection, +0.05 bounded trait advancement, saturated fallback, all-saturated equality and independent detached outputs.
- 15 new executable G430 cases increase total to **224 ACTIVE_PARITY**. G431 `succession.create_successor` (2 seed-derivation fixtures) remains **PENDING_PORT**.
- ARTIST initial roster: tricolor dog founder, capybara, chicken, and milho/tomate/cenoura. Concept art is not committed production sprites.

Verified:
- PR #71 exact head `fb2b8eb2d3c29f8406fed13408533cde8a8eaad7`: Godot CI / Validate Skills / Roblox CI **PASS**, including fixture schema, targeted G430 regression, previous domain tests and cap GOOD → BAD → RESTORE mutation proof.
- Guarded squash merge master@`0f9239a35b0ea00f5763e68216e1f2f9ce9bb1bf`: same three required post-merge workflows **PASS**; Roblox Behavioral SKIPPED/nonrequired.
- No complete pet-generation gameplay claimed by G430; G431+, G440+ persistence, scenes/ARTIST/LENTE and HTML5 export still pending.

Next: **G431 — deterministic single-successor creation** using legacy PR #34 / `Succession.luau` contract, preserving founder pedigree and explicit genetic seed ordinals.
