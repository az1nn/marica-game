# SPEC-003 — Plan

## Operating model

~~~text
                           SIGA
                             |
                    resolve live task/spec
                             |
                             v
                         GAUNTLET
              +--------------+--------------+
              |              |              |
          DOMAIN QA      RUNTIME QA      VISUAL QA
              |              |              |
         invariants       Roblox test       LENTE
         mutations        journey           |
              |              |          fresh critic
              +--------+-----+--------------+
                       |
                regression hunter
                       |
               ARTIST / HUMAN
                when applicable
                       |
                       v
                SIGA VERIFY/MERGE
~~~

## Boundaries

- SIGA owns task selection, concurrency classification and merge.
- QA owns measurable gates.
- GAUNTLET owns adversarial orchestration of quality evidence for the selected target.
- ROBLOX owns runtime/platform execution.
- LENTE observes rendered exact-head state.
- ARTIST owns intended visual direction and human visual acceptance.
- CENA materializes scenes/assets.

## Evidence contract

A machine-readable run manifest records:

- canonical repository;
- target task;
- baseline SHA;
- candidate SHA;
- exact-head gate SHA/results;
- critic isolation status;
- mutation requirement/result;
- regression result;
- bounded round count;
- decision and next action.

Repository utility:

~~~bash
python tools/gauntlet/gauntlet.py self-check
python tools/gauntlet/gauntlet.py validate <manifest.json>
~~~

## Mutation doctrine

For measurable P0 invariants, prefer one deliberately wrong mutation that represents a real product failure.

Examples for Animal Core:

- soulbound transfer guard removed;
- short absence promoted directly to critical disease;
- affection reset by a state transition;
- successor count changed away from exactly two;
- succession idempotency removed;
- guaranteed genetic advance allowed to regress.

The mutation is evidence about the test instrument, not production code to merge.

## Roblox behavioral execution

The repository test place receives a Jest runner Script so the built test place has an explicit executable entrypoint.

Current CI builds the test place but does not launch it. Therefore behavioral mutation proof remains BLOCKED until a supported runtime execution lane is wired.

Preferred future lane:

1. build/publish an isolated test place/version;
2. execute the Jest runner through Roblox-supported Studio/Open Cloud automation;
3. collect test result/logs for the exact candidate;
4. run isolated mutant;
5. restore candidate and rerun;
6. attach all three results to the Gauntlet manifest.

No API key, universe or place identifier is committed to the repository.

## Rollout

### Foundation
- skill + authority boundaries;
- validator + machine-readable manifest;
- QA mutation/regression doctrine;
- SIGA routing;
- T018 shadow calibration.

### Succession
Use the loop first on deterministic genetic-advance/succession work because failures are cheap to synthesize and high impact.

### Playable slice
Add runtime journey execution and then Scene State Matrix once UI/3D states exist.

### Scale
Only after repository complexity warrants it:
- generated architecture/ownership;
- asset provenance budgets;
- Graphify pilot.
