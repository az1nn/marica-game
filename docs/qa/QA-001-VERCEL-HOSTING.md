# QA-001 / #133 — Vercel-hosted Godot Web candidate

Scope: SPEC-008 Q804; preview/testing **only**, stacked on unchanged #134 → #132 → #128. This branch does **not** enable gameplay/save/care and does **not** grant ARTIST/LENTE/ARCH source-rights or physical-device approval.

## What changes on this isolated branch

- `vercel.json` switches **only this QA PR branch** from `public/` status HTML to `build/qa-preview/`; production `master` remains static status HTML.
- `tools/qa/build_vercel_godot.sh` downloads official checksum-verified 4.7.2 Godot Linux binary/Web export templates; makes an ephemeral copy of `game/`, injects the **QA-only** `res://scenes/qa_web_preview.tscn` startup scene and Compatibility/WebGL settings into that copy, exports `index.html/.js/.wasm/.pck`, and writes `qa-build.json`.
- No committed changes to `game/project.godot`, `game/assets/arch_probes/S01_A01_v4_original.png`, `public/`, CENA input, G452/save/domain or existing QA source files.
- The Web Preview Contract CI uses the original static assertions on `master` and all other branches; only `qa/133-vercel-godot-hosting-20261018` has the bounded QA Vercel build assertion.

## Verification before telling the tester to open a URL

1. Wait for Vercel deployment of this **new** PR branch and verify its build log contains `MARICA_QA001_VERCEL_EXPORT_PASS` (failed Vercel builds are not runtime evidence).
2. Retrieve the **actual branch preview URL** from its Vercel PR comment or verified status; do not infer the subdomain.
3. GET `/qa-build.json`, confirm `head_sha` equals the branch commit, `godot=4.7.2-stable`, and wasm/pck/index names + SHA-256 entries are present.
4. On public HTTPS URL, verify real Godot Canvas/engine marker `window.__MARICA_QA_GODOT_READY === true` after startup (marker comes only from Godot scene) and that browser errors are absent; mobile/desktop screenshot and gesture checks. CI localhost Chrome proof on parent #134 is **not a hosted-URL smoke test**.
5. Record Android device/browser and tester observations in #133 and parent tracker #129; only human independent retest can complete SPEC-008 Q805. Close Q804 only after deployed URL proof; never close ARTIST or production gates as a side-effect.

## Failure conditions & next action

- Vercel export timeout, fetch size/network quota or failed native binary: mark Q804 `BLOCKED`; preserve GitHub artifact [#134 exact-head Web proof](https://github.com/az1nn/marica-game/actions/runs/39148569671/artifacts/12144586145), which is **downloadable but not an HTTPS game URL**.
- If source redistribution/rights gate is disallowed, **do not promote this technical QA artifact into production**; remove/quarantine hosted build as directed by domain owner.
- The exported scene is a **technical farm/founder pan prototype** (CENA #132) with no full playable gameplay cycle. Its Godot-native readiness marker is stronger than Vercel `Ready`, but is not game acceptance.
- No merge without exact-head CI, separate authorized rights/import/accessibility gates and independent ARTIST/LENTE decisions.
