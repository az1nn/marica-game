# QA HANDOFF

Status: G420 VERIFIED / ADVANCE

Authority: SPEC-004 / Constitution v2.0.0. Runtime: Godot 4.7.2-stable, offline-first.

## G420 exact-head verified delivery
- PR #48 candidate head 10c803ce38c3308018c6601db9f933d9a0df2552: Godot CI PASS; Validate Skills PASS; Roblox CI PASS.
- PR #48 expected-head merge: master@a889f9132720ab251ae2b60c99d7c6115341a826.
- Post-merge master@a889f9132720ab251ae2b60c99d7c6115341a826: Godot CI PASS; Validate Skills PASS; Roblox CI PASS.
- Godot headless markers: MARICA_G420_PET_IDENTITY_PASS, MARICA_G420_PET_ID_PARITY_PASS cases=5.
- Catalog: 4 harness autochecks; 5 verified PetId cases; 8 pending lineage/time/genetics cases, parity=NOT_YET_PROVEN.

## GAUNTLET / mutation proof
- Baseline: master@4bbca87dbe80e20032b5c0d8ded2aadc367bed76.
- Known-bad mutant changed whitespace-ID validation from strip_edges().is_empty() to text == "" in the ephemeral CI workspace. Golden runtime rejected it (nonzero exit and mismatch); restoring source passed exact fixture runtime and clean git diff.
- MARICA_G420_MUTATION_PROOF_PASS good=pass bad=fail restore=pass.
- Fresh independent critic isolation: no; measurable runtime mutation evidence is present.
- Regression hunt: prior G414 boot/smoke, G415 lint/typing, G416 fixtures and legacy compatibility CI passed on exact head. No applicable adjacent regressions observed.
- Visual human gate: N/A, no visual player-facing scope.

## Limitations / next
G420 covers PetId semantics and identity-only Pet shell, not complete Animal Core behavior. No save, pedigree, succession or gameplay acceptance.
Next G421: source-linked lineage/pedigree executable parity, then subsequent domain ports.
