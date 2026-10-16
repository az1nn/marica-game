# ARCH V201/V201a — browser/device evidence and conditional import contract

**Status:** TECHNICAL_WORK_IN_PROGRESS / CAPABILITY_BLOCKED for physical-device profiling and Godot web export. This is not final V201/V201a sign-off, not shipping art, not a release build and not ARTIST approval.
**Task:** SPEC-005 V201 and V201a; related downstream SPEC-005 V202–V205 and SPEC-004 G452/G458 remain OPEN.
**Owner:** SIGA dispatches ARCH, then CENA → LENTE → ARTIST under separate gate authority.

## 1. Immutable source and already verified technical facts

- Human-approved *isolated concept* S01-A01 V4: original on ARTIST draft PR #77; non-production byte-identical copy `game/assets/arch_probes/S01_A01_v4_original.png` in master.
- Original blob `da7806ebfcb051c8fd32ccdbad4760b7136f97dd`, SHA-256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`. 344 × 378 RGBA, 174,947 bytes.
- Verified native Godot import and sprite settings: nearest filter explicitly set, Y-sorted isolated root, feet contact offset `(0,-182)`. PR #88; four Xvfb/Mesa actual Godot screenshot conditions in PR #97.
- PR #124 (independent, still draft) extends that to eight Godot Xvfb/Mesa captures, original SHA protected, integer and fractional zoom nearest-versus-linear screenshot pairs. Its HEAD `79a28564` reported 17 applicable PASS / one nonrequired SKIP. Two-frame wall-time readings are not steady-state FPS.
- The **source is not automatically a validated logical pixel-art sprite grid**: many distinct colors exist (historical technical inspection counted 37,780 opaque RGB colors), and its zero/one alpha with nonblack transparent RGB can interact poorly with downsampling. No destructive conversion or palette reduction is approved.

## 2. Browser evidence (new isolated lane)

`tools/arch/v201_browser_probe.html` reads the same original PNG without modification. `tools/arch/v201_browser_profile.py` drives a **real Chrome browser process on the Ubuntu GitHub runner**, captures six Canvas2D renderings and 89 RAF intervals per condition, with forced canvas redraw, including desktop and emulated narrow mobile viewports/touch input. Screenshots and a SHA-stamped JSON manifest are uploaded by `.github/workflows/v201-browser-evidence.yml`.

Scenarios: 390×844 DPR2 at 0.5× nearest and 1.25× nearest/linear on dark background; 432×768 DPR1 at 1× nearest on light background; 1280×960 DPR1 at 2× nearest/linear on dark background. Browser PNG dimensions must match CSS size × DPR, pair hashes must differ, samples must not be empty, and the source Git blob/hash is pinned. QA deliberately changes nearest to linear and requires GOOD → BAD → RESTORE.

**Scope boundary:** Actual Chrome/browser Canvas2D API is exercised; mobile *viewport and touch are emulated on desktop*, not a physical phone. This is **not Godot's WebAssembly/web export**, not the in-game farm renderer, not a real Android/iOS GPU, not a Safari test and not a frame-budget pass. RAF intervals measure this proxy in a variable hosted CI environment. Neither GPU occupancy nor memory peak nor game-loop update time is measured. No screenshots are ARTIST-approved without independent LENTE/ARTIST review.

## 2b. Actual Godot WebAssembly export evidence (separate from the Canvas proxy)

A second, independently checkable lane is provided by `.github/workflows/v201-godot-web-proof.yml`. It downloads the **official Godot 4.7.2 binary and export templates with fixed SHA-256**, and temporarily switches only the CI checkout's `game/project.godot` to the opt-in `game/scenes/arch_v201_web_probe.tscn`. It then restores the unchanged committed project file; no production default scene or committed export preset changes.

The scene instantiates the existing G450/G451 farm/camera and a source-preserving, small founder V4 Sprite2D. The Godot Web build itself raises a JavaScript ready marker through `JavaScriptBridge` when that scene loads. `tools/arch/v201_godot_web_profile.py` launches the resulting **actual Godot WebAssembly/WebGL canvas** in Linux-hosted Chrome for desktop and mobile-emulated viewports, requires the *engine runtime marker* (not merely a downloaded HTML shell), records two screenshots and 89 RAF intervals per browser case, and hashes the immutable exported build files plus captures. It explicitly records physical mobile=false and does not call browser RAF a Godot engine frame-time budget.

**Evidence status:** source/CI authored, NOT measured until the exact candidate HEAD's `V201 Godot Web Export Proof` workflow completes green. A red workflow must be analyzed; this file must not be interpreted as a successful Godot Web export by itself. Even green on hosted Chrome does not certify physical Android/iOS, Safari or the full G452 gameplay scene.

## 3. Candidate import/filter contract (source-preserving; production decisions partially open)

| Area | Bounded ARCH policy / verification | Production gate |
| --- | --- | --- |
| Provenance | Keep ARTIST V4 PNG bytes unchanged and assert exact SHA-256/Git blob for every diagnostic run | Explicit asset redistribution/ownership confirmation before release |
| Sampling | Nearest in existing isolated Godot Sprite2D probe; linear used only as a negative A/B control | Inspect edges, alpha fringe and perceived quality on actual exported mobile/web scene with LENTE |
| Pixel grid / palette | Never invent an original logical pixel unit, quantize/recolor or scale the source file silently | ARTIST and ARCH must accept an intentional native pixel grid or request a separate approved production sprite derivative |
| Alpha | Preserve original binary alpha; inspect halo/fringe under fractional zoom, light/dark/terrain and in-world overlaps | Browser + Godot exported screenshot check; reject visible fringe |
| Import / compression | Do not enable lossy transformations, mipmap/downsample or indiscriminate filtering in this diagnostic lane | Pin explicit Godot import settings and verify runtime resource/texture memory after full render sample |
| Atlas | **NO atlas committed**: leave original single texture isolated; do not move it into a packing pipeline without evidence | Propose packing only with declared padding/extrusion, atlas capacity and alias-free edges measured in representative dense farm |
| Foot/depth | y-sort root and offset `(0,-182)` are exercised in the isolated Godot import probe; G451 camera implements bounded zoom | CENA verifies actual in-farm y-sort overlap, feet positioning and contact shadow; LENTE captures it |
| Logical resolution | G451 fit-to-viewport uses zoom bounds 0.5–2, but it is NOT a signed-off responsive pixel-grid strategy | Confirm visible founder size, effective CSS/device pixels and UI hit targets in portrait/desktop scene |
| Performance | Store sample timings, Chrome version, CSS/DPR and actual GPU/browser information where available | Godot exported web build and physical-device p50/p95 frame times, input latency, memory and thermal stability required |

The current uncompressed RGBA8 footprint of a **single** 344 × 378 texture is 520,128 bytes, excluding import copies, mipmaps, atlas padding or GPU format overhead. This is a size *calculation*, not a measured GPU allocation or an approval budget.

## 4. Explicit capability gaps and test matrix

| Gate target | Today | Required next evidence |
| --- | --- | --- |
| Godot editor/headless import | VERIFIED via PR #88 | Preserve original source |
| Godot software OpenGL desktop simulated viewports | VERIFIED technical-only via PR #97 and #124 | LENTE screen comparison and exported scene |
| Real Chromium Canvas2D proxy | CI-instrumented, require matching exact-head successful run | Archive manifest, per-frame timing and screenshot hashes |
| **Godot web export in Chromium** | **CI implementation awaiting exact-head result** | Verify official-template hash, actual Godot WebAssembly ready marker, exported build SHA, screenshots and browser RAF (not engine FPS) |
| **Physical Android Chrome** | **CAPABILITY_BLOCKED** | Real handset/version/GPU, exported Godot web build, portrait/touch FPS p50/p95, long-session memory/frame stability and screenshots |
| **Physical iOS Safari** | **CAPABILITY_BLOCKED** | Real iPhone/iOS/Safari test on same source/export SHA with compositor/texture behavior and screenshots |
| **Actual final pixel-grid/atlas and rights** | **UNAPPROVED** | ARCH policy with ARTIST visual review, publisher rights confirmation and texture/atlas profile |

A browser user-agent that claims to be mobile, or Chrome emulation's device scale factor, is *never* physical-device evidence. No automatic promotion of this proxy to V201/V201a PASS is allowed.

## 5. Staged owner handoff (queued; not false claims of peer execution)

1. **ARCH V201/V201a — OPEN:** inspect exact-head browser/Godot evidence, choose a measurable original-preserving import setting and evaluate actual Godot web-export/mobile hardware path. Report CAPABILITY_BLOCKED on missing device/export access. Keep all PRs draft.
2. **CENA V203/G452 — QUEUED:** use opt-in Godot scene of draft PR #125; validate founder dimensions, feet/pivot, foreground/behind occlusion, terrain, touch-safe composition and HUD layering. Do not merge this before ARCH prerequisites.
3. **LENTE V204/V205/G458 — QUEUED:** capture **the same exact Godot candidate HEAD/build** with nearest-vs-linear, integer/fractional zoom, dark/light/terrain and relevant player actions. Browser Canvas2D proxy images are supplementary, not acceptable substitutes.
4. **ARTIST — HUMAN_REQUIRED after LENTE:** independently ACCEPT/REVISE/REJECT actual runtime and intended visual fidelity. Historical isolated concept V4 ACCEPT remains unaltered.
5. **SIGA — WATCH:** reconcile new claims/PR heads, exact-head CI, protected merge and historical gates. R2 animals must pass before R3 plants.

No automatic CENA/LENTE/ARTIST acceptance or callback invocation occurs from documentation alone. A draft handoff is a task routing request, not a specialist's output.

## 6. Merge and rollback

No PR #77/#123/#124/#125 or this branch may be merged based on Canvas2D proxy alone. Keep all source binaries and draft ownership. If any new browser scenario fails, publish CI logs and adjust only the test runner/harness on its claimed branch with exact-head reruns. Do not weaken source hash, source rights or fail-closed distinction.

**Decision:** preserve original, use nearest in diagnostics and defer atlas conversion. Technical contract **not finalized** until engine web export, real-device evidence, ARTIST-owned visual gate and explicit release rights.
