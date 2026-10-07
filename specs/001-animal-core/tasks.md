# SPEC-001 — Tasks

**Mode:** historical delivery record  
**Active execution:** moved to SPEC-004 Godot V1 Transition  
**Rule:** SIGA must select new executable work from specs/004-godot-v1-transition/tasks.md.

## Delivered before runtime transition

### Phase A — Foundation

- [x] **T001** Bootstrap do repositório.
- [x] **T002** Criar constituição Spec Kit.
- [x] **T003** Registrar SPEC-001 Animal Core.
- [x] **T004** Criar plano técnico inicial.
- [x] **T005** Fechar ADR de engine/runtime Roblox — historical; superseded by ADR-0004.
- [x] **T006** Fechar ADR de persistência/tempo Roblox — semantic parts retained; platform details superseded.
- [x] **T007** Bootstrap do toolchain Roblox/Rojo/Jest — legacy migration source.

### Phase B — Domain P0

- [x] **T010** Implementar entidade Pet e IDs imutáveis.
- [x] **T011** Implementar lineage/pedigree.
- [x] **T012** Implementar lifecycle state machine.
- [x] **T013** Implementar relógio/simulação injetável.
- [x] **T014** Implementar genetic potential vs expressed traits.
- [x] **T015** Implementar care state.
- [x] **T016** Implementar health/disease/treatment.
- [x] **T017** Implementar soulbound como invariant de domínio.
- [x] **T018** Implementar affection persistente.

## Superseded executable backlog

As antigas tasks T020+ não são mais executáveis em Luau/Roblox para a V1.

- T020 → SPEC-004 **G430**; PR #26 é MIGRATION_SOURCE.
- T021 → SPEC-004 **G431**; PR #34 é MIGRATION_SOURCE.
- T022–T025 → SPEC-004 **G432–G436**.
- T030–T035 → SPEC-004 **G450–G458**.
- T040–T047 marketplace/ownership online → pós-V1.
- T050–T053 reprodução → permanece contrato de produto; será replanejada no runtime Godot depois do core de sucessão, sem preceder Animals/Plants/Farm Structure.
- G001–G006 antigos → substituídos pelos gates da SPEC-004.

## Authoritative next roadmap

Ver: specs/004-godot-v1-transition/tasks.md
