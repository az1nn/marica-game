# SIGA claim — SPEC-005 V203 CENA portrait founder technical preview

Owner: SIGA -> CENA (isolated, non-production composition); ARCH, LENTE and ARTIST remain independent gate owners.
Status: CLOSED_FOR_WRITES / WATCH_EXTERNAL_GATES; do not merge; physical-device V201/V201a gates CAPABILITY_BLOCKED.
Date: 2026-10-17 America/Sao_Paulo.
Observed master: `bbfc4a24e5da5ab0015fbda83bffc6f2109461f6`.
Branch: `cena/v203-portrait-preview-20261017`.
Task: SPEC-005 V203 preview slice, **not** completed V203, G452 or a human art approval.

## Bounded ownership
Exclusive new paths: `game/scenes/v203_portrait_preview.tscn`, `game/src/presentation/v203_portrait_preview.gd`, `game/tests/v203_portrait_preview_runner.gd`, `.github/workflows/v203-portrait-preview.yml`, `docs/cena/V203-PORTRAIT-PREVIEW.md`, and this claim.
No edits to `game/scenes/farm_iso_view.tscn`, `game/src/presentation/farm_iso_camera.gd`, `game/project.godot`, `game/assets/arch_probes/S01_A01_v4_original.png`, save/domain, specs/tasks status or ARTIST binary.

## Reconciliation
- Base `master@bbfc4a24` and active drafts: ARTIST #77, ARCH #123/#124/#126, GODOT G452 #125.
- #125 G452 diagnostic claim explicitly CLOSED_FOR_WRITES; do not modify or cherry-pick its code without new ownership.
- ARCH #126 claim CLOSED_FOR_WRITES, original PNG source SHA-256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`, git blob `da7806ebfcb051c8fd32ccdbad4760b7136f97dd`.
- Issue #127 dispatches only a *conditional CENA portrait-framing iteration*. New technical scene must not masquerade as actual hydrated founder, final G452, real physical mobile, rights approval, HUD, world occlusion, or artist acceptance.

## Verification and handoff
- Render opt-in farm+founder technical scene under Godot 4.7.2 Xvfb/Mesa at portrait 390x844 and desktop 1280x960; compare responsive zoom to G451 fit, source SHA, nearest filter, feet offset, and camera pivot.
- CI includes a known-bad portrait-zoom mutation: GOOD -> BAD -> RESTORE. Save screenshot + JSON manifest with immutable code head; no game-frame performance claim.
- Only after exact PR HEAD green may CENA evidence be handed to LENTE for **independent** web/real-device exported runtime comparisons, then ARTIST independent human runtime decision.
- Do not merge any PR or tick V201/V201a/V203/V205/G452. Before further writes/merges, reconcile live HEAD/claims and reject any overlapping ownership.

## Technical evidence and claim release — 2026-10-17

- Feature head `735fc90ebaee1d5f9dcf82c4b38a8fe1f8d42e1f`: **16 GitHub Actions SUCCESS, 1 optional SKIPPED, 0 failed**, including G415 typed/lint, dedicated V203 CENA GOOD/BAD/RESTORE, Godot CI, G450/G451, G440–G447 and Validate skills.
- Dedicated [run #39042059775](https://github.com/az1nn/marica-game/actions/runs/39042059775), [artifact #12104357994](https://github.com/az1nn/marica-game/actions/runs/39042059775/artifacts/12104357994): real Godot 4.7.2 hosted Xvfb/Mesa screenshots for 390x844 and 1280x960 + machine-readable SHA/head evidence. Binary images were inspected and match previous technical candidate PNG hashes. Original source blob and SHA verified unchanged.
- 390x844: observed G451 fit zoom 0.7051, candidate focus zoom **1.75**, measured projected founder width **150.5 screen pixels**. 1280x960: unchanged G451 fit zoom **2.0**, founder projected width **172 px**. This is a camera/composition measurement, **not** art/runtime acceptance or physical handset performance.
- Visual CENA technical triage: original dog visible and more legible; farm now reaches/crops left/right viewport edges, with substantial unused upper/lower margins. Foreground occlusion, contact shadow, HUD safe areas and real browser/device behavior are NOT certified. Independent LENTE review remains necessary.
- PR [#128](https://github.com/az1nn/marica-game/pull/128) remains **DRAFT / NO MERGE**; no SPEC checkbox closure; branch work no longer reserves files for active modification.
- This closeout documentation commit produces a **new HEAD** and must receive its own exact-head CI before the branch can be considered fully verified. Historical checks above belong only to the named feature SHA. Do not promote V201/V201a/V203/V205/G452 or override ARCH, LENTE and ARTIST human gates.
