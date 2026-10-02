# Maricá Game — local skills

Repository-local operating system for:

~~~text
az1nn/marica-game
~~~

No other repository is an authority for Maricá Game task state, handoffs, claims, CI evidence or skill orchestration.

## Master

- SIGA — continuation, task selection, routing, delivery, exact-head verification, merge and persistence.
- siga-concurrency — concurrent-session collision protection for every mutating wave.

## Product / creative

- LORE — narrative canon.
- ARTIST — visual direction and human visual acceptance.
- CENA — production visual materialization.
- LENTE — exact-head visual evidence and critique.

## Engineering

- ROBLOX — production runtime/platform specialist under the currently ratified repository-local architecture.
- QA — automated quality gates.
- GAUNTLET — bounded adversarial quality loop: baseline, fresh critic, mutation proof and regression hunter under SIGA.
- GODOT — portability/reference lane unless explicitly activated by a newer local ADR/spec.
- 3JS — reference/prototype renderer lane unless explicitly activated by a newer local ADR/spec.

## Observability

- RELATORIO — compact read-only repository status.

## Default routing

~~~text
Siga
 -> identity lock
 -> reconcile live repo/spec/claims/PRs/CI
 -> classify RESUME/WATCH/ADVANCE/BLOCKED
 -> select task from live repository state
 -> route smallest owning specialist
 -> concurrency barrier before mutation
 -> execute bounded work
 -> exact-head QA / rendered evidence
 -> GAUNTLET for applicable high-risk/P0 acceptance
 -> guarded merge or WATCH
 -> persist handoff + one next action
 -> mandatory RELATORIO from fresh resulting state
~~~

Task IDs and "next task" state do not belong in this README or in the SIGA skill. They are derived from live specs/tasks, PRs, claims and handoffs on each invocation.
