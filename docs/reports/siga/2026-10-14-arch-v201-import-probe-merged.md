# RELATORIO / SIGA — Maricá Game ARCH V201/V201a (2026-10-14)

**Result:** VERIFIED TECHNICAL-PROBE MERGE (not finished visual R1)
**Authority:** SPEC-005 V201/V201a, SIGA / SPEC-006
**PR:** [#88](https://github.com/az1nn/marica-game/pull/88) — squash merged into `master@45d89c6bb1f028a4682be9540c87bea8c701184b` after branch-base reconciliation.
**Artifact:** isolated Godot 4.7.2 sample scene, original SHA-pinned S01-A01 PNG test copy, import/alpha/filter/pivot runner and ARCH CI mutation proof.

## Evidence
- Pre-merge PR HEAD `b3a1fc42608a2a1eb886d1666f6dbd7cb8dd2167`: Godot CI, ARCH V201 Source Import, Validate skills, Roblox CI, Web Preview Contract all PASS. Roblox Behavioral SKIPPED/nonrequired.
- Post-merge master SHA `45d89c6bb1f028a4682be9540c87bea8c701184b`: [Godot CI](https://github.com/az1nn/marica-game/actions/runs/38599316902), [Validate skills](https://github.com/az1nn/marica-game/actions/runs/38599316918), [Roblox CI](https://github.com/az1nn/marica-game/actions/runs/38599317461), [Web Preview Contract](https://github.com/az1nn/marica-game/actions/runs/38599317367) all PASS.
- Exact original S01-A01 V4 binary preserved (Git blob `da7806ebfcb051c8fd32ccdbad4760b7136f97dd`). Approved concept remains separate from runtime.

## Boundaries / risks
- No Godot actual rendered screenshots/mobile frame-time/alpha-edge A/B, texture atlas/grid/license acceptance, production camera or UI interaction. The test scene is **isolated**, not a playable build.
- SPEC-005 V201/V201a **OPEN**; R2 V202–V205 **OPEN**. PR #77 ARTIST remains draft/unmerged. Source concept human ACCEPT does not certify runtime.
- SPEC-004 G440 independent work remains eligible; no domain files modified.

## Next
SCENE + LENTE exact-head rendered Godot viewport/zoom/contrast captures, ARCH budget/grid policy, then ARTIST independent runtime review; SIGA decides gates and guarded merges.

**STATE: MERGED_TEST_INFRA / CI_PASS / VISUAL_NOT_ACCEPTED / NO_RELEASE**
