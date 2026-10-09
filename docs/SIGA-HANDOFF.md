CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-004 — Godot V1 Transition

STATE:
Foundation Phase B complete. Phase C G420–G425 verified and merged on master@947010158d0bc63d21afcf18c75a0dab187b9e46.
Runtime: Godot 4.7.2-stable, single-player, offline-first. G426 next.

MODE:
ADVANCE

DELIVERED:
- G425 PR #60: MaricaCare pure typed GDScript port, finite unit scores, defaults hunger=0 hygiene/affection/energy=1; weakest essential need quality (1-hunger, hygiene, affection, energy).
- Care.to_expression_factors creates deterministic per-trait factors compatible with G424 genetics, without mutating potential.
- 21 new executable Luau-derived golden cases (create 9 / quality 6 / factors 6); 98 total ACTIVE_PARITY domain cases, 4 harness selftests, 3 G430 advancement cases PENDING_PORT.
- Independent care regression verifies snapshots/detachment, invalid/nonfinite values, deterministic G424 expression; hunger inverse GOOD→BAD→RESTORE mutation proof.

QUALITY:
- PR #60 exact head ca36f3ab2d74c3bde0131f453938d22d3d889c0c: Godot CI PASS, Validate Skills PASS, Roblox CI PASS; Roblox Behavioral SKIPPED (nonrequired).
- Guarded squash merge master@947010158d0bc63d21afcf18c75a0dab187b9e46, post-merge Godot CI PASS, Validate Skills PASS and Roblox CI PASS.
- G420–G424 regression gates retained; full Pet aggregate, G426–G429 domain parity, succession, save, export web, and ARTIST V2 visual/runtime acceptance NOT YET PROVEN.

BLOCKER / WAIT:
None for G426. Vercel + Cloudflare same-artifact deploy verification waits for separate Godot Web export build and provider configuration; not a G426 dependency.

CONCURRENCY:
G425 claim CLOSED; PR #60 merged; no open PR overlaps at reconciliation. SPEC-005 ARTIST V2 target remains approved but visuals not implemented.

NEXT:
G426 — port Health.new/advance/treat and prove deterministic Luau/Godot behavior, preserving animal-first and no new online dependency.

END FILE
