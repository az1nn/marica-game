# ARTIST HANDOFF — Maricá Game

Status: DIRECTION V2 APPROVED / S01-A01 V4 VISUAL CONCEPT ACCEPTED / PRODUCTION GATES PENDING
Approved visual direction: 2026-10-09, G1–G25; full pixel art 2.5D
Canonical direction ledger: docs/artist/grilling/2026-10-09-v2-direction.md
Spec Kit: specs/005-pixel-art-v2-migration/ (V201/V201a and R2 remain open)
Runtime: Godot V1, single-player/offline-first; gameplay priority Animals → Plants → Farm Structure.

## S01-A01 — founder dog (2026-10-13)
- S01 screen V3 concept ACCEPT remains valid. S01-A01 V3 *concept sheet* REVISE (2026-10-12) also remains in history.
- S01-A01 **V4 isolated tricolor founder-dog visual concept ACCEPT** (2026-10-13). Preserve red bandana, floppy ears, friendly expression, 3/4 silhouette and approved pixel-art 2.5D proportions; approval is not for an importable production sprite.
- Decision records: docs/artist/reviews/S01-A01-2026-10-12-v3-revise.md and docs/artist/reviews/S01-A01-2026-10-13-v4-concept-accepted.md (PR #77 until merged).
- Actual V4 source and preview PNGs are still **conversation-local**, unversioned in GitHub. Do not infer image SHA, alpha quality, importability, animation, sprite atlas, or exact-head Godot/runtime acceptance.
- Preserve approved V1 3×3 roster: dog (founder), capybara, chicken; corn, tomato, carrot. Crops remain gated behind animal R2.

## Next executable gates
1. ARTIST: recover and version the actual V4 PNG, verify silhouette/palette/alpha/pixel clusters against the approved visual without silently regenerating a replacement.
2. ARCH: validate SPEC-005 V201/V201a Godot logical scale, pixel grid, filtering, alpha/import pipeline and resource contract via prototype.
3. SCENE: implement one isolated animal-first Godot visual slice only after source/ARCH checks.
4. LENTE: capture exact-head mobile/desktop runtime A/B; independent ART review.
5. SIGA: reconcile ownership and exact-head CI before merge. PR #77 Godot CI failed on the G424 parity step at head `3a2d4009`; do not waive or classify this as a visual failure without proof.

Ownership: ARTIST approves visual intent/result; SCENE implements; ARCH proves technical integrity; LENTE validates runtime captures; SIGA owns orchestration and merges.

**Current state:** CONCEPT_ACCEPTED / SOURCE_BINARY_MISSING / ARCH_PENDING / SCENE_PENDING / LENTE_PENDING / CI_RED / NO_RUNTIME_PASS. REJECT remains valid in subsequent gates.
