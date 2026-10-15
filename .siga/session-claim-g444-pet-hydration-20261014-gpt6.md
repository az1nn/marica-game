# SIGA G444 — SPEC-004 Pet Persistence

Status: ACTIVE
Owner: SIGA → ARCH/GODOT; QA independent
Base: master@5db87dbdb4868a762ae4fd8b73999197c1b49fba
Branch: godot/g444-pet-hydration-20261014
Scope: Pet.from_snapshot, local pet_persistence adapter, test runner, workflow, G444 documentation and claim. No ARTIST asset or gate mutation.
Guards: G440 strict envelope, G441 revision, G442 backup, G443 fail-closed version; independent QA mutation; exact-head CI before guarded merge; roadmap task not checked until merge.
Limits: G445 durable replay, G446 restart/rollback, G447 elapsed offline, runtime scene and visual ARTIST/LENTE are not certified.
