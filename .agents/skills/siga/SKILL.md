---
name: siga
description: Master continuation protocol for Maricá Game. Reconcile live repository state, execute and verify the next bounded task safely, persist one authoritative next action, then always finish by invoking the canonical RELATORIO visual report.
---

# SIGA — Maricá Game repository orchestrator

SIGA is the repository-local master orchestrator for Maricá Game.

## Repository identity lock

Canonical repository:

~~~text
az1nn/marica-game
~~~

Before reading operational backlog, selecting work, trusting handoffs, or mutating anything:

1. resolve the live repository full name;
2. require an exact match with the canonical repository above;
3. fail closed on mismatch.

Do not import task state, claims, handoffs, CI evidence, orchestration rules, or canonical skill authority from another repository.

Trust order:

~~~text
LIVE REPOSITORY / CI / RUNTIME EVIDENCE
> .specify/memory/constitution.md
> active specs / plans / tasks / ADRs
> repository-local specialist handoffs
> docs/SIGA-HANDOFF.md
> chat / model memory
~~~

Repository evidence always wins over remembered state.

## Magic command

`SIGA` is the **single session opener** for code, architecture, design, art, review, scenes, QA and roadmap work. `SIGA <intent>` prefers a documented owner but cannot bypass dependencies:

- `SIGA` — select one safe next unit from **all** active specs and in-flight claims/PRs.
- `SIGA code|architecture|design|lore|artist|scene|review|qa|inspect|release|spec` — scoped intent, not authorization to mutate.
- `SIGA review visual` -> LENTE then ARTIST; `SIGA review code` -> ARCH then QA adversarial mode as applicable.
- Direct `ARTIST` / `ARCH` / `CENA` / `DESIGN` and other specialist commands are **compatibility requests to open SIGA sessions**, never authority for independent, unroadmapped execution.

A run with no executable roadmap must first commit a governance-only Spec Kit, not write code or produce art. SIGA is not a status-only command when progress is safe.

## Mandatory lifecycle

Every invocation must execute this control loop:

~~~text
IDENTITY
-> RECONCILE
-> SPEC_GATE
-> CLASSIFY
-> ROUTE
-> CONCURRENCY BARRIER when mutation may occur
-> EXECUTE
-> VERIFY
-> MERGE / WATCH
-> PERSIST
-> CONTINUE
-> RELATORIO
~~~

A phase may be short, but it may not be skipped when applicable.

### IDENTITY

Confirm `az1nn/marica-game` before consuming operational state.

A mismatch is a hard stop. Never "helpfully" continue in a similarly named or previously used repository.

### RECONCILE

Rebuild state from fresh repository evidence.

Inspect the smallest sufficient live set:

- default branch and exact HEAD;
- open PRs and their exact heads;
- active/relevant branches;
- current CI/check/workflow evidence;
- `.specify/memory/constitution.md`;
- active `specs/*/{spec,plan,tasks}.md`;
- relevant ADRs;
- repository-local handoffs;
- active session claims under `.siga/`;
- exact files/contracts likely to change.

Never infer the current task or completion state from chat when repository evidence exists.

### SPEC_GATE

**No task mutation without a committed Spec Kit roadmap and a scoped, explicit task ID.** This applies equally to code, repairs, reviews, concepts, architecture, QA, asset changes, reports that mutate repository files and PR merges.

1. Confirm `specs/<number>-*/spec.md`, `plan.md`, `tasks.md` and the selected executable task ID in the **live repository**; resolve owner, prerequisites and acceptance evidence. Check existing task/claim for RESUME.
2. If the requested work is unplanned, open `SPEC_BOOTSTRAP`: on a claimed branch write or extend spec/plan/tasks as a **governance-only commit**. No code, image production, or acceptance claim in this bootstrap commit.
3. Reconcile the committed roadmap after the bootstrap before admitting any implementation and repeat concurrency checks.
4. If bootstrap itself is unsafe or undefined, return SPEC_BLOCKED with actionable missing decision. Read-only inspection may occur without a task but never a mutating review verdict.

No emergency/minor-repair exception. Merely mentioning Spec Kit in a handoff does not pass the gate.

### CLASSIFY

Choose exactly one control state:

- **RESUME** — already-dispatched repository work is incomplete.
- **WATCH** — the primary thread is waiting on a real external/check/human gate.
- **ADVANCE** — the prior bounded unit is complete; select the next repository-documented task.
- **BLOCKED** — no safe mutation is possible without a required product/human decision.

Classification is based on live evidence, not on the previous report.

WATCH is non-terminal. When the primary thread is waiting, search for another safe bounded task unless an explicit strict-sequential dependency forbids parallel advance.

### ROUTE

SIGA selects the task and retains orchestration authority. Route implementation to the smallest repository-local specialist that owns the concern:

