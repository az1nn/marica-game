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

## Test runner contract

The canonical Godot test runner is **GUT v9.7.1** from `bitwes/Gut`.

The machine-readable source of truth is:

```text
game/test-runner.lock.json
```

The pin records both the release tag and its exact upstream commit (`aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605`). GUT v9.7.1 is the upstream line explicitly designated for Godot 4.7.x, matching this project's Godot 4.7.2-stable runtime.

G413 owns installation/bootstrap in CI and the first headless execution. G412 only selects and pins the runner; it does not add a second test framework or change the engine version.

## CI: exact-head Godot import and parse (G413)

`.github/workflows/godot-ci.yml` runs on pull requests, pushes to `master` and manual dispatch. It checks out the exact PR head (or push SHA), verifies `game/.godot-version` and `game/test-runner.lock.json`, downloads the **Godot 4.7.2-stable Linux x86_64 editor**, and validates the archive against its official SHA-256 digest before execution.

CI clones the pinned GUT v9.7.1 tag, checks its exact commit and copies `addons/gut` into `game/addons/gut`. Its two required engine gates run on `game/project.godot`:

```sh
godot --headless --editor --path game --import --quit
godot --headless --editor --path game --quit
```

A non-zero exit fails the job; import, parse and version diagnostics are uploaded as a workflow artifact. These are **bootstrap/import gates**, not a claim that gameplay tests or the G414 smoke scene already exist. G414 adds the first executable smoke scene, followed by typed GDScript conventions (G415) and golden-parity tests (G416).

When changing Godot or GUT versions, update the version pin, lockfile, workflow download checksum and compatibility evidence in a dedicated task. Prior green results from an older commit never validate a new head.

## G414: minimal headless runtime smoke

`game/project.godot` now points to `res://scenes/smoke.tscn` as a temporary boot scene. The Node2D scene intentionally contains no animal gameplay or final art. `game/tests/smoke_runner.gd` verifies scene loading, instantiation and `_ready()` with an explicit nonzero exit on failure.

```sh
godot --headless --editor --path game --import --quit
godot --headless --path game --quit-after 3
godot --headless --path game --script res://tests/smoke_runner.gd
```

CI checks for the exact `MARICA_G414_SCENE_READY` and `MARICA_G414_SMOKE_PASS` markers and uploads both logs. This gate proves only startup/scripting, not gameplay parity or visual acceptance. G415 owns typed GDScript conventions and G416 owns deterministic golden fixtures.

## G415: typed GDScript and style validation

First-party GDScript conventions live in [docs/GDSCRIPT-CONVENTIONS.md](docs/GDSCRIPT-CONVENTIONS.md).
The Godot CI exact-head job runs Python declaration guard tests, checks all `game/src` and `game/tests` scripts for explicit typing, and enforces pinned `gdtoolkit==4.5.1` `gdformat --check` plus `gdlint` before importing or executing Godot. Generated `addons` and `.godot` trees are excluded. The authoritative compiler/runtime gates remain the pinned Godot headless tests.
