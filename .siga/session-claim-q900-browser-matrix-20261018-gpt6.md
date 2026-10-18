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
