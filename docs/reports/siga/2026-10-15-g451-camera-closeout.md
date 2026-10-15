# SIGA RELATORIO — SPEC-004 G451 camera (2026-10-15)

## REAL STATE / HANDOFF

- Base at claim: `master@5193b8002f63270be4fa52c49cbf6f455349aa63`.
- Owner and isolated branch: `godot/g451-isometric-camera-20261015`.
- Protected feature PR #120: `631d91bc0b495a6f0e3862543acc6c17ad55be0b` merged to `master@90855cf6c6a669d836f090fe8f13c35568e09f53`.
- Open ARTIST PR #77 and chicken concept PR #109 paths were checked and disjoint.

## EXECUTE

- Added opt-in `res://scenes/farm_iso_view.tscn` with canonical G450 scene under projected Node2D world.
- Added Camera2D orthographic basis `(0.70710678,0.35355339),(-0.70710678,0.35355339)` and viewport-centering; zoom bounds 0.5 to 2.0; wheel/magnification control and small-screen fit.
- Added standalone G451 runner, pinned Godot workflow and deterministic zoom-clamp mutation.
- Corrected exact `gdformat` feedback and `gdlint` max-returns, without changing gameplay contract.

## VERIFY

- Exact HEAD: G451 test and GOOD→BAD→RESTORE PASS, plus G450 farm, G440–G447, Godot CI, Validate skills, ARCH V201, Roblox CI, Web Preview Contract PASS (15 applicable GitHub Actions checks); optional Roblox Behavioral skipped.
- New files only in G451 lane; existing `game/project.godot`, G450 `farm_base.tscn`/layout, G440–G447 and ARTIST assets unchanged.
- No ARTIST/V201 production sprite approval, no live device visual capture, no gameplay pet/HUD nor Gate F certification.

## NEXT / OWNERSHIP

- G451 feature merge verified; mark G451 complete and close claim in separate docs PR with its own exact-head CI.
- Next atomic unit: G452 founding pet runtime composition; separate claim, no implied visual gates.
