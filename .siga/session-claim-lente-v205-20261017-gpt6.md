# SIGA -> LENTE exclusive claim — SPEC-005 V204/V205 founder V4 A/B

Status: ACTIVE / TECHNICAL_CAPTURE_ONLY / NO_MERGE
Date: 2026-10-17 (Brasília); owner: LENTE.
Source PR: #128 CENA at exact `001e0469b4d848e4c005a62e888e4de12af767f4`.
Branch: `lente/v205-founder-runtime-ab-20261017` (stacked **on top of CENA branch**, not `master`).
Observed `master@bbfc4a24e5da5ab0015fbda83bffc6f2109461f6`.

## Concurrency and protection
- CENA #128 claim CLOSED_FOR_WRITES, ARTIST #77, ARCH #123/#124/#126 and GODOT #125 draft/independently owned. No LENTE PR or overlapping LENTE branch observed at claim start.
- Exclusive LENTE paths: this claim; `game/tests/lente_v205_capture_runner.gd`; `tools/lente/v205_analyze.py`; `.github/workflows/lente-v205-runtime-ab.yml`; `docs/lente/V205-FOUNDER-V4-REVIEW.md`. Any other path requires fresh post-claim reconciliation.
- **No modifications** to CENA V203 scene/script/tests, farm/G451 camera, G452 save/domain, PNG source/assets, ARTIST decisions, spec tasks, export defaults or default Godot main scene.
- Approved V4 original source: Git blob `da7806ebfcb051c8fd32ccdbad4760b7136f97dd`; SHA256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`.

## Bounded purpose
Generate independent **fresh actual Godot 4.7.2 software GL frames** at the LENTE exact code HEAD: portrait CENA vs original G451 baseline, sampling nearest vs linear and background light/dark, desktop. Measure bounding-box empty area and crop of non-background pixels, and compare nearest/linear. Capture metadata into CI artifact run through repo-local LENTE evidence tool. These are technical A/B controls; negative controls are not human ARTIST judgments.

## Hard gates
- A LENTE run is a new commit, thus its CI must be checked against its own **exact head**. Do not claim screenshots verify a later doc-only head.
- V201/V201a ARCH **REVISE/CAPABILITY_BLOCKED** physical Android Chrome/iOS Safari / rights / logical pixel grid, so no V204/V205 acceptance, no production runtime or merge. G452 hydrated runtime, camera input/HUD, Y-sort/contact shadow and actual browser WebGL of **this** candidate remain unverified unless separately evidenced.
- Findings route to CENA/ARCH via SIGA; LENTE cannot override ARTIST. REVISE is a runtime-layout evaluation, not a concept rejection.
