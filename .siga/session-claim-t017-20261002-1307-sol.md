Task: T017
Owner: GPT-5.6 Sol / 20261002-1307
Base: master@837e29fbae0acdd5b1e51ee093dcb3e96cdc3671
Branch: feat/t017-soulbound-domain-invariant
Scope:
- src/shared/domain/Soulbound.luau
- src/shared/domain/Pet.luau
- tests/soulbound.spec.luau
- specs/001-animal-core/tasks.md
- docs/ROBLOX-HANDOFF.md
- docs/QA-HANDOFF.md
- docs/SIGA-HANDOFF.md
Opened: 2026-10-02T13:07:00-03:00
Status: CLOSED
PR: #16
Delivery HEAD: 46dd15acde656b42c9ce92930e9edb5720f2458d
Merged: master@bca1b81410aa79af06c47b052e14478b2e578c03
Concurrency: PARALLEL_SAFE with RELATORIO visual-contract work; no semantic/file overlap.
Result: T017 complete; soulbound is persisted on Pet, preserved across domain transitions and enforced by domain transfer guards while descendants remain transferable by default.
Next: T018
