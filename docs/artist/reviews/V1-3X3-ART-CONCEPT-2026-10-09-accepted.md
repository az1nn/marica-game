# ARTIST — 3×3 V1 composite visual concept / human acceptance

**Project:** Maricá Game (`az1nn/marica-game`)  
**Date:** 2026-10-09  
**Stage:** consolidated art-concept board (not production assets, Godot scene or runtime capture)  
**Decision:** **ACCEPT — human visual approval** (“Aprovado”) in direct response to the **revised** 3×3 board.  
**Supersedes for composite reference:** former collage `a_detailed_game_asset_concept_sheet_ui_in_pixel_ar.png`, which incorrectly featured lettuce and pepper.

## Accepted reference and provenance

- Conversation image: `wide_game_concept_art_design_sheet_in_pixel_art_2.png`
- Actual source: **1536 × 1024 px**, PNG **RGB**, SHA-256: `64985c0a27ef2975bd8c44d43c1e0e8a9a6cfac881862af14850d69050894098`.
- Source binary was created in the ChatGPT conversation and remains **conversation-local, not GitHub-committed**. SHA and path are provenance identifiers, not proof of GitHub or Godot asset availability.
- Reference style: full pixel-art 2.5D, cozy Maricá Game farm, readable 3/4 animal views and iconic plants; illustrative directional-turnaround, animation, growth and in-scene panels. The approved **board composition** is a visual reference, not an in-engine representation.

## Frozen initial V1 visual roster — exactly 3 + 3

| ID | Visual | Role / accepted details |
| --- | --- | --- |
| **S01-A01** | Tricolor **dog** with red bandana | **Only founder**, preserves S01 V3 established puppy |
| **PET-ALT-001** | Brown **capybara**, blue bandana, green pack | Another animal, not founder |
| **PET-ALT-002** | Cream-white **chicken**, red comb and golden legs | Third animal, not founder |
| **S07-P01** | **Milho / corn** | Lush tall green stalk, exposed golden cob |
| **S07-P02** | **Tomate / tomato** | Leafy vine with multiple ripe red tomatoes |
| **S07-P03** | **Cenoura / carrot** | Bright orange root and distinct lush green tops |

The three plant concepts were **separately human-approved**; the new 3×3 board is now also human-accepted as the **consolidated art concept**. Preserve their original standalone concept references. Canonical species/quantities live in SPEC-004 §3.1 and `docs/artist/reviews/S07-P01-P03-2026-10-09-plants-accepted.md`. G463 fruit tree is for the expanded cultivation slice, not a fourth initial crop.

## Acceptance boundary and design/technical guards

- **APPROVED:** overall 3×3 board layout, style, composition, chosen species, palette direction and readable depiction of each animal/crop.
- **NOT approved as new mechanics:** board caption about chicken egg production, production timings, backpack inventory, or claims of functional items. These remain **illustrative only**; require DESIGN/LORE specification if ever proposed.
- **NOT production evidence:** turnarounds, stage sequences, `idle/andar/correr/interagir` grids and visible `64 × 64` dimensions are **concept drawings/labels**, not frame-accurate sprite atlases, verified technical resolution or separately approved animation files.
- **NOT completed:** isolated founder-dog production sprite `S01-A01`; independent capybara/chicken frame sets; three plants' actual growth sprites; Godot imports/engine integration; V201/V201a ARCH decisions; LENTE current-runtime screenshot/diff; interaction or performance gates.
- Green `STATUS: APROVADO (V1)` printed inside the image denotes the **art-concept direction**, not a release-ready V1 or CI/run verification.
- The previous crop-content mismatch (alface / pimenta) is **corrected in this accepted board**, per `docs/artist/reviews/V1-3X3-ART-CONCEPT-CORRECTION-2026-10-09.md`; preserve that audit trail.

## Handoff

`3X3_COMPOSITE_CONCEPT_ACCEPTED` → **S01-A01 isolated founder dog sprite (still PENDING)** → independent visual `ACCEPT / REVISE / REJECT` → ARCH V201/V201a → ART/SCENE/Godot integration → LENTE exact-head A/B → SIGA release gates. Do not promote S07 plants or S02 scenes past their existing locks solely because of composite art acceptance.
