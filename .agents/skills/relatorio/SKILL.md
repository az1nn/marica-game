---
name: relatorio
description: Generate the canonical Maricá Game repository status report from live evidence, using one stable visual dashboard pattern and the same factual topics every time.
---

# RELATORIO — canonical Maricá Game status dashboard

RELATORIO is the read-only reporting skill for Maricá Game.

Canonical repository:

~~~text
az1nn/marica-game
~~~

Its job is to reconstruct current repository truth and render it in a stable, recognizable report format. **Visual Mode is the default output**; Text Mode is used only when the user explicitly requests text/no image. The factual topics, ordering and classification rules remain the same.

RELATORIO never selects new roadmap work, mutates repository state, merges, creates tasks or changes labels. SIGA acts; RELATORIO reports.

## Repository identity lock

Before consuming operational state:

1. resolve the live repository full name;
2. require an exact match with the canonical repository above;
3. fail closed on mismatch.

Never import identifiers, roadmap labels, claims, handoffs, status, visuals or task state from another repository.

Repository evidence always outranks chat/model memory.

## Triggers

Treat these as RELATORIO requests:

- `relatorio`
- `relatório`
- `status`
- `relatório do repositório`
- `gere um relatório`
- `gere relatório imagem`
- `relatório visual`
- requests from SIGA to render the final repository state

Use **Visual Mode by default**, including for standalone `relatorio` / `relatório` and for every invocation coming from SIGA.

Use **Text Mode only when the user explicitly requests textual output, no image, or equivalent wording**.


## Inline delivery contract

Visual Mode must be delivered as an **inline-rendered image in the conversation**, not merely as a download link or file path.

Required behavior:

- render exactly one final RELATORIO image per invocation;
- present that image inline in the assistant response;
- a download link may exist only as a secondary convenience, never as the primary or sole visual delivery;
- do not emit draft/intermediate report images to the user;
- if a generated image is rejected during QA, discard it and render a replacement before responding;
- never expose a stale or cross-project image while producing the Maricá Game report.

## Mandatory live reconciliation

Read the smallest sufficient live set, in this order:

1. canonical repository identity and default branch;
2. exact default-branch HEAD;
3. open PRs and exact PR heads;
4. active claims under `.siga/`;
5. active `specs/**/tasks.md`;
6. relevant spec/plan/constitution when needed to interpret task meaning;
7. exact-head workflow/check evidence;
8. relevant specialist handoff;
9. `docs/SIGA-HANDOFF.md`.

Do not trust a previous generated report as state evidence.

### Dynamic task derivation

Never hard-code a current or next task identifier in this skill.

Derive it from live evidence:

- if an active claim/open PR owns unfinished work, that is the active unit;
- otherwise the first unchecked task allowed by the active executable backlog is next;
- in ADVANCE, the main task card shows the latest verified completed unit and the NEXT card shows the newly derived next task;
- in RESUME/WATCH, the main task card shows the active unfinished unit;
- in BLOCKED, show the blocked unit and exact required decision.

### Current phase

The current phase is the phase containing the active/next executable task.

Phase progress is:

~~~text
checked executable tasks in phase / total executable tasks in phase
~~~

Do not invent percentages, project-wide task counts, asset counts, spec counts or metrics that are not explicitly derivable from live repository files.

## Classification

Choose exactly one:

- **ADVANCE** — previous bounded unit is verified/merged/complete and the next documented task is ready.
- **RESUME** — an active implementation/spec unit exists and can continue.
- **WATCH** — an active unit is waiting on a real CI/provider/human gate.
- **BLOCKED** — a required product/semantic/human decision prevents safe continuation.

Distinguish missing evidence from failed evidence.

A green check from another SHA is stale and must not be presented as current exact-head proof.

## Canonical topics and order

Every RELATORIO output must preserve these topics in this order.

### 1. Header

Always show:

- **MARICÁ GAME**
- **SIGA • RELATÓRIO DE ORQUESTRAÇÃO**
- report date/time only when an authoritative current time is available
- optional small label: **ESTILO DEFAULT DO REPOSITÓRIO**

