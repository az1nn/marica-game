Task: G435 / SPEC-004 Phase D accelerated complete 2-4 week animal lifecycle
Owner: SIGA GPT-6 2026-10-13 America/Sao_Paulo
Base: master@5956e4fb6d044d75d27e8720215e0b283a10f04f
Branch: feat/g435-accelerated-lifecycle-20261013
Scope: game/tests/accelerated_lifecycle_runner.gd; .github/workflows/godot-ci.yml; this claim. No production rules/ARTIST/save schema changed.
Status: CLOSED / FEATURE_MERGED_VERIFIED
Acceptance: deterministic injected-clock test scenarios spanning 14, 21 and 28 days; care/health/lifecycle transitions; natural end only after senior; exactly two successors, once-only repeat in same session; rollback and duplicate observation safe; isolated descendants.
Test-only checkpoint schedule must not be asserted as a finalized game-balance age policy; production age scheduler deferred to separate application integration.
Required gates: exact-head G415 quality + Godot CI + independent runner + GOOD/BAD/RESTORE clock regression; Validate skills / Roblox CI / Web Preview Contract as applicable; GAUNTLET check and guarded merge.
Overlap: #77 ARTIST draft touches seven art files only, no overlap with test or CI.
Closure: PR #83 exact-head e87b1124efa19fb3e0bda5418e678f0f444fe745 and guarded master@d019443e2d1e8a1e2711f9d9fda3463bb6390b62: Godot CI, Validate skills, Roblox CI and Web Preview Contract PASS. Independent G435 scenario and rollback GOOD→BAD→RESTORE PASS.
Next: G436 GAUNTLET P0 after separately validated docs closeout.
