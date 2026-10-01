---
name: siga-concurrency
description: Protect Maricá Game from concurrent-session collisions using live snapshots, repository-visible claims, overlap scans, optimistic writes, exact-head gates and guarded merges.
---

# SIGA-CONCURRENCY — concurrent mutation safety

This helper is mandatory whenever SIGA or a specialist may mutate repository state.

Canonical repository:

~~~text
az1nn/marica-game
~~~

## Goal

Multiple sessions may work in parallel, but no session may overwrite or falsely validate another session's work.

## Pre-mutation snapshot

Before the first mutation capture:

- default branch + exact HEAD;
- intended working branch + HEAD;
- open PR numbers/base/head SHAs;
- active session claims under .siga/;
- relevant workflow/check heads;
- blob SHAs for files expected to change;
- active spec/task keys.

## Dedicated branch

Feature/runtime mutation must use a dedicated branch unless the task is an explicitly safe repository-maintenance write that policy allows on default.

Branch names should identify the bounded task.

## Session claim

Before substantive mutation create a repository-visible claim:

~~~text
.siga/session-claim-<task-key>-<session-id>.md
~~~

Minimum claim:

~~~text
Task: <task key>
Owner: <session identifier>
Base: <default branch + sha>
Branch: <working branch + sha>
Scope: <files/contracts expected>
Opened: <timestamp if available>
Status: ACTIVE
~~~

Claims coordinate; they do not reserve unrelated files forever.

## Post-claim barrier

After publishing the claim, re-read:

- default HEAD;
- open PRs;
- claims;
- overlapping files/contracts.

This barrier is mandatory even when the first scan found no competing work.

## Drift classification

Classify new state as exactly one:

- CLEAR — no relevant drift.
- PARALLEL_SAFE — concurrent work exists but does not overlap semantics/files.
- RECONCILE — safe integration/rebase/update is needed before continuing.
- COLLISION — same contract or file is being changed incompatibly; stop mutation and resolve.
- SUPERSEDED — newer accepted work makes this task unnecessary.
- GATE_STALE — validation belongs to an older head.

Semantic overlap matters even when filenames differ.

Examples:
- two tasks changing Pet lifecycle invariants are overlapping;
- CENA and ROBLOX both changing the same camera contract may overlap;
- docs-only lore and isolated QA test work may be parallel-safe if contracts are independent.

## Before every logical write batch

Re-read the smallest live state that can invalidate the batch:

- target file blob SHA;
- branch head;
- default head if dependency-sensitive;
- overlapping PR/claim state.

A failed optimistic write means re-read and reconcile. Never bypass with force.

## Handoff conflict rule

Handoffs are reconstructed from live facts.

If another session changed a handoff:

1. fetch newest version;
2. preserve newer verified facts;
3. add only facts verified by this session;
4. never restore stale branch/CI/task state.

## Exact-head validation

Validation is attached to a SHA.

~~~text
validated_sha != current_head -> GATE_STALE
~~~

After any commit that can affect the tested contract, rerun required gates or obtain a fresh workflow result for the current head.

## PR overlap scan

Before implementation and again before merge:

- inspect every open PR touching the same feature/domain;
- compare changed files when available;
- compare semantic contracts;
- identify stacked dependencies;
- identify sibling implementations.

Never merge competing sibling implementations without reconciling or marking one SUPERSEDED.

## Merge contract

Before merge verify:

- expected PR head SHA is current;
- base has not invalidated assumptions;
- required checks are green for that exact head;
- required human/visual acceptance is complete;
- no active collision exists;
- dependency order is satisfied.

Merge with expected-head guard when supported.

After merge verify default branch contains the result and run any required post-merge gate.

## Claim closure

When work is merged/superseded/abandoned, update or archive the claim with final state. Never leave an ACTIVE claim that no longer represents real work when you can safely close it.

## No-force rule

Force pushes/force file overwrites are not normal concurrency tools.

Optimistic conflict -> re-read -> classify -> reconcile.

## Completion report

Return to SIGA:

~~~text
Concurrency: <CLEAR|PARALLEL_SAFE|RECONCILE|COLLISION|SUPERSEDED|GATE_STALE>
Base: <sha>
Branch: <sha>
Overlap: <none or exact task/PR>
Claim: <path/status>
Merge safety: <ready/not-ready + reason>
~~~