### 2. Estado Global

Show:

- classification: ADVANCE / RESUME / WATCH / BLOCKED;
- one short plain-language state sentence;
- blocker status;
- wait status.

Preferred chips:

- `SEM BLOQUEIOS` when none;
- `SEM WAIT` when no real wait;
- otherwise show the exact blocker/wait concisely.

### 3. Repositório

Show:

- `az1nn/marica-game`;
- default branch;
- short exact HEAD;
- open PRs relevant to the active unit;
- latest merged PR when it materially defines the verified unit.

Never show a SHA that is not verified live for this report.

### 4. Maricá / Animal-First visual identity

Visual Mode includes one compact decorative scene panel.

Direction:

- cute low-poly / pixel-textured feel;
- coastal Maricá/Brazil cues;
- farm + pet/animal emphasis;
- warm daylight/cozy tone;
- original stylized art, not default Roblox-avatar identity.

This panel is decorative. It must never encode invented repository facts.

### 5. Fluxo SIGA

Always show the five stages in this exact order:

~~~text
RECONCILE -> CLASSIFY -> EXECUTE -> VERIFY -> HANDOFF
~~~

Stage state is factual:

- ADVANCE after a fully delivered unit: all five complete;
- RESUME: RECONCILE + CLASSIFY complete, EXECUTE active unless later evidence says otherwise;
- WATCH: show the real waiting stage, usually VERIFY or HANDOFF;
- BLOCKED: stop at the stage where the decision is required.

### 6. Unidade atual / última unidade verificada

Main large card.

Show:

- task key + short task title;
- status badge;
- 4–6 material facts only;
- current phase name;
- phase progress count and percentage.

For ADVANCE, this card should normally describe the **latest verified completed unit**, because the next task has its own dedicated panel.

Facts should describe delivered behavior/contracts, not commit-history trivia.

### 7. Gates exato-head

Always show the required evidence for the exact relevant SHA.

Default rows when applicable:

- Validate skills;
- Roblox CI;
- Open PRs;
- active/closed claim.

Allowed gate states:

- PASS
- FAIL
- RUNNING
- QUEUED
- MISSING
- STALE
- CLOSED / ACTIVE for claims

Never convert RUNNING, QUEUED, MISSING or STALE into PASS.

### 8. Tarefas da fase atual

Show only the current phase's executable tasks, not an invented whole-project roadmap.

Use compact statuses:

- green = complete;
- orange = active/next;
- muted = pending;
- cyan/purple only when a real repository status requires another distinction.

The task labels and completion state come directly from the active `tasks.md`.

### 9. Próxima ação

One action only.

Show:

- next task key;
- concise task title;
- one sentence describing the immediate boundary/intent.

It must match the repository-documented next action.

Do not offer several alternative next steps in the canonical dashboard.

### 10. Footer source

Always show:

~~~text
Fonte: live repository state • az1nn/marica-game • <branch>@<short-sha>
~~~

## Visual Mode — default design contract

This is the default visual style for Maricá Game reports.

### Canvas

- wide landscape dashboard;
- target 1536×1024 or nearest supported landscape size;
- single-screen composition;
- strong grid alignment;
- generous but efficient spacing;
- readable on mobile zoom; avoid microscopic text.

### Palette

Use a restrained dark-tech palette:

~~~text
background     #07111D
panel          #0D1B2A
panel alt      #102436
border         #1F3B53
primary text   #EDF6FF
muted text     #9FB3C8
success/flow   #2FE3B0
info           #39BDF8
next/action    #FF9F1C
error          #FF6B6B
~~~

Small variations for antialiasing/shading are fine; preserve the visual identity.

### Typography and hierarchy

- bold geometric/sans title treatment;
- `MARICÁ` in white and `GAME` in orange;
- section titles uppercase;
- state word large and prominent;
- monospace is acceptable for SHA/branch only;
- concise text, no paragraphs inside cards.

