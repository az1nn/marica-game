# SPEC-005 V201 — Render evidence harness (ARCH / LENTE)

This bounded diagnostic captures the existing approved S01-A01 V4 source as rendered by Godot 4.7.2 through Xvfb/Mesa software OpenGL, rather than equating image import with an in-game screenshot.

- **Exactly four captures:** mobile dark/light at 432×768 1× nearest; desktop at 1280×960 2× nearest and linear-control.
- **Immutable source:** git blob da7806ebfcb051c8fd32ccdbad4760b7136f97dd under game/assets/arch_probes. No modifications to ARTIST #77, production scene, save/domain, or gameplay.
- **Exact-head manifest:** SHA, source, viewport, sampling, screenshot filenames, Godot runtime, and technical-only status. A blank/solid frame fails closed.
- **Runtime scope:** simulated software desktop and mobile-sized viewport. No real mobile-device/browser FPS budget, camera/atlas/license approval, genuine gameplay scene, or ARTIST visual acceptance is implied.
- **Workflow:** V201 Render Evidence uploads PNG and manifest only when actual Godot rendering yields material images; review independently via LENTE/ARCH and ARTIST. Keep V201/V201a/R2 unchecked until real acceptance.
- **Concurrency:** separate from G441 local SaveStore claim and ARTIST draft PR #77. No external provider deployment.

Reference: Godot Viewport screenshot guidance (await frame_post_draw) and SPEC-005 plan.
