# LENTE — #131B independent AFTER inspection (SPEC-005 V205)

**Date:** 2026-10-18 BRT · **Verdict:** **REVISE (composition only)** · **Scope:** independent inspection of existing native Godot captures, **not** independent fresh Godot run, WebGL, human ARTIST approval, or production acceptance.

## 1. Provenance and reproducibility

- Source: isolated CENA [draft PR #136](https://github.com/az1nn/marica-game/pull/136), immutable candidate `a8b3b57d98d3285c947103d388571f36bc7ba099` based on CENA #132. Do not touch owner branch.
- Native Godot 4.7.2 Xvfb/Mesa run [#39154942879](https://github.com/az1nn/marica-game/actions/runs/39154942879), artifact [#12146976225](https://github.com/az1nn/marica-game/actions/runs/39154942879/artifacts/12146976225); GitHub recorded artifact ZIP digest `sha256:1a295fa2aadc6240d15189c2b981aaed8e0b1cc5a9e1ef5eb25b6a7d4f9fde04`.
- Six archived PNGs independently SHA-256-verified against **artifact** `verification.json`; archived manifest `head_sha` matches #136 exact HEAD; original V4 source `sha256:b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e` is declared invariant by the CENA job. This LENTE inspection does not separately re-fetch the binary asset and therefore does **not** assert independent original-art binary verification.
- The images below were **produced by CENA**, then inspected by LENTE with a separate RGB comparison and visible compositional review; do not label them independent LENTE screenshots.

| Native frame | Resolution | Verified SHA-256 prefix | Inspection |
|---|---:|---|---|
| `portrait-before.png` | 390×844 | `ff9eaa522a5b` | Gray top/bottom exterior, farm in central region |
| `portrait-after.png` | 390×844 | `76d721cd9ea3` | Decorative green underlay changes backdrop only |
| `portrait-left.png` | 390×844 | `0768fac0eda7` | Extreme pan reveals cropped lateral farm; founder partially offscreen |
| `portrait-right.png` | 390×844 | `5a84815434c2` | Opposite crop; founder partially offscreen |
| `landscape.png` | 844×390 | `2b8c15c282ce` | Existing fit retained, no green underlay |
| `desktop.png` | 1280×960 | `9ba5562bd3ce` | Existing small/debug farm, no green underlay |

## 2. Independent pixel audit

Analysis method: Python Pillow RGB arrays decoded from the six archived PNGs. For center portrait A/B, compare pixel-wise RGB equality, then classify BEFORE RGB different from the `(77,77,77)` gray backdrop. This is **image-level observation**, not source code or runtime interaction verification.

- Full 390×844 canvas: **329,160 pixels**; BEFORE→AFTER **198,900 RGB pixels differ (60.427%)**, **130,260 identical**.
- The original BEFORE frame contains **130,650 non-gray pixels** by this broad mask. **130,260/130,650 unchanged**; the other **390 (0.299%)** are at the farm/exterior compositing boundary from y=204 through y=639, commonly RGB `(64,67,65)` before and green blended tones after. Treat these as **edge-compositing differences to inspect**, not as automatic sprite mutation or definite art damage. The CENA higher-contrast/core mask reports **36,752 preserved and zero changed**; these measures use different masks and are not contradictory.
- The original 390×844 outer blank strips are ~**204 px above + 207 px below**, or **411/844 = 48.70% of portrait height** outside core farm vertical bounds. AFTER replaces the gray backdrop with decorative green motif but **does not add navigable plots, farm rows, interactive HUD or real-world area**. This is background coverage, not gameplay coverage.
- Manifest reports AFTER approximate non-background/motif coverage only through y=756, leaving ~**87 px** of relatively flat lower backdrop; left/right extremes have ~**27 px** and **147 px** below their motif estimates. Do not interpret this coarse threshold as empty HTML bars.
- Manifest `pan_limits_x = [-114.846, 160.100]` for portrait at zoom 1.75, but actual interactive horizontal reach and tap discrimination of the **#136** updated candidate in Chrome/Firefox/physical Android are not captured here. In DPR2 QA-002 on a **different** candidate, the viewport can fit horizontally and clamp pan: keep the responsive gate open.
- Archived landscape and desktop images are reported by CENA to match their V206 parent snapshots, but this LENTE pass has **not independently downloaded the parent snapshot** for a second equality calculation.

## 3. LENTE findings / gate decision

| Finding | Severity | Re-evaluation | Decision |
|---|---|---|---|
| **LENTE-V205-001** lateral clip/camera reach | P1 | CENA #132 enables bounded lateral pan, but center farm still touches both screen edges; screenshots at both extremes show founder partly offscreen. This is a pan design, not proof of complete safe framing. | **REVISE / partial remediation** |
| **LENTE-V205-002** vertical portrait dead area | P1 | Outer ~48.7% height changed from gray to decorative green. No added usable gameplay, no committed HUD/safe-area layout, no approved visual treatment. | **REVISE / remains open** |
| **LENTE-V205-003** desktop composition | P2 | 1280×960 retains large top/bottom margins (manifest ~232/231 px), debug farm remains visually small and provisional. | **REVISE / remains open** |
| **LENTE-V205-004** runtime/occlusion/rights | P1 | No WebGL render of #136, no 4/4 human Chrome/Firefox desktop+physical Android matrix, no actual #136 HUD, G452 hydrated pet, contact/Y-sort or import/atlas/rights/performance/ARTIST human verdict in this capture. | **BLOCKED / no approval** |

**Aesthetic observation, not a human ARTIST verdict:** center founder is visually legible, but highly textured/green decorative outer space suggests more world outside the plot without granting access. The difference between *background continuity* and *playable boundaries* must be explicit in visual affordances to avoid fake navigable tiles. The approved V4 identity is still conceptually intact; this report does **not** judge its commercial/production appearance.

## 4. Next authoritative gates

1. **CENA/UX + human decision:** determine whether noninteractive grass continuity is a valid direction **or** a separate HUD/vertical gameplay composition is required. Do not implement unapproved HUD or treat grass as a fix for useful-space deficit.
2. **LENTE owner new isolated capture (not this report):** fresh exact-HEAD after-run covering nearest vs fractional filtering, portrait/landscape/desktop, safe areas, contrast, alpha edge and contact/occlusion with real runtime interactions once available; ensure no new writable ownership overlaps.
3. **ARCH/GODOT/QA:** publish/test a WebGL build of the **updated #136 candidate** and bind deployed SHA to authenticated run. Apply approved SPEC-009 four-cell matrix when in force: WD-CH, WD-FF, WA-CH, WA-FF (physical); no emulation as a replacement.
4. **ARTIST human runtime decision** and remaining V201/V201a rights/atlas/mobile performance gates. The V4 concept ACCEPT in #77 is not runtime PASS.

**Disposition:** **REVISE**, return to CENA/#131 and keep #127, V201/V201a/V203/V204/V205, G452 and all other SPEC-005 tasks OPEN. This draft is a traceable independent *inspection report*, **not** completion of a new LENTE native A/B workflow or authorization to merge/release.