- **DESIGN** — gameplay mechanics, economy, progression, rules and player-experience intent; DOMAIN_CONFLICT with LORE escalates to SIGA.
- **ARCH** — structural code integrity, APIs, refactors, persistence/networking/security design, test architecture and performance budgets.
- **LORE** — narrative canon, characters, places, tone and CÂNONE / RUMOR / ABERTO.
- **ARTIST** — intended visual direction, concepts and human visual acceptance.
- **CENA (SCENE alias)** — production visual materialization, scene composition, assets, lighting, integration and provenance.
- **QA** — automated gates, deterministic domain tests, integration/E2E, persistence, performance and regression.
- **QA adversarial mode** — independent critique, objective baseline, mutation proof and regression hunting for P0/high-risk work.
- **LENTE** — exact-head screenshot/video/object evidence and visual critique.
- **RELATORIO** — mandatory terminal read-only reporter for every SIGA invocation; it re-reconciles live state and renders the canonical visual dashboard.
- **GODOT** — canonical V1 production runtime under Constitution v2.0.0 / SPEC-004 / ADR-0004.

SIGA never delegates:

- repository identity;
- active-task selection;
- concurrency classification;
- exact-head acceptance;
- PR delivery policy;
- merge decision;
- authoritative next-action persistence.

Specialists return bounded results to SIGA; they do not silently choose unrelated roadmap work.

## Dispatch decision contract

Read `tools/skills/skill_tree.json` and optionally evaluate `tools/skills/dispatch.py` (routing helper, not an automated multi-agent runtime). SIGA is **the only controller**. A specialist may execute within its assigned domain, but cannot directly call another specialist or hand over its own task priority.

For every task provide:
`{spec, task, intent, owner, branch_head, inputs, prerequisites, expected_artifacts, acceptance_gates}`.

A specialist returns:
`{status: PASS|REVISE|REJECT|BLOCKED|HUMAN_REQUIRED, changes, evidence, missing_dependency, next_owner, human_gate}`.
SIGA explicitly schedules the next owner; a return arrow is not a recursive call.

**Dependency-first and anti-starvation:**
1. Scan ready units across every active roadmap, draft PR, claim and specialist handoff. Do not treat the first unchecked Godot task as the only possible work.
2. If a task is WATCH/BLOCKED, resolve the **first actionable missing prerequisite** and dispatch its owner. For the accepted founder-dog V4 concept: ARCH/GODOT render/import contract (SPEC-005 V201/V201a), CENA/GODOT sample (V203), LENTE exact-head A/B (V205), then ARTIST independent runtime verdict. Do not re-ask for accepted concept approval.
3. Mark unmeasurable/tool-missing gates CAPABILITY_BLOCKED and true human visual/product decisions HUMAN_REQUIRED. A blocked runtime gate does not prohibit a separate, collision-safe roadmapped concept/audit/architecture task.
4. Record ready lanes skipped in the handoff. If a ready, safe high-value specialist lane has been skipped across **two** bounded runs, dispatch it before another optional task unless P0 strict priority, sequential dependency or semantic overlap forbids it.
5. Review is a scoped task: code/structure -> ARCH, QA adversarial mode; gameplay -> DESIGN; canon -> LORE; visuals -> LENTE then ARTIST. A read-only inspection without a task cannot become an authoritative acceptance verdict.
6. **Concept ACCEPT != Godot sprite/import != playable SCENE != LENTE exact-head proof != ARCH technical PASS != ARTIST runtime acceptance.** REVISE and REJECT are valid end states. Never use one as proof of another.

Dispatch may require multiple bounded SIGA units. Never claim that writing the routing instructions physically executed a specialist.

### CONCURRENCY BARRIER

SIGA owns this process internally. Consult docs/SIGA-CONCURRENCY.md (legacy helper remains archived as historical evidence). Mandatory sequence: snapshot -> claim -> post-claim barrier -> mutate -> re-read -> exact-head verify -> guarded merge.

Capture and reconcile at minimum:

- default-branch HEAD;
- intended working-branch HEAD;
- open PR heads;
- active `.siga/` claims;
- relevant workflow/check heads;
- blob SHAs for files/contracts that may change;
- semantic overlap with other active work.

For substantive mutation:

1. use a dedicated branch;
2. publish a repository-visible session claim;
3. perform the post-claim barrier;
4. classify drift;
5. mutate only when CLEAR or PARALLEL_SAFE, or after explicit RECONCILE;
6. use optimistic file/head guards;
7. never use force overwrite as normal conflict handling.
8. Recheck claims, PR heads, branch/base HEAD, blobs, semantic overlaps and exact-head checks before each write batch and merge. Classify CLEAR, PARALLEL_SAFE, RECONCILE, COLLISION, SUPERSEDED or GATE_STALE. Close claims after completion.

Read-only inspection does not require a claim.

### EXECUTE

A non-blocked SIGA run must produce a concrete progress unit.

Valid progress units include:

- implement/fix a task justified by the active spec;
- advance a bounded spec/plan/tasks/ADR;
- add required tests or acceptance automation;
- complete a bounded LORE/CENA/ARTIST unit;
- repair CI/tooling required by the active milestone;
- reconcile safe drift/conflict;
- merge verified work;
- commit a governance-only Spec Kit task bootstrap first; implement its first scoped unit only after a fresh admission/barrier.

Do not invent work merely to avoid WATCH/BLOCKED.

A pure status recap is not successful execution when safe progress exists.

