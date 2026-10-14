# SIGA concurrency claim — ARCH V201/V201a Founder V4 import probe

Task: SPEC-005 V201/V201a (bounded technical import/render probe)
Owner: ARCH session 2026-10-14 GPT-6
Base: master@eb63378191a07fc494b1f35b0d7a27e67035bb6c
Branch: arch/v201-v201a-founder-import-20261014 (created from base)
Status: WATCH — source import/alpha/filter/feet pivot tested; PR remains draft pending independent visual and performance gates; no active write ownership
Opened: 2026-10-14 (exact minute not asserted)

Scope:
- `game/assets/arch_probes/` immutable copy of the human-approved founder V4 original binary, preserving Git blob `da7806ebfcb051c8fd32ccdbad4760b7136f97dd` and recorded SHA-256.
- `game/scenes/arch_v201_founder_probe.tscn` isolated scene, not main scene; `game/tests/arch_v201_import_runner.gd` test; dedicated `.github/workflows/arch-v201.yml`.
- `docs/arch/` technical evidence and `docs/ARCH-HANDOFF.md` bounded handoff (without changing canonical GODOT or ARTIST handoffs).
- No domain/gameplay, save, web export, production camera, UI, R2 visual approval, or existing Godot CI pipeline changes.

Concurrent work: PR #77 ARTIST draft and asset source owns art identity; this ARCH branch copies exact blob but never mutates ARTIST files or its branch. No other open PR observed at claim. Preserve CODE/SPEC-004 priority (now G440).
Guards: post-claim live-state barrier; no auto-merge; exact-head checks; report separate TECHNICAL vs LENTE/ART visual evidence, and keep V201/V201a checked only if proved.

## Verification & guarded handoff (2026-10-14)

- Implemented `game/scenes/arch_v201_founder_probe.tscn`, Godot `game/tests/arch_v201_import_runner.gd`, dedicated ARCH workflow, and provenance with unmodified V4 Git blob `da7806ebfcb051c8fd32ccdbad4760b7136f97dd`.
- Required checks on implementation SHA `5de62093615e9b2a548912644bfff31c1896e9c3`: ARCH V201 Source Import PASS (38576899725), Godot CI PASS (38576899710), Validate skills PASS, Roblox CI PASS, Web Preview Contract PASS; behavioral optional SKIPPED. GOOD→BAD→RESTORE linear sampler mutation detected.
- This claim no longer reserves code paths or blocks G440. Remaining SCENE/LENTE/ART mobile pixel-quality and ARCH performance/image-policy gates explicitly **not** accepted.
- No merge or release; this documentation-only closeout commit requires fresh exact-head CI and optimistic recheck.
