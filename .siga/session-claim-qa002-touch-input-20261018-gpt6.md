# SIGA exclusive claim — QA-002 Android tap selection diagnostic

Owner: SIGA → GODOT/QA; date: 2026-10-18 America/Sao_Paulo.
Task: SPEC-008 Q806, bootstrap then QA-only implementation, reporter SIGA.
Branch: `qa/138-tap-feedback-20261018`, stacked on immutable QA hosting PR #135 HEAD `1191dcc626dabec9f47dc1146508c15702b9e023` (upstream #134 → #132 → #128).
Issue: [#138](https://github.com/az1nn/marica-game/issues/138), trackers #129/#133.
Status: ACTIVE / SPEC_BOOTSTRAP / POSTCLAIM_BARRIER_PENDING.
Scope:
- `specs/008-qa-web-preview/{spec,plan,tasks}.md` only Q806 governance additions;
- `game/src/qa/qa_web_preview.gd` QA-only click/touch diagnostic;
- `tools/qa/qa_tap_web_profile.py`, `game/tests/qa_tap_input_runner.gd`, `.github/workflows/qa002-touch-input.yml`;
- `docs/qa/QA-002-TOUCH-TEST.md` and this claim.
Do NOT modify CENA `game/src/presentation/v203_portrait_preview.gd`, saved/animal domain, `game/project.godot`, `game/assets/**`, ARCH/ARTIST/LENTE, master static, hosting `vercel.json`, `tools/qa/build_vercel_godot.sh` or active #135 claim's paths.
Concurrent PR #135 owns hosting, PR #136 owns new portrait exterior, all disjoint (QA touch wrapper may coexist in stacked browser scene). Feature remains draft/no merge, no implicit release or physical mobile acceptance.
SPEC_BOOTSTRAP: first commit Q806 roadmap only after claim, reconcile fresh exact states and task identifiers before code.
Acceptance: original V4 PNG hash, mouse click and emulated touchscreen tap, visible QA-selected founder panel from **Godot InputEvents**, pan drag preserved, no synthetic duplicates, exact-head real Godot WebAssembly Chrome proof and test artifact; external Firefox Android tester replay remains human gate. Do not conflate selection diagnostic with gameplay/care/save, real performance or ARTIST runtime approval.

## Scoped downstream CI gate reconciliation — 2026-10-18

User explicitly requested QA-002 PR #139 CI completion. Reconciled live PR #139 head `79a4006637254c2caaa24d379cabe37cc585242c` on unchanged parent PR #135 `1191dcc626dabec9f47dc1146508c15702b9e023` and 16 success, 1 optional skip, 1 Web Preview Contract failure. This same QA-002 owner exclusively permits a **branch-local one-line correction** in `.github/workflows/web-preview-contract.yml` to recognize exact QA-002 descendant `qa/138-tap-feedback-20261018` alongside existing QA-001 branch. The change is limited to this branch and must not be pushed to PR #135/master, does not modify Vercel configuration, and must not grant wildcard QA or preview exemptions.

Ownership boundary: The upstream hosting owner retains PR #135 and its workflow. This is a descendant-specific QA-002 check contract adjustment; upstream owner has been notified via PR #135. After this scoped downstream change, verify new exact-head CI and preserve NO MERGE / ARTIST-LENTE-ARCH / authenticated HTTPS and physical Firefox Android gates. Other writers may not concurrently modify this branch.
