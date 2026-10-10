# ARTIST S01-A01 — Human acceptance of character concept board (2026-10-09)

**Project:** az1nn/marica-game  
**Stage:** isolated character art concept sheet / directional visual reference  
**Decision:** **ACCEPT (visual concept board)** — explicit human message **"Aprovado"** in direct response to the S01-A01 image generated in chat.  
**Scope:** SPEC-005 G1–G25, ARTIST V2 full pixel-art 2.5D. Continue SPEC-004 gameplay priority; no runtime or architecture mutation.

## Approved depiction and provenance

- Name on board: `S01-A01 — PET FUNDADOR`; status printed in image: `PARA APROVAÇÃO` (historical text within the approved concept, not a final UI label).
- Concept sheet PNG generated in chat, **1536 × 1024 px**, RGBA; local SHA-256 `1c33037535efc835ea87f153c1fd5fc8b6fd0f4353dcd8a4066342be36bac12a`.
- A **capybara-like, rounded pixel pet** with brown coat, blue neckerchief and green pack, shown in a 3/4 hero pose, four views, schematic idle/walk/run/happy sequences, palette, details and one farm-context vignette.
- This board is a **design reference**, **not** an isolated transparent PNG sprite, precisely tiled spritesheet, functioning animated resource, verified frames, Godot import, or runtime screenshot.
- The source PNG exists in the conversation artifact only. **Not uploaded/committed to this GitHub PR**; digest identifies original without implying repo provenance.

## Canon and visual conflicts — do not resolve silently

The previously approved `S01 V3` **screen composition** depicts a tricolor puppy-like pet. S01-A01 depicts a **capybara-like** pet with blue bandana and pack. Both human approvals are valid **at their respective scopes**, but they cannot automatically be asserted as the *same canonical founder design*. ART + DESIGN/LORE must reconcile canonical animal identity and screen consistency before replacing S01 V3 artwork. Human ACCEPT of this board does **not** authorize new biological species, lore, backpack mechanic, branding/logos, inventory capability, or gameplay abilities.

## Approval matrix

| Gate | Result |
| --- | --- |
| S01 V3 screen-layout concept | ACCEPT, separate prior review |
| S01-A01 pixel-pet concept sheet visual | **ACCEPT** |
| Founder identity/species consistency S01 V3 × S01-A01 | **DOMAIN_CONFLICT / OPEN**, do not silently override |
| Individual transparent production sprite and poses | NOT_GENERATED / NOT_VERIFIED |
| Pixel dimensions noted as 64x64 / 128x128 on board | CONCEPT LABELS, NOT MEASURED SOURCE |
| Godot V201/V201a pixel/atlas/camera contract | PENDING ARCH |
| Production animation and import | NOT_IMPLEMENTED |
| LENTE exact-head captured runtime A/B | NOT_RUN |
| Visual/runtime integration merge/deploy | NOT_AUTHORIZED |

## Next bounded ARTIST action

1. Reconcile the conflicting founder **depictions** with DESIGN/LORE and the human owner without rewriting either earlier approval.
2. Prepare **one isolated, transparent S01-A01 production sprite** preserving whichever founder depiction is confirmed; no false framing of the board as ready-to-import assets.
3. Review source sprite separately, then pose-specific frame assets with deterministic grid under V201/V201a ARCH gate.
4. Keep S02/plant assets gated as before; no overwrite, merge, export, render or runtime changes based on this visual acceptance alone.

---

## Subsequent human clarification — 2026-10-09 (append-only addendum)

The user decided explicitly: **"Outro animal, o cachorro é o fundador."** Therefore the capybara-like animal on **this approved board** is **PET-ALT-001, an additional non-founder animal**. The original heading printed `S01-A01 — PET FUNDADOR` is a **mislabel in the historical illustration**, not the game canon. The **tricolor puppy** in the approved S01 V3 screen remains the sole designated founder. **S01-A01** now refers to the still-pending isolated founder dog sprite, **not** this capybara concept board. This classification supersedes the previously open role conflict *without rescinding the visual acceptance* of the capybara concept.

Authoritative decision: `docs/artist/reviews/2026-10-09-founder-dog-and-alternate-capybara.md`. No gameplay/LORE additions, import/animation/runtime sign-off, or materialized sprite are implied.
