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
- [x] **G421** Portar lineage + pedigree.
- [x] **G422** Portar lifecycle state machine.
- [x] **G423** Portar simulation time/clock injetável.
- [x] **G424** Portar genetic potential + expressed traits.
- [x] **G425** Portar care state. Luau care defaults/quality/factors verified by 21 executable Godot golden cases, targeted runner and hunger inversion GOOD→BAD→RESTORE proof (PR #60).
- [x] **G426** Portar health/disease/treatment. Pure `MaricaHealth` GDScript matches Luau Health.new/advance/treat/isTerminalRisk thresholds and costs; 35 executable golden cases (create 10 / advance 13 / treat 7 / terminal 5), independent state runner, and 48h sickness-boundary mutation proof on PR #63. Pet aggregate/end-of-life wiring is separately pending, not implied by this isolated port.
- [x] **G427** Portar soulbound invariant. `MaricaSoulbound` reproduz Luau new/isTransferable/assertTransferable; estado explícito em `MaricaPet`, fundador bloqueado para transferência e descendentes unbound por default. 22 casos ACTIVE_PARITY, runner independente e GOOD→BAD→RESTORE comprovados no PR #65; integração com todas as transições do agregado permanece G429.
- [x] **G428** Portar affection persistente. `MaricaAffection` preserva o contrato Luau new/increase (zero default, valor salvo finito [0,1], ganho não-negativo, saturação em 1); `MaricaPet` mantém afeição em snapshots independentes do vínculo soulbound e do cuidado momentâneo. 33 fixtures ACTIVE_PARITY (11 create / 13 increase / 9 Pet), runner independente, GOOD→BAD→RESTORE e Godot CI PASS no PR #67, incluindo master pós-merge. Transições compostas Pet/Care/Health/Lifecycle e parity agregada permanecem em G429.
- [x] **G429** Provar golden parity para G420–G428. PR #69 integrou Pet composto em Godot (pedigree, lifecycle, genetics/expressed traits, care, health, Soulbound e affection persistente); 21 casos ACTIVE_PARITY source-linked (209 no total), regressão independente e terminal-risk GOOD → BAD → RESTORE em CI. Exact-head PR@9edde551 e master@66604001 Godot CI / Validate skills / Roblox CI PASS. G430+ sucessão e G440+ save ainda pendentes.

**Gate C:** invariantes já entregues no domínio Roblox têm equivalente testado em Godot.

## Phase D — Succession P0

- [x] **G430** Portar avanço genético determinístico do contrato PR #26 (seed inteira finita, rotação lexicográfica, incremento +0,05, fallback cíclico, teto 1, snapshot detached). PR #71: 15 novos casos ACTIVE_PARITY (224 no total), regressão independente e GOOD → BAD → RESTORE; Godot CI / Validate Skills / Roblox CI PASS em PR@fb2b8eb e master@0f9239a. G431 implementado separadamente no PR #73; G432 duas sucessoras segue pendente.
- [x] **G431** Geração determinística de **uma** sucessora por chamada (PR #73, legado PR #34): pai terminal obrigatório; seed+ordinal validado; avanço genético G430, mesma lineage/founder, geração+1 e pai direto; juvenile/active, care/health fresh, affection zero, soulbound false; snapshots independentes. **14 casos ACTIVE_PARITY** (238 total), regressão independente, mutation GOOD→BAD→RESTORE, CI Godot/skills/Roblox PASS em PR@1afe3c7d e master@0b116a10. Exatamente duas sucessoras e idempotência permanecem G432/G433.
- [x] **G432** Garantir exatamente duas sucessoras por encerramento. PR #75: `MaricaSuccession.create_successors` compõe duas sucessoras por chamada para pai terminal com IDs distintos e ordinais 1/2, preservando G431, progressão genética e isolamento; runner independente, cardinalidade GOOD→BAD→RESTORE e Godot CI / Validate skills / Roblox CI PASS em PR@67334e2 e master@cdc427ae. Idempotência transacional, save e evento automático continuam G433/G440+.
- [x] **G433** Tornar end-of-life/sucessão idempotente **dentro de uma sessão de execução**. PR #79: `MaricaSuccessionEvent.trigger_once` registra evento concluído após o par G432 completo, devolve o mesmo par no replay exato (`created=false`), rejeita seed/IDs/estado parental conflitantes e não grava marcador em chamadas que falham, permitindo retry. Runner independente, duplicação GOOD→BAD→RESTORE e Godot CI / Validate skills / Roblox CI / Web Preview PASS em PR@c2a69d40 e master@196431e2. **Não** prova reabertura/salvamento transacional, reservados G440/G445/G446; G434 pedigree multigeração verificado separadamente no PR #81.
- [x] **G434** Preservar pedigree multigeração por continuidade de lineage/founder, incremento de geração, pai direto correto em cada ramificação e rastreabilidade de ancestrais pelas snapshots históricas retidas. PR #81: runner Godot independente cobre fundador → G1 (2 filhos) → G2 em dois ramos → G3, replay G433, isolamento das snapshots e soulbound exclusivo do fundador; BAD mutant troca pai intermediário por fundador e é detectado (GOOD → BAD → RESTORE). Godot CI / Validate skills / Roblox CI / Web Preview Contract PASS em PR@87fdfb65 e master@bac5a15e. **Sem novo campo de ancestral embutido**, persistência de histórico/IDs globais e reabertura permanecem G440/G444/G445/G446; não implica cena jogável.
- [x] **G435** Simulação acelerada determinística de 14/21/28 dias (PR #83): runner Godot independente combina relógio injetável, cuidado→doença→tratamento pago→recuperação, estágios juvenile→adult→senior, fim natural/por saúde, duas sucessoras, replay único na sessão e rollback do relógio; mutation proof GOOD→BAD→RESTORE. PR #83 exact-head e87b1124efa19fb3e0bda5418e678f0f444fe745 and guarded master@d019443e2d1e8a1e2711f9d9fda3463bb6390b62: Godot CI, Validate skills, Roblox CI and Web Preview Contract PASS. Independent G435 scenario and rollback GOOD→BAD→RESTORE PASS. Marcos etários são fixtures de teste, não scheduler de produção nem política final de idade. Nenhum save/restart, cena jogável ou nova paridade Luau foi comprovada. G436 GAUNTLET P0 permanece pendente.
- [x] **G436** GAUNTLET P0 determinístico, escopo delimitado, PR #85: runner Godot independente combina founder→care/expression→aging→end-of-life→2 successors→G2 pedigree, replay in-session e avanço genético nos fixtures não saturados. Mutante de fator de expressão (qualidade→1.0) GOOD→BAD→RESTORE PASS. Exact-head PR@180b37fc e master@e8b29a5d: Godot CI, Validate skills, Roblox CI, Web Preview Contract PASS. Manifest + critic: `docs/gauntlet/G436-PHASE-D-2026-10-14.{json,md}`. Limites: não prova save/restart, scheduler de produção ou progressão universal com todos os traços no teto (issue #86, decisão DESIGN/ARCH antes de certificação de release).

**Gate D:** founder → care → aging → end-of-life → 2 successors é determinístico e testado. **Evidência de teste bounded:** G436 PASS em fixtures não saturados; exceção de saturação #86 não certificada como garantia universal.

## Phase E — Offline Persistence

- [x] **G440** Definir schema v1 do save local (PR #91): envelope JSON Schema 2020-12 fechado (`schema_version`, `revision`, `last_observed_at`, snapshots de pets históricos e ledger de sucessão) + 3 fixtures, verificador cross-record e 9 corrupções intencionais. PR exact-head `0242aba5` com G440 Save Schema / Godot CI / ARCH V201 / Validate skills / Roblox CI / Web Preview Contract PASS; merge guardado em `master@dfc98d33`. **Só contrato/validação de fixtures:** SaveStore, atomicidade, migrations, hidratação, replay após restart e teste offline G441–G447 permanecem pendentes.
- [x] **G441** Implementar SaveStore local versionado (PR #96): adapter Godot tipado `game/src/adapters/local/save_store.gd` e validador v1 estrito. `load` distingue ausência/corrupção sem criar pet; `save` valida schema/pedigree/ledger, exige revisão esperada, relógio injetável monotônico, path `user://` permitido e rejeita duplicação de chaves JSON. Runner independente prova fixtures mínima/fundador/sucessão, escrita/leitura, colisão de revisão, relógio e invalidação; QA GOOD → BAD (ignorar revisão obsoleta) → RESTORE. **PR head `42018f778d81405d08bb5b438103b2c2bf19f490` e master pós-merge `4f58a8251a4e9ccfd4c89d9a370b913081ccecbd`: todos os gates aplicáveis PASS** (G441 SaveStore, Godot CI, G440 schema, ARCH V201, Validate skills, Roblox CI, Web Preview Contract). Não comprova G442 atomicidade/backup, G443 migração, G444 hidratação, G445 marcador durável, G446 round-trip após reinício ou G447 offline catch-up.
- [x] **G442** Implementar atomic save + backup/recovery (PR #101): staging JSON v1 verificado, backup da revisão anterior e restauração somente a partir de backup válido; nunca criar perfil a partir de staging órfão. 12 cenários G442 e QA GOOD→BAD→RESTORE PASS; G441 SaveStore, G440 Schema, Godot CI, Validate skills, ARCH V201, Web Preview e Roblox CI PASS no head exato `29543918db2ed3afb12f61dc561225275deb95e6`; merge guardado em master@`e90173f3bb8c720101cdbe9511b3970f0f30b41d`. Limites: power-loss/fsync e rename cross-platform não provados; G443 migrations, G444 hydration, G445 replay, G446 restart e G447 offline continuam abertos.
- [x] **G443** Implementar migration harness por schema_version (PR #103): `MaricaSaveMigration.migrate` v1 identity validada/detached, rejeição fail-closed de versões ausentes, inválidas, antigas ou futuras sem contrato; sem fabricar migração v0/v2, sem reescrever G442. 12 cenários G443 e QA GOOD→BAD→RESTORE; G443, G442, G441, G440, Godot CI, Validate skills, ARCH V201, Web Preview, Roblox CI PASS no head exato `dbcaeea6d69098b9945126fd6654af2614cf5dd4`; merge protegido master@`445a32084b1ad73f4ef5d814f9d20ebef3691324`. G444 hidratação, G445 ledger persistido, G446 restart, G447 offline continuam pendentes.
- [x] **G444** Persistir e reidratar animals/pedigree/care/health/affection/lifecycle (PR #106): adaptador `MaricaPetPersistence` com admissão G443 e validação cross-record G440; `MaricaPet.from_snapshot` reconstitui agregado tipado, inclusive ancestrais terminais, preserva expressão genética histórica sem recomputar, mantém ledger intacto, e revalida snapshot serializado. Runner G444 12 cenários, disk round-trip G442 e QA GOOD→BAD→RESTORE; G444/G443/G442/G441/G440, Godot CI, Validate skills, ARCH V201, Web Preview e Roblox CI **PASS** no PR head exato `eacc033ba5227c84e147888fe7d821351401e812`; merge protegido master@`802bd53314ce6974340445d4c0d9b1cb22529e20`. G445 replay durável, G446 reinicialização e G447 tempo offline ainda pendentes; ARTIST/LENTE não certificados.
- [x] **G445** Persistir idempotency markers de sucessão (PR #110): `MaricaDurableSuccession` lê SaveStore G442, reidrata via G444, rejeita conflito de seed/IDs e devolve exatamente as duas sucessoras já persistidas sem gerar nem salvar novamente; ausência de marcador gera duas sucessoras G432 e persiste snapshots + marcador G440 numa única revisão G441. Runner G445 com 12 cenários e QA GOOD→BAD→RESTORE; G445/G444/G443/G442/G441/G440, Godot CI, Validate skills, ARCH V201, Web Preview e Roblox CI PASS no HEAD exato `ef0f5807bfadd2b47c19d38e8ee7ebaabca024f7`; merge protegido master@`cb87ada6ad4cf6bd770063098c46669e1beff5ab`. G446 processo/rollback e G447 offline ainda pendentes; sem certificação visual ARTIST.
- [ ] **G446** Testar save/load round-trip e clock rollback.
- [ ] **G447** Testar retorno após horas/dias sem rede.

**Gate E:** fechar/abrir o jogo não reinicia nem duplica o ciclo animal.

## V1 roster decision / Spec Kit trace (2026-10-09)

**Decision accepted, implementation not marked done.** SPEC-004 §3.1 limits the **initial V1** to **3 animal types: tricolor dog (founder), capybara, chicken; 3 initial plant/crop types: milho (S07-P01), tomate (S07-P02), cenoura (S07-P03)**. Existing G463 fruit tree belongs to the **expanded crop slice**, not a fourth initial type.

- [x] **G-ROSTER-DECISION** Human scope locked and recorded in SPEC-004 §3.1. Chicken and capybara ARTIST concept boards approved; founder dog still awaits individual sprite review.
- [ ] **G-ROSTER-ANIMALS** Verify all **three animal types** appear in V1 build with correct founder soulbound semantics, relevant care/lifecycle/successor behavior, and valid offline saves. Depends on G450–G458, G440–G447 and existing core domain gates.
- [x] **G-ROSTER-PLANTS-NAMES** Human chose **exactly three** initial species: milho / tomate / cenoura; recorded in SPEC-004 §3.1 with DESIGN/LORE domain mechanics unchanged. No additional crop approved.
- [x] **G-ROSTER-ART-PLANTS-CONCEPTS** ARTIST: generate three individual transparent PNG previews and record human visual **ACCEPT** for S07-P01 / P02 / P03. See `docs/artist/reviews/S07-P01-P03-2026-10-09-plants-accepted.md`; binaries are conversation artifacts, not committed/imported runtime assets.
- [x] **G-ROSTER-ART-3X3-CONCEPT** ARTIST: revised consolidated **3 animals × 3 plants** board accepted by human on 2026-10-09, with milho/tomate/cenoura replacing erroneous alface/pimenta composite. This completes **composite concept review only**, not independent sprites, verified animation frames, Godot import, runtime or LENTE acceptance. Evidence: `docs/artist/reviews/V1-3X3-ART-CONCEPT-2026-10-09-accepted.md`.
- [ ] **G-ROSTER-PLANTS-VERIFY** Verify exactly three initial crops through planting/harvest/food/save offline; G463 expanded fruit tree must be separately testable without becoming a fourth initial offering.
- [x] **G-ROSTER-ART-FOUNDING-DOG** ARTIST: **isolated S01-A01 tricolor dog founder concept ACCEPTED** by human 2026-10-10, consistent with S01 V3; evidence `docs/artist/reviews/S01-A01-2026-10-10-isolated-dog-preview-pending.md` (append-only acceptance). This completes **concept review only**; no production sprite, import or runtime validation.
- [x] **G-ROSTER-ART-DOG-AUDIT** ARTIST/ARCH preflight (source-bytes only): PNG SHA-256 + RGBA 362×400 / binary alpha PASS, 24,532 opaque colors observed; 128px/48 and 96-color nearest-neighbor **technical prototypes only**, with **production validation REVISE/OPEN**. Evidence `docs/artist/reviews/S01-A01-2026-10-10-technical-audit.md`. GitHub PNG binaries, pixel-grid contract, animations, Godot runtime and LENTE still pending.
- [ ] **G-ROSTER-ART-DOG-TECH** ARCH/ART: obtain source PNG, verify alpha-edge quality, true dimensions, palette and pixel grid; resolve V201/V201a before approving production-resolution assets.
- [ ] **G-ROSTER-ART-DOG-ANIM** ART/SCENE: generate and validate isolated aligned pose/animation frames against approved identity, then test Godot import, movement and LENTE exact-head runtime A/B.
- [ ] **G-ROSTER-ART-ALTERNATES** ARTIST: independently isolate capybara PET-ALT-001 and chicken PET-ALT-002 sprites; the approved concept boards **do not count as Godot sprites or approved runtime**.

Do not mark these implementation checks complete based on illustrative previews alone; SPEC-004 priority Animals → Plants → Farm Structure and SPEC-005 R2 gate remain unchanged.

## Phase F — Playable Animal Slice

**Visual companion:** SPEC-005 ARTIST V2 full pixel art 2.5D approved on 2026-10-09. Its visual tasks V201–V211 are a gated accompaniment to G450–G458; they do **not** mark these existing tasks complete or preempt G425–G449.

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

**Initial crop quantity contract:** G462 is **three initial plants/crops: milho, tomate, cenoura** (identities accepted; no runtime completion claimed). G463 preserves the distinct **expanded-slice** fruit-tree requirement; it is not a fourth initial option.

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
