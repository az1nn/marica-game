# SPEC-008 — Isolated interactive Godot Web QA access

Status: IN PROGRESS / QA-001 P1 #133, QA-002 P1 #138; parent QA tracker #129.
This is test-access infrastructure, not production gameplay or visual approval.

## Problem
Vercel previews originally deployed static status HTML, not actual game runtime. A separate QA branch now builds an isolated Godot Web scene, but human Firefox Android feedback shows **clicks/taps provide no response**, because the QA wrapper has no selection handler; CENA only supports panning.

## Requirements
- Export isolated CENA V206 candidate through official checksum-pinned Godot 4.7.2 Web templates, without changing committed main scene.
- Verify original founder V4 PNG SHA-256, source/head invariants, WASM/PCK presence and checksums.
- Start actual Godot WebAssembly via HTTP/HTTPS in real browser, require engine-owned readiness marker and nonempty canvas; capture desktop and emulated mobile portrait screenshots.
- Publish versioned immutable GitHub Actions artifacts and a separately authenticated HTTPS preview, preserving deployment protection.
- **Q806:** provide test-only, visible and accessible tap/click feedback for founder/farm in the **Godot scene itself**; distinguish touch tap from pan movement, mouse from touch-synthesized duplicates, and preserve the existing CENA camera gestures. The on-screen state must never masquerade as actual gameplay/care/save.
- **Q807:** actual Firefox Android and desktop tester retest must independently verify selection/swipe on the real deployed HEAD. Browser emulation is not physical device verification.
- Do not claim full gameplay, ownership or redistribution rights beyond authorized time-limited protected QA, release performance, LENTE/ARTIST visual approval or source modifications.

## Safety
Stack QA-only Q806 on Vercel hosting #135 after SIGA claim and governance-only Spec Kit bootstrap. Preserve the QA code ancestor #134, CENA #128/#132/#136, ARCH #126, LENTE #130, ARTIST #77, founder PNG and unrelated production scenes; do not conflate Q806 with Q804 hosting or independently gated G452 playable interactions. No merge before external gates.
