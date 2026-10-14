# Maricá Game — local skills

Canonical repository: `az1nn/marica-game`. The only session opener is **SIGA**, including `SIGA code`, `SIGA architecture`, `SIGA design`, `SIGA artist`, `SIGA scene`, `SIGA review`, `SIGA qa`, `SIGA spec`.

```text
SIGA — single-entry orchestrator, roadmap admission, conflicts, merge
├── DESIGN — mechanics, systems, economy, progression
├── LORE — narrative canon
├── ARCH — architecture, APIs, persistence, performance, technical review
├── GODOT — canonical Godot V1 engine/runtime
├── ARTIST — visual direction and independent human visual gate
├── CENA (SCENE alias) — pixel-art sprites, scenes, materialization
├── LENTE — visual observation and exact-head A/B evidence
├── QA — deterministic and integration quality
├── GAUNTLET — independent bounded review / regression hunt
├── ROBLOX — migration reference/future port (not V1 runtime)
├── 3JS — noncanonical prototype/reference
├── siga-concurrency — claim and collision safety
└── RELATORIO — mandatory final read-only dashboard
```

**No committed Spec Kit + task => no implementation, art production, code review verdict or merge.** SIGA creates/repairs spec/plan/tasks in a governance-only commit first, then performs a new task admission/claim. Direct standalone specialist names are compatibility aliases that request a SIGA session, not independent authorities.

**Dispatch:** `IDENTITY -> RECONCILE -> SPEC_GATE -> CLASSIFY -> DEPENDENCY_RESOLVE -> ROUTE -> CLAIM -> EXECUTE -> VERIFY -> MERGE/WATCH -> HANDOFF -> RELATORIO`. Specialists execute bounded work and return to SIGA with evidence, missing dependency, next owner and acceptance status; no direct peer recursion.

**Visual example:** concept ACCEPT -> ARCH/GODOT measured import -> CENA/SCENE playable slice -> LENTE exact-head A/B -> ARTIST runtime verdict. A blocked visual gate does not lock unrelated ready roadmap tasks. Prevent starvation by inspecting all active specs/PRs and tracking skipped ready specialist lanes.

Approved artistic target: **full pixel art 2.5D** in `specs/005-pixel-art-v2-migration/`; historical low-poly text is not active guidance. Godot offline-first/animal-first remain canonical.

See `docs/SKILL-TREE.md`, `tools/skills/skill_tree.json`, `tools/skills/routing_cases.json`. Validate with `python tools/skills/validate.py`.
