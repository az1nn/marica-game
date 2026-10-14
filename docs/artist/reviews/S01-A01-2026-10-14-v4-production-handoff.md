# ARTIST — S01-A01 V4 source-to-runtime production handoff (2026-10-14)

**Scope:** visual review of the exact approved isolated tricolor founder dog PNG, and an actionable ART acceptance rubric for the forthcoming ARCH V201/V201a measured Godot prototype. **NOT** a new artwork, revised visual concept, production sprite acceptance, ARCH decision, SCENE implementation, LENTE evidence or release approval.

## Provenance / constraints

- Repository: `az1nn/marica-game`, draft PR [#77](https://github.com/az1nn/marica-game/pull/77) on `artist/s01-a01-v3-revise-20261012`. At this review, `master@6d98f9a549ab93a5c7e1beeffb4ad5494f82dc17` and independent draft PR [#85](https://github.com/az1nn/marica-game/pull/85) G436 were observed.
- Approved source: `docs/artist/assets/S01-A01/V4/S01-A01_CACHORRO_FUNDADOR_V4_ISOLADO_CANDIDATO.png`. SHA-256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`; Git blob `da7806ebfcb051c8fd32ccdbad4760b7136f97dd`; 344×378 RGBA, 174,947 bytes.
- Independent QA reference: [2026-10-13 V4 source audit](S01-A01-2026-10-13-v4-source-audit.md) verified a connected subject silhouette, binary alpha, 6-pixel margins, and 37,780 opaque colors; it did **not** certify a fixed pixel grid, filtering, atlas, Godot scene or runtime.
- Historical approvals remain separate and intact: S01 V3 *screen* ACCEPT; S01-A01 V3 *concept board* REVISE; S01-A01 V4 *isolated dog visual concept* ACCEPT; capybara PET-ALT-001 and chicken PET-ALT-002 remain distinct; V1 initial crops remain corn/tomato/carrot. None of these means import/runtime PASS.

## Source-only ART review

Visual examination of the repository's exact V4 PNG (not a generated substitute) supports the already-accepted character identity:

1. **Silhouette and canon — consistent with V4:** tricolor puppy, large floppy ears, upcurled tail, short legs/paws, 3/4 standing pose, friendly expression. Do not replace it with the capybara or change the founder designation.
2. **Signature accent — preserved:** red bandana gives a distinctive foreground identifier. Preserve the placement, overall shape and legibility relative to the white chest.
3. **Expression — readable at source scale:** eye highlights, muzzle and tongue convey warmth. At reduced game scale, internal features **may** collapse; this is a testable risk, not a confirmed runtime failure.
4. **Pixel-art consistency — not certified:** the source uses detailed shade transitions and non-uniform apparent pixel groupings. This may produce visually inconsistent cluster density beside deliberately gridded tiles, especially at non-integer zoom. Do not assume a required palette count or force a destructive quantization without side-by-side evidence.
5. **Alpha edge/color bleed — not tested in engine:** underlying RGB on transparent pixels is nonzero per audit; the soft-looking source shading and hard alpha need actual filtering checks on contrasting backgrounds. Source image review alone cannot rule out halos.

**ART disposition: ACCEPTED CONCEPT / SOURCE FIDELITY CONFIRMED / READY FOR ARCH TEST.** This is neither a second human ACCEPT nor an ART runtime approval.

## ARCH V201/V201a: required measured prototype

Build the smallest **isolated Godot scene**, using the **unmodified SHA-pinned V4 PNG as input**, without changing domain gameplay or claiming production readiness. Archive settings and runtime captures for:

| Test | Evidence to collect | ART assessment / blocking concern |
| --- | --- | --- |
| Native import | Source hash, import metadata, filtering/compression/alpha settings | Original pixels and transparent silhouette preserved; no hidden content replacement |
| Integer vs fractional zoom | Same scene at multiple camera zoom values, including at least one integer-scale candidate and one stress case | Bandana, face and paws stay interpretable; quantify blur, shimmer and uneven pixel groups |
| Background/alpha | Dark, light and farm-terrain backgrounds; nearest and proposed alternative filtering | No visually objectionable halos, dark edge fringes or transparent RGB bleed |
| Mobile and desktop | Captures at at least two representative viewport classes; record the **actual** character screen-space size | Founder remains recognizable at real gameplay presentation, not just full-size PNG preview |
| Pose anchor / depth | Feet pivot, grounding/contact shadow and test foreground occluder in a 2.5D sample | No apparent floating, limb clipping, depth inversion or interaction-anchor confusion |
| UI collision | One minimal selection/care/status overlay at expected touch size | Player can recognize animal and state without a dense permanent HUD |
| Performance | ARCH documents actual viewport, device/emulation, scaling policy and measured cost | Do not ratify an FPS, logical resolution or atlas size without measured platform evidence |
| Derived candidate (optional) | Side-by-side source vs candidate with exact command/settings and retained original | No implicit 128×128, 48/96-color, quantized or downscaled production decision; re-review any transformed output |

ARCH owns the **resolution, scale, texture-import, pixel snapping, layering, resource/atlas dimensions and mobile budget** decision; ART owns image fidelity and readability. Suggested cases are experiments, **not** ratified numerical design constraints.

## SCENE / LENTE handoff after ARCH

- **SCENE V202/V203:** one founder-dog animal-first sample with feet pivot, contextual camera, selection/care affordances; no modified animal-domain rules, second creature, crop rollout, production animation claims or automatic export/deploy.
- **LENTE V204/V205:** exact-commit Godot AFTER screenshots at measured mobile/desktop viewports, recorded settings, and comparable BEFORE baseline; include detail crops of muzzle/bandana, feet/alpha and HUD overlap; record A/B evidence separately from authored art boards.
- **ART review after real evidence:** `ACCEPT` if silhouette/identity, red bandana, sharp pixel-art presentation and readable state hold without objectionable halos; `REVISE` with quantified/visual deltas if reparable; `REJECT` if unacceptable. **No auto-promotion** by CI, code inspection or an attractive concept image.

## Concurrency and single next action

- PR #85 G436 alters tests/workflow; its scope is separate from this document. PR #77 remains draft and behind newer `master` commits. Keep source asset SHA unchanged and leave G436 untouched.
- ART/ARCH/SCENE/LENTE production gates **remain open**. Do not merge PR #77 or advance to plant production based on this review.
- **Next executable action:** ARCH V201/V201a minimal Godot source-import/scale/alpha prototype with exact-head evidence for the accepted V4 PNG. Send measured settings and screenshots to ART + LENTE for independent review before any production sprite promotion.

**ARTIST status: SOURCE_REVIEWED / BRIEFED_FOR_ARCH / NO_RUNTIME_PASS.**
