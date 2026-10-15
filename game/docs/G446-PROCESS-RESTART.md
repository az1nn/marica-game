# G446 — Process restart, save/load round-trip and clock rollback

Six independent Godot headless OS invocations use the same isolated user-data-dir: seed initial founder + commit G445 successor pair; reopen and hydrate; save after wall-clock rollback with G423 monotonic logical time; reopen and verify unchanged time and one marker; corrupt primary and recover G442 validated backup; reopen recovered state and replay persisted G445 pair without regeneration. All process invocations are separate, not repeated calls within one SceneTree.

QA mutates G423 `maxf(raw_now, previous)` to `raw_now` and requires the rollback phase to fail; restores the source and rechecks recovered state. CI uses pinned Godot 4.7.2 and exact PR HEAD. This tests restart in a Linux CI process, not abrupt physical power loss, portable filesystem fsync, true cross-process CAS, or G447 offline time catch-up.
