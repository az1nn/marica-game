# SIGA QA-002 / #138 — founder tap diagnostic claim

Date: 2026-10-18 (America/Sao_Paulo)
Owner: SIGA → GODOT/QA input diagnostic.
Status: ACTIVE / ISOLATED / EXCLUSIVE / NO MERGE.
Branch: `qa/138-founder-tap-diagnostic-20261018`
Immutable parent: PR #135 HEAD `1191dcc626dabec9f47dc1146508c15702b9e023`; stacked through #134 → #132 → #128.

## Exclusive ownership and limits
- `game/src/qa/qa_web_preview.gd`: QA-only native Godot tap/click feedback on founding pet.
- `tools/qa/qa002_input_profile.py`, `.github/workflows/qa002-input.yml`, `docs/qa/QA-002-INPUT.md`, and this claim: standalone exact-HEAD browser evidence.
- No changes to ARTIST original asset, CENA camera and pan, ARCH import, G452/gameplay/save, default project scene, Vercel configuration, other claims or branches.
- Do not claim production interaction, accessible final HUD, ARTIST runtime acceptance, public authenticated Godot boot or human physical-device QA.

## Guards
- Human report: #138 (Firefox Android taps/clicks have no feedback).
- InputEventScreenTouch/MouseButton must produce a Godot-owned visible QA label on a founder hit. Drags must not select. Suppress mouse synthesized after touch.
- Existing CENA pan remains free to receive events; wrapper MUST NOT consume them.
- Real exported Godot WebAssembly test must verify native Godot boot and selection marker with actual browser pointer injection; screenshot/hashes are diagnostic, not acceptance.
- Merge remains prohibited until exact-HEAD tests, #133 authenticated deployment provenance, user physical Android+desktop retest, independent ARCH/LENTE/ARTIST/runtime and source rights gates; upstream stacked PRs also require their own merge gates.
