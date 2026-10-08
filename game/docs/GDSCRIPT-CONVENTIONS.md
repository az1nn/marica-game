# G415 — Typed GDScript conventions

**Authority:** Maricá Game Constitution v2.0.0 / SPEC-004 / ADR-0004. Godot 4.7.2-stable is the production runtime.

## Runtime and boundaries

- Production code uses typed GDScript. Explicitly annotate function arguments and returns (`-> void` for procedures).
- Declare variables with an explicit type (`var pet: PetState`) or inferred type (`var next := current + 1`). Avoid untyped `var x = value`.
- Prefer `const` for immutable values; constants may use type inference. Use `StringName` only where appropriate.
- Domain logic under `game/src/domain` cannot reference `Node`, `SceneTree`, `Control`, `HTTPRequest`, UI state or concrete persistence/network adapters.
- Keep time and RNG explicit/injectable for deterministic animal lifecycle and golden parity; offline gameplay is mandatory.
- Keep `game/tests` deterministic. G414 smoke verifies boot only; G416 introduces fixture parity against legacy Luau contracts.

## First-party style

- 4 spaces indentation, LF UTF-8 source, 100-column format/lint target.
- Files and functions: snake_case; types/classes: PascalCase; constants: SCREAMING_SNAKE_CASE.
- Name engine callbacks per Godot conventions (`_ready`, `_initialize`, etc.).
- Avoid untyped public APIs or implicit dependency on singletons; adapters are replaceable interfaces.
- Do not reformat vendor code under `game/addons` or Godot's generated `game/.godot`.

## Local commands

From repository root:

```sh
python3 -m venv .venv-gdscript
. .venv-gdscript/bin/activate
python -m pip install -r game/requirements-gdscript.txt
python -m unittest discover -s tools/godot -p 'test_*.py'
python tools/godot/check_gdscript_types.py game/src game/tests
cd game
gdformat --check src tests
gdlint src tests
# To apply formatting intentionally: gdformat src tests
```

The pinned `gdtoolkit` is a supplemental formatter/linter, not the authoritative Godot compiler. CI must also pass exact-head Godot import, parse, main-scene boot and runtime smoke tests. The small Python typing guard deliberately enforces declaration syntax, not complete GDScript semantic type checking.

## Delivery gate

G415 passes only when the typing guard, its regression tests, gdformat check, gdlint, existing Godot runtime gates and repository skill validation all pass for the **same candidate commit SHA**. No gameplay parity, art or save behavior is implied by this foundation.
