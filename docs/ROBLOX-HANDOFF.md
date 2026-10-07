# ROBLOX HANDOFF

Status: MIGRATION_SOURCE / FUTURE_PORT

ADR-0004 supersedes Roblox as the V1 production runtime.

Open transition sources at decision time:
- PR #26 / T020 — preserve genetic advancement contract/fixtures; do not merge Luau into V1.
- PR #34 / T021 — preserve deterministic successor contract/fixtures; do not merge Luau into V1.
- PR #29 / AQ011 — SUPERSEDED for V1; Open Cloud behavioral gate is no longer a production dependency.

Roblox/Studio/DataStore/Open Cloud must not block Godot V1.

Next:
SIGA G404/G405 must reclassify the open PRs and extract any migration contracts needed before cleanup.
