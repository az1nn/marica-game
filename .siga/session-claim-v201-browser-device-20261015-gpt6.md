# SIGA claim — SPEC-005 V201/V201a browser and device evidence

Owner: SIGA -> ARCH. Date: 2026-10-15 America/Sao_Paulo.
Task: SPEC-005 V201/V201a, bounded web-browser render profiling + testable import/atlas policy handoff.
Branch: `arch/v201-browser-device-gates-20261015`; base `master@bbfc4a24e5da5ab0015fbda83bffc6f2109461f6`.
Status: ACTIVE, pending post-claim barrier.
Claimed files: `tools/arch/v201_browser_profile.py`, `tools/arch/v201_browser_probe.html`, `.github/workflows/v201-browser-evidence.yml`, `docs/arch/V201-V201A-BROWSER-DEVICE-GATES.md`, this claim.
NO edits to original art, G452 scene, existing V201 raster workflow/script, SPEC-005 checkboxes, production game/export configurations, root SIGA handoff or other PR branches.

Concurrent drafts: ARTIST PR #77 owns V4 PNG source; ARCH PR #123 owns gap audit; ARCH PR #124 owns Godot raster harness and has active but **file-disjoint** claim; GODOT PR #125 owns G452 probe and reports CLOSED_FOR_WRITES. Semantic classification PARALLEL_SAFE only for browser-Canvas2D proxy / provisional constraints. Do NOT close V201/V201a or present emulator Chrome as physical Android/iOS, actual Godot web export or release performance.

Objective: run actual Chromium browser on CI (desktop and mobile viewport emulation), capture original-source raster with nearest/linear, collect requestAnimationFrame timings and exact-head evidence; pin source hash and software version. Document deterministic lossless import policy and explicit gaps, staged CENA -> LENTE -> ARTIST handoff. If physical device/engine web export unavailable, report CAPABILITY_BLOCKED rather than guessing.

Gates: post-claim barrier, guarded writes, exact-head Godot CI/skills/V201 Browser Evidence PASS for test capability; physical Android/iOS Godot-engine performance MISSING, human art/runtime decision MISSING. All PRs remain draft, no merge.
