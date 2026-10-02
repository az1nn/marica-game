CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 T020 verification + SPEC-003 AQ011 exact-head behavioral gate

STATE:
T020 guaranteed genetic advancement remains active in PR #26. AQ011 now has a repository-side candidate that converts Roblox Behavioral from SKIPPED-on-missing-config into an explicit fail-closed exact-head gate.

MODE:
WATCH

CANONICAL SOURCE:
az1nn/marica-game master + repository-local SIGA/GAUNTLET/QA skills + live specs/tasks/PRs/claims/CI.

ACTIVE PRODUCT:
T020 / PR #26 / feat/t020-genetic-advancement-algorithm.
Product implementation exists but is not accepted because behavioral Jest and mutation evidence are still missing.

QUALITY CANDIDATE:
AQ011 / feat/aq011-behavioral-exact-head-gate.
- behavioral job always starts;
- missing Open Cloud configuration fails explicitly;
- checkout is pinned to the PR head SHA;
- checked-out SHA is verified before runtime execution;
- Jest execution remains the acceptance evidence once configuration is present.

BLOCKER / WAIT:
Repository Open Cloud configuration is not present:
- secret ROBLOX_API_KEY;
- vars ROBLOX_TEST_UNIVERSE_ID and ROBLOX_TEST_PLACE_ID.
Until those exist, Roblox Behavioral must fail closed and T020 must not merge.

CONCURRENCY:
AQ011 changes quality infrastructure/handoffs only. T020 product files are semantically dependent on the resulting gate but do not overlap AQ011 mutation scope.

NEXT:
Provide the isolated Roblox test-place configuration, obtain an exact-head Roblox Behavioral PASS, then execute AQ012 mutation proof for T020.
