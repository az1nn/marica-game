# SIGA QA-002 / #138 — founder tap diagnostic claim

Date: 2026-10-18 (America/Sao_Paulo)
Owner: SIGA → GODOT/QA input diagnostic.
Status: CLOSED_FOR_WRITES / VERIFIED_CODE_ONLY / NO MERGE.
Branch: `qa/138-founder-tap-diagnostic-20261018`
Immutable parent: PR #135 HEAD `1191dcc626dabec9f47dc1146508c15702b9e023`; stacked through #134 → #132 → #128.

## Exclusive ownership and limits
- `game/src/qa/qa_web_preview.gd`: QA-only native Godot tap/click feedback on founding pet.
- `tools/qa/qa002_input_profile.py`, `.github/workflows/qa002-input.yml`, `docs/qa/QA-002-INPUT.md`, and this claim: standalone exact-HEAD browser evidence.
- Downstream branch-only adjustment to `.github/workflows/web-preview-contract.yml` admits this named QA-002 descendant to the inherited QA build contract. Q804 parent branch/workflow remains untouched; no unguarded wildcard.
- No changes to ARTIST original asset, CENA camera and pan, ARCH import, G452/gameplay/save, default project scene, `vercel.json`, other claims or branches.
- Do not claim production interaction, accessible final HUD, ARTIST runtime acceptance, public authenticated Godot boot or human physical-device QA.

## Guards
- Human report: #138 (Firefox Android taps/clicks have no feedback).
- InputEventScreenTouch/MouseButton must produce a Godot-owned visible QA label on a founder hit. Drags must not select. Suppress mouse synthesized after touch.
- Existing CENA pan remains free to receive events; wrapper MUST NOT consume them.
- Real exported Godot WebAssembly test must verify native Godot boot and selection marker with actual browser pointer injection; screenshot/hashes are diagnostic, not acceptance.
- Merge remains prohibited until exact-HEAD tests, #133 authenticated deployment provenance, user physical Android+desktop retest, independent ARCH/LENTE/ARTIST/runtime and source rights gates; upstream stacked PRs also require their own merge gates.

## SIGA technical closeout (2026-10-18)
- Final **code** HEAD `0214d1d754f737076cf7d930cf57658ab7e9b915` verified against live GitHub Actions: **17 SUCCESS, 1 optional Roblox Behavioral SKIPPED, zero failed/pending** (18 total), including [Godot CI/G415](https://github.com/az1nn/marica-game/actions/runs/39167128595) and [QA-002 Godot Web Input](https://github.com/az1nn/marica-game/actions/runs/39167128660).
- QA-002 tested real exported Godot WebAssembly in Chrome desktop mouse and emulated mobile touch: selection evidence, visible feedback screenshots, synthetic dedupe and negative drag. This is not Firefox Android physical-device acceptance.
- Closing metadata commit requires fresh exact-HEAD CI; do not infer this code-head green proves the metadata SHA until verified.
- New work must acquire a fresh isolated claim; preserve existing Q804 parent claim and all other owner paths. Merge remains strictly forbidden absent external AUTH/provenance, physical QA and ARCH/LENTE/ARTIST runtime approvals.
