# SPEC-010 — Tasks

## Bootstrap

- [x] **R900** Create this Spec Kit with repository identity, scope, invariants and dependency graph.
- [x] **R901** Reconcile every current open PR into the evidence ledger with exact head/base, owner, spec/task mapping and claim state. Evidence: docs/siga/SPEC-010-PR-CHAIN-2026-10-20.md.
- [x] **R902** Classify every missing gate as executable, HUMAN_REQUIRED, CAPABILITY_BLOCKED, EXTERNAL_PROVIDER or STALE. Evidence: classification column and certification rules in the live ledger.
- [x] **R903** Persist one authoritative next action per active chain root and update the smallest relevant handoff. Evidence: ledger next-action column and docs/SIGA-HANDOFF.md.

## Root execution

- [ ] **R910** Verify ARTIST #77 source/concept lane without claiming runtime acceptance; route the first missing ARCH prerequisite.
- [ ] **R911** Verify ARCH #126 V201/V201a evidence and classify physical-device/import/rights limits.
- [ ] **R912** Verify GODOT #125 G452 isolated diagnostic and preserve its no-merge boundary.
- [ ] **R913** Verify CENA #128 V203 prototype and its downstream stacked branches.
- [ ] **R914** Verify LENTE #130/#142 exact-head A/B and REVISE findings.
- [ ] **R915** Verify QA/GODOT #134/#135/#139 export, hosting and interaction evidence.
- [ ] **R916** Verify SPEC-009/#141 web matrix governance and its 4/4 manual gate.

## Certification

- [ ] **R920** Re-run applicable exact-head checks after each corrective commit; mark stale evidence explicitly.
- [ ] **R921** Execute safe technical corrections through the owning specialist and preserve independent review boundaries.
- [ ] **R922** Update SPEC-004/SPEC-005/SPEC-008/SPEC-009 task links only when their own acceptance evidence exists.
- [ ] **R923** Merge only non-draft, dependency-ready PRs with expected-head guards; otherwise keep WATCH/BLOCKED.
- [ ] **R924** Reconcile master, open PRs, claims, handoffs and the final RELATORIO after every bounded unit.

## Definition of done

A task is checked only when its files, commands, exact SHA, result and next action are recorded in repository evidence. Human or unavailable capability gates must remain unchecked and named.
