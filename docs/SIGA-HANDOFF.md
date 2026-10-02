CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 Animal Core continuation

STATE:
T017 soulbound domain invariant is merged and complete. Live task order advances to T018 persistent affection.

MODE:
ADVANCE

CANONICAL SOURCE:
az1nn/marica-game master + .agents/skills/siga/SKILL.md + .specify/memory/constitution.md + live specs/tasks/PRs/claims/CI.

DELIVERY:
PR #16 merged.
Delivery HEAD: 46dd15acde656b42c9ce92930e9edb5720f2458d.
Merge commit: bca1b81410aa79af06c47b052e14478b2e578c03.

BASE / ENV:
master / Roblox-first

ACTIVE PR / CLAIM:
No product PR after #16 merge.
T017 claim is CLOSED by this handoff closure.
RELATORIO visual-contract claim is also CLOSED and was PARALLEL_SAFE.

SPEC / ADR:
SPEC-001 Animal Core; ADR-0001 runtime; ADR-0002 persistence/time.

DONE:
- Pet persists an explicit immutable soulbound flag;
- invalid soulbound values are rejected;
- transfer eligibility/rejection is enforced in the domain rather than UI/runtime;
- lifecycle, care and health transitions preserve soulbound;
- descendants do not inherit soulbound automatically;
- behavioral Jest coverage documents the invariant;
- T017 is checked complete in the executable SPEC-001 backlog.

VERIFY:
PR #16 exact-head gates PASS at 46dd15acde656b42c9ce92930e9edb5720f2458d:
- Validate skills: PASS;
- Roblox CI: PASS, including lockfile reproducibility, StyLua, Selene and production/test builds.

CONCURRENCY:
- master drift from RELATORIO visual-contract work was reviewed before merge;
- drift touched only RELATORIO skill/report files;
- classification: PARALLEL_SAFE;
- no T017 files or semantic contracts overlapped.

BLOCKERS:
None.

INVARIANTS:
- soulbound is a domain restriction, not a presentation rule;
- future transfer-capable paths must call the domain guard;
- descendants remain transferable by default unless explicitly soulbound;
- only az1nn/marica-game is authoritative for this project.

NEXT:
Execute T018 — persistent affection — from fresh master state, keeping affection distinct from transient care and preserving it for future ownership transfers.

VERIFY-FIRST:
Re-read master HEAD, open PRs, active .siga claims, T018 task contract and exact-head workflows before mutation.
