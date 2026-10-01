---
name: siga
description: Master continuation protocol for Maricá Game. Reconcile live repository state, route to specialist skills, execute bounded work, verify exact-head evidence, merge safely and persist the next action.
---

# SIGA — Maricá Game repository continuation protocol

This skill is local to the repository that contains it. The repository is the source of truth.

## Repository identity lock

Canonical repository:

~~~text
az1nn/marica-game
~~~

Before reading operational backlog or mutating anything, verify the exact repository full name. Fail closed on mismatch.

Trust order:

~~~text
LIVE REPOSITORY / CI / RUNTIME EVIDENCE
> .specify/memory/constitution.md
> active specs / plans / tasks / ADRs
> repository-local handoffs
> chat / model memory
~~~

## Magic command

Treat standalone Siga / SIGA as the master continuation command.

## Mandatory lifecycle

Every successful invocation follows:

~~~text
RECONCILE
-> CLASSIFY
-> ROUTE
-> EXECUTE
-> VERIFY
-> MERGE when safe
-> CONTINUE
-> PERSIST
~~~

### RECONCILE

Inspect fresh live state:

- default branch and exact HEAD;
- open branches / PRs and overlap;
- current CI/checks;
- .specify/memory/constitution.md;
- active specs/*/{spec,plan,tasks}.md;
- relevant ADRs and docs;
- repository-local handoffs;
- active session claims under .siga/;
- exact files/contracts likely to change.

Never infer current state from chat when repository evidence exists.

### CLASSIFY

Choose exactly one:

- RESUME — dispatched work is incomplete.
- WATCH — primary work is waiting on a real external/check gate.
- ADVANCE — previous work is complete; start the next documented task.
- BLOCKED — no safe mutation is possible without a required human/product decision.

WATCH is non-terminal. If the primary thread is waiting, advance another safe bounded task unless a strict sequential roadmap forbids it.

### ROUTE

Use the smallest repository-local specialist that owns the concern:

- LORE — narrative canon, characters, places, tone, CÂNONE / RUMOR / ABERTO.
- ARTIST — approved visual direction, concepts and per-scene/object art review.
- CENA — production visual materialization, assets, composition, lighting, scene integration and provenance.
- ROBLOX — production runtime/platform implementation, server authority, persistence adapters, remotes and runtime performance.
- QA — automated gates, deterministic domain tests, runtime integration/E2E, persistence, performance and regression.
- LENTE — exact-head screenshots/video/object inventory and visual critique.
- RELATORIO — compact read-only CAVEMAN repository status.
- GODOT — portability/reference lane unless a newer ADR/spec selects Godot for production.
- 3JS — reference/prototype lane unless a newer ADR/spec selects Three.js.
- siga-concurrency — mandatory helper for mutating waves and merge safety.

SIGA retains authority for repository identity, task selection, concurrency, exact-head verification, PR delivery, merge and handoff persistence.

### EXECUTE

A SIGA run must produce a concrete progress unit. Status-only output is not a successful run.

Valid progress units include:

- implement/fix a task justified by the active spec;
- advance a bounded spec/plan/tasks/ADR;
- add tests/acceptance automation;
- complete a LORE/CENA/ARTIST bounded task;
- repair CI/tooling required by the current milestone;
- reconcile safe drift/conflict;
- merge verified work;
- create the next repository-visible task and execute its first meaningful step.

Do not invent busywork.

## Spec Kit contract

When constitution/specs exist:

1. constitution constrains all downstream artifacts;
2. spec owns user-visible/product contract;
3. plan owns technical decisions;
4. tasks own executable order;
5. implementation must remain traceable to those artifacts.

For a new product capability, specify before coding. Repairs that restore already-specified behavior may use a smaller repair path.

Current foundation rule: SPEC-001 is active. Its next unchecked foundation task is the engine/runtime ADR (T005), and the plan already records a Roblox-first product direction. SIGA must reconcile live tasks before assuming that remains next.

## Non-stop progress

When the main thread is waiting:

1. preserve exact-head evidence for the watched thread;
2. run overlap/concurrency scan;
3. choose the next safe bounded task;
4. create/claim it if necessary;
5. execute at least one meaningful step;
6. persist both watched and advanced state.

A declared STRICT_SEQUENTIAL roadmap overrides parallel advance inside that roadmap.

## Concurrency

Before any mutation load .agents/skills/siga-concurrency/SKILL.md.

Minimum snapshot:

- default-branch HEAD;
- working-branch HEAD;
- open PR heads;
- relevant workflow heads;
- blob SHAs for same-path edits.

Use dedicated branches, repository-visible session claims, optimistic write guards and exact-head validation. Never force-update as a normal conflict mechanism.

## VERIFY

Require only gates applicable to the change, but require them for the exact current head.

Possible gates:

- deterministic domain unit/property tests;
- persistence round-trip / idempotency tests;
- Roblox server/client integration tests;
- Studio/runtime smoke tests;
- lint/static validation;
- build/export validation when applicable;
- exact-head visual evidence for player-facing scene changes;
- ARTIST/CENA human acceptance when explicitly required by the active visual contract.

Green evidence for a previous SHA is stale.

## MERGE

When the PR is open, reconcilable, exact-head gates are green, no semantic collision remains and required acceptance is satisfied, merge without asking again.

Use expected-head guards when supported, then verify the resulting default-branch state.

## PERSIST

Update the smallest relevant handoff. At minimum docs/SIGA-HANDOFF.md should contain:

- verified repo/base/head;
- classification;
- active spec/task;
- work produced;
- gates and exact SHA;
- branch/PR;
- blockers;
- single next action.

Do not turn handoffs into changelog dumps.

## Compact final report

End every successful SIGA invocation with:

~~~text
SIGA <RESUME|WATCH|ADVANCE|BLOCKED> — <task/milestone>
Repo: <branch>/<short-sha> | PR: <#n/state or none>
Done: <material progress from this invocation>
Gates: <required exact-head gates>
Wait: <real pending gate or none>
Blocker: <actionable blocker or none>
Next: <single next action>
~~~

Prefer one screen. Repository state, not the report, is authoritative.
