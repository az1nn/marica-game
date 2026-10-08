# SPEC-004 — Godot V1 Transition Tasks

**Mode:** executable migration roadmap  
**Priority order:** Animals → Plants → Farm Structure → Progression → City/Services → Online Leaderboard  
**Rule:** nenhum requisito online/Roblox pode bloquear o core single-player.

## Phase A — Constitution & Governance

- [x] **G400** Ratificar Godot-first / single-player / offline-first na Constituição v2.0.0.
- [x] **G401** Registrar ADR-0004 supersedendo ADR-0001 para a V1.
- [x] **G402** Criar SPEC-004 + plano + roadmap executável.
- [x] **G403** Atualizar routing documental de SIGA/GODOT/ROBLOX para a nova autoridade.
- [x] **G404** Fechar/reclassificar PR #29 como SUPERSEDED e PRs #26/#34 como MIGRATION_SOURCE sem merge Luau.
- [x] **G405** Registrar mapa de contratos/fixtures aproveitáveis de #26/#34 antes de qualquer limpeza.
- [x] **G406** Marcar ADR-0002 como parcialmente superseded onde depender de DataStore/servidor, preservando semântica de tempo/idempotência.

**Gate A:** master não contém conflito documental sobre runtime canônico.

## Phase B — Godot Foundation

- [x] **G410** Criar game/project.godot e estrutura domain/application/adapters/presentation/scenes/tests.
- [x] **G411** Pesquisar e pinar a versão Godot 4.x estável usada pelo projeto.
- [x] **G412** Escolher/pinar test runner compatível com a versão Godot selecionada.
- [x] **G413** Criar Godot CI com import/headless parse em SHA exato.
- [x] **G414** Criar smoke scene mínima e execução headless reproduzível.
- [x] **G415** Criar convenções GDScript tipado, lint/format quando aplicável.
- [x] **G416** Criar harness de golden fixtures para paridade Luau → Godot.

**Gate B:** clone limpo consegue validar o projeto Godot sem Roblox Studio.

## Phase C — Animal Domain Port

- [x] **G420** Portar Pet + IDs imutáveis.
- [ ] **G421** Portar lineage + pedigree.
- [ ] **G422** Portar lifecycle state machine.
- [ ] **G423** Portar simulation time/clock injetável.
- [ ] **G424** Portar genetic potential + expressed traits.
- [ ] **G425** Portar care state.
- [ ] **G426** Portar health/disease/treatment.
- [ ] **G427** Portar soulbound invariant.
- [ ] **G428** Portar affection persistente.
- [ ] **G429** Provar golden parity para G420–G428.

**Gate C:** invariantes já entregues no domínio Roblox têm equivalente testado em Godot.

## Phase D — Succession P0

- [ ] **G430** Reespecificar/portar algoritmo determinístico de avanço genético usando o contrato de PR #26.
- [ ] **G431** Implementar geração determinística de sucessora usando o contrato de PR #34.
- [ ] **G432** Garantir exatamente duas sucessoras por encerramento.
- [ ] **G433** Tornar end-of-life/sucessão idempotente.
- [ ] **G434** Preservar pedigree na geração seguinte.
- [ ] **G435** Executar simulação acelerada completa de 2–4 semanas.
- [ ] **G436** Rodar GAUNTLET/mutation proof nos invariantes mensuráveis P0.

**Gate D:** founder → care → aging → end-of-life → 2 successors é determinístico e testado.

## Phase E — Offline Persistence

- [ ] **G440** Definir schema v1 do save local.
- [ ] **G441** Implementar SaveStore local versionado.
- [ ] **G442** Implementar atomic save + backup/recovery.
- [ ] **G443** Implementar migration harness por schema_version.
- [ ] **G444** Persistir animals/pedigree/care/health/affection/lifecycle.
- [ ] **G445** Persistir idempotency markers de sucessão.
- [ ] **G446** Testar save/load round-trip e clock rollback.
- [ ] **G447** Testar retorno após horas/dias sem rede.

**Gate E:** fechar/abrir o jogo não reinicia nem duplica o ciclo animal.

## Phase F — Playable Animal Slice

