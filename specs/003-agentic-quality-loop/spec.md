# SPEC-003 — Agentic Quality Loop

**Status:** ACTIVE  
**Type:** repository operating model / quality infrastructure  
**Authority:** subordinate to the Maricá Game constitution, active product specs and SIGA.

## 1. Problem

Maricá Game already has exact-head CI, deterministic domain specs and specialist skills, but the current acceptance loop can still confuse four different questions:

1. did the builder implement the requested target?
2. can the quality gate actually detect a known bad implementation?
3. did the change regress behavior that was already correct?
4. for player-facing work, does the rendered result satisfy the intended visual contract?

A builder must not be the sole authority for those answers.

## 2. Goal

Add an adversarial, bounded quality loop under SIGA:

~~~text
SIGA
  -> baseline
  -> builder
  -> objective gates
  -> fresh critic
  -> mutation proof when measurable
  -> regression hunter
  -> LENTE / ARTIST when player-facing
  -> SIGA exact-head acceptance
~~~

The loop strengthens the existing architecture. It does not replace SIGA, QA, ROBLOX, LENTE, CENA, ARTIST or LORE.

## 3. Functional requirements

### AQ-FR-001 — Authority

SIGA remains the only repository-local master orchestrator. GAUNTLET is a specialist that may inspect, compare, challenge and report; it may not select unrelated roadmap work, redefine canon/runtime architecture or merge independently.

### AQ-FR-002 — Builder/critic separation

The critic must evaluate target evidence and acceptance criteria without relying on the builder's justification. If context isolation cannot be established, the review records that limitation explicitly.

### AQ-FR-003 — Baseline and exact head

Every run records repository identity, baseline SHA, candidate SHA, target task/spec and the exact SHA associated with gate evidence.

### AQ-FR-004 — Mutation proof

For new or materially changed measurable P0 invariants, the desired proof is:

~~~text
GOOD -> PASS
KNOWN BAD MUTANT -> FAIL
RESTORE -> PASS
~~~

A missing execution capability is not PASS. It is BLOCKED or SKIP with a concrete reason.

### AQ-FR-005 — Regression hunter

Every completed Gauntlet run contains a regression section that asks what got worse relative to the baseline. This is separate from checking whether the candidate meets its new target.

### AQ-FR-006 — Bounded loops

A run stops when one of these conditions is reached:

- PASS;
- FAIL with actionable findings;
- HUMAN_REQUIRED;
- two rounds without measurable criterion movement;
- repeated blocker without a new strategy;
- architecture/roadmap boundary;
- missing measurement capability.

Unbounded "iterate until perfect" loops are prohibited.

### AQ-FR-007 — Domain-first adoption

Before the playable UI exists, domain tasks use deterministic state/test evidence first. Visual evidence is required only when the task changes player-facing rendered behavior.

### AQ-FR-008 — Visual state matrix

When player-facing scenes become active, evidence is organized by scene × state × viewport/device × relevant input/camera mode. One attractive screenshot is not sufficient evidence for a multi-state surface.

### AQ-FR-009 — Human visual authority

Automated measurements may detect regressions or technical limits but do not replace ARTIST/human acceptance for aesthetic direction.

### AQ-FR-010 — Roblox runtime authority

Roblox remains the production runtime. Test automation should target the real Roblox DataModel/runtime through supported Studio/Open Cloud mechanisms rather than substituting an unrelated renderer.

## 4. Non-goals

SPEC-003 does not:

- reactivate 3JS as production runtime;
- replace the Animal Core delivery order;
- create automatic aesthetic scores;
- vendor external agent repositories or skills;
- allow Graphify or generated documentation to become a source of task truth;
- require every tiny maintenance change to run a full adversarial loop.

## 5. Adoption policy

Use full Gauntlet for:

- new/changed P0 domain invariants;
- succession/genetics correctness;
- persistence/ownership/economy safety;
- runtime/player-journey release gates;
- player-facing scene changes where visual regressions matter.

Use reduced verification for isolated docs/tooling changes when the active spec does not require product evidence.

## 6. Acceptance criteria

SPEC-003 foundation is accepted when:

- GAUNTLET exists as a repository-local skill and is routed by SIGA;
- QA defines mutation proof and regression hunting semantics;
- the skill validator requires GAUNTLET;
- a machine-readable Gauntlet manifest can be validated in CI;
- T018 has a shadow calibration record that does not invent missing mutation evidence;
- the test place contains an explicit Jest runner entrypoint;
- missing headless behavioral execution is represented as a tracked gap rather than PASS.

## 7. Future capabilities

Later tasks may add:

- headless Roblox behavioral execution in CI;
- Scene State Matrix/contact sheets through LENTE;
- asset sourcing/provenance ledger;
- generated architecture/ownership surfaces;
- Graphify as a non-authoritative navigation experiment.
