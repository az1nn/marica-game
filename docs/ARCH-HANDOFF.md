# ARCH HANDOFF — Maricá Game

Task: SPEC-005 V201/V201a founder dog S01-A01, isolated technical probe.
Branch: `arch/v201-v201a-founder-import-20261014`; base observed `master@eb63378191a07fc494b1f35b0d7a27e67035bb6c`.
Source: exact human-approved V4 binary, copied by **identical Git blob**, not regenerated.
Prototype: `game/scenes/arch_v201_founder_probe.tscn`; executable tests and dedicated GitHub Actions `ARCH V201 Source Import`.
Authority: ARCH validates import/grid/scale/performance; ART owns intended appearance; SCENE owns gameplay scene materialization; LENTE owns visual capture; SIGA owns orchestration and guarded merges.
Evidence: ARCH V201 Source Import run #38576899725 PASS and full Godot CI run #38576899710 PASS at implementation SHA `5de62093615e9b2a548912644bfff31c1896e9c3`; source/alpha/filter/foot-anchor headless tests and nearest→linear BAD mutant verified. These do not certify on-screen sharpness, mobile performance or shipping assets; later handoff documentation commits require fresh exact-head CI.
Risks: 37,780 opaque RGB colors and hard alpha with nonzero transparent RGB; need nearest/linear comparative visual capture at real zoom/terrain and alpha-border assessment; no approved atlas or pixel-grid units.
Concurrence: ARTIST draft PR #77 remains separate/unmerged; original art concept ACCEPT applies only to source; SPEC-004 gameplay G440 priority stays unaffected.
Status: ARCH_SOURCE_IMPORT_VERIFIED / R1_PROTOTYPE_COMPLETE / MOBILE_PERF_AND_RENDER_CONTRACT_OPEN / PR_DRAFT. R1 V201/V201a remain unchecked globally.
Next: SCENE/LENTE real Godot output at representative mobile/desktop dimensions and contrast backgrounds, then independent ART/ARCH quality and performance decision; no premature V201/V201a closure or runtime ACCEPT.


## Follow-up — PR #88 technically merged (2026-10-14)

- SIGA applied a user-authorized **scoped, non-production-only** merge of [PR #88](https://github.com/az1nn/marica-game/pull/88) after reconciling branch to SPEC-006 and exact-head checks. Guarded squash commit: `45d89c6bb1f028a4682be9540c87bea8c701184b`.
- Post-merge `master@45d89c6bb1f028a4682be9540c87bea8c701184b`: Godot CI [PASS](https://github.com/az1nn/marica-game/actions/runs/38599316902), Validate skills [PASS](https://github.com/az1nn/marica-game/actions/runs/38599316918), Roblox CI [PASS](https://github.com/az1nn/marica-game/actions/runs/38599317461), Web Preview Contract [PASS](https://github.com/az1nn/marica-game/actions/runs/38599317367).
- The canonical original V4 PNG blob `da7806ebfcb051c8fd32ccdbad4760b7136f97dd` remains unchanged in the ARCH-only `game/assets/arch_probes/` **test copy**. It is not the production sprite resource or final art distribution license approval.
- **Remaining gates:** SPEC-005 V201/V201a are explicitly **unchecked**; logical resolution, integer zoom, pixel-grid/palette, atlas/licensing, browser/mobile frame budget and visible alpha-edge tests still need independent real Godot evidence. SCENE/LENTE capture plus ART result must precede runtime acceptance. [ARTIST PR #77](https://github.com/az1nn/marica-game/pull/77) remains draft and unmerged.
- No main-scene, animal-domain state, persistence, V1 release, or web deployment behavior changed. Full V201/V201a acceptance, V202–V205, and final production art are **not** implied by this merge.

Next actionable SPEC-005 owner: **LENTE/SCENE**, once an actual rendered scene/capture environment is available; ARCH then evaluates pixel scaling and frame budgets. Keep G440 as a parallel, noncolliding core gameplay task.
