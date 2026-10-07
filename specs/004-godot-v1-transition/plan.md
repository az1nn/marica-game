# SPEC-004 — Implementation Plan

**Status:** READY  
**Strategy:** Godot-first, offline-first, strangler migration, contract parity before deletion

## 1. Transition model

A migração será incremental.

~~~text
Legacy Roblox/Luau ── contracts + fixtures ──┐
                                            │
                                            ▼
                                      Godot Domain
                                            │
                       ┌────────────────────┼───────────────────┐
                       ▼                    ▼                   ▼
                 Local Save          Godot Scenes      Leaderboard Port
                       │                                    │
                       └──────── core works offline ────────┘
~~~

Nenhuma parte do Roblox será tratada como nova fonte de verdade depois da ratificação da ADR-0004. Código antigo permanece apenas enquanto ajuda a provar paridade.

## 2. Target repository layout

A migração começa sem destruir a árvore Luau existente:

~~~text
game/
├─ project.godot
├─ src/
│  ├─ domain/
│  ├─ application/
│  ├─ adapters/
│  │  ├─ local/
│  │  └─ online/
│  └─ presentation/
├─ scenes/
├─ assets/
└─ tests/

src/                  # legacy Roblox/Luau until parity
tests/                # legacy Roblox tests until parity
tools/roblox/         # legacy/reference until decommission gate
~~~

Depois da paridade, uma task explícita decide se a lane Roblox será movida para legacy/roblox/ ou mantida apenas no histórico Git.

## 3. Runtime baseline

- Engine: Godot 4.x estável, minor exata pinada no bootstrap técnico.
- Gameplay/runtime language: GDScript tipado.
- Runtime principal: single-player.
- Core save: local e versionado.
- Online: adapter HTTP opcional, restrito inicialmente ao leaderboard.
- Build/test: headless CI em SHA exato.

A versão minor de Godot e o test runner devem ser escolhidos e pinados em PR próprio usando documentação/release vigente no momento da implementação.

## 4. Domain boundary

~~~text
Presentation
  scenes / UI / camera / VFX
          ↓ commands + queries
Application
  use cases / orchestration
          ↓
Domain
  Pet / Lifecycle / Genetics / Care / Health
  Pedigree / Succession / Crops / Farm / Progression
          ↓ ports
Adapters
  LocalClock / SaveStore / RNG / Leaderboard
~~~

O domínio não conhece Node, SceneTree, Control, HTTPRequest, filesystem concreto, backend provider ou Roblox APIs.

## 5. Port strategy

### 5.1 Golden-contract migration

Cada bloco já implementado em Luau deve gerar ou inspirar fixtures determinísticas com:

- input;
- explicit time/seed;
- expected state/result;
- invariant name.

Godot deve reproduzir o contrato, não a estrutura interna do código Luau.

### 5.2 Port order

1. Pet / IDs;
2. lineage / pedigree;
3. lifecycle;
4. simulation time;
5. genetic potential / trait expression;
6. care;
7. health/disease/treatment;
8. soulbound;
9. affection;
10. guaranteed genetic advancement;
11. successor generation;
12. exactly-two + idempotency;
13. full accelerated lifecycle.

## 6. Persistence

V1 usa save local com schema versionado.

Requisitos:

- documento serializável independente de Node;
- schema_version;
- atomic write/replace quando suportado;
- backup/recovery simples;
- migration functions por versão;
- timestamps persistentes;
- idempotency markers para end-of-life/succession;
- farm + animals + crops + inventory + progression persistidos com consistência.

O relógio do dispositivo não é segurança forte. Para single-player, rollback deve ser tratado como integridade de save/gameplay, não como anti-cheat absoluto. O leaderboard deve assumir que dados locais podem ser manipulados e validar score no backend.

## 7. Scene strategy

Primeira apresentação jogável:

- uma fazenda compacta;
- câmera isométrica/elevada com zoom;
- pet fundador;
- HUD mínimo de cuidado/saúde/fase;
- interações simples;
- área de plantio;
- estruturas de capacidade;
- acesso simples à cidade/serviços depois do core farm loop.

ARTIST define intenção visual; CENA materializa; GODOT integra runtime; LENTE/GAUNTLET validam quando aplicável.

## 8. Plants and farm

Plantas são suporte ao animal, não um jogo paralelo.

Primeiro corte:

- 3 crops;
- 1 fruit tree;
- planted_at + growth_duration;
- harvest;
- alimento/inventário;
- qualidade simples;
- offline progression;
- estrutura que expande active slots/reserve.

## 9. Progression

V1 local:

- Coins;
- reputação/nível;
- desbloqueio de estruturas/capacidade;
- veterinário;
- mercado/NPC de sementes/alimentos;
- cidade mínima.

Marketplace entre jogadores sai da V1. “Mercado” na V1 significa serviço/NPC local.

## 10. Online leaderboard

~~~text
Game
  ↓ ScoreCandidate
LeaderboardPort
  ├─ OfflineNullAdapter
  └─ HttpLeaderboardAdapter
            ↓
        Backend
        ├─ identity/token
        ├─ validation
        ├─ rate limits
        ├─ score record
        └─ ranking query
~~~

Antes de implementação pública, criar spec própria para:

- fórmula de score;
- temporada ou ranking permanente;
- identidade;
- validação server-side;
- replay/proof payload mínimo;
- rate limiting;
- privacidade/nome público;
- recuperação quando offline.

## 11. CI migration

Durante a transição:

1. Validate skills continua obrigatório.
2. Roblox CI continua apenas enquanto arquivos Luau são fonte de fixtures/paridade.
3. Novo Godot CI vira gate de produção assim que o bootstrap estiver presente.
4. Depois da paridade e arquivamento, Roblox CI deixa de ser release gate e pode ser removido/transformado em legacy check.

Godot CI deve evoluir para:

- engine/version print;
- import headless;
- parse/load project;
- deterministic tests;
- save round-trip tests;
- accelerated lifecycle tests;
- export smoke para o target escolhido.

## 12. Risk controls

### Semantic drift
Mitigação: golden fixtures + port por bloco + GAUNTLET para invariantes P0.

### Big-bang rewrite
Mitigação: lane nova em game/, código Roblox preservado até paridade.

### Online scope creep
Mitigação: LeaderboardPort; core não pode importar adapter online.

### Save corruption
Mitigação: schema versionado, atomic write, backup e migration tests.

### Engine lock-in
Mitigação: domínio sem Nodes/SceneTree e dados serializáveis.

### Old PR collision
Mitigação: congelar/fechar PRs Roblox incompatíveis e registrar quais contratos serão reaproveitados.

## 13. Delivery policy

Cada fase termina com:

- exact-head automated gates;
- handoff atualizado;
- nenhum conflito com constituição;
- uma única próxima ação autoritativa.

Não iniciar leaderboard antes de o core offline animal + plantas + estrutura mínima da fazenda estar funcional.
