# QA-002 — founder tap diagnostic (issue #138)

**Scope:** native Godot `InputEventScreenTouch` / `InputEventMouseButton` feedback on **isolated** `qa_web_preview.tscn`. This does not add care actions, persistence, pet interactions in production, or approve ARTIST/LENTE/runtime gates.

## Changes
- A direct tap/click inside the existing founder `Sprite2D.get_rect()` (using canvas-aware transform, so camera zoom/pan is considered) shows **"Cachorro fundador selecionado"** on a noninteractive Godot `CanvasLayer` label. The original V4 texture is unmodified.
- The QA wrapper tracks touch index, press/release travel distance, and mouse synthetic events; drags are never selections. It does not mark events handled, so CENA's V206 `_unhandled_input` remains responsible for bounded camera pan.
- Browser markers `__MARICA_QA_SELECTIONS` and `__MARICA_QA_FOUNDER_CENTER` are written exclusively from Godot code for test automation. The browser injects real pointer events rather than mutating markers or painting an HTML overlay.

## Automated evidence
- `.github/workflows/qa002-input.yml` checks out exact head, source PNG SHA, uses the inherited official pinned Godot 4.7.2 scratch export, and runs actual Chrome + emulated touch/mouse on exported WebAssembly.
- Screenshots before/after and SHA-bound manifest validate visible native selection; mouse-synthesis debouncing and drag-negative checks are included.
- Real Firefox Android, actual touch pan, hosted authenticated preview provenance, performance, safe-area/HUD accessibility, texture rights, independent LENTE/ARTIST approval and all production gameplay remain **OPEN**. A passing Linux Chrome emulation is not physical-device acceptance.

## Dependency and merge order
`#128 CENA V203` → `#132 CENA V206` → `#134 QA-001 Web export` → `#135 QA-001 protected Vercel host` → this **stacked QA-002 PR**. Parallel `#130 LENTE`, `#136 CENA portrait continuity`, `#77 ARTIST`, `#123/#124/#126 ARCH` and `#125 G452` remain independently gated and untouched.

**NO MERGE** until all exact-head checks, verified authorized deployment + exact SHA/hash/canvas evidence, real Android/desktop tester verdict and appropriate source/visual/runtime approvals. QA-001 #133 remains OPEN and QA-002 #138 remains OPEN; neither is resolved by the new code alone.

## Manual physical QA recipe (authorized protected preview)
1. Sign in to the intended restricted Vercel QA deployment. Read `/qa-build.json` while authenticated; verify `head_sha` matches PR head. Do not share bypass tokens.
2. In Firefox Android, tap the founder once. The Godot label must appear. Tap twice again; each tap should register once. Drag far enough to pan; no extra selection should occur.
3. Verify landscape/desktop mouse selection and compare supported camera behavior; record exact browser, OS, device, PR SHA and tester ACCEPT/REVISE/REJECT in #138.
