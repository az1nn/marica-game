# ROBLOX HANDOFF

Status: MIGRATION_SOURCE / FUTURE_PORT

ADR-0004 supersedes Roblox as the V1 production runtime.

## Closed legacy PRs

- PR #29 / AQ011 — **SUPERSEDED**, closed without merge.
- PR #26 / T020 — **MIGRATION_SOURCE**, closed without merge; branch/head retained.
- PR #34 / T021 — **MIGRATION_SOURCE**, closed without merge; branch/head retained.

The reusable deterministic contracts and golden-fixture candidates from #26/#34 are recorded in:

`docs/migration/ROBLOX-TO-GODOT-CONTRACT-MAP.md`

Roblox/Studio/DataStore/Open Cloud are not V1 release dependencies.

No new Roblox production work is authorized unless a future ratified spec/ADR reactivates that target.

Next:
Support SPEC-004 only as migration evidence until G510-G514 decommission/future-port boundary.
