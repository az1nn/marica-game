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
- **V4 source original versioned**: `docs/artist/assets/S01-A01/V4/S01-A01_CACHORRO_FUNDADOR_V4_ISOLADO_CANDIDATO.png`, SHA-256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e` (174,947 bytes; 344×378 RGBA). Source byte-match verified against the uploaded file. Transparent/opaque alpha only, single connected foreground, 6 px margins. **Preview and concept-board binaries remain unversioned**; see `docs/artist/reviews/S01-A01-2026-10-13-v4-source-audit.md`. No claim of animation, pixel-perfect rendering, atlas, importability or runtime acceptance.
- Preserve approved V1 3×3 roster: dog (founder), capybara, chicken; corn, tomato, carrot. Crops remain gated behind animal R2.

## Next executable gates
1. ARTIST: source-provenance and basic alpha/isolation inspection COMPLETE; preserve accepted V4 art. Pixel density/palette and practical silhouette readability require independent V201/V201a prototype validation; do not silently regenerate a replacement.
2. ARCH: validate SPEC-005 V201/V201a Godot logical scale, pixel grid, filtering, alpha/import pipeline and resource contract via prototype.
3. SCENE: implement one isolated animal-first Godot visual slice only after source/ARCH checks.
4. LENTE: capture exact-head mobile/desktop runtime A/B; independent ART review.
5. SIGA: the stale golden fixture branch failure at `742a06cb` was resolved by preserving both parents in merge commit `25656204` (G433 `master@c0928893`), without changing tests or art. All required exact-head checks at `25656204` PASS (Godot CI, Validate skills, Roblox CI, Web Preview Contract). **ARTIST PR remains draft for the independent ARCH V201/V201a, SCENE and LENTE gates; CI PASS is not runtime approval.**

Ownership: ARTIST approves visual intent/result; SCENE implements; ARCH proves technical integrity; LENTE validates runtime captures; SIGA owns orchestration and merges.

**Current state:** CONCEPT_ACCEPTED / SOURCE_BINARY_VERSIONED / BASIC_SOURCE_QA_PASS / PIXEL_GRID_UNVERIFIED / ARCH_PENDING / SCENE_PENDING / LENTE_PENDING / CI_PASS_RECONCILED_HEAD_25656204 / PR_DRAFT_PENDING_ARCH_SCENE_LENTE / NO_RUNTIME_PASS. REJECT remains valid in subsequent gates.
