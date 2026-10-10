# ARTIST — V1 screen and asset map (Godot / V2 approved visual language)

**Status:** **V1 3×3 COMPOSITE ART CONCEPT ACCEPTED** (2026-10-09); S01 V3 SCREEN CONCEPT ACCEPTED; DOG FOUNDER CONFIRMED; PET-ALT-001 CAPYBARA and PET-ALT-002 CHICKEN concept boards ACCEPTED; S07-P01..P03 PLANT CONCEPTS ACCEPTED; **S01-A01 ISOLATED DOG CONCEPT ACCEPTED / TECHNICAL_REVISE (V201/V201a OPEN)**; Godot sprites/runtime unverified
**Baseline:** `master@947010158d0bc63d21afcf18c75a0dab187b9e46` (2026-10-09)
**Authority:** SPEC-004 V1 gameplay/screens, SPEC-005 ARTIST V2 G1–G25, `docs/VISUAL-DIRECTION.md`, `docs/lore/CANON.md`.
**Purpose:** Queue individually reviewed screen concepts and corresponding art assets. This document does **not** claim that approved screen layouts, production sprites, or Godot scenes already exist.

## Locked principles

- The **V1** is Godot single-player/offline-first with priority Animals → Plants → Farm Structure → Progression/City → optional Leaderboard.
- The approved **visual target** is ARTIST **V2 full pixel art 2.5D**, not the historical low-poly + pixel-texture look.
- Camera is contextual; mobile-first; modern discreet HUD and restrained feedback; UI accent contrast is stable; no changes to core gameplay, save, or platform.
- All generated items start as `CONCEPT_PENDING`. A human `ACCEPT / REVISE / REJECT` applies to each concept separately. `ACCEPT` concept is **not** runtime acceptance.
- Avoid unapproved founder species/name, NPC identities, magic mechanics, crop species beyond existing specs, and screen-level artwork that implies an online requirement.
- Technical density, atlas, pixel grid, import settings, base resolution, and pixel-perfect policy remain V201/V201a gates owned by ARCH.

## Screen concept queue

| ID | Screen | Priority | Visual assets to map | Source | Status |
| --- | --- | --- | --- | --- | --- |
| S01 | Founder pet interaction & care | P0 / **first concept** | original pet silhouette, pixel poses, context floor/background, selection ring, compact state card, feed/care/treat/interact affordances, status/phase icons | SPEC-001 US-001/002; G452–G454; V202–V205 | **CONCEPT_ACCEPTED V3** / dog confirmed as founder; S01-A01 isolated dog sprite concept NEXT |
| S02 | Inherited farm overview | P0 | compact isometric/2.5D ground tiles, path, pet habitat, starter plots, original farm background, zone cues, minimal HUD, touch targets | G450–G451; G9/G10/G23 | QUEUED |
| S03 | Pet health / treatment | P0 | sick/healthy/recovery expressions, veterinarian/treatment iconography, contextual care panel | SPEC-001 US-002; G426/G453/G454 | QUEUED |
| S04 | Pet lifecycle and lineage | P0 | stage variants, portrait, soulbound marker, pedigree/lineage tree UI, affection/trait indicators | SPEC-001 US-001/003; G453 | QUEUED |
| S05 | Respectful end-of-life | P0 | restrained transition, remembrance visual, simple message framing | SPEC-001 US-004; G455 | QUEUED |
| S06 | Two successors / continuation | P0 | distinct successor portraits/silhouettes, generation marker, lineage continuation UI | SPEC-001 US-004; G456 | QUEUED |
| S07 | Cultivation / planting | P1 after animal visual gate | soil/crop tiles, seed/bud/growth/maturity sprites, **milho/tomate/cenoura** (3 accepted initial concepts), one expanded-slice fruit tree, plot-selection and harvest effects | G460–G463; V206–V207; G8/G20 | **P01–P03 CONCEPT_ACCEPTED**; S07 screen and runtime **LOCKED_BEHIND_R2** |
| S08 | Harvest / inventory / animal food | P1 | crop/fruit/item icon set, inventory cells, food grades/states, harvest prompt | G464–G466; G454 | LOCKED_BEHIND_R2 |
| S09 | Farm build and expansion | P1 after plants | fences, modular shelter, barn/building upgrade states, placement overlay/valid placement cells, capacity affordance | G470–G475; V208 | LOCKED_BEHIND_R3 |
| S10 | Active slots / Nursery / Legacy Reserve | P1 after core | compact slot cards (~4 initial), active/reserve indicators, successor storage portraits | G471–G472 | LOCKED_BEHIND_R3 |
| S11 | Town / local services | P2 | functional town tiles/landmarks, veterinarian, seed/food market, readable NPC silhouettes/props/signs, short direct transition | G480–G484; V210 | POST_CORE |
| S12 | Offline-safe menus / save/continue/settings | P0 enabling UX | launch/continue affordance, save/loading/backup notices, accessible HUD/settings iconography | US-401; G440–G447/G457 | QUEUED (layout not fixed) |
| S13 | Optional asynchronous leaderboard | P2 | score/rank cells, unavailable/offline state, no forced auth screen | G490–G498; US-405 | OPTIONAL_POST_CORE |

