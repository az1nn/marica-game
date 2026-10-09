# QA HANDOFF

Status: G421 VERIFIED / ADVANCE

Authority: SPEC-004, canonical Godot 4.7.2-stable, single-player/offline-first.

Verified delivery:
- PR #50 final head 358cf82ba2bba9a12f77607fbfea76feba4092aa: Godot CI PASS, Validate skills PASS, Roblox CI PASS; Roblox Behavioral SKIPPED.
- PR #50 guarded merge master@664f6e5d9126af81505d59760b412209ae9e4fdb; all three post-merge gates PASS.
- 18 Python unit tests; typed script guard, gdformat/gdlint, headless import/parse/boot, G414/G420 regression tests and G416 fixture harness passed.
- 6 LineageId + 15 Pedigree real golden parity cases PASSED, alongside 5 PetId cases. PENDING_PORT remains 6 for future time and genetics.
- Runtime markers: MARICA_G421_LINEAGE_ID_PARITY_PASS cases=6; MARICA_G421_PEDIGREE_PARITY_PASS cases=15; MARICA_G421_LINEAGE_PEDIGREE_PASS.
- Adversarial G421 mutation: relaxing founder-parent constraint causes exact golden mismatch; original source restored; MARICA_G421_MUTATION_PROOF_PASS good=pass bad=fail restore=pass.
- G420 whitespace mutant proof remains PASS on same SHA.
- Independent critic isolation: no. Objective tests/mutation were executed, not simply authored. No player-facing visual changes or ARTIST gate.

Known gap:
- G421 validates structural lineage/pedigree only. Composite Pet, lifecycle, simulation clock, genetic potential, care/health, succession, persistent saves, UI and full Animal Core parity not yet proven.

Next: G422 lifecycle state machine, deterministic golden parity + negative/mutation tests.
