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