**Not V1 screen targets:** real-time multiplayer, peer-to-peer marketplace/trading, Robux or Roblox avatar UI. Fishing is optional only after G485 review.

## Approved animal-role split

| Asset ID | Depiction | Approval | Role / next gate |
| --- | --- | --- | --- |
| **S01-A01** | Tricolor puppy from approved S01 V3 | Screen V3 accepted; isolated character **CONCEPT_ACCEPTED**; technical production **REVISE** | **Founder / P0 first**, next isolated sprite review |
| **PET-ALT-001** | Brown capybara-like companion with blue bandana / green pack | Character **concept board ACCEPTED**, independent visual | **Other animal (not founder)**; production sprite pending, no backpack mechanics assumed |
| **PET-ALT-002** | Cream-white hen, red comb, golden beak/feet | Character **concept board ACCEPTED**, independent visual | **Third V1 animal type**, not founder; production sprite pending, no unapproved egg/food gameplay assumed |

See `docs/artist/reviews/2026-10-09-founder-dog-and-alternate-capybara.md` for founder-role decision, `docs/artist/reviews/PET-ALT-002-2026-10-09-chicken-accepted.md` for approved chicken, and `specs/004-godot-v1-transition/spec.md` §3.1 for binding initial V1 scope: **exactly 3 animal types and exactly 3 named initial plant/crop types (milho, tomate, cenoura)**. Existing G463 fruit tree belongs to the later expanded crop slice.

## Consolidated V1 ARTIST board — ACCEPTED (concept only)

The user explicitly approved the revised **3 animal × 3 crop** composite board on **2026-10-09**, after replacement of the earlier mistaken lettuce/pepper depictions. **Approved species:** founder **cachorro**; alternate **capivara**; alternate **galinha**; and crops **milho S07-P01 / tomate S07-P02 / cenoura S07-P03**. The approved 1536×1024 PNG `wide_game_concept_art_design_sheet_in_pixel_art_2.png` has SHA-256 `64985c0a27ef2975bd8c44d43c1e0e8a9a6cfac881862af14850d69050894098` and exists in the conversation, **not as a committed GitHub binary**.

**Authoritative visual acceptance:** `docs/artist/reviews/V1-3X3-ART-CONCEPT-2026-10-09-accepted.md`; prior correction rationale: `docs/artist/reviews/V1-3X3-ART-CONCEPT-CORRECTION-2026-10-09.md`. Scope is reference/composition only: the board's egg-production caption and illustration-only animation sheets/technical grid labels do **not** add gameplay rules, pass ARCH/LENTE/runtime checks, or complete S01-A01 isolated sprite. **Next unchanged:** founder dog isolated sprite review first, with SPEC-005 R2/ARCH V201–V201a gates respected.

## Current S01-A01 human visual gate (2026-10-10)

The actual *single-dog* cutout candidate was prepared from a new pixel-art concept sheet: **362×400 transparent RGBA PNG**, plus checkerboard preview. The **three animal / three plant V1 concept board remains accepted**, and this **isolated dog source sprite concept was approved on 2026-10-10**. Technical review remains **REVISE** pending V201/V201a. Evidence and SHA-256 for the conversation-local art files: `docs/artist/reviews/S01-A01-2026-10-10-isolated-dog-preview-pending.md`. **Visual concept ACCEPTED**; do not mark production sprite, Godot import, atlas, or animation complete until ARCH/ART/LENTE technical checks run. Audit: `docs/artist/reviews/S01-A01-2026-10-10-technical-audit.md`.

