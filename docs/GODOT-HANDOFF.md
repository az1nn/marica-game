# GODOT HANDOFF

Status: G434 VERIFIED / ADVANCE G435
Authority: Constitution v2.0.0 · SPEC-004 · ADR-0004.
Runtime: Godot 4.7.2-stable · typed GDScript · single-player/offline-first · GUT v9.7.1 pinned.

Delivered:
- G410–G416 foundation; G420–G429 composite Pet and cross-domain Luau parity (238 ACTIVE_PARITY source-linked cases through G431); G430 deterministic genetic advancement; G431 single successor; G432 exactly two detached successors; G433 in-memory once-only event coordinator.
- **G434** independent multigeneration pedigree regression at PR #81: founder → G1 pair → independent G2 branch successors → G3, with immutable lineage/founder, monotonic generations, direct-parent links, reconstructable ancestry, sibling isolation, founder-only soulbound and same-session replay.
- **G434** measurable direct-parent identity mutation gate (GOOD → BAD → RESTORE) protects against assigning founder in place of immediate parent for G2+.

Verified:
- PR #81 exact head `87fdfb651e9f0afd2f21a74ce18a580eaddf6f82`: Godot CI / Validate skills / Roblox CI / Web Preview Contract PASS. Roblox Behavioral SKIPPED/nonrequired.
- Guarded merge master@ `bac5a15e8ab3f241650477aeecd0a915c19886e2`: same four workflows PASS, Godot CI job also passed G434 independent regression and mutation step.

Limits:
- G433/G434 replay is session-local only. G440/G445/G446 own disk schema, durable markers and restart safety.
- G435 full 2–4 week accelerated lifecycle, G436 P0 GAUNTLET, gameplay scene G450+, sprites/ART/LENTE and Godot playable HTML5 export remain pending.
- PR #77 S01-A01 V4 is an approved concept draft, **not** an imported or validated runtime asset. Vercel root static technical page is not playable export.

Next: **G435** — implement a deterministic end-to-end accelerated 2–4 week lifecycle runner against Godot Pet/clock/care/health/succession contracts, demonstrate exactly two successors without duplicates, catch boundary failures; preserve G440+ persistence separation and applicable mutation evidence.
