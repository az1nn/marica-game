# SPEC-006 — Single-entry SIGA skill orchestration

Status: APPROVED INTENT (2026-10-14); implementation must satisfy the gates below.
Scope: repository-local operating system; no game runtime or asset change.
Authority: Constitution v2.0.0; SPEC-004 gameplay priorities; SPEC-005 accepted full pixel art 2.5D.

## Problem
SIGA can indefinitely advance a linear Godot backlog without dispatching a ready visual task; ARCH and DESIGN are named as owners in live work but lack local skills. ARTIST and CENA retain superseded Roblox/low-poly defaults. A human ACCEPT of concept art is confused with runtime approval. Skill existence validation does not catch missing owners or invalid call edges.

## Required behavior
- **FR-601 Single entry:** `SIGA` opens/reconciles any development session. `SIGA <intent>` may request code, architecture, gameplay design, narrative, ARTIST, SCENE/CENA, review, QA, LENTE, release or specification work. Existing direct specialist commands are compatible aliases/requests and MUST return control to SIGA for task authorization and closeout.
- **FR-602 Spec-first hard gate:** no task mutation, implementation, asset production, review verdict, code change or merge without a traceable active `specs/<id>/{spec,plan,tasks}.md` and an explicit unchecked task ID. If absent, SIGA first creates/repairs a Spec Kit roadmap as a dedicated **governance-only bootstrap**; commit it and verify its presence before any implementation. Bootstrap cannot silently implement its own proposed work.
- **FR-603 Single orchestration authority:** SIGA owns identity, task selection, dependency resolution, concurrency, exact-head acceptance, merge and final RELATORIO. Domain owners execute within the dispatched task and return bounded results. Specialist-to-specialist instructions are requests via SIGA, never recursive control transfer.
- **FR-604 Complete authority:** DESIGN = gameplay/mechanics, LORE = canon, ARCH = technical architecture and structural integrity, GODOT = engine implementation, ARTIST = visual intent and human art decision, CENA/SCENE = materialization, LENTE = captured evidence, QA/GAUNTLET = independent technical/behavioral critique, RELATORIO = terminal read-only status.
- **FR-605 Dependency-driven routing:** Every candidate declares or derives owner, prerequisites, artifact class and acceptance gates. On WAIT/BLOCKED, SIGA follows the *first actionable missing dependency* and dispatches its owner; only real unavailable input is HUMAN_REQUIRED. A blocked production step does not block independent concepts, audits, architecture prototypes or other ready roadmap tasks.
- **FR-606 Anti-starvation:** inspect all active specs and PRs, not only the current linear phase. An existing ready or unblocked high-value specialist lane (including ARTIST) cannot be ignored repeatedly because another lane has more unchecked tasks. Preserve constitutional animals -> plants -> farm milestone order, but allow bounded non-colliding preparatory work. Surface skipped ready lanes in the handoff.
- **FR-607 Reviews are work:** technical/code review uses ARCH/QA/GAUNTLET as applicable; visual review uses LENTE then ARTIST; gameplay design review uses DESIGN. Record findings under a specific spec task; no review without scope.
- **FR-608 Separate evidence gates:** human concept ACCEPT != production sprite/import != SCENE slice != LENTE exact-head A/B != ARCH/QA technical PASS != runtime ARTIST acceptance. REVISE/REJECT are legitimate outcomes; never force acceptance to unblock.
- **FR-609 Static enforcement:** validation checks registered skills, dispatch edges/return-to-SIGA semantics, current V2 baseline, Spec Kit gate and routing scenarios; CI must exercise validator on exact head.

## Acceptance examples
1. `SIGA artist` with an existing accepted concept and missing runtime import routes the documented ARCH/GODOT dependency first, not another ARTIST concept approval.
2. `SIGA review` starts read-only reconciliation and chooses an appropriate *existing* review task; if no task exists it first prepares a scoped review Spec Kit item.
3. `SIGA` with no roadmap writes only Spec Kit bootstrap, not code.
4. A human REVISE leaves the artistic unit open but lets SIGA continue collision-safe, already documented preparation work.
5. No circular delegation path; specialists report back to SIGA with explicit deliverables, evidence and next dependency.

## Exclusions
No merge of draft ARTIST PR #77 without its independent gates; no reassignment of existing source approval, no gameplay balance alteration, no asset generation, no silent constitutional amendment.
