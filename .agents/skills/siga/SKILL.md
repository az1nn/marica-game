---
name: siga
description: Master continuation protocol for Maricá Game. Reconcile live repository state, select and route the next bounded task, enforce concurrency safety, verify exact-head evidence, merge safely and persist one authoritative next action.
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

Treat standalone `Siga` / `SIGA` as the command to continue the highest-priority safe work already justified by this repository.

SIGA must not behave as a status command unless execution is genuinely blocked.

## Mandatory lifecycle

Every invocation must execute this control loop:

~~~text
IDENTITY
-> RECONCILE
-> CLASSIFY
-> ROUTE
-> CONCURRENCY BARRIER when mutation may occur
-> EXECUTE
-> VERIFY
-> MERGE / WATCH
-> PERSIST
-> CONTINUE
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

- **LORE** — narrative canon, characters, places, tone and CÂNONE / RUMOR / ABERTO.
- **ARTIST** — intended visual direction, concepts and human visual acceptance.
- **CENA** — production visual materialization, scene composition, assets, lighting, integration and provenance.
- **ROBLOX** — production runtime/platform engineering, server authority, adapters, remotes and runtime performance.
- **QA** — automated gates, deterministic domain tests, integration/E2E, persistence, performance and regression.
- **LENTE** — exact-head screenshot/video/object evidence and visual critique.
- **RELATORIO** — compact read-only repository status.
- **GODOT** — portability/reference lane unless a ratified repository-local ADR/spec assigns production scope.
- **3JS** — reference/prototype lane unless a ratified repository-local ADR/spec assigns production scope.
- **siga-concurrency** — mandatory mutation/merge safety helper.

SIGA never delegates:

- repository identity;
- active-task selection;
- concurrency classification;
- exact-head acceptance;
- PR delivery policy;
- merge decision;
- authoritative next-action persistence.

Specialists return bounded results to SIGA; they do not silently choose unrelated roadmap work.

### CONCURRENCY BARRIER

Before any mutation, load:

~~~text
.agents/skills/siga-concurrency/SKILL.md
~~~

Then capture and reconcile at minimum:

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
- create the next repository-visible task and execute its first meaningful step when the roadmap requires task creation.

Do not invent work merely to avoid WATCH/BLOCKED.

A pure status recap is not successful execution when safe progress exists.

## Spec Kit contract

When constitution/spec artifacts exist:

1. constitution constrains all downstream artifacts;
2. spec owns user-visible/product contract;
3. plan owns technical decisions;
4. tasks own executable order;
5. implementation must remain traceable to those artifacts.

For a new product capability, specify before coding. A repair that restores already-specified behavior may use a smaller repair path.

### No stale task hard-coding

SIGA itself must not encode a "current task", "next task", or task identifier.

Every invocation derives the active/next task from live `specs/**/tasks.md`, open PR/claim state and repository-local handoffs. Handoffs are hints to reconcile, not substitutes for live task state.

## Non-stop progress

When the primary thread is WATCH:

1. preserve exact-head evidence for the watched thread;
2. run the overlap/concurrency scan;
3. inspect repository-documented parallel-safe work;
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
- Roblox server/client integration tests;
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
4. return a compact report.

Do not recursively invent unbounded work. The repository roadmap remains the scope boundary.

## Compact final report

End every invocation with:

~~~text
SIGA <RESUME|WATCH|ADVANCE|BLOCKED> — <task/milestone>
Repo: <branch>/<short-sha> | PR: <#n/state or none>
Done: <material progress from this invocation>
Gates: <required exact-head gates>
Wait: <real pending gate or none>
Blocker: <actionable blocker or none>
Next: <single next action>
~~~

Prefer one screen. Live repository state remains authoritative.
