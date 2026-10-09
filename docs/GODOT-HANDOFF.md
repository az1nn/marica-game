# GODOT HANDOFF

Status: G421 candidate / VERIFY exact-head

Authority: Constitution v2.0.0 · SPEC-004 · ADR-0004
Runtime: Godot 4.7.2-stable, typed GDScript, offline-first; pinned GUT v9.7.1.

Delivered foundation: G410–G416.
Previously merged G420: pure PetId + identity-only Pet, five real golden fixtures and whitespace mutant proof.
G421 candidate PR #50:
- Pure lineage_id.gd validation + injected generator preserving LineageId.luau contract.
- Pure pedigree.gd with nonnegative integer generation, founder no-parent invariant, 1–2 distinct direct parents for descendants, preserved source order, detached/copy-safe parent arrays and snapshots.
- Golden catalog: 4 harness selftests; 5 PetId + 6 LineageId + 15 pedigree real domain cases ACTIVE_PARITY (26 total); 6 future time/genetics cases PENDING_PORT.
- G421 headless runner verifies founder/descendant records, generator injection and mutation isolation.
- GOOD > BAD > RESTORE pedigree mutant verified (founder mistakenly allowed a parent, golden gate rejected it).

Verification evidence:
- PR #50 intermediate head f71affe3a482e0ac40c8d428f356bac682cf62c4: Godot CI PASS (18 Python unit tests, formatting, lint, headless import/parse/smoke, G420 and G421 parity, both P0 mutation checks), Validate skills PASS, Roblox CI PASS, Roblox Behavioral SKIPPED/non-required.
- Since task and handoff updates follow this SHA, check **the final PR head** again before merge. No green is automatically transferable to later commits.
- No merge or post-merge state asserted here yet.

Limits:
- G421 establishes ID, lineage and pedigree structural parity only, not lifecycle, health, care, genetics, time, succession, persistence, scene usability or visual/art acceptance.
- No Roblox/online dependency in Godot domain. Legacy retained as migration source.

Next after G421 merge: G422 — port lifecycle state machine with actual golden proof.
