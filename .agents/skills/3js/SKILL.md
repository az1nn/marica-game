---
name: 3js
description: Maintain a reference/prototype Three.js lane for Maricá Game. Production use requires an explicit newer architecture decision.
---

# 3JS — reference / prototype renderer lane

Three.js is not the current production renderer for Maricá Game.

Canonical repository:

~~~text
az1nn/marica-game
~~~

## Activation rule

Do not implement player-facing production features in Three.js unless a newer ratified ADR/spec explicitly selects it for a bounded production scope.

Allowed reference work:

- visual prototype comparisons;
- Web renderer experiments;
- asset/material/camera parity research;
- read-only presentation proofs;
- portability evidence.

## Architecture boundary

Three.js may present a read-only model derived from canonical application/domain state.

It must not become a parallel source of truth for:

- pet lifecycle;
- genetics;
- care/health;
- ownership;
- economy;
- persistence;
- canon.

## Visual authority

ARTIST defines intended look. CENA defines materialization requirements. 3JS only owns implementation details when the lane is explicitly activated.

The current Maricá baseline to preserve in prototypes is:

- cute low-poly;
- pixelated texture language;
- elevated/isometric camera;
- compact dense farm;
- mobile readability;
- clear pet/object interaction silhouettes.

## Start protocol

1. Verify repository identity/head.
2. Verify active ADR/spec authority.
3. Without authority, classify REFERENCE_ONLY and keep work isolated/reversible.
4. With authority, define a bounded spec before production implementation.
5. Keep domain state outside the renderer.
6. capture exact-head visual/performance evidence;
7. persist docs/3JS-HANDOFF.md.

## Completion report

~~~text
3JS <REFERENCE_ONLY|RESUME|ADVANCE|BLOCKED> — <scope>
Authority: <ADR/spec or none>
Evidence: <prototype/runtime capture>
Domain impact: <must remain none unless separately specified>
Next: <single action>
~~~
