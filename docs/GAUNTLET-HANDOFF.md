# GAUNTLET HANDOFF

Status: AQ010_CANDIDATE

## Foundation

SPEC-003 Agentic Quality Loop is active under SIGA. Missing behavioral execution is never promoted to PASS.

## AQ010 candidate

Branch: feat/aq010-open-cloud-behavioral-execution

Implemented:

- GitHub Actions workflow `Roblox Behavioral`;
- exact-head checkout and Rojo build of `test.project.json`;
- publication of the built RBXLX to a dedicated Roblox test place through Open Cloud;
- Luau Execution against the exact published place version;
- explicit Jest invocation because Luau Execution does not auto-run place Scripts;
- log/error propagation back to CI;
- syntax/format guards in the existing Roblox CI.

Configuration contract:

- secret: `ROBLOX_API_KEY`;
- repository variables: `ROBLOX_TEST_UNIVERSE_ID`, `ROBLOX_TEST_PLACE_ID`;
- API key permissions must include place publish/write and Luau execution for the isolated test place.

The behavioral workflow intentionally skips when the test universe/place variables are absent. A skipped workflow is missing evidence, not PASS.

## Product thread

T020 remains the active SPEC-001 P0 candidate in PR #26.

Its authored deterministic genetics tests cannot satisfy the new GAUNTLET mutation requirement until Roblox Behavioral actually executes against the candidate SHA.

## Next quality action

Verify AQ010 candidate gates and merge the wiring. Then AQ011 makes behavioral Jest execution an exact-head acceptance gate once repository Open Cloud configuration is present.