- [ ] **G450** Criar fazenda compacta base.
- [ ] **G451** Implementar câmera isométrica/elevada com zoom.
- [ ] **G452** Integrar pet fundador ao runtime Godot.
- [ ] **G453** Criar HUD mínimo de fase/saúde/cuidado.
- [ ] **G454** Criar ações mínimas feed/care/treat/interact.
- [ ] **G455** Criar apresentação respeitosa de fim de vida.
- [ ] **G456** Criar continuidade visual/mecânica com sucessoras.
- [ ] **G457** Integrar autosave/manual save seguro.
- [ ] **G458** Capturar LENTE + ARTIST/CENA gate da slice.

**Gate F:** Animal Core V1 é jogável ponta a ponta em Godot.

## Phase G — Plants

- [ ] **G460** Implementar crop domain independente de cena.
- [ ] **G461** Implementar planted_at/growth_duration e offline growth.
- [ ] **G462** Implementar 3 crops iniciais.
- [ ] **G463** Implementar 1 fruit tree.
- [ ] **G464** Implementar harvest → inventory → food.
- [ ] **G465** Integrar qualidade simples de alimento ao care.
- [ ] **G466** Persistir crops/inventory e testar round-trip.

**Gate G:** plantar → sair → retornar → colher → alimentar funciona offline.

## Phase H — Farm Structure

- [ ] **G470** Implementar modelo de farm capacity.
- [ ] **G471** Implementar ~4 active animal slots iniciais.
- [ ] **G472** Implementar Nursery/Legacy Reserve.
- [ ] **G473** Implementar estruturas de expansão de capacidade.
- [ ] **G474** Persistir layout/estrutura/capacidade.
- [ ] **G475** Validar densidade, legibilidade e navegação da fazenda.

**Gate H:** progresso estrutural muda capacidade sem quebrar o core animal.

## Phase I — Progression & City Services

- [ ] **G480** Implementar Coins como economia local.
- [ ] **G481** Implementar reputação/nível e unlocks.
- [ ] **G482** Implementar veterinário/clinic service.
- [ ] **G483** Implementar mercado/NPC local de sementes/alimentos.
- [ ] **G484** Implementar centro da cidade mínimo.
- [ ] **G485** Revisar pesca simples e mover para V1 somente se não atrasar core.

**Gate I:** animal + plantas + estrutura + progressão formam um loop sustentável single-player.

## Phase J — Online Leaderboard

- [ ] **G490** Criar spec própria da fórmula de score e ranking.
- [ ] **G491** Definir identidade pública/privacidade mínima.
- [ ] **G492** Criar LeaderboardPort e OfflineNullAdapter.
- [ ] **G493** Selecionar backend/provider em ADR separada.
- [ ] **G494** Implementar submission validada server-side.
- [ ] **G495** Implementar rate limits/replay protection/proof payload compatível com a fórmula.
- [ ] **G496** Implementar ranking read model/UI.
- [ ] **G497** Provar fallback offline completo.
- [ ] **G498** Testar cliente adulterado enviando score arbitrário.

**Gate J:** ranking agrega competição assíncrona sem virar dependência do core.

## Phase K — Release Hardening

- [ ] **G500** Selecionar/pinar target(s) de export da V1.
- [ ] **G501** Adicionar export smoke em CI.
- [ ] **G502** Rodar save migration/recovery regression suite.
- [ ] **G503** Rodar accelerated multi-generation soak.
- [ ] **G504** Rodar performance profiling da farm densa.
- [ ] **G505** Rodar LENTE/ARTIST/CENA final.
- [ ] **G506** Fechar todos os blockers P0/P1 do release gate.
- [ ] **G507** Produzir build candidata V1.

## Phase L — Roblox Decommission / Future Port Boundary

- [ ] **G510** Confirmar paridade de todos os contratos Roblox ainda úteis.
- [ ] **G511** Remover Roblox CI como release gate da V1.
- [ ] **G512** Arquivar/remover toolchain Roblox da árvore ativa sem apagar histórico Git.
- [ ] **G513** Atualizar ROBLOX skill para future-port only definitivo.
- [ ] **G514** Registrar backlog pós-V1 para eventual port Roblox.

**Final Gate:** master representa Godot-first sem dependência operacional Roblox para construir, testar ou jogar a V1.
