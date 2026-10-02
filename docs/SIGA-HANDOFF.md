CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 Animal Core continuation

STATE:
T017 soulbound domain invariant is implemented on a dedicated candidate branch and awaits exact-head delivery gates.

MODE:
RESUME

CANONICAL SOURCE:
az1nn/marica-game master + .agents/skills/siga/SKILL.md + .specify/memory/constitution.md + live specs/tasks/PRs/claims/CI.

BASE / ENV:
master@837e29fbae0acdd5b1e51ee093dcb3e96cdc3671 / Roblox-first

ACTIVE PR / CLAIM:
Branch: feat/t017-soulbound-domain-invariant.
Claim: .siga/session-claim-t017-20261002-1307-sol.md (ACTIVE).
PR: pending creation.

SPEC / ADR:
SPEC-001 Animal Core; ADR-0001 runtime; ADR-0002 persistence/time.

DONE:
- Pet persists an explicit immutable soulbound flag;
- soulbound input is validated as boolean;
- domain transfer eligibility and rejection guards are available independently of UI/runtime;
- all existing Pet state transitions preserve soulbound;
- descendants do not inherit soulbound automatically;
- behavioral Jest coverage is authored;
- T017 is checked complete on the candidate branch.

VERIFY:
Required exact-head gates are pending for the final PR head:
- Validate skills;
- Roblox CI.

BLOCKERS:
None.

INVARIANTS:
- soulbound is a domain restriction, not a presentation rule;
- future transfer-capable paths must call the domain guard;
- descendants remain transferable by default unless explicitly soulbound;
- only az1nn/marica-game is authoritative for this project.

NEXT:
Open the T017 PR, verify exact-head gates, merge if green, then close the claim and persist T018 as the single next action.

VERIFY-FIRST:
Before merge, re-read master, PR head, open claims, overlap and exact-head workflows.
