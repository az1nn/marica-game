# CENA #131B — portrait exterior terrain continuity blockout

**Status: technical proposal only; not production, not gameplay, not V203/V205 or ARTIST acceptance.**

## Reconciled truth
- Live master `bbfc4a24e5da5ab0015fbda83bffc6f2109461f6` and upstream draft CENA #132 `82860359df7649a9bb0d0fd14e6fcbdf302eb57e`. This branch is **stacked onto #132** without editing its paths. Independent LENTE #130, QA #134 and ARTIST #77 remain separately owned. Original V4 accepted isolated concept/source preserved SHA-256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`.
- SPEC-005 `V207` belongs to **plants**; this new issue #131B scene uses no canonical V207 task name, nor changes task status.

## Scoped change
An opt-in `res://scenes/cena131b_terrain_preview.tscn` wraps untouched `v203_portrait_preview.tscn` and V206 navigation code. Only in a portrait aspect ratio above 1.35 does the new controller render a **dark-green decorative noninteractive exterior underlay** behind the existing G450 farm, extending its visual terrain continuity into the previously gray upper/lower portrait margins. The non-interactive underlay is generated as deterministic simple pixel blocks. It is not new cultivable land, a game-world boundary expansion, production terrain art, or an approved vegetation biome.

The G450 playable prototype grid remains exactly 12×10, with no changes to path, plot, structure or state logic. V206 clamped one-finger/mouse horizontal pan and portrait animal legibility remain as inherited. On desktop 1280×960 and landscape 844×390, the underlay is off, and the original technical camera and grayscale exterior remain intact. No source sprite modification or G452 save/domain mutation.

**Critical distinction:** The screenshot no longer has the same gray *background* after applying this concept, but filling background pixels is not the same as filling the viewport with useful gameplay, approving an HUD, meeting physical-device ergonomics or eliminating the product/interaction-level LENTE-V205-002 issue. Mark **CENA preview proposed; LENTE/ARTIST review needed**.

## Evidence / acceptance criteria
Exact PR-head Godot 4.7.2 Compatibility/Xvfb/Mesa native snapshots, six cases: before+after portrait center 390×844, pan left+right with underlay, landscape 844×390, desktop 1280×960. CI checks source blob/SHA, case count, bounds/pan invariant, portrait visual continuity background, unchanged landscape/desktop void baseline, preservation of existing original-farm opaque pixels (not miscounting anti-aliased edges), manifest tied to exact HEAD, negative-control mutation disabling underlay GOOD→BAD→RESTORE. Visual artifact PNGs and JSON include original head, transform, colors and source SHA.

## Pending gates / owners
- **CENA:** presenting a neutral blockout proposal only; needs review of whether exterior world continuity is desired or vertical margins should instead be assigned to an **approved** HUD or another camera/layout approach. No unauthorized HUD generated.
- **LENTE:** independently inspect exact candidate, including unwanted fake navigable edges, dead play area, contrast, and contact/occlusion when available. Existing LENTE findings remain OPEN.
- **ARCH/GODOT/QA:** pixel grid and alpha/filter policy, external rights; true WebGL export of **this** changed scene, physical Android Chrome and iOS Safari, real input/performance; no device certification from native CI.
- **ARTIST:** independent human review of runtime scene. Existing V4 concept ACCEPT is historical and unchanged.
- **SIGA:** draft only; no merge, V201/V201a/V203/V204/V205/V206/V207 closure, source promotion or overlapping claim writes.

**Next specific decision:** Inspect CENA #131B six-frame before/after proposal. Either accept this *environment-only* blockout direction for CENA iteration or request a separate ARTIST/UX-approved vertical HUD/focus layout. Do not treat decorative grass as resolved usable vertical space.
