# SIGA Claim — Q900 cross-browser web acceptance standard

- Date: 2026-10-18 (America/Sao_Paulo)
- Owner: SIGA → QA governance (documentation only)
- Branch: `spec/009-web-qa-four-browser-matrix-20261018` based on `master` `bbfc4a24e5da5ab0015fbda83bffc6f2109461f6`
- State: ACTIVE / isolated governance bootstrap
- Exclusive paths: `specs/009-web-browser-qa-matrix/{spec,plan,tasks}.md`, `.specify/memory/constitution.md`, this claim. No other paths.
- Purpose: establish four mandatory web acceptance cells (desktop Chrome, desktop Firefox, Android Chrome, Android Firefox) as standing release/QA contract.
- Adjacent work: SPEC-008 on PR #139 `qa/138-tap-feedback-20261018` is CLOSED_FOR_WRITES and stacked on PR #135; do not modify it or its parent, CI, game assets, tests, or preview hosting. Consumer reconciliation of the new standard must happen under separate authority after this governance PR is integrated.
- SIGA post-claim barrier: re-read branch heads, no overlapping claims before every write, use blob SHA guards for existing files. No merge under this claim.
- Human feedback evidence: user said zoom in/out and character/farm clicks work in desktop Windows browser; exact browser was NOT reported, so none of four named cells may be marked PASS from this alone.

## Governance closeout

- Status: **CLOSED_FOR_WRITES / SPEC_DEFINED / DRAFT_PR_141 / NO_MERGE**.
- Q900–Q902 completed as documentation-only PR #141; Q903 and Q904 explicitly remain future adoption/manual browser testing under independent claims.
- Q902 code/doc verification HEAD `4c52f5ac8ccc073c27849ee4995cc14f4dbe2491`: 15 SUCCESS, 1 optional SKIPPED, zero failures. This closeout commit creates a new SHA requiring CI exact-head reconfirmation.
- No source/runtime/asset/CI/hosting paths touched. QA-002 #139 existing closed claim not reopened, and previous Windows browser result not attributed to Chrome/Firefox.
