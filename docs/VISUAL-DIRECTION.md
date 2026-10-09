# Maricá Game — Visual Direction

**Approved visual target:** ARTIST V2 — full pixel art 2.5D (human-approved 2026-10-09)  
**Implemented runtime:** current Godot V1 remains unchanged until visual slices pass independent gates.  
**Sources of truth:** `docs/artist/grilling/2026-10-09-v2-direction.md` G1–G25 and `specs/005-pixel-art-v2-migration/`.  
**Constitution:** Godot-first / offline-first; Animals → Plants → Farm Structure.

## Approved V2 artistic contract

- **Full pixel art** for world, creatures, plants and interactive visual language; texture-only pixelization of low-poly 3D is not compliant (G1).
- **2.5D** via pixel-art sprites and tile layers, stylized depth, contextual isometric camera/zoom; no commitment to a specific rendering mechanism before ARCH prototype (G2, G6).
- **Animals first:** original fantasy-cozy silhouettes, expressive animation where important, statuses legible on selection, no unnecessary UI indicators (G3, G7, G14).
- **Plants:** botanic form recognizable by stage; growth and harvest may receive expressive pixel animations (G8, G20).
- **Farm:** compact dense layout, organic terrain, contextual building overlays and recognizable modular structures (G9, G10, G21–G22).
- **Environment:** cinematic day/night (G18), palette/tile-based seasons and weather with low animation density (G19); effects prioritized per interaction and performance (G24).
- **UX:** modern subtle UI, minimal interaction feedback, stable neutral interface with contextual accents, mobile responsive pixel-sharp presentation (G11–G13, G23).
- **City:** functional landmarks, recognizable NPCs, direct transitions to farm (G15–G17).
- **Evidence:** real Godot capture + independent A/B verification before visual acceptance (G25). ART approves look, ARCH technical budget, LENTE capture/evidence, SIGA orchestrates.

## Operational separation / gates

Approval of direction **does not** mean approved assets, scene implementation, shader, export or player-visible acceptance. Existing V1 runtime art may remain while the SPEC-005 slices are produced and validated. Preserve domain gameplay and stable save structures. Do not change release platform or cloud configuration in this visual-direction PR.

## Historical baseline (superseded as artistic target, not as runtime fact)

The prior V1 target was low-poly 3D with pixelated textures; this section is retained for baseline comparisons.

## Core look

- cute low-poly 3D;
- pixelated / low-resolution texture language;
- original stylized characters;
- do not make default Roblox avatars the visual identity;
- elevated isometric camera with zoom;
- compact dense farm;
- warm cozy presentation;
- strong silhouettes and interaction readability;
- light Maricá/Brazil/coastal vegetation, fruit and architecture cues without literal reconstruction;
- mobile-first composition.

## World anchors

- inherited farm;
- founder pet;
- town center;
- veterinarian;
- market;
- seeds/food;
- lake/fishing.

## Priorities

Animal readability and care interaction come before secondary decoration.

Visual polish must not outrun SPEC-001 delivery order.

## Change control

Material direction changes require explicit ARTIST V2 review and must not silently contradict the active spec/constitution.

