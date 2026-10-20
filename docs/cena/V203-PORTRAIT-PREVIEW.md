# SPEC-005 V203 — CENA founder portrait composition (technical proposal)

**State:** PROPOSED / non-production / ARTIST UNREVIEWED / NO MERGE.
**Owner:** CENA under isolated SIGA claim in .siga/session-claim-v203-portrait-preview-20261017-gpt6.md.
**Prerequisite:** ARCH V201/V201a Godot WebAssembly proof exists in draft PR #126, but final physical-device/import/rights gates remain REVISE / CAPABILITY_BLOCKED. See issue #127.

## Design and narrow scope

The existing G451 camera fits the entire 12x10 isometric debug farm into a narrow viewport. The ARCH #126 Godot/Web emulated 390x844 portrait capture then leaves a small world and founder. This separate candidate mounts the unchanged G451 farm and original ARCH-only V4 PNG test copy into the opt-in game/scenes/v203_portrait_preview.tscn. It changes neither default game/project.godot scene nor the G451 camera script.

Only the preview Camera2D receives a portrait-focus rule when viewport height exceeds width by 1.35x: zoom capped at 1.75, using a focus target width of 220 logical pixels, with camera centered on founder feet anchor. This intentionally crops outer farm columns in portrait; it is **not** final navigation or HUD design. Desktop retains original G451 fit. Sprite remains exactly the original 344x378, node scale 0.25, nearest, offset (0,-182).

No destructive quantization, pixel-grid fabrication, mipmaps/atlas, sprite regeneration, default export, save/domain, source PNG or ARTIST PR modified. G450 colored farm tiles are temporary debug geometry. This scene does not bind G452 hydrated soulbound state. It does not certify world layer occlusion, feet contact visually, physical mobile use, HUD targets or full V203.

## Exact-head verification contract

The new V203 CENA Portrait Preview workflow pins the official Godot 4.7.2 binary checksum, verifies source Git blob + SHA-256, and renders this **actual Godot scene** at 390x844 and 1280x960 using Xvfb/Mesa software OpenGL. It stores two PNGs, a code-HEAD and original-source pinned JSON manifest, checks actual Camera2D zoom/pivot and texture filter/size, and fails on flat/blank captures. It requires portrait zoom >1.5x the G451 fit but preserves desktop fit. Mutation QA reduces portrait focus to a known-bad result, must fail, then restores and passes.

Successful CI is a technical sample only. It is not a Godot Web export of the new scene, an instrumented engine frame budget, physical Android/iOS/Safari test, or independent LENTE/ARTIST decision.

## Next gates and constraints

1. CENA independently inspect the exact-head screenshot artifact and classify ACCEPT/REVISE for portrait framing, visible contact, cropped navigation and accessibility. **V203 task remains OPEN.**
2. ARCH evaluate whether source-preserving import/filter/rights contract can admit this scoped candidate; physical-device performance still CAPABILITY_BLOCKED.
3. LENTE independently produce same-build A/B runtime: portrait/desktop, light/dark/terrain, nearest/linear, integer/fractional zoom, alpha halos, feet contact, in-front/behind sorting, HUD input and actual WebGL export. Proxy screenshots never substitute for real in-game evidence.
4. ARTIST independently choose ACCEPT/REVISE/REJECT of runtime only, preserving the approved V4 concept history.
5. SIGA reconcile PR HEAD/claims and exact CI before considering any gated integration.

Concurrent draft PRs retain separate ownership: ARTIST #77; ARCH #123, #124, #126; GODOT #125. No merge, status checkbox closure, asset replacement or new approval implied.
