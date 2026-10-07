# Maricá Game — Godot runtime

## Runtime version contract

The canonical V1 engine is **Godot 4.7.2-stable**.

The machine-readable source of truth is:

```text
game/.godot-version
```

Local development, automated tests and CI must resolve the exact stable release declared in that file. Preview, beta, RC and dev builds do not satisfy the production baseline.

The selected release is the latest stable Godot 4.x release verified against the official Godot release archive on 2026-10-07. Godot 4.8-dev7 is a pre-release and is intentionally excluded.

G412 may select a compatible test runner, but it must not silently change this engine pin. Any engine upgrade requires an explicit task/decision, compatibility verification and an update to `game/.godot-version`.

## Project boundary

`game/project.godot` is the canonical Godot project entrypoint. Domain code under `game/src/domain` must remain independent from Node, SceneTree, UI, HTTP and concrete storage.
