Task: SPEC-003 Agentic Quality Loop foundation
Owner: GPT-5.6 Sol
Base: master@11295a68468eb5ac7eb447c1a08b5195db5fd524
Branch: feat/003-agentic-quality-loop
Scope: .agents/skills/gauntlet/SKILL.md; .agents/skills/qa/SKILL.md; .agents/skills/siga/SKILL.md; .agents/skills/README.md; tools/skills/validate.py; specs/003-agentic-quality-loop/*; docs/gauntlet/T018-SHADOW-PILOT.md
Opened: 2026-10-02
Status: ACTIVE

Concurrency intent:
- product roadmap remains SPEC-001; this branch adds repository-local quality protocol/tooling.
- no product/domain runtime files are modified.
- T018 is used only as a historical/shadow fixture after merge.

Reconciled drift:
- master advanced through T018 closure and RELATORIO terminal-stage work.
- RELATORIO/SIGA overlap was reconciled before GAUNTLET edits.
- later claim-closure-only drift is PARALLEL_SAFE and does not change the quality contracts.
- current product next action remains T020.
