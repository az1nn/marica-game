# SIGA QA-001 / #133 — isolated Vercel hosting claim

Date: 2026-10-18 (America/Sao_Paulo)
Owner: SIGA → ARCH/GODOT (hosting only).
Status: ACTIVE / EXCLUSIVE / NO MERGE.
Branch: `qa/133-vercel-godot-hosting-20261018`
Immutable upstream: draft QA-001 export harness PR #134 `8edfec42f8499b8818fc03c9415ef59abd23518b`, stacked on CENA PR #132 `82860359df7649a9bb0d0fd14e6fcbdf302eb57e`.
Scope: SPEC-008 Q804 only (public HTTPS deployment of isolated Godot Web export), parent QA tracker #129, issue #133.

## Exclusive file ownership
- `tools/qa/build_vercel_godot.sh` — isolated Vercel compilation adapter using already established Godot pin/scene
- `vercel.json` — QA-branch-only Vercel output override (never touch master)
- `.github/workflows/web-preview-contract.yml` — preserve master static contract, add exact opt-in QA export-branch contract
- `docs/qa/QA-001-VERCEL-HOSTING.md` — deployment/runbook and limitations
- this claim only

No writes to parent QA PR #134, CENA #128/#132, ARTIST #77, ARCH #126, LENTE #130, source PNG, `public/`, gameplay/domain/save, default `game/project.godot`, or historical claims. Do not mark Q804 PASS until HTTPS preview, actual Godot canvas and exact deployed SHA verified. Q805 requires independent human Android/desktop test. Source-art redistribution rights and production gates remain separate.

## Guard / verification
- Reconcile fresh exact upstream and all PRs before write; branch exclusively owned.
- Required: official Godot 4.7.2 checksum-pinned editor/Web templates; isolated temp project main scene QA wrapper, WebGL compatibility renderer, no source file mutation.
- QA browser marker `window.__MARICA_QA_GODOT_READY` must be set by Godot, never prefilled by HTML; exported wasm/pck must be nonempty.
- Preserve static landing on master; branch-only output must be Godot HTML, not Vercel status page.
- Record exact Git SHA, deployment result and final human retest separately. This claim is not authorization to merge or to claim ARTIST/runtime acceptance.
