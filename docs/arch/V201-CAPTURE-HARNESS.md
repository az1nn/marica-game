# SPEC-005 V201 — Render evidence harness (ARCH / LENTE)

This bounded diagnostic captures the existing approved S01-A01 V4 source as rendered by Godot 4.7.2 through Xvfb/Mesa software OpenGL, rather than equating image import with an in-game screenshot.

- **Exactly four captures:** mobile dark/light at 432×768 1× nearest; desktop at 1280×960 2× nearest and linear-control.
- **Immutable source:** git blob da7806ebfcb051c8fd32ccdbad4760b7136f97dd under game/assets/arch_probes. No modifications to ARTIST #77, production scene, save/domain, or gameplay.
- **Exact-head manifest:** SHA, source, viewport, sampling, screenshot filenames, Godot runtime, and technical-only status. A blank/solid frame fails closed.
- **Runtime scope:** simulated software desktop and mobile-sized viewport. No real mobile-device/browser FPS budget, camera/atlas/license approval, genuine gameplay scene, or ARTIST visual acceptance is implied.
- **Workflow:** V201 Render Evidence uploads PNG and manifest only when actual Godot rendering yields material images; review independently via LENTE/ARCH and ARTIST. Keep V201/V201a/R2 unchecked until real acceptance.
- **Concurrency:** separate from G441 local SaveStore claim and ARTIST draft PR #77. No external provider deployment.

Reference: Godot Viewport screenshot guidance (await frame_post_draw) and SPEC-005 plan.

## Supplemental V201/V201a raster/scale evidence — pending CI verification (2026-10-15)

This change deliberately **extends** rather than replaces the original four-capture baseline. The Godot capture runner now proposes **eight** captures from the unchanged approved 344×378 source, including:

| Capture | Viewport | Scale | Filter | Backdrop | Purpose |
| --- | --- | --- | --- | --- | --- |
| mobile-dark-nearest | 432×768 | 1.0 | nearest | dark | baseline |
| mobile-light-nearest | 432×768 | 1.0 | nearest | light | alpha/background contrast |
| desktop-dark-nearest | 1280×960 | 2.0 | nearest | dark | integer zoom |
| desktop-dark-linear-control | 1280×960 | 2.0 | linear | dark | filter control |
| mobile-terrain-half-nearest | 432×768 | 0.5 | nearest | olive | downscaled/terrain contrast |
| mobile-dark-fractional-nearest | 432×768 | 1.25 | nearest | dark | fractional pixel edges |
| mobile-dark-fractional-linear-control | 432×768 | 1.25 | linear | dark | matched fractional filter control |
| desktop-light-integer-nearest | 1280×960 | 2.0 | nearest | light | contrast at integer zoom |

The manifest records per-PNG SHA-256, viewport, scale, actual filter, pixel-sample informativeness, projected 344×378 sprite footprint and two-frame **capture wall-clock milliseconds**. The recorded time is environment-/runner-dependent and **cannot be interpreted as steady-state FPS, device performance, CPU/GPU budget or web export results**.

Pairs of real rendered PNGs (desktop integer and mobile-sized fractional) are compared on a 4-pixel grid, with at least 11 differing samples required. Workflow validation enforces eight valid captures, six distinct binary PNG hashes, matching hashes/metadata, pinned original Git blob and exact PR head. All validations FAIL CLOSED on missing or inconsistent output.

**Status until matching CI run:** unverified proposal, not a measurement result. No V201/V201a completion, production scene, license/atlas decision, approved mobile scale policy or ARTIST/CENA/LENTE verdict may be inferred. Human art identity and source rights remain independently gated. PR #77 remains a draft.
