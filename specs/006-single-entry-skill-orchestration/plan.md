# SPEC-006 — Implementation plan

## Atomic rollout
1. Commit **governance-only Spec Kit** (this spec, plan, tasks and claim) on a dedicated branch before touching skill behavior.
2. Reconcile active claims and the open ARTIST draft; preserve independent visual production gates.
3. Add missing `arch` and `design` skills. Canonical name `cena`, conversational alias SCENE.
4. Publish a machine-readable acyclic skill/dispatch graph and update SIGA's single-entry/dependency-routing/Spec Kit gate; align ARTIST and CENA with approved V2 + Godot.
5. Extend the validator with graph, ownership, baseline and gate regression checks; exercise against concrete routing fixtures.
6. Verify exact-head CI and merge only if required gates are green; record the result in SIGA handoff.

## Routing decision algorithm
`IDENTITY -> RECONCILE -> SPEC_GATE -> RESOLVE(task,owner,dependency) -> CLASSIFY -> CLAIM -> DISPATCH -> EXECUTE -> VERIFY -> HUMAN_GATE(if truly required) -> MERGE/WATCH -> HANDOFF -> RELATORIO`.

Selection order: explicit task/intent if valid and safe > repair an in-flight ready dependency > prior high-impact ready specialist lane not yet served > next constitutional milestone task. Read-only reconciliation is allowed without a claim; any write after bootstrap needs an existing task and concurrence barrier. No implicit approval.

## Ownership / dependency contract
Specialist requests: `{spec,task,owner,intent,inputs,prerequisites,expected_artifacts,acceptance_gates,branch_head}`.
Return: `{status,changes,evidence,missing_dependency,next_owner,human_gate}`.
Only SIGA transitions tasks or hands control to the next owner; graph has no peer delegation.

## Failure and rollback
No roadmap: bootstrap-only. Task ambiguity: select explicit safe documented unit; otherwise record missing decision, never fabricate. Semantic overlap: WATCH/RECONCILE. Stale evidence: GATE_STALE. Machine capability missing: CAPABILITY_BLOCKED (not falsely HUMAN_REQUIRED). All changes isolated on one PR, no changes to production domain behavior.
