# SIGA claim — SPEC-005 V201/V201a browser and device evidence

Owner: SIGA -> ARCH. Date: 2026-10-15 America/Sao_Paulo.
Task: SPEC-005 V201/V201a, bounded web-browser render profiling + testable import/atlas policy handoff.
Branch: `arch/v201-browser-device-gates-20261015`; base `master@bbfc4a24e5da5ab0015fbda83bffc6f2109461f6`.
Status: CLOSED_FOR_WRITES / WATCH_EXTERNAL_PHYSICAL_AND_VISUAL_GATES. This bounded browser/Web proof has been delivered; a new SIGA session/claim is required for subsequent mutations.
Claimed files: `tools/arch/v201_browser_profile.py`, `tools/arch/v201_browser_probe.html`, `.github/workflows/v201-browser-evidence.yml`, `docs/arch/V201-V201A-BROWSER-DEVICE-GATES.md`, this claim.
NO edits to original art, G452 scene, existing V201 raster workflow/script, SPEC-005 checkboxes, production game/export configurations, root SIGA handoff or other PR branches.

Concurrent drafts: ARTIST PR #77 owns V4 PNG source; ARCH PR #123 owns gap audit; ARCH PR #124 owns Godot raster harness and has active but **file-disjoint** claim; GODOT PR #125 owns G452 probe and reports CLOSED_FOR_WRITES. Semantic classification PARALLEL_SAFE only for browser-Canvas2D proxy / provisional constraints. Do NOT close V201/V201a or present emulator Chrome as physical Android/iOS, actual Godot web export or release performance.

Objective: run actual Chromium browser on CI (desktop and mobile viewport emulation), capture original-source raster with nearest/linear, collect requestAnimationFrame timings and exact-head evidence; pin source hash and software version. Document deterministic lossless import policy and explicit gaps, staged CENA -> LENTE -> ARTIST handoff. If physical device/engine web export unavailable, report CAPABILITY_BLOCKED rather than guessing.

Gates: post-claim barrier, guarded writes, exact-head Godot CI/skills/V201 Browser Evidence PASS for test capability; physical Android/iOS Godot-engine performance MISSING, human art/runtime decision MISSING. All PRs remain draft, no merge.

## Verified handoff / claim release — 2026-10-15

- Scope delivered on draft [PR #126](https://github.com/az1nn/marica-game/pull/126): original PNG immutable, actual Chrome Canvas2D source probe; official-pinned Godot 4.7.2 Compatibility WebAssembly export with real engine marker and two WebGL browser captures. No production scene, ARTIST file, G452 original, default project or SPEC checkbox mutations.
- Verified pre-handoff HEAD: `d6c9158f0cb459706a889f93a05257942274515f` — **18 PASS, one optional SKIP**, including [Web proof run 38836236086](https://github.com/az1nn/marica-game/actions/runs/38836236086) and artifact [#12019387500](https://github.com/az1nn/marica-game/actions/runs/38836236086/artifacts/12019387500). Exact-head checks on this *new documentation/claim HEAD* are required and cannot be inherited from earlier code commits.
- Actual engine hosted Linux Chrome: desktop p95 RAF 50.0 ms, mobile-emulated p95 50.1 ms, zero page errors; this cannot certify device FPS or Godot update time. Portrait screenshot shows a small gameplay footprint surrounded by large unused vertical space. ARCH `REVISE` for production framing/performance, `CAPABILITY_BLOCKED` on physical Android/iOS/Safari.
- Technical safe policy: source-preserving, nearest in probes; no palette/atlas/source-grid conversion; rights and actual device profile still open. The original V4 isolated ARTIST concept remains ACCEPT only.
- Routed future CENA -> LENTE -> ARTIST gates under [issue #127](https://github.com/az1nn/marica-game/issues/127), not executed or accepted by a documentation instruction. PR #77/#123/#124/#125 remain draft and independently owned. No merge of #126.
- The browser test scope has ended; no active write ownership. Next work must claim a new collision-safe unit and re-reconcile master and open PRs.
