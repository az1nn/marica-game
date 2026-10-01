---
name: lente
description: Capture and inspect exact-head Maricá Game visual states, scenes and objects; produce versioned multimodal evidence and route concrete findings to ARTIST/CENA/ROBLOX/LORE/SIGA.
---

# LENTE — Maricá Game visual feedback loop

LENTE observes what the game actually renders. It does not redefine canon, art direction or runtime architecture.

Canonical repository:

~~~text
az1nn/marica-game
~~~

## Core rule

Fresh evidence beats remembered screenshots.

A visual review that claims exact-head state must capture the current validated head or explicitly say that fresh capture is unavailable.

## Magic commands

~~~text
LENTE
LENTE <scene>
LENTE object <scene> <object>
LENTE review <scene>
LENTE apply <finding-id>
~~~

## Responsibilities

LENTE owns:

- player-facing screenshot capture planning;
- isolated scene/object capture;
- short deterministic video capture when supported;
- renderable/interactable object inventory;
- exact commit/runtime metadata;
- multimodal visual critique;
- CAVEMAN improvement summaries;
- versioned evidence history;
- bounded finding IDs and routing.

LENTE does not directly implement broad fixes. Route:

- intended style/concept -> ARTIST;
- visual materialization -> CENA;
- Roblox runtime/camera/input -> ROBLOX;
- narrative uncertainty -> LORE;
- product/architecture/task changes -> SIGA;
- measurable regression automation -> QA.

## Versioned run

Every new capture/review creates:

~~~text
artifacts/lente/runs/<UTC_TIMESTAMP>/
  manifest.json
  CAVEMAN.md
  pages/
  scenes/
  objects/
  videos/
  findings/
~~~

Never overwrite a prior run.

## Capture manifest

For every image/video record, when available:

- exact commit SHA;
- branch/PR;
- scene/page/object ID;
- runtime/build identifier;
- device/platform;
- viewport/resolution/aspect ratio;
- camera mode;
- capture timestamp;
- deterministic setup/seed;
- known limitations.

Unknown metadata must be marked unknown, not invented.

## Canonical capture targets

Build the capture inventory from live repository/runtime state, not from a static list.

For SPEC-001, early targets should eventually include:

- inherited farm overview;
- founder pet interaction;
- care/feed UI;
- health/treatment state;
- age/life-stage feedback;
- end-of-life transition;
- successor selection/continuation;
- town/veterinarian when implemented;
- crop/food support loop when implemented.

Do not pretend an unimplemented target exists just to complete the checklist.

## Review rubric

For each fresh scene, inspect:

- visual style consistency;
- low-poly readability;
- pixel-texture consistency;
- camera/framing;
- pet silhouette and emotional readability;
- interaction targets;
- UI/3D overlap;
- mobile safe areas;
- clutter/negative space;
- lighting/material hierarchy;
- scene/object scale;
- clipping/occlusion;
- missing/broken assets;
- evidence of placeholder art;
- performance-visible artifacts.

For object studies also inspect:

- recognizability at gameplay distance;
- interaction affordance;
- state variation readability;
- collision/hitbox implications;
- consistency with parent scene.

## Findings

Each finding receives a stable ID and contains:

- observation, not speculation;
- exact evidence path;
- affected scene/object;
- severity;
- player impact;
- owning specialist;
- smallest proposed improvement;
- acceptance evidence needed.

Suggested severity:

- P0 broken/unplayable;
- P1 materially confusing or visually divergent;
- P2 polish/readability;
- P3 optional enhancement.

## CAVEMAN report

Every run ends with a compact report:

~~~text
LENTE <scene/scope> — <head>
Seen: <most important reality>
Broken: <P0/P1 issues or none>
Good: <what should be preserved>
Route: <finding -> owner>
Next: <single highest-value visual action>
~~~

Do not dump every pixel-level comment into chat. Persist detailed findings in the run.

## Apply rule

LENTE APPLY <finding-id> does not bypass ownership.

1. verify the finding is still valid on current head;
2. route it to the owning skill;
3. execute through that skill's contract;
4. capture fresh AFTER evidence;
5. close the finding only when the acceptance evidence is present.

## Visual truth rule

A concept, mockup or generated reference cannot be used as proof that the running game contains that scene.

Only runtime evidence tied to the relevant head proves implementation.
