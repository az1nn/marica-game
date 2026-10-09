# QA HANDOFF

Status: G421 candidate / exact-head VERIFY

Authority: SPEC-004, offline-first Godot 4.7.2-stable.

Scope: LineageId/Pedigree structural contracts ported from src/shared/domain/{LineageId,Pedigree}.luau.
PR #50 preliminary head f71affe3a482e0ac40c8d428f356bac682cf62c4:
- Godot CI PASS, Validate skills PASS, Roblox CI PASS, Roblox Behavioral SKIPPED.
- 18 Python unit tests; Godot headless boot, G414 smoke, G415 typing/format/lint; G416 catalog transport.
- 6 lineage golden cases and 15 pedigree golden cases pass; 5 PetId cases preserved. Catalog ACTIVE_PARITY=26, PENDING_PORT=6.
- MARICA_G421_LINEAGE_PEDIGREE_PASS and MARICA_G421_LINEAGE_ID_PARITY_PASS cases=6; MARICA_G421_PEDIGREE_PARITY_PASS cases=15.
- GOOD -> BAD -> RESTORE mutation evidence at same SHA: founder-with-parent acceptance mutant rejected by real Godot golden harness, original source restored and retested.
- Existing G420 PetId whitespace mutation proof still passes; adjacent identity behavior remains green.
- Independent critic isolation: no. Objective executed parity and mutation evidence available.
- Human aesthetic gate: N/A (no player-facing visual changes).

After documentation commits, candidate SHA evidence is STALE for merger. Rerun final exact-head CI.
Known gap: domain parity is NOT_YET_PROVEN overall until G429/G430+ prove remaining contracts. G422 owns lifecycle next.
