# ADR-0004 — Godot como runtime canônico da V1

**Status:** ACCEPTED  
**Date:** 2026-10-07  
**Spec:** SPEC-004  
**Supersedes:** ADR-0001 para a V1

## Contexto

O projeto iniciou Roblox-first para aproveitar identidade, persistência e multiplayer de plataforma. Na prática, a V1 ainda não precisa provar multiplayer: precisa provar rapidamente o loop de animais, plantas e estrutura da fazenda.

A dependência de Roblox/Open Cloud adicionou gates operacionais antes da validação do produto e dificultou o mesmo tipo de iteração rápida que o projeto consegue obter em Godot.

## Decisão

**Godot 4.x** passa a ser o runtime canônico de produção da V1.

A implementação principal usará **GDScript tipado**, com versão minor da engine e test tooling pinados em task própria a partir da release estável vigente no momento do bootstrap.

A V1 é **single-player e offline-first**.

Online é permitido como uma camada fina e opcional, começando por leaderboard assíncrono.

## Arquitetura

~~~text
Presentation / Scenes / UI
            ↓
Application / Use Cases
            ↓
Domain
├─ Animals
├─ Lifecycle
├─ Genetics / Pedigree
├─ Care / Health
├─ Succession
├─ Crops / Food
├─ Farm
└─ Progression
            ↓ ports
Adapters
├─ Local Save
├─ Clock / RNG
└─ Leaderboard
~~~

O domínio não depende de APIs de cena, storage concreto ou rede.

## Persistência

A V1 usa save local versionado.

Requisitos obrigatórios:

- schema serializável;
- schema_version;
- migrations;
- escrita segura/recuperável;
- timestamps persistentes;
- markers idempotentes para eventos críticos;
- funcionamento integral sem rede.

Semânticas úteis da ADR-0002 para tempo, rollback e idempotência permanecem válidas; detalhes específicos de Roblox DataStore/MemoryStore deixam de governar a V1.

## Online

O leaderboard é um adapter externo.

- gameplay não depende dele;
- cliente não é autoridade do score;
- backend valida submissões;
- falha de rede degrada para modo offline;
- fórmula/identidade/provider exigem spec/ADR próprios antes do release público.

## Roblox

Roblox passa a ser:

- migration source temporária para contratos já implementados;
- possível target futuro de port/distribuição;
- não obrigatório para build, teste, gameplay ou release da V1.

PRs Roblox abertos na data da decisão devem ser revisados contra SPEC-004 antes de qualquer merge.

## Consequências positivas

- iteração local e visual mais rápida;
- menos human/provider gates no caminho crítico;
- core loop validável sem infraestrutura online;
- CI e testes de domínio podem rodar headless;
- arquitetura permanece portável.

## Custos e riscos

- código Luau existente precisa ser portado, não apenas movido;
- save local precisa de schema/migrations próprios;
- leaderboard requer backend mínimo e proteção contra cliente adulterado;
- haverá período transitório com duas lanes no repositório.

## Regras de transição

1. Não deletar a implementação Roblox antes da paridade relevante.
2. Não mergear novas features Roblox para a V1 depois desta ADR, salvo correção necessária para extrair/provar contrato de migração.
3. Toda nova feature de produção escolhe Godot por padrão.
4. Roblox CI deixa de ser release gate assim que a lane Godot tiver gates equivalentes e a paridade necessária estiver concluída.
5. Marketplace player-to-player sai do escopo da V1.
6. Leaderboard não pode reintroduzir dependência online no core.
