# ARTIST S07-P01..P03 — V1 initial crops accepted (2026-10-09)

**Decision:** `CONCEPT_ACCEPTED` for **all three individually generated plant previews**, user explicitly responded **"Aprovados os 3"** after seeing milho, tomate and cenoura. This approves *botanical identities and visual concept assets*, not production import, the S07 screen, multi-stage sprites or runtime.

**Scope:** exactly **three initial V1 crop/plant types** under SPEC-004 §3.1. Original visual authority: ARTIST V2 **G1–G25 full pixel art 2.5D**; target is Godot V1 single-player/offline-first. Initial animals remain the tricolor founder dog, capybara and chicken. The distinct G463 expanded-slice fruit tree is not an additional initial crop.

## Reviewed individual sources

| Asset ID | Initial crop | Source conversation PNG | Dimensions / mode | SHA-256 of original PNG | Decision |
| --- | --- | --- | --- | --- | --- |
| S07-P01 | **Milho** | `milho_pixelado_com_espiga_dourada.png` | 1254 × 1254, RGBA with alpha | `cf86a3d6527394ced8152e38253d37aee75923acba57ec57d7f4307698b2c6f1` | **ACCEPT** |
| S07-P02 | **Tomate** | `planta_de_tomate_pixelada_em_destaque.png` | 1254 × 1254, RGBA with alpha | `edbd94df2213b3f4f95b576486de66a3fa864771f8d7ae460feecb5bf3305882` | **ACCEPT** |
| S07-P03 | **Cenoura** | `cenoura_pixel_art_isométrica.png` | 1254 × 1254, RGBA with alpha | `890a45c551988ce6263e004075b8333d2574869dc69d8f45febec924b9abee99` | **ACCEPT** |

**Appearance:** isolated bright-green corn stalk with exposed golden cob; lush tomato plant with multiple ripe red tomatoes; leafy carrot top with visible tapered orange root. All three are standalone polished pixel-art 2.5D concept assets against transparent backgrounds, no surrounding scene or approved crop interaction UI.

## Acceptance and implementation boundary

| Gate | Status |
| --- | --- |
| Crop roster (milho/tomate/cenoura, no fourth initial type) | **ACCEPTED** |
| Three individual source previews / visual identity | **CONCEPT_ACCEPTED** |
| S07 complete cultivation screen | NOT_APPROVED |
| Seed / young / growing / ripe variants | NOT_GENERATED |
| Harvest/item icons and animations | NOT_GENERATED |
| Pixel grid, scale, atlas, licensing and import policy V201/V201a | PENDING ARCH |
| Godot import / in-game appearance / planting-harvest loop / saved crop state | NOT_IMPLEMENTED / NOT_VERIFIED |
| LENTE exact-head screenshot A/B, mobile UX, performance and runtime checks | NOT_RUN |
| Release / deploy / binary assets committed to repository | NOT_CLAIMED |

The PNG files were produced in the conversation. Their SHA-256 fingerprints identify the exact **approved source files**, but **they are not committed to this PR**. A downloadable user-facing ZIP of all three PNGs and manifest was prepared separately; no GitHub storage is implied.

**Important:** human-selected species resolves `G-ROSTER-PLANTS-NAMES` as product intent. DESIGN/LORE may refine non-conflicting botanical presentation and food-use rules in their own approved domain. It does *not* authorize unexplained genetics, growth durations, yields, effects or additional crops.

## Ordered follow-through

1. Preserve R2 animal-first runtime gate: no advancement of Godot plant integration until animals / V205 verified.
2. With ARCH V201/V201a settled, create production-sized assets for each accepted species and 4 crop-state variants under V206; review source lineage and each state's pixel clarity.
3. Integrate offline crop-state / save and G462/G464 flow, independent LENTE/ART/ARCH review under V207.
4. Keep G463 fruit tree in expanded cultivation slice; do not expose it among the *three initial* crops.

**Audit:** this is an append-only ARTIST human approval entry; earlier "species TBD" text in prior reviews is historical, now superseded for initial plant identity only.
