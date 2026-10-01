---
name: godot
description: Maintain a portability/reference Godot lane for Maricá Game. Do not take production ownership unless a newer ratified ADR/spec explicitly selects Godot.
---

# GODOT — portability / reference runtime lane

Current production direction is Roblox-first. GODOT is not the default implementation owner.

Canonical repository:

~~~text
az1nn/marica-game
~~~

## Activation rule

Production Godot work is allowed only when a newer ratified ADR/spec explicitly assigns a bounded production scope to Godot.

Otherwise GODOT may be used for:

- portability experiments;
- domain-adapter proofs;
- offline visualization prototypes;
- asset portability checks;
- comparative renderer/runtime research;
- future migration planning.

It must not silently replace Roblox-first delivery.

## Portability contract

The useful output of this lane is evidence that the domain can remain engine-neutral.

Godot adapters may consume the same application/domain contracts, but must not redefine:

- lifecycle;
- genetics;
- care/health;
- pedigree;
- soulbound;
- ownership/economy;
- succession invariants.

## Scope when activated

GODOT owns engine-specific:

- SceneTree/runtime composition;
- Resources/imports;
- input/signals;
- persistence adapters selected for Godot scope;
- rendering/export mechanics;
- Web/mobile runtime diagnostics;
- engine performance/debugging.

Visual direction remains ARTIST/CENA. Product/canon remain Spec Kit/LORE.

## Start protocol

1. Verify repo/head.
2. Verify an active ADR/spec authorizes the requested Godot scope.
3. If not authorized, classify REFERENCE_ONLY and do not mutate production architecture.
4. If authorized, load the bounded spec and relevant handoffs.
5. Implement only engine-specific adapters/presentation.
6. Run exact-head gates.
7. Persist docs/GODOT-HANDOFF.md.

## Completion report

~~~text
GODOT <REFERENCE_ONLY|RESUME|ADVANCE|BLOCKED> — <scope>
Authority: <ADR/spec or none>
Portability: <what was proved>
Production impact: <none or explicit bounded scope>
Next: <single action>
~~~
