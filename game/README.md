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
The Godot CI exact-head job runs Python declaration guard tests, checks all `game/src` and `game/tests` scripts for explicit typing, and enforces pinned `gdtoolkit==4.5.0` `gdformat --check` plus `gdlint` before importing or executing Godot. Generated `addons` and `.godot` trees are excluded. The authoritative compiler/runtime gates remain the pinned Godot headless tests.

## G416: deterministic golden-fixture harness (infrastructure only)

`tests/fixtures/golden.json` is the versioned contract catalog. Every case carries an invariant name, deterministic input, expected result **or** expected error, and a source path from the legacy repository. A case is either:

- `ACTIVE_SELFTEST`: validates the fixture transport/comparator, **not** animal behavior;
- `PENDING_PORT`: documented legacy expectation that **must not** count toward parity until its SPEC-004 milestone ships a Godot domain adapter and real exact-head tests.

`tools/godot/validate_golden_fixtures.py` rejects malformed and duplicate cases, missing provenance, ambiguous expected/error pairs and premature domain activation. `tests/golden_fixture_runner.gd` runs the G416 self-tests in headless Godot, prints explicit pending counters and fails on mismatches or unregistered active operations. It performs no network access.

From repository root:

```sh
python3 -m unittest discover -s tools/godot -p 'test_*.py'
python3 tools/godot/validate_golden_fixtures.py
godot --headless --editor --path game --import --quit
godot --headless --path game --script res://tests/golden_fixture_runner.gd
```

CI requires `MARICA_G416_CATALOG_VALID`, `MARICA_G416_HARNESS_PASS`, and `parity=NOT_YET_PROVEN` while adapters are not implemented. **A green G416 gate certifies harness readiness only.** G420 onwards must add actual Godot implementations and executable golden parity checks; G429/G430+ own domain/succession acceptance.

## G420: Pet identity port and executable PetId golden parity

The first pure Godot domain components are `src/domain/pet_id.gd` and `src/domain/pet.gd`. The Pet implementation is deliberately **identity-only**: pedigree, lifecycle, genetics, care, health, soulbound and affection remain owned by G421–G428, rather than depending on unported Luau. `pet_id.gd` deterministically validates nonempty strings and supports an injected Callable ID generator; unlike Luau exceptions, rejections are explicit `{ok:false,error:...}` results suitable for fixtures.

`MaricaPet.create(id)` validates before construction. The Pet exposes `get_id()` and returns detached identity snapshots, with no public identity setter; this is API-level identity immutability, not a claim that GDScript has hard private fields. Other Pet fields are intentionally absent until their domain tasks are ported.

The G416 fixture harness now executes five golden cases from `src/shared/domain/PetId.luau` as `ACTIVE_PARITY`. Cases from lineage, simulation time and genetics stay `PENDING_PORT`. `tools/godot/validate_golden_fixtures.py` rejects unauthorized promotion to `ACTIVE_PARITY`; CI requires positive PetId parity and the explicit overall `parity=NOT_YET_PROVEN` marker.

```sh
godot --headless --path game --script res://tests/golden_fixture_runner.gd
godot --headless --path game --script res://tests/pet_identity_runner.gd
```

Passing G420 proves identity validation and the limited Pet shell only, **not** Animal Core parity or playability.

## G421 — Lineage and pedigree (real Godot parity)

`src/domain/lineage_id.gd` validates and generates nonblank lineage IDs through an injected Callable (deterministic, no online service). `src/domain/pedigree.gd` constructs founder and descendant pedigree records with a validated lineage ID, founder Pet ID, nonnegative integral generation, zero parents for founders, one or two distinct parents for descendants, and stable direct-parent order. The source contracts are `src/shared/domain/LineageId.luau` and `src/shared/domain/Pedigree.luau`.

Construction returns explicit `{ok, pedigree|error}` results instead of relying on Luau's `error()`; the golden runner compares equivalent values/errors. Input parent arrays are copied, accessors return detached copies, and snapshots are detached and serializable. There are **no public pedigree setters**. This proves practical API-level immutability, not language-enforced private fields.

`tests/fixtures/golden.json` runs 6 `lineage_id.from_string` and 15 `pedigree.create` cases as `ACTIVE_PARITY`; PetId's 5 verified cases remain active. Simulation time and genetics remain `PENDING_PORT`. Python schema validation disallows unapproved migration contracts; the Godot runner checks deterministic repeatability, rejection cases, and structurally equivalent output.

CI also runs `tests/lineage_pedigree_runner.gd`, which verifies injected lineage IDs and mutation-resistant detached snapshots, plus a GOOD→BAD→RESTORE mutation check against the forbidden founder-with-parent case. No lifecycle, genetics, succession, save, or playable farm behavior is certified by G421.

## G422 — Pure lifecycle state machine (verified in PR #52)

`src/domain/lifecycle.gd` ports the deterministic Luau `Lifecycle.luau` state machine (not the elapsed-time simulation, owned by G423). A new pet begins `juvenile/active`; legal stage advances are exactly `juvenile → adult → senior` without skips/reversals. The `health` end reason may terminate at any active stage; `natural` requires `senior`. Ended states are terminal. Transitions create replacement objects, not in-place mutations. `to_snapshot()` returns a fresh serializable dictionary, omitting `endReason` while active.

The G416 catalog executes 19 `ACTIVE_PARITY` lifecycle scenarios from `src/shared/domain/Lifecycle.luau`, alongside previous G420/G421 parity; G423 time and G430 genetics remain `PENDING_PORT`. The headless `tests/lifecycle_runner.gd` verifies independent state snapshots and terminal behavior, while CI injects a broken natural-death guard and requires GOOD→BAD→RESTORE proof. The Godot domain returns `{ok,error|lifecycle}` instead of throwing Luau errors.

```sh
godot --headless --path game --script res://tests/golden_fixture_runner.gd
godot --headless --path game --script res://tests/lifecycle_runner.gd
```

G422 parity does not imply full animal simulation, clock, composite Pet, save, succession or player-visible acceptance.

## G423 — deterministic injected simulation clock (verified)

`src/domain/simulation_time.gd` mirrors the legacy Luau `SimulationTime.observe`
contract with a typed, injectable `Callable` instead of reading wall time.
Its pure observation `{rawNow, logicalNow, elapsed}` clamps device-clock rollback
and rejects nonnumeric, nonfinite or negative timestamps. The explicit
`{ok, observation|error}` envelope follows the existing Godot parity-adapter pattern.

`tests/simulation_time_runner.gd` exercises multi-observation offline gaps,
rollback and recovery, invalid clocks, NaN/infinity, fractional seconds and repeatability.
Nine provenance-linked golden cases run through the G416 harness as `ACTIVE_PARITY`.
The G423 CI gate also mutates away the rollback clamp and proves that golden parity fails,
then restores the original source and rechecks. Neither lifecycle stage acceleration
(G435) nor Animal Core parity (G429) is claimed here.

```sh
godot --headless --path game --script res://tests/simulation_time_runner.gd
godot --headless --path game --script res://tests/golden_fixture_runner.gd
```

G423 merged via PR #54 at `master@da9f4c8919fc`. The exact PR head and post-merge
master both passed required CI. The broader Animal Core parity remains unproven;
G424 genetic potential/expressed traits is next.
