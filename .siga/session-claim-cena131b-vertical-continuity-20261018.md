# SIGA -> CENA isolated claim — issue #131, portrait vertical-space blockout B

Status: ACTIVE / BLOCKOUT_ONLY / NO_MERGE.
Date: 2026-10-18 (America/Sao_Paulo).
Live master: `bbfc4a24e5da5ab0015fbda83bffc6f2109461f6`.
Source CENA V206 [draft PR #132](https://github.com/az1nn/marica-game/pull/132) at `82860359df7649a9bb0d0fd14e6fcbdf302eb57e`; [#128](https://github.com/az1nn/marica-game/pull/128) still draft at `001e0469b4d848e4c005a62e888e4de12af767f4`. LENTE [#130](https://github.com/az1nn/marica-game/pull/130) at `c84c5046f18fcd77aed8f5061f88ea577f964485` is an independent sibling; QA Web [#134](https://github.com/az1nn/marica-game/pull/134) is another independently owned child of #132. ARTIST #77; ARCH #123/#124/#126; G452 #125 untouched.

## Reserved scope (new paths only)
- `game/src/presentation/cena131b_terrain_underlay.gd`
- `game/src/presentation/cena131b_terrain_scene.gd`
- `game/scenes/cena131b_terrain_preview.tscn`
- `game/tests/cena131b_terrain_capture_runner.gd`
- `.github/workflows/cena131b-terrain-viewport.yml`
- `docs/cena/CENA-131B-VERTICAL-CONTINUITY.md`
- this claim only.

Do not modify canonical `V207` (reserved for plants), V203/V206 scripts/tests, G450 farm/layout, G451 camera, save/domain, `game/project.godot`, V4 original PNG, rights/import contract, HUD, LENTE, ARTIST, QA #134. Source original SHA-256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`, original git blob `da7806ebfcb051c8fd32ccdbad4760b7136f97dd`.

## Proposal
Independently **opt-in** decorative underlay tiles extending *behind and beyond* the existing G450 prototype rectangle in portrait only, using neutral placeholder grass colors, no new farms/interactive tiles or canonical world content. Keep old bounded touch-pan, original farm tile grid, founder source, landscape/desktop same view unchanged. Generate real Godot 4.7.2 Xvfb/Mesa exact-head portrait original/current, pan extremes, landscape/desktop screenshot A/B; prove original gameplay region pixel preservation and contrast, source hash and metadata. Positive and negative controls, GOOD→BAD→RESTORE. This is a compositional **proposal for visual review** and must not be counted as player-usable farm coverage.

## Gates
- LENTE P1 `LENTE-V205-002` vertical-void finding remains OPEN until independent confirmation and ARTIST/UX approval of final visual composition. The new blockout may hide gray void but cannot close design, HUD or safe-area.
- ARCH physical Android/iOS, sprite import/atlas/rights/performance; QA browser WebGL export of **the updated candidate**, G452 hydrated runtime, contact/depth sorting and independent ARTIST human runtime verdict remain OPEN.
- Do not modify SPEC V201/V201a/V203/V204/V205/V206/V207 status, existing PRs or merge.
