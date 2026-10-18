# SIGA → LENTE exclusive claim — #131B independent AFTER visual audit

- Owner: LENTE, dispatched by SIGA on 2026-10-18 (America/Sao_Paulo).
- State: **CLOSED_FOR_WRITES / DOCUMENTARY_AUDIT_DELIVERED / REVISE / NO_MERGE**.
- Branch: `lente/131b-independent-capture-review-20261018`, stacked on immutable CENA [PR #136](https://github.com/az1nn/marica-game/pull/136) HEAD `a8b3b57d98d3285c947103d388571f36bc7ba099`.
- Issue: [#131](https://github.com/az1nn/marica-game/issues/131); original LENTE [PR #130](https://github.com/az1nn/marica-game/pull/130) separate, not changed.
- Reserved and touched only: this claim and `docs/lente/LENTE-131B-INDEPENDENT-AFTER-REVIEW.md`.
- Evidence: CENA native six-frame [run #39154942879](https://github.com/az1nn/marica-game/actions/runs/39154942879), artifact #12146976225, reported ZIP `sha256:1a295fa2aadc6240d15189c2b981aaed8e0b1cc5a9e1ef5eb25b6a7d4f9fde04`. Six PNG SHA-256 independently match archived verification manifest.
- Review result: LENTE **REVISE**. Independent pixel audit measured 198,900/329,160 portrait RGB pixel changes (60.427%); 130,260 original non-gray pixels unchanged and 390 composited farm-edge pixel differences; 204px + 207px original vertical non-game margins (~48.7% height) remain noninteractive, green underlay is visual only. Pan extremes can partially clip founder; desktop remains provisional.
- Protected unchanged: CENA scene/logic, `game/project.godot`, `specs/`, V4 original PNG source (`sha256:b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`), G452/domain, ARCH/QA/ARTIST, old LENTE #130, PR #139 and SPEC-009 PR #141.
- Validation boundary: reused and independently examined CENA native PNGs; **no fresh independent Godot run, WebGL, physical device, ARTIST approval or sprite source SHA recomputation**. Report does not satisfy all LENTE V205 gates. `master`, source PR #136 and all other owner refs were not modified.
- PR: [draft #142](https://github.com/az1nn/marica-game/pull/142), stacked on #136. At claim closeout, a new commit/HEAD is produced: **all mandatory CI checks must be verified against that final HEAD before marking its technical CI gate PASS**.
- Handoff: [issue #131](https://github.com/az1nn/marica-game/issues/131) to CENA/UX for vertical-use decision; independent LENTE new capture, ARCH rights/import, QA real updated WebGL/physical four-cell browser evidence and human ARTIST runtime verdict remain open.
- No merge, no SPEC checkbox closure, no independent runtime PASS or release approval.
