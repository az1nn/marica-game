# V206 CENA — first corrective slice for SPEC-005 / issue #131

**PROPOSED / NOT PRODUCTION / LENTE REVISE STILL OPEN.** Stacked on CENA PR #128 exact HEAD `001e0469b4d848e4c005a62e888e4de12af767f4`. Independent LENTE PR #130 findings remain authoritative for original frame; ARTIST V4 concept ACCEPT preserved.

## Technical change
Portrait zoom 1.75 remains; lateral crop of G450 debug farm is now inspectable via one-finger touch / left-mouse drag. Camera clamps to the analytically projected isometric farm AABB. The axis with no overflow is locked to center; landscape 844×390 and desktop 1280×960 preserve G451 full fit. No source PNG change (original SHA-256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`), no production scene change, no G452 hydration or domain save edit.

CI generates real Godot 4.7.2 Compatibility/Xvfb/Mesa screenshots for 390×844 center/left/right, landscape 844×390 and desktop 1280×960. Captures include approximate 4px-sampled pixel bbox, upper/lower margins and farm pan limits, exact-head SHA, plus an inverted-direction mutation GOOD→BAD→RESTORE.

**Unresolved:** original portrait vertical void (~204px upper/lower) is not fixed, nor are responsive HUD/safe areas, real device touch, pinch, feet/contact, occlusion/Y-sort, WebGL export of THIS sample, atlas/rights or independent ARTIST runtime approval. No promotion of V201/V201a/V203/V205/G452; no merge.

## Handoff
1. Exact-head CI and captured image review (including no unintended camera overscroll).
2. Independent LENTE A/B on the changed code, including physical touch/WebGL as available.
3. CENA responsive-layout design for unused portrait regions, with explicit ARTIST/UX gate rather than inventing HUD.
4. ARCH import/rights/devices, SIGA merge protection.

CAVEMAN: Found cropped farm at portrait focus; made left/right reachable without changing approved art. Vertical empty region and full runtime gates stay REVISE.
