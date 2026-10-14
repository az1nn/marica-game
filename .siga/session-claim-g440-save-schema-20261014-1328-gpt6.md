# SIGA claim — G440 save schema v1

Task: SPEC-004 G440 (define offline local save schema v1)
Owner: ARCH/GODOT session GPT-6, 2026-10-14 13:28 America/Sao_Paulo
Base: master@8585f3635c170aa52b03b611e44243b94d511b05
Branch: arch/g440-save-schema-v1-20261014
Status: ACTIVE — schema contract work, verification pending

Scope:
- `game/docs/save-schema-v1.md` normative G440 persistence envelope and cross-record invariants
- `game/docs/save-schema-v1.schema.json` machine-readable schema for current animal domain
- `game/tests/fixtures/save_v1_minimal.json` and `game/tests/fixtures/save_v1_founder.json` fixtures
- `tools/godot/validate_save_schema_v1.py` offline stdlib contract assertions (no storage writes)
- `docs/GODOT-HANDOFF.md`, `docs/SIGA-HANDOFF.md` only after verification
- `specs/004-godot-v1-transition/tasks.md` on verified closeout

Concurrency:
- ARTIST draft PR #77 owns original dog V4 concept and assets.
- ARCH prototype draft PR #88 owns V201/V201a import probe and test workflow.
- G440 schema is animal-domain persistence planning, no overlap with either draft.
- Issue #86 genetics saturation is unresolved; no claim of universal advancement.

Guardrails: G441–G447 implementation, migration, atomic commit, runtime load and cross-session replay tests remain NOT DONE. Do not mark G440 complete until exact-head CI + independent schema checks. Claim will be closed after guarded merge.
