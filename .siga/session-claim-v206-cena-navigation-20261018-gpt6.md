# SIGA — exclusive CENA V206 corrective claim
Owner: SIGA → CENA; status CLOSED_FOR_WRITES / WATCH_EXTERNAL_GATES / NO MERGE.
Date: 2026-10-18 America/Sao_Paulo.
Branch: `cena/v206-portrait-pan-bounds-20261018`. Parent immutable CENA #128: `001e0469b4d848e4c005a62e888e4de12af767f4`.
Issue: #131; parent gate issue #127.
Prior CENA #128 claim and independent LENTE #130 claim CLOSED_FOR_WRITES. No modifications to ARTIST #77, ARCH #123/#124/#126 or GODOT #125.

Exclusive files: `game/src/presentation/v203_portrait_preview.gd`, `game/tests/v206_portrait_navigation_runner.gd`, `.github/workflows/v206-cena-navigation.yml`, `docs/cena/V206-PORTRAIT-NAVIGATION.md` and this claim.
No source PNG, farm world, G451 camera, G452 domain, master, LENTE code, SPEC task checkboxes or production acceptance edits.

Commit holds only the candidate. Verify new exact-head CI, mutation and native frames before any technical closeout; independent LENTE/ARCH/ARTIST gates remain open. Stop on competing active ownership.

## Verification and safe handoff (2026-10-18)
- Isolated implementation verified at `a3ceecb5eaa482cff73bb2f9961b6dfd5cf79939`: 17 GitHub Actions SUCCESS, 1 optional Roblox Behavioral SKIPPED, zero failed or pending.
- Dedicated native Godot V206 [workflow #39141104700](https://github.com/az1nn/marica-game/actions/runs/39141104700) SUCCESS. [Five real Godot Xvfb/Mesa screenshots + manifest artifact #12141277614](https://github.com/az1nn/marica-game/actions/runs/39141104700/artifacts/12141277614), GOOD→BAD→RESTORE, source SHA and exact-head checks. G415, V203, G451 and all required baseline checks SUCCESS.
- Independent LENTE still has original REVISE; portrait vertical void intentionally unresolved and input/world/rights/real-device/WebGL/G452 gates remain open. No visual runtime or ARTIST human approval is inferred.
- Issue [#131](https://github.com/az1nn/marica-game/issues/131) updated, corrective [PR #132](https://github.com/az1nn/marica-game/pull/132) remains DRAFT stacked on CENA #128, with all other specialists' branches untouched.
- This claim-closeout metadata creates a NEW HEAD: verify CI on the new exact SHA, rather than counting the predecessor's successful checks as current. No merge, no promotion of SPEC-005 V201/V201a/V203/V205/G452.
