# QA HANDOFF

Status: G420 candidate — VERIFY

## Canonical V1 evidence

Repository: az1nn/marica-game; Constitution v2.0.0; SPEC-004.
Godot runtime: 4.7.2-stable, typed GDScript, offline-first.

G420 candidate PR #48 at e9e2ba20490274bdded541a48c390a55c0fce274:
- Godot CI PASS (G414 smoke, G415 typing/format/lint, G416 harness, G420 PetId golden parity and identity runner);
- Validate skills PASS; remaining checks must be repeated at final PR head;
- five PetId ACTIVE_PARITY fixtures executed in Godot, eight other domain fixtures PENDING_PORT;
- MARICA_G420_PET_IDENTITY_PASS;
- MARICA_G420_PET_ID_PARITY_PASS cases=5;
- MARICA_G420_MUTATION_PROOF_PASS good=pass bad=fail restore=pass.

## Adversarial verification

Baseline: accepted G416 master@4bbca87dbe80e20032b5c0d8ded2aadc367bed76.
Known-bad mutant: change PetId validation from strip_edges().is_empty() to text == "" in ephemeral CI runner. Negative whitespace golden fixture fails; original file restored; exact-head tests pass.
Critic isolation: no independently isolated agent; tests are objective and mutation backed.
Regression hunt: prior G414/G415/G416 gates run in same Godot CI. No failures found in applicable adjacent tooling contracts.
Human visual approval: N/A — no player-facing visuals changed.

## Limitations and next gate

G420 only validates identity semantics and an identity-only Pet shell; it does not prove complete Pet composite parity or animal gameplay.
Legacy Roblox authored behavioral test-place execution remains optional/reference during Godot migration.
Next: G421 lineage/pedigree port and its executable fixtures.
