# SPEC-005 — Plan (Godot ARTIST V2)

**Status:** PLAN ACCEPTED AS ENGINEERING ROADMAP; EXECUTION NOT STARTED
**Source:** approved G1–G25, SPEC-004/Godot, `docs/VISUAL-DIRECTION.md`

## Architecture

Keep domain state and logic independent of scene or rendering choices. Use Godot 4.x typed GDScript, Godot-native scene composition, pixel-art sprites/tiles and a 2.5D presentation. ARCH must select integer scaling, logical reference resolution, texture filtering, y-sort/depth policy, rendering pipeline and mobile performance envelope **after measured prototype** rather than hardcoding unverified technical numbers.

## Delivery order

1. **V200 R0 / governance:** reconcile master and ledger; publish this SPEC/PLAN/TASKS, historical vs approved direction, ownership and handoff. No graphics runtime changes.
2. **V201 R1 / architecture:** define measured render contract, import pipeline, camera/layout and acceptable effects budget for browsers and touch devices. ARTIST reviews examples; ARCH owns technical choice.
3. **V202–V205 R2 / animal:** one approved sprite/animation set, Godot in-game scene, care/state legibility, mobile HUD and independent runtime evidence; REJECT is valid. Must not change animal domain behavior.
4. **V206–V207 R3 / plants:** botanic pixel sprites with growth/harvest cues and regression checks; after animal visual baseline PASS.
5. **V208–V209 R4 / farm:** modular buildings, construction overlay, compact farm, day/night/weather, performance tests; after plant visual PASS.
6. **V210+ optional / town:** town/NPC scenes after V1 core priorities, based on SPEC-004 readiness.
7. **V211 / release gate:** mixed-size viewport screenshots, accessibility, mobile/web performance and exact export smoke before migrating release baseline.

## Gates

**Gate A — scope:** owner assignment and active-roadmap collision check; follow SIGA claim + optimistic writes.
**Gate B — architecture:** Godot import/headless and runtime profile; ARCH documents tested resolutions/frame budget.
**Gate C — art:** ARTIST approves actual pixel-art composition, and the human can reject the visual result.
**Gate D — evidence:** LENTE captures current exact-head runtime and independent A/B; no mockup-only proof.
**Gate E — delivery:** CI for exact PR HEAD green, branch/current master reconciled, no active semantic collision; only then merge.
**Gate F — deploy:** Vercel and Cloudflare must be validated together on the same exported build SHA in a subsequent deployment workstream. Not accomplished by this documentation PR.

## Rollback

Keep V1 assets/scenes available until V2 vertical slices pass. No irreversible deletion; a rejected slice falls back to the current runtime implementation without changing save/domain schemas.
