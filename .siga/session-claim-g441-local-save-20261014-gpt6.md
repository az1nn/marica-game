# SIGA session claim — G441 local versioned SaveStore

Task: SPEC-004 G441
Owner: SIGA → ARCH/GODOT + QA adversarial
Opened: 2026-10-14 14:47 America/Sao_Paulo
Base: master@69c57653d0e8fc5495c4bd3eb932cfc88401776c
Branch: godot/g441-local-save-store-20261014
Status: CLOSED / FEATURE_MERGED_AND_VERIFIED

Scope:
- game/src/adapters/local/save_store.gd (new; no changes to domain)
- game/tests/save_store_runner.gd (new independent headless runner)
- .github/workflows/g441-save-store.yml (new exact-head test and mutation)
- game/docs/G441-LOCAL-SAVE-STORE.md (bounded contract and failure modes)
- Followup closeout only after all gates, separate from G441 implementation SHA.

Strict boundary: G441 local versioned I/O + fail-closed envelope validation, optimistic revision/clock checks.
NOT G442 atomic replace/backups; NOT G443 migrations; NOT G444 domain hydrate;
NOT G445 runtime event replay; NOT G446 restart/catchup validation.
Original G440 contract and three fixtures stay byte-identical.
Parallel ARTIST draft PR #77 changes no intended paths.
No active G441 branch/claim observed at admission. Post-claim barrier required.

Closure: PR #96 head 42018f778d81405d08bb5b438103b2c2bf19f490 merged as master@4f58a8251a4e9ccfd4c89d9a370b913081ccecbd. G441 and applicable PR gates PASS; master Godot CI, Validate skills, Roblox CI, Web Preview Contract PASS. Docs closeout separately claimed, G442 next.
