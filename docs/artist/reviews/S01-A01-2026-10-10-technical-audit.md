# ARTIST / ARCH — S01-A01 technical inspection (2026-10-10)

**Evidence scope:** original conversation PNG S01-A01 founder dog; NOT Godot runtime, production spritesheet, or independent ART/ARCH acceptance.
**Human gate:** isolated dog **visual concept ACCEPTED** (preserved). **Technical disposition:** **REVISE / production gate still OPEN**.
**Canonical source:** `S01-A01_CACHORRO_FUNDADOR_CONCEPT_SPRITE.png` SHA-256 `461a0132f4778168d1e0fe093ab26534c055c16f773e4a37fa2426c7ab66385e`.

## Reproducible image-level checks (Pillow + NumPy; local source bytes)

| Check | Observed |
| --- | --- |
| Image | 362 × 400, PNG RGBA |
| Nontransparent bounding box | x=[26,335], y=[24,367]; Pillow `(26,24,336,368)` |
| Pixels with alpha 255 | 66,095 |
| Pixels with alpha 0 | 78,705 |
| Pixels with intermediate alpha | **0** (hard binary mask) |
| Distinct RGB values among fully opaque pixels | **24,532** |
| Fully transparent pixels carrying nonzero RGB | **0** |
| SHA-256 matches previously approved visual candidate | **PASS** |

**Interpretation:** source binary identity and basic alpha integrity are proven. A high full-resolution RGB color count plus 362×400 source make a *fixed low-color, fixed-grid Godot sprite contract* **unproven**. Do not equate `0` partial alpha with absence of all visible silhouette-edge jaggies or independent scene/background testing. Color count is evidence of dense gradient/shading, not in isolation a formal pixel-art contract violation: V201/V201a must establish limits and scene tests.

## Engineering-only scale/palette experiments

Created *two 128×128 RGBA* nearest-neighbor resampling/quantization prototypes with a **101×112** preserved-aspect sprite footprint and binary alpha; no interpolation:
- `S01-A01_TECH_PROTOTYPE_128_48C.png` — 48 opaque colors; SHA-256 `f746ab79837f5961839303d02465d78bbbc53073d54f7e6f749802628962b006`
- `S01-A01_TECH_PROTOTYPE_128_96C.png` — 96 opaque colors; SHA-256 `62221d9222ff40d8031ce9c6de8b0d4a81d8207a8660e3fc053fb72320190037`
- `S01-A01_RELATORIO_TECNICO.png` — explanatory single-image diagnostic, SHA-256 `c5278caa557643d0de95761c516dae1fdf52df22b57b8fb6f4e52c4a162f55a4`.

All files are conversation-local outputs **not uploaded/committed to GitHub**. These experimental 128px/48/96 choices are **NOT ratified design, not mandatory palette policy, and not import-ready acceptance**.

## Technical gate results

- **Image provenance, bit-depth, shape, hard alpha:** PASS (local bytes).
- **Palette hierarchy, intended pixel units, 2.5D grid consistency:** REVISE/PENDING ARCH+ART V201/V201a; avoid assuming artificial 48/96 cap or fixed 128 cell.
- **Texture filtering, atlas/frames, origin, character collision, camera scale, mobile/desktop display:** NOT RUN.
- **Animations:** NOT GENERATED as aligned, frame-accurate spritesheets.
- **Godot runtime screenshots, LENTE A/B, visual regression & CI exact-head for revised branch:** NOT RUN for this source.

## Concurrency / CI reconciliation evidence

At inspection time: `master@57a5ef016f1ffc909ed78ea9123063b928830550` (G426 completed, G427 next) and PR #62 `artist/v1-screen-asset-map-20261009@ebcdd34154620b6344930501cba853dde7e5ef3f` diverged by **28 ahead / 3 behind**. PR #62 Godot CI run **38054296925** failed in `G426 health state compile diagnostic` at 2026-10-10 13:04Z, **because `res://src/domain/health.gd` was absent from the outdated branch**, not because of the dog PNG. The corresponding `master` contains G426 after PR #63. Preserve new master G425+G426 accomplishments and reconcile branches before rerunning CI; no claim all CI green. Preserve other domain owners' files.

## Next action

1. Reconcile current master into the ARTIST branch safely (preserve master G425/G426 statuses, Godot files and CI).
2. Rerun exact-head checks; no merge with unknown/failing gates.
3. ARCH and ART agree and measure V201/V201a grid/import requirements using this approved visual reference and one runtime prototype.
4. Produce and independently review actual frame-accurate motion, then SCENE/Godot/LENTE before promoting any production asset. No extra crop implementation until R2 passes.
