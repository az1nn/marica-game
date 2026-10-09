# SPEC-005 — ARTIST V2 Full Pixel Art 2.5D Migration

**Status:** VISUAL DIRECTION APPROVED / IMPLEMENTATION PLANNED
**Approved:** 2026-10-09 by human review of G1–G25
**Priority:** dependent visual lane; not a blocker for animal-domain G425–G449
**Constitution:** v2.0.0; SPEC-004 remains V1 gameplay delivery authority
**Decision source:** [ARTIST V2 ledger](../../docs/artist/grilling/2026-10-09-v2-direction.md)

## Problem

The original V1 art brief used cute low-poly 3D plus pixelated textures. The approved V2 direction instead requires a **fully pixel-art world in 2.5D**, with cohesive creatures, plants, farm, town and UI. A document approval is not evidence that scenes or builds already meet that direction.

## Decision / user value

Deliver a coherent, readable, original, cozy pixel-art farm in Godot, usable on mobile and web. Preserve the existing single-player, offline gameplay without rewriting domain rules; an art transition must not block the animal lifecycle, care, genetics, successor and save deliverables.

## Functional visual requirements

- **FR-501, ART identity (G1–G6):** world and actors follow full pixel-art 2.5D; consistent pixel density, contextual camera, recognizable species and original silhouettes. Texture-only low-poly does not pass.
- **FR-502, Animals (G3, G7, G14):** strong creature silhouettes, affection/care/health states as relevant, expressions that reinforce rather than obscure game state; a representative animal slice is first.
- **FR-503, Plants (G8, G20):** readable botanical growth and expressive crop/harvest effects, tied to existing domain states.
- **FR-504, Farm (G9–G10, G21–G22):** organic layout with construction overlays only on request, recognizably modular buildings and expansions.
- **FR-505, Town (G15–G17):** functional navigation, NPC recognizability and fast transitions.
- **FR-506, UX (G11–G13, G23):** unobtrusive modern HUD, consistent interaction feedback, mobile legibility/touch accessibility, pixel-sharp scaling and no blur.
- **FR-507, Environment (G4, G18–G19, G24):** cinematic day/night, season/weather primarily by palette/tiles, meaningful localized effects under frame budget.
- **FR-508, Visual evidence (G25):** independent ARTIST/LENTE A/B baseline and exact-head Godot screenshot/video for user-visible acceptance; an authored mockup alone cannot pass runtime gates.
- **FR-509, Portability:** typed GDScript Godot V1 preserved; domain remains isolated from presentation. No cloud provider dependency.
- **FR-510, Release discipline:** all visual slices obey exact-head CI, ARCH performance and accepted scope; reject/blocked states do not unlock subsequent visual migration steps.

## Acceptance scenarios

1. In the initial animal scene, a player can recognize a pet and its interaction state at representative mobile resolution without reading a dense HUD.
2. A runtime capture demonstrates actual full pixel art in foreground, creature, terrain and UI; no merely pixel-textured low-poly scene.
3. A Godot scene demonstrates contextual camera/zoom without blurred/scaled fractional pixels or inaccessible controls.
4. Cultivation stage and harvest event are recognizable and visually expressive, but crop timing and persistence are unchanged.
5. Farm layout and build overlay communicate valid regions without a permanent intrusive grid.
6. Cinematic day/night, discrete seasons and triggered VFX meet a documented mobile/web frame budget established by ARCH.
7. A/B evidence compares the prior baseline and new exact-head artifact; ARTIST, LENTE and ARCH approvals are recorded separately.

## Exclusions

No new gameplay mechanics, rebalancing, asset mass generation, engine replacement, forced backend, Roblox restoration or deployment/provider changes. No unsupported claims that builds or artist validation passed.

## Dependencies and release priority

- SPEC-004 domain phase C (currently G425 care) and successor/persistence phases retain their authority.
- Visual prototyping can be parallel-safe when isolated; V2 cannot silently replace active scenes before visual gates.
- Deliver visual acceptance in order: **Animals → Plants → Farm Structure**; city and decorative work later.
