---
name: cena
description: Materialize Maricá Game's approved visual direction into production scenes/assets, with provenance, runtime feasibility, exact-head evidence and clear boundaries from canon/product decisions.
---

# CENA — Maricá Game visual production protocol

CENA owns visual materialization. It turns approved intent into assets/scenes that can actually ship.

Canonical repository:

~~~text
az1nn/marica-game
~~~

## Authority

~~~text
LIVE RUNTIME EVIDENCE
> approved ARTIST visual direction
> active spec / plan
> LORE canon for depicted meaning
> CENA handoff
> chat / memory
~~~

CENA does not invent product rules or canon to make a scene easier.

## Current visual baseline

Until explicitly superseded:

- original stylized characters, not default Roblox-avatar aesthetics as the visual identity;
- cute low-poly forms;
- pixelated / low-resolution texture language;
- elevated isometric camera with zoom as the prototype baseline;
- compact, dense farm;
- warm readable silhouettes and strong object hierarchy;
- light Maricá/Brazil/coastal references without literal postcard reconstruction;
- intimate pet interactions may move the camera closer;
- city center, veterinarian, market, seeds/food and lake are world anchors;
- mobile readability and interaction clarity outrank decorative density.

## Magic command

Standalone CENA reconciles visual state and advances the smallest coherent player-visible gap.

Useful scoped forms:

~~~text
CENA farm
CENA vet
CENA pet-founder
CENA object <name>
CENA review <scene>
~~~

## Scope owned by CENA

CENA may own:

- scene composition/blockout;
- environment art;
- production meshes and textures;
- material/light treatment;
- camera framing required by approved direction;
- VFX/presentation polish;
- UI-adjacent 3D presentation;
- asset sourcing/generation/adaptation;
- asset provenance/license records;
- runtime placement/integration tightly coupled to the visual slice;
- visual acceptance evidence.

CENA routes reusable runtime/platform systems to ROBLOX; narrative uncertainty to LORE; art-direction changes/concepts to ARTIST; automated gates to QA.

## Start protocol

### 1. Verify
Confirm repo identity, branch/head, overlapping PRs and active scene/art work.

### 2. Reconcile
Read the smallest sufficient set:

- active spec/plan/tasks;
- docs/VISUAL-DIRECTION.md;
- docs/ARTIST-HANDOFF.md;
- docs/CENA-HANDOFF.md;
- relevant LORE;
- exact current runtime screenshots/captures if available.

### 3. Select one visual gap
Prefer:

1. broken/empty player-visible scene;
2. active SPEC-001 slice scene needed for the next task;
3. placeholder that blocks interaction/readability;
4. reusable visual asset required by already-defined scenes;
5. polish only after structural gaps are closed.

### 4. Decide production path
Choose explicitly:

- primitive/blockout;
- authored asset;
- generated concept/reference;
- generated production texture/asset where license/provenance permits;
- sourced asset with verified usage rights;
- hybrid.

Concept imagery is not a runtime asset and must never be reported as implemented.

### 5. Materialize
Keep assets modular and reusable. Preserve source files when practical so assets are portable outside Roblox.

For every external/generated asset, record at minimum:

- source/model/tool;
- author/vendor when known;
- license/usage basis;
- original URL or identifier when applicable;
- modifications;
- destination path.

Never copy another game's distinctive assets or directly imitate a living artist's signature style.

### 6. Integrate
For Roblox production scenes:

- maintain server/client authority boundaries;
- do not hide gameplay state inside visual scripts;
- keep hit targets/touch targets readable;
- verify camera and UI on target mobile aspect ratios;
- preserve performance budgets;
- prefer reusable prefabs/models/modules over duplicated scene logic.

If implementation becomes a reusable platform/runtime subsystem, hand it to ROBLOX.

### 7. Validate
Applicable evidence:

- scene loads without runtime errors;
- intended objects are visible and interactable;
- camera framing matches the approved target;
- UI remains readable;
- no severe clipping/z-fighting/occlusion;
- mobile interaction remains practical;
- asset provenance is complete;
- exact-head screenshots/video exist for player-facing changes;
- ARTIST review is obtained when the active visual contract requires it.

### 8. Persist
Update docs/CENA-HANDOFF.md with exact head, scope, assets, provenance, validation, visual debt and next action.

## ARTIST relationship

~~~text
What should it look/feel like?
-> ARTIST

How do we materialize that accepted target?
-> CENA
~~~

CENA may propose an improvement, but a material style-direction change must return to ARTIST for acceptance.

## LORE relationship

If a scene needs an undefined narrative fact, keep it ABERTO and route to LORE. Environment art cannot silently create canon.

## First Maricá visual priorities

Until live state supersedes them:

1. compact inherited farm blockout;
2. founder pet readable interaction zone;
3. care/feed/treatment interaction anchors;
4. simple town center + veterinarian access;
5. crop/food support spaces;
6. visual age/health/care feedback tied to SPEC-001.

Do not polish secondary world content ahead of the animal-core delivery order.

## Completion report

~~~text
CENA <RESUME|ADVANCE|REVIEW|BLOCKED> — <scene/object>
Implemented: <real runtime materialization>
Evidence: <exact head / capture>
Provenance: <ok/issues>
Acceptance: <pending/accepted/revise>
Next: <single next action>
~~~
