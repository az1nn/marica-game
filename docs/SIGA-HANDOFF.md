CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 Succession P0 — T020 verification + T021 stacked implementation

STATE:
T020 remains open in PR #26 and cannot be accepted until the Roblox Behavioral exact-head gate can execute and GAUNTLET mutation proof is available. AQ011 remains open in PR #29 and currently fails closed because repository Open Cloud configuration is absent. While that external gate is waiting, T021 has been implemented on a stacked branch based exactly on the T020 candidate.

MODE:
WATCH

CANONICAL SOURCE:
az1nn/marica-game live repository + repository-local SIGA/GAUNTLET/QA skills + SPEC-001/SPEC-003.

LIVE BASES:
- master@16a0bd8016dfd33c4c2245248f00799a4e6db9be
- T020 / PR #26 @ b12daa4ef419b6e2980c8c71a206128a4db53384
- AQ011 / PR #29 @ 0d6155791e703e1c1bb92ee7d239a3e3c16307c6

T021 CANDIDATE:
Branch: feat/t021-deterministic-successors
Stacked base: feat/t020-genetic-advancement-algorithm / PR #26
Delivered behavior:
- pure deterministic single-successor factory;
- successor-specific seed derivation from succession seed + ordinal;
- generation only after parent lifecycle has ended;
- T020 guaranteed genetic advancement reused without redefinition;
- successor starts juvenile/active and non-soulbound;
- lineage advances one generation with ended parent as direct parent;
- tests cover repeatability, ordinal-driven genetic direction, lineage shape and active-parent rejection.

BOUNDARY:
T022 still owns the exactly-two-successors invariant. T023 still owns idempotency. T021 must not merge ahead of T020.

BLOCKER / WAIT:
External repository configuration is still required for behavioral execution:
- secret ROBLOX_API_KEY;
- vars ROBLOX_TEST_UNIVERSE_ID and ROBLOX_TEST_PLACE_ID;
- API key permissions for place publish + Luau execution.

CONCURRENCY:
T021 is intentionally stacked on T020 and does not mutate AQ011 workflow files. Merge order is T020 before T021.

NEXT:
Open and verify the stacked T021 PR against the exact T020 base; keep merge blocked until T020 passes the behavioral/GAUNTLET acceptance chain.
