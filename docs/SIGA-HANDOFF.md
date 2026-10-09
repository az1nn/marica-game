CAVEMAN HANDOFF v1

APP:
Maricá Game

WORKSTREAM:
SPEC-004 — Godot V1 Transition

STATE:
Phase B complete. Phase C — Animal Domain Port G420/G421 complete and merged; next G422 lifecycle. Godot 4.7.2-stable remains canonical offline-first.

MODE:
ADVANCE

DELIVERED:
- G421 PR #50 merged: pure LineageId generation and Pedigree with founder/descendant and direct-parent invariants.
- 6 LineageId + 15 Pedigree golden fixtures ACTIVE_PARITY; 5 PetId fixtures remain ACTIVE; 6 future time/genetics fixtures PENDING_PORT.
- Detached parent/snapshot behavior tested. G421 bad founder-parent mutant detected and source restored; G420 regression/mutation gate preserved.
- G421 claim CLOSED via verified documentation closeout.

QUALITY:
- PR #50 final head 358cf82ba2bba9a12f77607fbfea76feba4092aa: Godot CI PASS, Validate skills PASS, Roblox CI PASS; Roblox Behavioral SKIPPED/non-required.
- Expected-head guarded merge: master@664f6e5d9126af81505d59760b412209ae9e4fdb.
- Post-merge master@664f6e5d9126af81505d59760b412209ae9e4fdb: Godot CI PASS, Validate skills PASS, Roblox CI PASS.
- 26 verified domain fixture cases do NOT prove full Animal Core parity or visual/player acceptance.

BLOCKER / WAIT:
none for G422.

CONCURRENCY:
G421 post-claim barrier CLEAR; no PR collision, no master drift; claim CLOSED.

NEXT:
G422 — implement Godot lifecycle state machine and executable golden parity fixtures.

END FILE


G422 active candidate (reconcile this section with live truth):
- Branch: `feat/g422-godot-lifecycle`; claim `.siga/session-claim-g422-20261009-0901-gpt6.md` ACTIVE.
- 19 lifecycle golden fixtures, pure GDScript state machine, and G422 headless/mutation tests authored; pending exact-head CI verification.
- G421 remains the last merged/verified domain task; G422 remains unchecked until acceptance.
- Next: verify G422 current head, repair failing gates if any, then guarded merge and closeout.
