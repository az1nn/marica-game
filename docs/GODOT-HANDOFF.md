# GODOT HANDOFF

Status: PRODUCTION / ADVANCE — G433 NEXT
Authority: Constitution v2.0.0 · SPEC-004 · ADR-0004.
Runtime: Godot 4.7.2-stable · typed GDScript · single-player/offline-first · GUT v9.7.1 pinned.

Delivered:
- G410–G416 foundation/harness, G420–G429 pure animal domain and composite Pet, G430 deterministic bounded genetic +0.05.
- **G431**: `MaricaSuccession.create_successor` pure single successor; verified inheritance, seed/ordinal, terminal parent and detached snapshots.
- **G432**: `MaricaSuccession.create_successors(parent, successor_ids, succession_seed)` returns **exactly two** juvenile successor Pet objects from one ended composite parent using G431 ordinals 1 and 2. Requires an array of two distinct IDs, forbids reusing the parent ID, rejects invalid parent/seed and second-ordinal overflow; returns all-or-error, not a partial pair. Same lineage/founder, generation +1, direct parent and distinct deterministic genetic advancement; detached children/input/parent.
- **238 ACTIVE_PARITY** source-linked executable golden fixtures from G420–G431 (unchanged by G432), 4 harness selftests. G432 uses a separate independent regression, not fictitious legacy-Luau parity.

Verified:
- G431 feature PR #73 and its post-merge master checks PASS.
- **G432 PR #75 exact head `67334e2fd5829685aa7d661927366880a8331b8d`**: Godot CI (including targeted two-child runner, G431 regression and GOOD → BAD (one-child mutant) → RESTORE), Validate skills, Roblox CI PASS. Roblox Behavioral SKIPPED/nonrequired.
- Guarded squash merge **master@`cdc427ae04951ec534bfa5b75126945468183a6a`**; Godot CI / Validate skills / Roblox CI PASS on that exact merge commit.
- ARTIST approved initial dog/capybara/chicken and milho/tomate/cenoura concepts; not imported/accepted runtime sprites.

Limits:
- G432 guarantees the **pair returned by each call**, not once-only triggering on repeated end-of-life events; G433 owns durable idempotency markers/trigger semantics. G434 extended pedigree, G435 accelerated lifecycle, G440 saves, G450 gameplay scenes and G500 HTML5 export remain pending.
- Vercel preview does not prove Godot HTML5 export or playable-scene acceptance.

Next: **G433 — end-of-life/succession idempotency**: plan and implement event-level once-only marker/registry in pure Godot with deterministic repeated-call/reload tests and mutation proof; coordinate save-schema G440/G445 without falsely claiming persistence before its gate.
