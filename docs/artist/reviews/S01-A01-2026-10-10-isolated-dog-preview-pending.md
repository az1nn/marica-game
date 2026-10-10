# ARTIST S01-A01 — isolated founder-dog preview for human review (2026-10-10)

**Project:** `az1nn/marica-game`  
**Related:** SPEC-004 / SPEC-005, S01 V3 `CONCEPT_ACCEPTED`, founder role confirmed as **dog**, separate capybara PET-ALT-001 and chicken PET-ALT-002.  
**Visual gate:** `CONCEPT_PENDING` — **human ACCEPT / REVISE / REJECT not yet received for this isolated PNG**. Do not mark task G-ROSTER-ART-FOUNDING-DOG complete on preview generation alone.

## New preview evidence

- **One isolated tricolor founder puppy image**, faithfully based on the approved S01 V3 / V1 3×3 visual language: brown/orange, black and white fur, dark floppy ears, white blaze/paws, friendly expression, **red paw-print bandana**. No backpack. 3/4 angle.
- Source art study: `a_clean_high_resolution_sprite_sheet_style_concep.png` (conversation-generated sheet, *not* a vetted spritesheet or Godot runtime), SHA-256 `52cbd6056dc315a60bc8f0a01ab3aecc084cd48ac3b9bd5bd8e8355c4944e1d7`. Additional experimental study in conversation should not be automatically accepted.
- Cropped and masked **individual source PNG**: `S01-A01_CACHORRO_FUNDADOR_CONCEPT_SPRITE.png`; **362 × 400 px RGBA**, transparent outside the silhouette, SHA-256 `461a0132f4778168d1e0fe093ab26534c055c16f773e4a37fa2426c7ab66385e`.
- Transparent-preview checkerboard composite: `S01-A01_PREVIEW_CHECKER.png`, SHA-256 `23d49b78be09048974e99676eb628cfe962502a609f4b79e1743ff8fa0c62afc`.
- Source and derivative PNGs exist in this ChatGPT conversation's downloadable artifacts; **none of these binaries was committed to GitHub through this documentation-only PR**. Digests are preservation/review identifiers rather than proof of repository storage.

## Scope / gate hygiene

**Preview candidate only**. Do not claim the PNG is an approved production sprite, a `64×64` or `128×128` exact-pixel cell, multi-view atlas, aligned animation frames, LENTE screenshot, or Godot-imported texture. The crop's source-scale and jagged alpha outline must be reviewed before any production scaling/import. `S01-A01` is the *only* founder; capybara and chicken remain separate approved *concept board* identities.

**Human review question:** Does this individual 3/4-angle tricolor puppy correctly preserve the founder identity from S01 V3? Respond `ACCEPT / REVISE / REJECT`. Human acceptance approves only this isolated sprite **concept**, not technical import, animation, ready-to-ship production, or release.

**Next on ACCEPT:** ARCH V201/V201a pixel grid + transparency/alpha quality + source-scale constraints; ART review; then one production animation set at a time and SCENE/LENTE actual Godot capture. Preserve animals-first P0, S02 queue and S07 crop gate R2. **No automatic merge.**


## Human decision — 2026-10-10

**ACCEPT** — user explicitly approved the isolated S01-A01 tricolor founder-dog preview and authorized proceeding to the next production gates. This supersedes only the `CONCEPT_PENDING` review state above; original pending evidence remains preserved for audit. **Final state: `ISOLATED_CONCEPT_ACCEPTED`.** The approved PNG remains a conversation-local 362×400 RGBA candidate, not a committed GitHub binary or a validated Godot sprite atlas. Next: verify source bytes and alpha/pixel grid, resolve ARCH V201/V201a constraints, produce aligned production poses, validate ART/SCENE, and run Godot/LENTE exact-head checks before claiming runtime PASS. No merge or engine integration authorized solely by this acceptance.
