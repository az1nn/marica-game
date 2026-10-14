# ARCH V201 / V201a — S01-A01 Founder V4 technical probe

**Decision status:** IMPLEMENTED PROTOTYPE; Godot CI / ARCH-specific check and device-level LENTE pending until exact-head evidence exists. NOT a production sprite, ART accept, R2 scene, final sprite grid policy, performance certification, web export, or mobile verification.

## Source and rights

- Visual human acceptance: S01-A01 founder dog V4 isolated concept, 2026-10-13, carried by ARTIST draft PR #77.
- Original approved PNG source path (ARTIST-owned): `docs/artist/assets/S01-A01/V4/S01-A01_CACHORRO_FUNDADOR_V4_ISOLADO_CANDIDATO.png` on PR #77.
- **Same Git blob**, no pixel transformation: `da7806ebfcb051c8fd32ccdbad4760b7136f97dd` at `game/assets/arch_probes/S01_A01_v4_original.png`. SHA-256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`, PNG RGBA 344×378, 174,947 bytes.
- Origin recorded in ARTIST as user-supplied, conversation-generated asset. Do not infer third-party rights, production distribution licensing, or user-verified original authorship from Git provenance alone; distribution rights remain a release gate.
- This repo image is a **non-production testing copy**; canonical art authorship/approval records remain PR #77.

## Bounded technical contract (probe, not frozen production policy)

`game/scenes/arch_v201_founder_probe.tscn` contains only a y-sorted Node2D root and a source-preserving Sprite2D: explicit CanvasItem nearest filter (enum=1), unmodified imported PNG, centered texture, offset `(0,-182)` placing the last non-transparent image row on origin (feet contact). Keeping this in an isolated scene avoids changing main-scene, gameplay/save/clock, camera, plant or cloud code.

The standalone Godot 4.7.2 `game/tests/arch_v201_import_runner.gd` measures:

- Original 174,947-byte PNG SHA-256, 344×378 dimensions, exact nontransparent bbox (6,6,332,366) and alpha counts (transparent=48,609, opaque=81,423, partial=0).
- Native Godot `Texture2D` import, `PackedScene` instantiation, nearest sampling config, 2.5D y-sort flag, foot pivot, correct source texture dimensions.
- Only **math candidates** at 0.5× / 1.0× scale: projected width 172 / 344 px. Neither establishes actual mobile screen legibility, antialiasing, 60 fps or a final camera scale.

The dedicated `.github/workflows/arch-v201.yml` runs exact-head import/parse and isolated assertions, plus nearest→linear mutant to show the instrumentation detects a real filtering regression (GOOD→BAD→RESTORE). Logs are artifacts; **headless assertions are not screenshot evidence**. General Godot CI remains separate and required.

## Decisions deliberately left open

| Subject | Interim architecture | Production acceptance |
| --- | --- | --- |
| Input sprite | Verified source bytes, stored unchanged | ART confirms real presentation after scene capture |
| Filtering | Nearest for probe, explicit scene-level policy | Test against halos/edge bleeding on white/dark/terrain at real viewport |
| Pixel unit/grid/palette | **Undecided**; 37,780 opaque RGB colors in source | ART + ARCH compare clusters and readability before any destructive conversion |
| 2.5D depth | Y-sorted root and bottom silhouette pivot | SCENE checks occlusion/contact shadow and contextual camera |
| Texture compression / mipmap / atlas / batch | Godot defaults; one image only, no atlas frozen | ARCH measured import/performance and provenance/license constraints |
| Logical resolution, zoom and budgets | Not fixed by a headless script | Device/browser captures, CPU/GPU/frame-time measurements required |
| Mobile UI | No HUD in technical probe | SCENE R2 and LENTE independent mobile/desktop validation |
| Delivery | ARCH branch with independent CI; no gameplay change | SIGA exact-head conflict scan and downstream ART/SCENE/LENTE gates |

## Handoff

1. Validate exact-head workflows and source sha; archive run URLs and detect failures without recasting as art failures.
2. Expose this isolated scene to SCENE for representative farm background, selection affordance, foot occlusion and mobile/Desktop sizes *after* ARCH baseline.
3. LENTE independently captures real Godot output (not concept images, not a headless log). ART performs ACCEPT/REVISE on image and interaction readability.
4. Do not close V201/V201a globally on this evidence; mobile performance and final import/atlas policy remain measured gates. Avoid merge until SIGA coordinates dependency on PR #77 approved source and checks exact head.

**State: ARCH_PROTOTYPE_IMPLEMENTED / IMPORT_PROOF_PENDING / ART_LENTE_NOT_RUN / V201_V201a_NOT_CLOSED.**
