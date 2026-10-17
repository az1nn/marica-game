# SIGA claim — SPEC-005 V203 CENA portrait founder technical preview

Owner: SIGA -> CENA (isolated, non-production composition); ARCH, LENTE and ARTIST remain independent gate owners.
Status: ACTIVE / PROPOSED, do not merge; physical-device V201/V201a gates CAPABILITY_BLOCKED.
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
