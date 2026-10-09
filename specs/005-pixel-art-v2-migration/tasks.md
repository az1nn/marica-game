# SPEC-005 — ARTIST V2 Roadmap / Tasks

**State:** direction approved; execution queued by SIGA.
**Priority:** Animals → Plants → Farm Structure. Domain SPEC-004 G425–G449 remains P0; this is its visual companion, not a replacement.
**Source:** G1–G25 ledger; `docs/artist/SIGA-ARTIST-V2-RECONCILIATION.md`.

## R0 — Governance / Spec Kit

- [x] **V200** Human-approved V2 visual direction G1–G25 captured with provenance.
- [x] **V200a** Spec/plan/tasks added; approved target visually distinguished from running V1 in `docs/VISUAL-DIRECTION.md`.
- [x] **V200b** PR #58 reconciled and squash-merged into `master@8ac31108dde8e24fa319b7f51dbbf58c1d0c492c` after exact-head Godot CI, Validate skills and Roblox CI PASS (Roblox Behavioral SKIPPED).

## R1 — Technical contract (ARCH + ART)

- [ ] **V201** Prototype Godot full pixel art 2.5D; decide logical resolution, scale, filtering, layer order, camera and mobile/render budget based on tests.
- [ ] **V201a** Define import/atlas/artifact licensing and size constraints; validate sample sprites, without mass production.

## R2 — Animal first (ART + SCENE + ARCH + LENTE)

- [ ] **V202** Produce one original fantasy-cozy animal sprite set representative of G3/G7.
- [ ] **V203** Integrate this animal into a real Godot sample scene without gameplay/domain changes.
- [ ] **V204** Validate states-on-demand and mobile HUD/accessibility; check zoom and pixel edges.
- [ ] **V205** Capture baseline/current A/B runtime with LENTE; pass independent ART and ARCH gates or reject.

**R2 gate:** full pixel-art animal presentation accepted; no advancement to plants before it passes.

## R3 — Plants

- [x] **V206-concepts** Human visual acceptance of isolated concept PNGs for three initial crops (S07-P01 milho, S07-P02 tomate, S07-P03 cenoura), recorded in ARTIST review. This *early concept approval* does not open R3 Godot integration, does not close V206/V207, and does not bypass the animal-first R2 gate.\n- [ ] **V206** Crop stages and growth/harvest animation language (G8/G20) tied to existing state.
- [ ] **V207** Validate runtime evidence/mobile performance and care/harvest semantics unchanged.

## R4 — Farm and town

- [ ] **V208** Test modular structures and context-only building overlays (G9/G10/G21/G22).
- [ ] **V209** Validate cinematic day/night vs low-cost palette seasonal treatment (G18/G19/G24); no visual masking of player interactions.
- [ ] **V210** Town/NPC visual language only after SPEC-004 core priority gates.

## Acceptance and release

- [ ] **V211** Validate actual Godot runtime, exact-head CI, responsive screenshots, A/B, accessibility and browser/mobile performance.
- [ ] **V212** For deployment follow-up, validate Vercel and Cloudflare using the same immutable Godot web export/build artifact SHA. Do not claim deploy pass in this documentation PR.

**Human gates:** G1–G25 direction already approved; request further input only for materially new art alternatives or rejected real-world visuals.
