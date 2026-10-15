# SIGA G444 — SPEC-004 Pet Persistence

Status: CLOSED
Owner: SIGA → ARCH/GODOT; QA independent
Base: master@5db87dbdb4868a762ae4fd8b73999197c1b49fba
Branch: godot/g444-pet-hydration-20261014
Scope: Pet.from_snapshot, local pet_persistence adapter, test runner, workflow, G444 documentation and claim. No ARTIST asset or gate mutation.
Guards: G440 strict envelope, G441 revision, G442 backup, G443 fail-closed version; independent QA mutation; exact-head CI before guarded merge; roadmap task not checked until merge.
Limits: G445 durable replay, G446 restart/rollback, G447 elapsed offline, runtime scene and visual ARTIST/LENTE are not certified.

Closeout: PR #106 HEAD eacc033ba5227c84e147888fe7d821351401e812 passed all 10 required exact-head checks (G444, G443, G442, G441, G440, Godot CI, Validate skills, ARCH V201, Web Preview, Roblox CI). Roblox Behavioral skipped/nonrequired. Protected squash merge master@802bd53314ce6974340445d4c0d9b1cb22529e20. ARTIST PR #77 disjoint, capybara ARTIST changes reconciled through merge parent. This docs PR completes claim release. Post-merge master GitHub Actions not inferred from PR checks.
