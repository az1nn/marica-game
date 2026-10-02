# GAUNTLET HANDOFF

Status: AQ011_CANDIDATE

## AQ011 candidate

Branch: feat/aq011-behavioral-exact-head-gate

The Roblox Behavioral workflow now behaves as a real acceptance gate instead of silently skipping:

- the job always starts for pull requests;
- missing `ROBLOX_API_KEY`, `ROBLOX_TEST_UNIVERSE_ID`, or `ROBLOX_TEST_PLACE_ID` fails the job explicitly;
- checkout is pinned to the pull-request head SHA;
- a dedicated step verifies the checked-out commit equals that exact SHA;
- only then does the workflow build/publish the test place and execute Jest through Open Cloud.

A configuration failure is missing infrastructure/evidence, not a product-test failure and not PASS.

## Product thread

T020 remains open as PR #26. Its deterministic genetic-advancement candidate must not merge until Roblox Behavioral executes successfully on the exact T020 head and GAUNTLET can run the required mutation cycle.

## External configuration still required

- secret `ROBLOX_API_KEY`;
- variable `ROBLOX_TEST_UNIVERSE_ID`;
- variable `ROBLOX_TEST_PLACE_ID`;
- API key permission for place publishing and Luau execution on the isolated test place.

## Next quality action

Make the repository configuration available, obtain a PASS from Roblox Behavioral on the exact candidate head, then execute AQ012 GOOD -> BAD MUTANT -> RESTORE proof for T020.
