# SIGA claim — SPEC-004 G442 atomic save + backup/recovery

Task: SPEC-004 G442 (approved live task)
Owner: SIGA → ARCH/GODOT implementation; QA adversarial proof
Opened: 2026-10-14 America/Sao_Paulo
Base: master@0cf45eed3e9f603460daafed3ff66593bf6a5db5
Branch: godot/g442-atomic-save-backup-20261014
Status: ACTIVE

Scope: game/src/adapters/local/save_store.gd; game/tests/atomic_save_runner.gd; game/docs/G442-ATOMIC-SAVE.md; .github/workflows/g442-atomic-save.yml; this claim. No domain, G440 JSON schema, G441 fixtures, ARTIST production assets, V201/V201a changes.

Concurrency: only open PR #77 ARTIST at admission; disjoint file and semantic ownership. Another G442 claim/PR not observed among open PRs; post-claim barrier required before code commits.

Design: write valid temp + flush + verify; back up last valid primary with staged durable backup before atomic promotion; fail-closed on invalid primary or unsupported version; restore only schema-valid prior backup with explicit recovered status and never silently mint new animal state; revision + injected-clock CAS preserved; deterministic crash-stage simulation and mutation GOOD→BAD→RESTORE. No full power-loss/fsync portability guarantee, future-version migration G443, hydration G444, succession replay G445 or game-restart G446/447 claims.

Merge only after exact-head G442 + Godot CI + G441 + G440 + Validate skills + ARCH V201 + Web Preview and applicable legacy gates PASS. Expected-head guarded merge and master reconciliation; separate closeout task/PR after code merge.