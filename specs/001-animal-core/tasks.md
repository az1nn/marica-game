# SPEC-001 — Tasks

**Mode:** executable backlog  
**Rule:** atacar em ordem; não iniciar sistemas secundários antes dos gates P0.

## Phase A — Foundation

- [x] **T001** Bootstrap do repositório.
- [x] **T002** Criar constituição Spec Kit.
- [x] **T003** Registrar SPEC-001 Animal Core.
- [x] **T004** Criar plano técnico inicial.
- [x] **T005** Fechar ADR de engine/runtime.
- [x] **T006** Fechar ADR de persistência e autoridade de tempo.
- [ ] **T007** Bootstrap do toolchain Roblox/Rojo/Jest e CI reproduzível.

## Phase B — Domain P0

- [ ] **T010** Implementar entidade Pet e IDs imutáveis.
- [ ] **T011** Implementar lineage/pedigree.
- [ ] **T012** Implementar lifecycle state machine.
- [ ] **T013** Implementar relógio/simulação injetável.
- [ ] **T014** Implementar genetic potential vs expressed traits.
- [ ] **T015** Implementar care state.
- [ ] **T016** Implementar health/disease/treatment.
- [ ] **T017** Implementar soulbound como invariant de domínio.
- [ ] **T018** Implementar affection persistente.

## Phase C — Succession P0

- [ ] **T020** Definir algoritmo de avanço genético garantido.
- [ ] **T021** Implementar geração determinística de sucessoras.
- [ ] **T022** Garantir exatamente duas sucessoras por encerramento.
- [ ] **T023** Tornar encerramento/sucessão idempotente.
- [ ] **T024** Preservar pedigree na nova geração.
- [ ] **T025** Testar ciclo acelerado completo de 2–4 semanas.

## Phase D — Playable Slice

- [ ] **T030** Criar UI mínima do pet.
- [ ] **T031** Exibir fase de vida, saúde e cuidado.
- [ ] **T032** Criar ações mínimas de cuidado/tratamento.
- [ ] **T033** Exibir transição respeitosa de fim de vida.
- [ ] **T034** Exibir escolha/continuidade com sucessoras.
- [ ] **T035** Provar save/load sem regressão do ciclo.

## Phase E — Ownership & Market P1

- [ ] **T040** Implementar ownership history.
- [ ] **T041** Implementar transferência elegível.
- [ ] **T042** Bloquear transferência do fundador soulbound.
- [ ] **T043** Implementar moeda interna.
- [ ] **T044** Implementar listing com preço livre.
- [ ] **T045** Implementar ofertas.
- [ ] **T046** Implementar trocas.
- [ ] **T047** Implementar histórico de mercado.

## Phase F — Reproduction V1

- [ ] **T050** Implementar sexo simples.
- [ ] **T051** Implementar reprodução simples.
- [ ] **T052** Implementar regra simples de consanguinidade.
- [ ] **T053** Verificar independência entre reprodução e sucessão automática.

## Release Gate — Animal Core V1

- [ ] **G001** Todos os invariantes de SPEC-001 cobertos por testes.
- [ ] **G002** Vertical slice executável de ponta a ponta.
- [ ] **G003** Ciclo offline/retorno validado.
- [ ] **G004** Nenhuma ação de UI consegue violar soulbound.
- [ ] **G005** Próxima geração mantém pedigree e progresso esperado.
- [ ] **G006** Constituição e implementação sem divergências conhecidas.
