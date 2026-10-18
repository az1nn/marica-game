# QA-002 — Touch/click feedback for isolated Godot founder preview

**Owner:** SIGA → GODOT/QA · **Task:** SPEC-008 Q806 · **Issue:** [#138](https://github.com/az1nn/marica-game/issues/138).
**Status:** IMPLEMENTED CANDIDATE / CI AND ANDROID HUMAN QA REQUIRED / NO MERGE.

## Report and root cause

A human tester using Firefox on Android reported **"Clicks não funcionam"** on the protected Godot Vercel QA preview (PR #135). The original Android screenshot proved the real Godot farm and S01-A01 V4 founder render but did **not** prove functional input. In the verified source on PR #135, the QA wrapper `qa_web_preview.gd` only emitted an engine-owned readiness marker; CENA's V206 preview script handled `InputEventScreenTouch`/drag for camera panning but had no selection action or player-facing click feedback.

The missing tap handler is a known feature gap, not proof that all Firefox input events failed. CENA's pan implementation might have a separate device/gesture defect: physical Android testing remains required.

## Bounded diagnostic fix

Only the QA wrapper in `game/src/qa/qa_web_preview.gd` changes; original S01-A01 PNG, G451 camera, CENA pan controller, V203 scene, Godot default boot, domain/save and production UI are untouched.

- Real `InputEventScreenTouch` and left `InputEventMouseButton` press/release map to screen position; taps within 18px of their press become one selection. Drag paths are excluded.
- Godot viewport/canvas transforms hit-test the founder sprite first, then the projected G450 farm grid; other taps explicitly show a diagnostic outside-area message.
- `CanvasLayer` with non-intercepting controls shows "QA: toque no cachorro" and after selection "Cachorro fundador selecionado"; clearly flags that gameplay/care is not implemented.
- A 700ms synthetic mouse-after-touch suppression window avoids counting one physical tap twice. Input is *not* consumed, preserving CENA `_unhandled_input` pan.
- The browser `window.__MARICA_QA_TAP_STATE` is **emitted by GDScript after actual input**, with count, selection, projected founder location and camera X, `gameplay_enabled=false`. It is an observability hook, never a DOM click imitation.

## Test plan / acceptance

1. **Native Godot**: `game/tests/qa_tap_input_runner.gd` asserts mouse and screen touch founder selection, visible overlay label, synthesized mouse de-duplication, drag not selecting, and existing CENA camera pan still functional.
2. **Adversarial mutation**: flip the **unique** `QA_TAPS_ENABLED` guard `true → false`; the native test must fail; restore then pass. Exact original source validated.
3. **Real browser Godot WebAssembly**: `tools/qa/qa_tap_web_profile.py` launches locally exported Godot WebGL in hosted Chrome; performs actual `mouse.click()` and `touchscreen.tap()`, compares before/after PNG SHA and GDScript selection marker. Mobile CDP touch swipe should change camera X but not increment tap count. Chrome mobile viewport **emulated**, not physical Android.
4. **Original image**: enforce source SHA-256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e` and Git blob `da7806ebfcb051c8fd32ccdbad4760b7136f97dd`; do not merge production source.
5. **HTTPS / human**: create separate stacked draft above hosting PR #135 with unique verified Vercel preview URL. Do not disable authentication, claim a public URL, or mark Q806/Q807 PASS until CI + physical Firefox Android tester confirms that tapping the pet changes the banner and swiping farm moves view. Test same exact deployed commit, `qa-build.json` and engine marker when authorized; target preview may still require SSO.

**Not included:** complete animal-care UI, pet tapping inside true hydrated G452 gameplay, pet stats, movement/pathfinding, saving, ARTIST runtime approval, physical FPS/memory, or production/game merge.

## Handoff

QA-002 [#138](https://github.com/az1nn/marica-game/issues/138) remains P1 until actual mobile retest. Host QA-001 [#133](https://github.com/az1nn/marica-game/issues/133), CENA composition [#131](https://github.com/az1nn/marica-game/issues/131) and original founder ARTIST [#77](https://github.com/az1nn/marica-game/pull/77) remain independent gates. No unilateral merge or spec-checkbox closure.
