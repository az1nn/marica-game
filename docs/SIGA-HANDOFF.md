CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-001 Succession P0 — T020 verification + T021 stacked implementation

STATE:
T020 remains open in PR #26 and cannot be accepted until Roblox Behavioral executes on the exact candidate and GAUNTLET mutation proof is produced. AQ011 remains open in PR #29 and fails closed because the isolated Roblox Open Cloud configuration is absent. T021 is now implemented as stacked PR #34 on top of the exact T020 head.

MODE:
WATCH

CANONICAL SOURCE:
az1nn/marica-game live repository + repository-local SIGA/GAUNTLET/QA skills + SPEC-001/SPEC-003.

LIVE BASES:
- master@16a0bd8016dfd33c4c2245248f00799a4e6db9be
- T020 / PR #26 @ b12daa4ef419b6e2980c8c71a206128a4db53384
- AQ011 / PR #29 @ 0d6155791e703e1c1bb92ee7d239a3e3c16307c6
- T021 / PR #34 code candidate @ 4f04e9d81ba43003fad4b3be75517a1052da8251

T021 DELIVERED:
- deterministic single-successor factory;
- successor genetic seed derived from succession seed + ordinal;
- ended-parent precondition;
- T020 genetic advancement reused unchanged;
- fresh juvenile/active successor state;
- founder soulbound restriction does not propagate to descendants;
- next-generation lineage metadata is constructed from the ended parent;
- tests cover determinism, sibling direction, lineage shape and invalid active-parent succession.

EXACT-HEAD EVIDENCE ON CODE CANDIDATE 4f04e9d:
- Validate skills: PASS;
- Roblox CI: PASS;
- format/static/build gates: PASS;
- Roblox Behavioral: SKIPPED because this stacked branch inherits the pre-AQ011 workflow and repository Open Cloud configuration is absent.

GAUNTLET:
BLOCKED for acceptance. Behavioral Jest and GOOD -> BAD MUTANT -> RESTORE evidence are still unavailable. Authored tests are not treated as executed behavioral proof.

BOUNDARY:
T022 still owns exactly two successors. T023 still owns idempotency. T024 remains the explicit pedigree-preservation verification unit. PR #34 must not merge before PR #26.

BLOCKER / WAIT:
External repository configuration required:
- secret ROBLOX_API_KEY;
- vars ROBLOX_TEST_UNIVERSE_ID and ROBLOX_TEST_PLACE_ID;
- API key permissions for place publish + Luau execution.

CONCURRENCY:
T021 is intentionally stacked on T020. AQ011 touches quality workflow/handoffs, not T021 domain/test files. Merge order remains T020 -> T021.

NEXT:
Provide the Roblox Open Cloud test-place configuration, obtain AQ011 exact-head Behavioral PASS, run the required GAUNTLET mutation proof on T020, then unlock the T020 -> T021 merge chain.
