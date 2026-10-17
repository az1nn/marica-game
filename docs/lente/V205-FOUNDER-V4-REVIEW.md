# LENTE V204/V205 — S01-A01 V4 independent runtime review

**Result (visual screen review of CENA #128 source head `001e0469b4d848e4c005a62e888e4de12af767f4`): REVISE for scene composition.**
**Runtime ARTIST verdict: NOT_EVALUATED. ARCH V201/V201a: REVISE / CAPABILITY_BLOCKED. No merge, no V204/V205 completion.**

## Actual candidate and provenance
- `az1nn/marica-game` — stacked LENTE branch based on exact [CENA #128](https://github.com/az1nn/marica-game/pull/128) HEAD `001e0469b4d848e4c005a62e888e4de12af767f4` (16 required checks PASS, one optional SKIP). CENA claim CLOSED_FOR_WRITES.
- Original S01-A01 V4 dog concept remains ACCEPT; PNG bytes are unchanged. Git blob `da7806ebfcb051c8fd32ccdbad4760b7136f97dd`; SHA-256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`.
- CENA runtime sample is **opt-in nonproduction** `res://scenes/v203_portrait_preview.tscn`. It mounts the G451 isometric camera and G450 colored debug farm with a 0.25x test-copy source. This is NOT the playable hydrated G452 or complete shipping HUD.
- Predecessor capture artifact: [CENA exact source SHA, run #39042224199](https://github.com/az1nn/marica-game/actions/runs/39042224199), [two real-engine Xvfb/Mesa PNGs](https://github.com/az1nn/marica-game/actions/runs/39042224199/artifacts/12104716497).
- LENTE's **own** new exact-head evidence is generated through `.github/workflows/lente-v205-runtime-ab.yml`: seven fresh real Godot 4.7.2 Compatibility renderer screenshots (portrait G451 baseline vs CENA, nearest/linear, light/dark and 1.25 fractional scale, desktop nearest/linear) with SHA-pinned original, source commit manifest, numeric framing measurements, findings, CAVEMAN and versioned `artifacts/lente/runs/` artifact. The run must complete successfully before calling these independent new captures verified.

## Independent inspection of predecessor screenshots
The source Godot PNGs were visually inspected at their native 390x844 and 1280x960 sizes, independently of CENA's opinion. The founder V4 is recognizable and clear, retaining tri-color identity, red bandana and non-lossy appearance at visible scale. Pixel-art source grid/palette, nearest/fractional aliasing, transparency halo and final texture policy are **not** certified by this visual observation.

Technical RGB-image measurements from exact source screenshots (background `#4d4d4d`):
- **Portrait 390x844:** visible non-background extent x=0–389, y=204–639 (inclusive). 130,650 pixels differ from background (39.69% of frame, measured raw pixels). Farm hits both left and right edges, proving lateral clipping. Blank top/bottom ~204 px each.
- **Desktop 1280x960:** visible non-background extent x=141–1138, y=231–728 (inclusive). 246,976 non-background pixels (20.10% frame), a large empty perimeter.
- These are screenshot pixel occupancy/geometry measures, **not safe interaction area, frame rate or approved UI utilization**.

## Findings and owner routing
| Finding | Severity | Owner | Observed problem | Required acceptance evidence |
| --- | --- | --- | --- | --- |
| LENTE-V205-001 | P1 | CENA | Portrait farm clipped on both horizontal edges at focus zoom 1.75 | New actual Godot portrait + landscape composition without unintentionally cropped navigable farms |
| LENTE-V205-002 | P1 | CENA | Portrait vertically underutilizes display, ~204 px blank above and below | Responsive camera/FOV/HUD layout accepted on real screenshot with safe areas |
| LENTE-V205-003 | P2 | CENA | Desktop canvas uses large background margins, debug farm placeholders | Intentional viewport composition, production-motivated scene layout and independent capture |
| LENTE-V205-004 | P1 blocker | SIGA → ARCH/GODOT/CENA | Missing real HUD, touch size/safe area, alpha on terrain in overlapping scenes, Y-sort feet/foreground, G452 save-hydrated runtime, actual WebGL export of this candidate and physical mobile/browser QA | Independent exact-build screenshot/video + interaction evidence; ARCH contracts and device/memory/frame budget; ARTIST final human runtime verdict |

## Rules and next actions
- LENTE may label **REVISE** for the actual shown technical scene; this is not a rejection of accepted V4 source concept, nor a claim to decide ARTIST.
- **Do not mark V201/V201a/V203/V204/V205/G452 PASS**. No merge of LENTE PR, CENA #128, ARTIST #77 or ARCH #123/#124/#126 / GODOT #125 while dependencies are open.
- First owner action: CENA revise the portrait world framing and fill without introducing premature final HUD or altering approved source; allow intentional farm navigation (e.g., pan/zoom) if visual bounds require clipping.
- Then LENTE independently recapture the exact updated exported **Godot WebGL** scene and verify sampling, nearest/fractional zoom, light/dark terrain, alpha halos, feet contact, foreground Y-sort, HUD 44dp+ target semantics when implemented (actual CSS/Godot sizing must be measured), plus real Android Chrome/iOS Safari when external devices are available. Browser DPR emulation is not a real physical device.
- Route the final visual runtime candidate to ARTIST for independent human ACCEPT / REVISE / REJECT only after relevant ARCH and CENA gates.

## CAVEMAN
LENTE V205 — Source CENA #128
Seen: approved founder V4 visible with improved portrait legibility.
Broken: portrait lateral crop and vertical void; desktop margin; no player-facing HUD/depth/device.
Good: preserved original dog, no evidence of binary modification; honest technical scene.
Route: LENTE-V205-001/002/003 → CENA; LENTE-V205-004 → SIGA/ARCH/GODOT.
Next: CENA revise responsive scene/camera contract, then LENTE independent exact-head A/B + ARCH gates; keep all PRs draft.