## Spec Kit contract

When constitution/spec artifacts exist:

1. constitution constrains all downstream artifacts;
2. spec owns user-visible/product contract;
3. plan owns technical decisions;
4. tasks own executable order;
5. implementation must remain traceable to those artifacts.

**Hard gate:** every work type, including a repair or review, must first have an active spec/plan/tasks + task ID. The bootstrap is a separate governance-only commit.

### No stale task hard-coding

SIGA itself must not encode a "current task", "next task", or task identifier.

Every invocation derives the active/next task from live `specs/**/tasks.md`, open PR/claim state and repository-local handoffs. Handoffs are hints to reconcile, not substitutes for live task state.

## Non-stop progress

When the primary thread is WATCH:

1. preserve exact-head evidence for the watched thread;
2. run the overlap/concurrency scan;
3. inspect all repository-documented parallel-safe work, including ARTIST/ARCH/SCENE/LENTE dependencies on draft PRs;
4. claim the next bounded task when mutation is justified;
5. execute at least one meaningful step;
6. persist both the watched dependency and the advanced work.

An explicit strict-sequential dependency overrides parallel advance.

## VERIFY

Validation belongs to an exact commit SHA.

Require only gates applicable to the change, but require all applicable gates for the current head.

Possible gates:

- deterministic domain unit/property tests;
- persistence round-trip/idempotency tests;
- Godot headless/import/runtime tests for active V1 work;
- Roblox integration tests only for explicitly retained migration/reference scope;
- Studio/runtime smoke tests;
- lint/static validation;
- build/export validation when applicable;
- skill-system validation for skill/protocol changes;
- exact-head visual evidence for player-facing scene changes;
- ARTIST/CENA human acceptance when explicitly required by the active visual contract.

~~~text
validated_sha != current_head -> GATE_STALE
~~~

Green evidence from a previous SHA is not merge evidence.

### QA adversarial gate

When the spec requires adversarial verification or a changed P0 invariant, route QA in adversarial mode. Preserve independent builder/critic isolation and historical GAUNTLET evidence. Load .agents/skills/qa/SKILL.md; QA never selects roadmap work or merges.

The quality loop should establish baseline, objective gates, fresh criticism, mutation proof when measurable, and a separate regression hunt.

If required behavioral execution is unavailable, QA must return BLOCKED rather than treating authored-but-unexecuted assertions as PASS. SIGA may advance collision-safe infrastructure needed to unblock that evidence, but may not fabricate the missing gate.

### Protocol self-check

When SIGA or another repository-local skill/protocol is changed, verification must include:

~~~bash
python tools/skills/validate.py
~~~

The validator is part of the orchestration contract.

## MERGE / WATCH

Before merge, re-run the concurrency overlap scan and verify:

- PR head is the expected current SHA;
- base drift does not invalidate assumptions;
- required checks are green for that exact head;
- required human/visual acceptance is complete;
- no active semantic collision exists;
- dependency order is satisfied.

When those conditions hold, merge without asking again. Use expected-head guards when supported.

After merge, verify the new default-branch state.

If a required gate is pending, classify WATCH and continue other safe work when allowed.

## PERSIST

Update the smallest relevant specialist handoff plus `docs/SIGA-HANDOFF.md`.

The SIGA handoff should contain only current operational truth:

- verified repository/base/head;
- classification;
- active spec/task;
- work produced;
- gates and exact SHA;
- branch/PR;
- blockers or waits;
- one authoritative next action.

Do not turn handoffs into changelog dumps. Never persist another repository as canonical procedure/state authority.

Close or supersede the session claim when the bounded work is merged, superseded or abandoned.

## CONTINUE

At the end of the bounded unit:

1. reconcile the resulting default/live state;
2. determine whether another safe unit should start immediately;
3. persist exactly one next action;
4. hand the resulting live state to RELATORIO.

Do not recursively invent unbounded work. The repository roadmap remains the scope boundary.

## RELATORIO — mandatory terminal stage

Every SIGA session ends by loading .agents/skills/relatorio/SKILL.md and reconstructing fresh live evidence after the last mutation/merge. This is nonoptional.

Default is an **interactive native UI surface** when the ChatGPT client supports interactive controls: Resumo, Tarefas, Gates, Grafo and Evidências, with filters, drill-down, source links and copy, over an immutable, versioned factual snapshot. It is a read-only report; never claim a static mockup as a live interface. Contract: tools/relatorio/report_contract.py and docs/relatorio/INTERACTIVE-UI.md.

If interactive controls are unavailable, render exactly one canonical dashboard via a native inline image surface. Never substitute a file/download-only link. If neither native UI nor native inline image surface is available, explicitly report VISUAL_BLOCKED alongside factual state. Text-only report is an explicit user preference.

Re-read exact default HEAD, PR heads, claims, executable tasks, exact-head CI, relevant visual evidence, phase progress, blockers/wait and single next action. Mark MISSING/STALE/UNVERIFIED when needed. User interaction must not mutate a GitHub repository, alter source truth, or mark missing gates PASS. Preserve keyboard and mobile accessibility and the canonical report topics.
