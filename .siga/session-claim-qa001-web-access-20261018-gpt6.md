# SIGA — QA-001 / #133 Web QA access exclusive claim

Date: 2026-10-18 (America/Sao_Paulo)
Owner: SIGA → ARCH/GODOT (web-export harness), independent QA/LENTE/ARTIST remain separate.
Status: ACTIVE / ISOLATED / NO MERGE.
Branch: `qa/133-godot-web-preview-20261018`
Immutable upstream: CENA #132 at `82860359df7649a9bb0d0fd14e6fcbdf302eb57e`, stacked on #128.
Parent QA tracker: #129; blocker: #133; runtime gate: #127.

## Exclusive ownership
New only: `.github/workflows/qa-web-preview.yml`, `game/scenes/qa_web_preview.tscn`, `game/src/qa/qa_web_preview.gd`, `tools/qa/qa_web_profile.py`, `docs/qa/QA-001-WEB-PREVIEW.md`, `specs/008-qa-web-preview/{spec,plan,tasks}.md`, and this claim.
**Prohibited:** overwriting CENA #128/#132 scenes/scripts, ARCH #126, LENTE #130, ARTIST #77 or PNG; master `public/` and `vercel.json`; runtime app main scene; inherited claims, approval checks, or state/domain contracts.

## Bounded objective
Produce an immutable real Godot WebAssembly/WebGL2 **isolated technical QA build** from the V206 candidate, with source and commit hashes, browser-boot proof and downloadable CI artifact.
This does **not** supply an externally accessible hosted preview; deployment is a **separate unresolved acceptance gate** on #133, not a V201/V201a or final visual acceptance.
The default Vercel site intentionally remains informational.

## Guard
Snapshot upstream exact SHA and new branch HEAD before writes. Reject source drift/overlap. Require real browser runtime-ready marker, nonempty wasm/pck, archive checksums, original PNG checksum, and exact CI head before claim closure. Preserve CAPABILITY_BLOCKED physical-device and artist/rights gates.
