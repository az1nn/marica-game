# QA-001 — Real Godot Web diagnostic (not Vercel status HTML)

**Issue:** #133 · **Tracker:** #129 · **Source:** isolated CENA V206 draft #132, itself stacked on #128.

The QA-001 workflow builds the opt-in scene `res://scenes/qa_web_preview.tscn` without changing the committed default smoke scene. The wrapper instantiates unchanged V203/V206 farm/founder composition and sets a browser marker after the Godot runtime has actually mounted the founder.

The workflow verifies the approved source copy's PNG blob + SHA-256 and pins Godot 4.7.2 editor and web templates; a transient CI-only export preset produces `index.html`, `index.wasm`, `index.pck`. It serves the export on *localhost in the GitHub runner*, boots it in Linux Chrome, requires the engine-owned JS marker and canvas, captures 390×844 DPR2 emulated portrait and 1280×960 desktop, and writes SHA-256 evidence and screenshots to a downloadable GitHub Actions artifact `qa001-godot-web-<HEAD>` (14-day retention).

**Critical distinction:** This is NOT an externally hosted QA URL. The Vercel branch previews remain the static informational site; green deploy checks are not evidence of Godot runtime. The diagnostic is not the complete game, has no gameplay/care/save HUD and neither ARTIST/LENTE visual acceptance nor real Android/iOS performance/rights approval.

**Next missing gate:** choose permitted HTTPS hosting, deploy this exact immutable Web export with source/head provenance, prove browser boot *at the deployed URL* and collect actual tester feedback in #133/#129. No merge or status closure before separate gates; original founder V4 PNG and all independent drafts are untouched.
