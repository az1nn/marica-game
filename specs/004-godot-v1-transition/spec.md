# SPEC-004 — Godot V1 Transition

**Status:** APPROVED / EXECUTABLE  
**Priority:** P0  
**Constitution:** v2.0.0  
**Decision date:** 2026-10-07

## 1. Problem

O Maricá Game foi iniciado com Roblox/Luau como runtime de produção, mas a estratégia Roblox-first introduz dependências de plataforma, multiplayer, Open Cloud e validação operacional antes de provar o jogo principal.

A V1 precisa otimizar velocidade de iteração e validação do produto: **animais → plantas → estrutura da fazenda**, preservando portabilidade e adicionando online apenas onde houver valor claro.

## 2. Decision

A implementação canônica da V1 passa a ser **Godot 4.x**, com **GDScript tipado** como linguagem principal de gameplay/runtime.

A V1 será:

- single-player;
- plenamente jogável offline;
- baseada em save local versionado;
- composta por domínio determinístico separado de cenas/UI;
- complementada por uma camada online fina para ranking/placar assíncrono;
- independente de multiplayer, marketplace player-to-player ou serviços Roblox para seu core loop.

Roblox deixa de ser runtime de produção da V1 e passa a ser um alvo futuro opcional de port/distribuição.

## 3. Product priority

A ordem de produto da V1 é:

1. **Animals** — identidade, cuidado, saúde, genética, lifecycle, sucessão e pedigree;
2. **Plants** — cultivo e alimento ligados diretamente ao cuidado;
3. **Farm Structure** — capacidade, slots, reserva e expansão da propriedade;
4. **Progression** — reputação, desbloqueios e economia local;
5. **City / Services** — veterinário, mercado/NPCs e serviços mínimos;
6. **Online Leaderboard** — competição assíncrona sem tornar o jogo online-dependent.

Features fora dessa ordem não podem bloquear a vertical slice principal.

## 4. User-visible V1 contract

### US-401 — Jogar sem conexão — P0

Como jogador, quero conseguir iniciar, jogar, salvar e continuar minha fazenda sem depender de conexão.

**Acceptance criteria**

- O jogo inicia sem serviço online.
- Animal, plantas, fazenda, inventário, progressão e save continuam funcionais offline.
- Falha de rede nunca corrompe nem bloqueia o save local.
- O ranking pode ficar indisponível sem bloquear gameplay.

### US-402 — Manter o loop animal — P0

Como jogador, quero que todo o ciclo animal já definido continue válido na nova implementação.

**Acceptance criteria**

- IDs, pedigree, lifecycle, genética, care, health, soulbound e affection preservam os invariantes aprovados.
- O fim da vida continua gerando exatamente duas sucessoras.
- A sucessão continua determinística, idempotente e com avanço genético garantido.
- O ciclo completo de 2–4 semanas pode ser acelerado em testes.

### US-403 — Cultivar para sustentar a fazenda — P0

Como jogador, quero plantar, colher e usar alimentos dentro do loop de cuidado.

**Acceptance criteria**

- Pelo menos 3 cultivos e 1 árvore frutífera existem na primeira slice expandida.
- Crescimento usa tempo persistido e funciona entre sessões.
- Crop state participa do save versionado.

### US-404 — Expandir estrutura da fazenda — P0

Como jogador, quero aumentar a capacidade da fazenda conforme progresso.

**Acceptance criteria**

- A fazenda inicial é compacta e densa.
- Capacidade de animais começa limitada e pode crescer por estruturas/progressão.
- Active slots e Nursery/Legacy Reserve são representáveis no save.
- Estruturas não dependem de multiplayer.

### US-405 — Comparar progresso online — P1

Como jogador, quero comparar meu desempenho com outros jogadores sem transformar o jogo em multiplayer.

**Acceptance criteria**

- Ranking é assíncrono.
- Score submetido ao serviço online é validado no backend; o cliente não é fonte autoritativa.
- O jogo mantém fallback offline.
- O score não pode ser simplesmente um valor arbitrário enviado pelo cliente.
- A fórmula de score precisa de spec própria antes da implementação pública.

## 5. Architectural invariants

1. game/src/domain não depende de SceneTree, Node, UI, HTTP ou storage concreto.
2. Tempo e RNG críticos entram por interfaces/valores explícitos.
3. Save local usa schema versionado e migrations.
4. Rede é um adapter opcional.
5. Leaderboard nunca é requisito para abrir/carregar/jogar a fazenda.
6. Assets e conteúdo devem permanecer reutilizáveis fora de um único runtime quando razoável.
7. Nenhum requisito Roblox pode bloquear milestone da V1.
8. Código Roblox não é deletado antes de existir paridade verificável dos contratos relevantes em Godot.
9. PRs Roblox abertos na mudança de estratégia não podem ser mergeados silenciosamente; devem ser classificados como migration source ou superseded.
10. O domínio portado deve possuir golden fixtures/testes equivalentes para reduzir regressão semântica.

## 6. In scope

- alteração constitucional e ADR de runtime;
- reclassificação dos PRs/workflows Roblox;
- bootstrap Godot;
- CI headless Godot;
- port do domínio já implementado;
- conclusão de genética/sucessão em Godot;
- save local;
- vertical slice animal;
- plantas;
- estrutura da fazenda;
- progressão/cidade mínima;
- adapter de leaderboard;
- release hardening;
- arquivamento posterior da lane Roblox.

## 7. Out of scope for V1

- multiplayer síncrono;
- visita online a fazendas;
- marketplace player-to-player;
- ofertas/trocas online;
- monetização Robux;
- Roblox como release target obrigatório;
- backend obrigatório para core gameplay;
- mutações genéticas espontâneas;
- automação avançada da fazenda.

Esses itens podem retornar em specs pós-V1 sem alterar os invariantes de domínio.

## 8. Migration sources

Na data da decisão existem três PRs Roblox relevantes:

- **PR #26 / T020** — algoritmo de avanço genético: preservar contrato/fixtures como fonte para o port, mas não mergear Luau na V1 Godot;
- **PR #34 / T021** — geração determinística de sucessora: preservar contrato/fixtures como fonte para o port, mas não mergear Luau na V1 Godot;
- **PR #29 / AQ011** — gate comportamental Roblox/Open Cloud: superseded para a V1 Godot.

Branches podem permanecer temporariamente como material de migração mesmo depois do fechamento dos PRs.

## 9. Definition of Done

A transição está concluída quando:

1. Constituição/ADR/skills apontam Godot como runtime canônico.
2. Existe projeto Godot versionado e executável.
3. CI consegue importar/provar o projeto headless em SHA exato.
4. O domínio Animal Core relevante possui paridade/testes em Godot.
5. A vertical slice animal executa ponta a ponta com save local.
6. Plantas e estrutura mínima da fazenda estão integradas.
7. O jogo continua jogável sem rede.
8. Leaderboard possui contrato isolado e fallback offline.
9. Workflows Roblox não são mais release gates da V1.
10. A lane Roblox está claramente arquivada/reference-only, sem apagar evidência histórica útil.

## 10. Release gate

~~~text
Load/Create Local Farm
        ↓
Founder Animal
        ↓
Care / Health / Food
        ↓
Plants → Harvest
        ↓
Animal Growth / Traits
        ↓
End of Life
        ↓
Exactly 2 Successors
        ↓
Persisted Next Generation
        ↓
Farm Expansion / Progression
        ↓
Optional Score Submission
        ↓
Offline play still works
~~~
