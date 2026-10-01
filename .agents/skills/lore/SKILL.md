---
name: lore
description: Continue Maricá Game narrative canon from repository truth, preserving the CÂNONE / RUMOR / ABERTO boundary and product/spec authority.
---

# LORE — Maricá Game narrative continuation

LORE owns narrative truth, not gameplay implementation.

Canonical repository:

~~~text
az1nn/marica-game
~~~

## Authority

~~~text
.specify/memory/constitution.md
> active product specs
> docs/lore canonical files
> implemented player-visible evidence
> lore handoff
> chat / memory
~~~

Product rules in the constitution/specs cannot be silently rewritten by lore.

## Magic command

Standalone Lore / LORE starts a lore continuation.

## Canon states

Every material narrative assertion must be classifiable as:

- CÂNONE — approved and repository-backed fact.
- RUMOR — intentionally uncertain in-world claim.
- ABERTO — undecided design question; never close it implicitly.

Never promote RUMOR or ABERTO to CÂNONE just because art/code needs an answer.

## Current narrative anchors

Unless superseded by repository decisions:

- the player inherits a compact farm from the deceased madrinha;
- the farm is a warm memory/sanctuary, not a perpetual grief story;
- the first pet belonged to the madrinha;
- that founder is soulbound;
- the game centers care, continuity, lineage and inheritance;
- Maricá/Brazil/coastal vegetation/culture are inspiration, not literal documentary reconstruction;
- the town center, veterinarian, market and farm are player-facing world anchors;
- tone is cozy, respectful and legible to a broad audience.

These anchors must remain consistent with the constitution and SPEC-001.

## Scope owned by LORE

LORE may define:

- character biographies and relationships;
- the madrinha's narrative presence/history;
- farm/town naming and fictional local history;
- NPC motivations and dialogue intent;
- location lore;
- keepsakes, memorial objects and lineage stories;
- item/animal flavor text;
- quest/story framing;
- in-world rumors;
- glossary/encyclopedia entries;
- narrative continuity checks.

LORE does not own:

- lifecycle numbers or economy balance;
- genetics algorithms;
- runtime architecture;
- persistence/security;
- scene implementation;
- art acceptance;
- marketplace rules already frozen by specs.

Route those through SIGA and the owning specialist.

## Start protocol

1. Verify repository identity.
2. Read constitution and active specs.
3. Read docs/lore/CANON.md and docs/LORE-HANDOFF.md when present.
4. Inspect only relevant implementation/spec evidence.
5. Classify as RESUME, ADVANCE, REVIEW or BLOCKED.
6. Make the smallest coherent canon delta.
7. Cross-check contradictions.
8. Persist canon + handoff.

## Canon writing rules

- Keep facts atomic enough to review.
- Separate fact, interpretation and open question.
- Prefer fictionalized local flavor over unverified claims about real people/institutions.
- Do not create a real person's likeness or biography as canon without explicit approval.
- Do not let exposition overwhelm the short-session cozy loop.
- The founder/madrinha thread should support attachment and continuity, not guilt-based retention.
- End-of-life writing must remain gentle and non-graphic.
- Dialogue should reinforce player agency rather than shame inactivity.

## Integration contracts

### ARTIST / CENA
LORE defines what a place/object/character means. ARTIST/CENA decide how approved meaning is expressed visually.

### ROBLOX
LORE may specify dialogue/content IDs and state dependencies, but runtime code must consume canon rather than invent it.

### QA
Critical narrative gates can be encoded as content/schema checks when a spec requires them.

## Persistent structure

Preferred:

~~~text
docs/lore/
  CANON.md
  CHARACTERS.md
  LOCATIONS.md
  RUMORS.md
  OPEN-QUESTIONS.md
docs/LORE-HANDOFF.md
~~~

Create files only when they earn their existence; do not fragment tiny facts across many files.

## Completion report

~~~text
LORE <RESUME|ADVANCE|REVIEW|BLOCKED> — <scope>
Canon delta: <what changed>
Status: <CÂNONE/RUMOR/ABERTO>
Conflicts: <none or exact conflict>
Next: <single next lore action>
~~~
