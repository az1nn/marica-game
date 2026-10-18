# SPEC-008 — Isolated interactive Godot Web QA access

Status: IN PROGRESS / P1 QA-001 (#133), parent QA tracker #129.
This is test-access infrastructure, not production gameplay or visual approval.

## Problem
Vercel previews of the PR branches intentionally deploy static status HTML. Vercel Ready is not evidence that a playable Godot canvas exists.

## Requirements
- Export isolated CENA V206 candidate through official checksum-pinned Godot 4.7.2 Web templates, without changing the default scene in committed game/project.godot.
- Verify original founder V4 PNG SHA-256, source/head invariants, wasm + pck presence and checksums.
- Start actual generated Godot WebAssembly under HTTP in real Chrome, require a Godot-scene readiness marker and nonempty canvas; capture desktop and emulated mobile portrait screenshots.
- Publish versioned immutable GitHub Actions artifact and manifest signed to exact PR head.
- Publish separate HTTPS playable/interactive QA link only after an approved host/rights decision and deployed build smoke test; never claim a downloadable artifact is already hosted.
- Collect physical mobile and user QA ACCEPT/REVISE/REJECT before considering #133 resolved.

## Safety
Stacked on CENA #132, draft-only. Preserve parent CENA #128, ARCH #126, LENTE #130, ARTIST #77, founder PNG, source ownership and master static deployment. This does not close V201/V201a/V203/V205/G452 or approve ARTIST runtime.
