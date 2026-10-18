# SIGA — QA-001 Q804 HTTPS staging (exclusive claim)

Date: 2026-10-18 (America/Sao_Paulo)
Owner: SIGA → ARCH/GODOT + QA
Status: ACTIVE / Q804_PREDEPLOY_ONLY / NO_MERGE
Spec/task: SPEC-008 Q804 (unchecked)
Branch: `qa/133-https-staging-20261018`
Immutable source: draft PR #134 at `8edfec42f8499b8818fc03c9415ef59abd23518b`, stacked on CENA #132 at `82860359df7649a9bb0d0fd14e6fcbdf302eb57e`.
Parent: issue #133 / tracker #129.

## Exclusive write ownership

Only new paths: `.siga/session-claim-qa001-host-staging-20261018-gpt6.md`, `.github/workflows/qa-web-host-qualification.yml`, `tools/qa/qa_https_gate.py`, `tools/qa/test_qa_https_gate.py`, `docs/qa/QA-001-HOST-STAGING.md`, and an isolated draft PR body/comment.

No edits to `master`, `public/`, `vercel.json`, original founder PNG, ARTIST #77, ARCH #126, LENTE #130, CENA #128/#132, or QA export claim/PR #134. No overwrites of base `specs/008-qa-web-preview/tasks.md` or `docs/SIGA-HANDOFF.md` across owner branches.

## Bounded objective

Stage the **same existing immutable GitHub Actions exported Web artifact** into a portable static site. Enforce source branch SHA, artifact provenance/hash, byte-equivalence for all exported files; then optionally verify a user-authorized HTTPS URL by remote asset hashes and actual Chrome Godot-ready marker. CI staging is **not publication**. No automatic deploy to unapproved external hosts or source redistribution.

## Gates & human blockers

- Requires exact HEAD CI of this branch after scripts/workflow; no predecessor SHA inherits PASS.
- Remain Q804 OPEN until HTTPS host, distribution/rights and URL approved, immutable identical site deployed and remotely boot-tested.
- Q805 physical mobile/desktop human ACCEPT/REVISE/REJECT remains HUMAN_REQUIRED.
- ARCH V201/V201a, LENTE and ARTIST runtime gates independent; G452 gameplay incomplete.
- No merge, no claim of playable public URL without direct verification.