### Layout skeleton

Use this stable composition:

~~~text
[ HEADER --------------------------------------------------------------- ]

[ ESTADO GLOBAL ] [ REPOSITÓRIO ] [ MARICÁ / ANIMAL-FIRST ART ]

[ FLUXO SIGA ----------------------------------------------------------- ]

[ UNIDADE ATUAL / ÚLTIMA VERIFICADA -------- ] [ GATES EXATO-HEAD ----- ]

[ TAREFAS DA FASE ATUAL -------------------- ] [ PRÓXIMA AÇÃO ---------- ]

[ FOOTER SOURCE -------------------------------------------------------- ]
~~~

Do not replace this skeleton with a generic analytics dashboard.

### Rendering rules

- rounded rectangular panels;
- thin blue-gray borders;
- teal/cyan/orange status accents;
- simple circles/checks/lines for progress;
- no fake 3D charts;
- no decorative metric cards that lack live data;
- no stock-photo look;
- no unrelated roadmap categories;
- no cross-project imagery or terminology;
- no excessive gradients, glow or visual noise;
- decorative Maricá scene must stay subordinate to the factual dashboard.


### Composition QA gate

Before the final visual is emitted, validate the rendered bitmap itself.

Minimum checks:

- all canonical panels remain inside canvas bounds;
- no card overlaps another card;
- text bounding boxes remain inside their owning panel;
- no footer/header clipping;
- no text smaller than the renderer's mobile-readable minimum;
- no unexpected line wrap pushes content outside a panel;
- no duplicate report image is emitted;
- repository name, task key, PRs, SHA and gate labels visible in the bitmap match the reconciled facts;
- the final bitmap is the newest render from this invocation.

Prefer deterministic layout engines with measured text boxes for factual dashboards. Generative imagery may be used only for the small decorative scene panel; it must not render factual labels, metrics or repository state.

If any composition check fails, render again with corrected dimensions/content density. A visually broken dashboard is a failed RELATORIO attempt and must not be emitted as final output.

## Text Mode — same topics, compact form

Text Mode mirrors the same factual contract without art.

Required shape:

~~~text
RELATORIO <ADVANCE|RESUME|WATCH|BLOCKED> — <unit>
Repo: <branch>@<short-sha> | PR: <relevant PR or none>
State: <one-sentence repository state>
Flow: RECONCILE <state> -> CLASSIFY <state> -> EXECUTE <state> -> VERIFY <state> -> HANDOFF <state>
Unit: <task + 1–3 material facts>
Phase: <phase> | <done>/<total> (<percent>%)
Gates: <exact-head gates>
Blocker/Wait: <none or exact condition>
Next: <single next action>
~~~

Prefer one screen.

## Factuality guardrails

Never:

- copy the previous report's SHA, task, percentage or gates without re-reading live state;
- fabricate project metrics;
- invent a phase name;
- mark a task complete solely from chat memory;
- call CI green when the evidence belongs to another SHA;
- show another repository's visual or roadmap vocabulary;
- treat decorative art as evidence;
- convert RELATORIO into a changelog dump.

If a required fact cannot be verified, label it **MISSING** or omit the optional element rather than guessing.

## Relationship with SIGA

RELATORIO is read-only and is the **mandatory terminal stage of every SIGA invocation**.

The integrated contract is:

~~~text
SIGA
-> RECONCILE
-> CLASSIFY
-> ROUTE
-> EXECUTE
-> VERIFY
-> MERGE / WATCH
-> PERSIST
-> CONTINUE
-> RELATORIO
~~~

When called by SIGA, RELATORIO must re-read the resulting live repository state after SIGA's mutations/merge/persistence and render **Visual Mode by default**. A SIGA text recap never satisfies this requirement by itself.

RELATORIO can also be invoked directly as a standalone read-only command.

SIGA remains responsible for:

- task selection;
- concurrency control;
- execution;
- verification;
- merge decisions;
- handoff persistence.

RELATORIO reconstructs the resulting live truth and renders the canonical report.
