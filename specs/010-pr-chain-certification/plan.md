# SPEC-010 — Plan

## Control loop

For each bounded unit, SIGA performs:

1. **IDENTITY** — verify az1nn/marica-game and default branch.
2. **RECONCILE** — read live master, PR heads, claims, active specs and checks.
3. **SPEC_GATE** — admit only an explicit task from a committed Spec Kit.
4. **CLASSIFY** — RESUME, ADVANCE, WATCH or BLOCKED.
5. **ROUTE** — select the smallest owner: ARCH, GODOT, QA, CENA, LENTE, ARTIST or SIGA.
6. **BARRIER** — claim, re-read branch/base/overlap, then mutate only after CLEAR/PARALLEL_SAFE.
7. **EXECUTE** — perform exactly one bounded task.
8. **VERIFY** — run applicable tests/captures/checks on the new exact head.
9. **MERGE/WATCH** — merge only when all applicable technical and human gates are satisfied; otherwise preserve draft/watch state.
10. **PERSIST** — update the smallest handoff and one authoritative next action.
11. **REPORT** — finish with RELATORIO using fresh live evidence.

## Dependency graph

~~~text
#77 ARTIST source/concept
  -> #126 ARCH V201/V201a measurement and import policy
  -> #128 CENA V203 portrait prototype
     -> #130 LENTE V205 A/B
     -> #132 CENA responsive pan
        -> #136 CENA portrait continuity
           -> #142 LENTE independent after-review
        -> #134 QA-001 Godot Web export
           -> #135 QA-001 Vercel hosting
              -> #139 QA-002 tap/drag feedback
#125 GODOT G452 diagnostic (parallel root; depends on ARCH/CENA/LENTE gates for acceptance)
#141 SPEC-009 web matrix (parallel governance root; physical Android cells are human/capability gates)
~~~

The graph describes merge order, not permission to close product tasks. A REVISE or CAPABILITY_BLOCKED result is a valid terminal state for a unit.

## Evidence ledger

For every unit record:

- PR number and exact head/base;
- spec/task and owner;
- changed paths and semantic overlap;
- checks/workflow URLs and state;
- artifacts/capture manifests;
- human gate and capability gate;
- correction performed, if any;
- next owner/task.

## Execution policy

The first executable units are technical/documentation repairs that do not require human acceptance. Physical-device, external-hosting-authentication, source-rights and visual acceptance gates are WATCH/BLOCKED and are surfaced to the user without being fabricated or bypassed.
