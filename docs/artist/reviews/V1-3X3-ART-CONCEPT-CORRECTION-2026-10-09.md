# ARTIST — V1 3×3 composite art-concept correction (2026-10-09)

**Scope:** revise *only* the combined visual reference board formerly headed `S01 — ANIMAIS E PLANTAS INICIAIS (V1)` to accurately reflect the three individually approved crop concepts from another ARTIST session. This is a *new composite preview request*, not automatic production or runtime acceptance.

## Binding V1 content roster / identity

| Position | ID | Approved depiction | Status |
| --- | --- | --- | --- |
| Animal 1 | S01-A01 | Tricolor puppy, **founder**, red scarf; exact S01 V3 identity | S01 V3 scene concept ACCEPTED; isolated founder dog sprite PENDING |
| Animal 2 | PET-ALT-001 | Cozy brown capybara, blue neckerchief and green pack | Individual character concept ACCEPTED (not founder) |
| Animal 3 | PET-ALT-002 | Cream/white hen, red comb, orange-gold legs | Individual character concept ACCEPTED |
| Plant 1 | **S07-P01** | **Milho**: tall green stalk, long arching leaves, golden visible ear in husk and golden tassels | Isolated plant visual ACCEPTED |
| Plant 2 | **S07-P02** | **Tomate**: dense green-leaf tomato plant with multiple large red ripe tomatoes | Isolated plant visual ACCEPTED |
| Plant 3 | **S07-P03** | **Cenoura**: vivid orange root with broad, branching bright-green foliage | Isolated plant visual ACCEPTED |

Approved crop concept provenance names (conversation-local PNG artifacts; not GitHub binaries):
- `milho_pixelado_com_espiga_dourada.png`
- `planta_de_tomate_pixelada_em_destaque.png`
- `cenoura_pixel_art_isométrica.png`

Source/spec authority: `specs/004-godot-v1-transition/spec.md` §3.1 and `docs/artist/reviews/S07-P01-P03-2026-10-09-plants-accepted.md`. All six are V1 initial types. The expanded-slice G463 fruit-tree requirement is **not a fourth initial plant**.

## Correction to older composite board

Earlier combined board `a_detailed_game_asset_concept_sheet_ui_in_pixel_ar.png` mistakenly showed **P01 ALFACE, P02 TOMATE, P03 PIMENTA**. This botanical roster is **REJECTED as a representation of initial V1 content**; its approval banner, illustrative arbitrary maturity timings, item/egg-production claims and “Godot-ready” wording do not supersede SPEC-004 or individual ARTIST reviews.

**Required visible deltas in the revised board:**
1. Replace all lettuce panels/icons/tile shots with tall **milho S07-P01** matching approved source (cob, husk, foliage, tassels).
2. Keep **tomate S07-P02** but adapt image to the *approved* dense leafy vine with multiple ripe red tomatoes; retain its identity.
3. Replace all pepper panels/icons/tile shots with **cenoura S07-P03** showing orange edible root and distinctive bushy green top, matching its approved source.
4. Ensure labels, mini-stage studies, legends, technical inventory text, and the isometric farm context consistently use **only milho/tomate/cenoura**. Do not accidentally reintroduce alface/pimenta.
5. Preserve **exactly** the established three animals, visual hierarchy, cozy pixel-art 2.5D, Portuguese typography and board proportions. The **dog is the sole founder**.
6. Drop inaccurate gameplay claims such as automatic chicken egg production, forced unique animal mechanics, or verified sprites/atlas/import settings.
7. Annotate the composite as **UPDATED CONCEPT / COMPOSITE REVIEW PENDING**; individual crop/animal approvals remain valid while a redesigned *combined board* requires separate human review.

## Scope / acceptance boundary

No asset PNGs are claimed to have been committed to this PR and no Godot files or gameplay mechanics changed. The composite art revision must not be mistaken for transparent isolated sprites, tested stage sprites, LENTE exact-head runtime screenshots, or R2/R3 gate PASS.

**Handoff:** present updated 3×3 art concept as a new visual image for review; next independent V201/V201a, ART/ARCH/LENTE/SCENE gates remain intact.