## Reusable asset families — mapped requirements, not approved artwork

### A. Animal-first (first production family)
- Founder pet: **tricolor puppy from accepted S01 V3** (human visual role decision; no pet name chosen); original cozy-fantasy silhouette and body proportions, orientation/idle/walk/eat/interact, care, health and age-state readable variations; animation economy follows G7. Other animals must not silently replace the founder.
- Successors: **two** visually distinguishable next-generation silhouettes/portraits; lineage signification without novel mutation mechanics.
- Pet UI: selectable outline/anchor, portrait, care actions (feed, care, treat, interact), hunger/hygiene/affection/health indicators as already modeled, life stage, pedigree, soulbound state, optional critical alert (not permanent dense bars).

### B. Farm/environment
- Terrain tile families: grass, dirt, cultivated soil, paths, edge transitions, vegetation, shadows; 2.5D depth/layer cues.
- Structures: pet shelter, fences, farm utility/build structures, modular build/upgrade variants and interaction points.
- Contextual light/day-night palettes; weather/season primarily palette/tile variations; effects budget under ARCH gate.
- Farm/navigation HUD and selection affordances with generous touch zones.

### C. Plants/crops
- **Exactly 3 initial crop/plant families:** S07-P01 **milho**, S07-P02 **tomate**, S07-P03 **cenoura** — all individual art concepts human-accepted on 2026-10-09. Their PNG sources are chat artifacts, not repository binaries or production imports. Plus **1 fruit tree in the later expanded cultivation slice** under unchanged SPEC-004 US-403/G463; each stage (seed/young/growing/ripe) as domain requires; harvest-ready animations and harvested item icons. See `docs/artist/reviews/S07-P01-P03-2026-10-09-plants-accepted.md`.
- Inventory & food feedback; no speculative new botanical species or cultivation mechanics.

### D. City/services
- Clear service facades/wayfinding, veterinarian and market landmarks, NPC silhouettes with modest professional accessories, service panels.
- Lake/fishing visual elements are **deferred/conditional**, not part of the core slice.

### E. Interface/shared
- Modern discreet UI: typography, accessible buttons, selected/disabled/focus states, icon family, panels, modal/toast/confirmation, safe-area variants for mobile/web, save/offline indicators, contextual overlays.
- Composition at mobile and desktop ratios to be tested; exact resolution/pixel art import and atlas settings remain open.
- Static concepts are not exports/importable sprite sheets or runtime screenshots.

## Individual approval protocol

1. Produce exactly **one screen concept** at a time and visibly mark it `CONCEPT`.
2. Review against G1–G25 (style), relevant SPEC-004 mechanics (no invented behavior), pet focus, legibility on mobile and touch hierarchy.
3. Record one `ACCEPT / REVISE / REJECT` per screen; a revision creates a new version and preserves older references.
4. Following concept acceptance, separately review **individual sprites/assets** before any Godot integration.
5. Runtime approval only after V201/V201a technical decision, ART/ARCH gates, LENTE exact-head screenshots and A/B independent review.

**S01 concept decision:** `ACCEPT` on V3, recorded in `docs/artist/reviews/S01-2026-10-09-v3-accepted.md`. This approval applies to the screen-level reference only; it does **not** certify the source PNG as repo-committed or runtime-accepted. **Founder decision (resolved):** user confirmed **the dog is founder; the capybara is another animal**, in `docs/artist/reviews/2026-10-09-founder-dog-and-alternate-capybara.md`. The capybara-like sheet formerly printed `S01-A01 — PET FUNDADOR` remains **ACCEPT as PET-ALT-001 visual concept only**, NOT founder and NOT a Godot spritesheet; its historical review is preserved at `docs/artist/reviews/S01-A01-2026-10-09-concept-accepted.md`. **S01-A01 now designates the isolated dog founder sprite concept (ACCEPTED by human on 2026-10-10; technical production REVISE).** Next: generate a **single isolated dog sprite** faithful to S01 V3 for human review; capybara family remains queued separately. No claim of canonical pet name, animal behavior, source PNG committed, runtime acceptance or import. Do not advance S02 or other screen concepts until the S01 asset review flow reaches its own gates.
