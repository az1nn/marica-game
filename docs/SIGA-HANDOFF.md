# SIGA HANDOFF — live operational truth

- Repository: az1nn/marica-game
- Default branch: master
- Verified master HEAD: 42a9e26df571b0d6dc19d3ad36110709955167e4
- Classification: RESUME
- Active Spec Kit: SPEC-010 — Open PR Chain Certification
- Active task: R920 — exact-head revalidation
- Active governance PR: #143, draft, branch codex/spec-010-pr-chain-20261020
- Current governance branch head: b85d749a5d2bf10fd296c953233ca2ede247ac68
- Last verified merge: #123 documentation audit, squash merge at master@42a9e26df571b0d6dc19d3ad36110709955167e4
- #124 was previously merged and remains in master ancestry.

## Completed in this bounded unit

- Created committed SPEC-010 spec/plan/tasks.
- Reconciled all 13 currently open PRs into docs/siga/SPEC-010-PR-CHAIN-2026-10-20.md.
- Mapped each open PR to an owner, canonical spec/task, exact head/base and one next action.
- Classified current gates as HUMAN_REQUIRED, CAPABILITY_BLOCKED, REVISE, EXTERNAL_PROVIDER or UNVERIFIED.
- Recorded the validation command and result; it passed on a different local checkout and is STALE for PR #143.
- Preserved all visual/product/physical-device/source-rights gates as fail-closed.
- Replaced this handoff's stale historical-only state with the current operational snapshot.

## Chain roots and current truth

- #77 ARTIST: concept accepted; runtime/import/ARCH/SCENE/LENTE gates open.
- #126 ARCH: technical web evidence reported; physical device, rights/import/atlas/pixel-grid and visual gates blocked.
- #125 GODOT: isolated G452 diagnostic reported; explicit no-merge boundary and visual acceptance dependencies remain.
- #128 CENA: V203 technical prototype reported; CENA/ARCH/LENTE/ARTIST gates remain open.
- #141 QA: SPEC-009 governance exists on its branch; 4/4 browser matrix is not executed.
- Descendants #130, #132, #134, #135, #136, #139 and #142 remain stacked or dependent and cannot be promoted by green CI alone.

## Next action

Execute SPEC-010 R920: obtain exact-head validation for PR #143 or add a bounded exact-head CI path; keep the PR draft until then. Do not merge any draft or close any human/capability gate.
