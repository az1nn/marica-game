# SPEC-010 — Open PR Chain Certification

**Status:** BOOTSTRAP / EXECUTION QUEUED  
**Authority:** SIGA, constrained by Constitution v2.0.0 and existing SPEC-004, SPEC-005, SPEC-008 and SPEC-009 when admitted.  
**Repository:** az1nn/marica-game

## Intent

Create one auditable operational contract for the open pull-request chain. Every PR must be mapped to an existing product/technical task, have a current exact-head evidence record, distinguish executed work from pending work, and expose only genuine HUMAN_REQUIRED or CAPABILITY_BLOCKED decisions.

This spec does not replace feature specs, does not close their checkboxes, and does not authorize visual/product acceptance.

## Invariants

- Repository identity is exactly az1nn/marica-game.
- A green result is valid only for the exact current commit SHA.
- A concept, prototype, emulator capture or documentation audit is not runtime acceptance.
- Human visual/product decisions, source-rights decisions and physical-device evidence remain fail-closed.
- Provider failures are classified as EXTERNAL_PROVIDER, not silently converted to code success.
- Each bounded unit has one owner, one task ID, one branch/head, one evidence set and one next action.
- A stacked child cannot be merged before its parent is verified and its applicable gates are complete.
- No task checkbox is closed from chat memory or stale PR prose.

## Scope

The chain includes the current roots and descendants:

- ARTIST source/concept: PR #77.
- ARCH V201/V201a evidence: PR #126.
- GODOT G452 diagnostic: PR #125.
- CENA V203 and responsive follow-ups: PRs #128, #132, #136.
- LENTE V204/V205 and independent review: PRs #130, #142.
- QA/GODOT web evidence and hosting: PRs #134, #135, #139.
- Web QA governance matrix: PR #141.
- The already merged documentation reconciliation PR #123 remains historical evidence only.

## Acceptance

SPEC-010 is complete only when every open PR has:

1. a canonical spec/task mapping;
2. current branch/head/base evidence;
3. exact-head checks classified PASS/FAIL/RUNNING/MISSING/STALE;
4. executed artifacts or an explicit NOT_EXECUTED reason;
5. human and capability gates separately listed;
6. dependency state and owner;
7. a single next action.

A PR may remain open/draft and still be fully documented. Documentation is not acceptance, and acceptance is not merge authorization.
