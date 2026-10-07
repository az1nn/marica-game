# ADR-0001 — Roblox como runtime inicial de produção

**Status:** SUPERSEDED FOR V1  
**Date:** 2026-09-30  
**Task:** SPEC-001 / T005  
**Supersedes:** nenhuma  
**Superseded by:** ADR-0004 — Godot como runtime canônico da V1

## Contexto

A SPEC-001 exige uma vertical slice online do ciclo animal com identidade de jogador, persistência, autoridade de domínio e evolução temporal. O plano já congelou a direção de produto **Roblox-first**, mas a decisão ainda precisava de um registro arquitetural formal antes de iniciar estrutura irreversível de runtime.

Também existe uma exigência de portabilidade: regras de ciclo de vida, genética, cuidado, saúde, pedigree, ownership e economia não podem depender de objetos de cena, UI ou serviços específicos de uma engine.

## Decisão

A primeira implementação de produção do Maricá Game será feita em **Roblox**, usando **Luau** e **Roblox Studio** para runtime/apresentação.

Esta decisão foi válida até 2026-10-07. ADR-0004 substitui Roblox por Godot como runtime canônico da V1; o restante deste documento fica como registro histórico e fonte de contratos de migração.

### Fronteira obrigatória

A arquitetura deve manter o domínio independente do runtime:

```text
Presentation / Camera / UI / VFX
              ↓ commands / queries
Application / Use Cases
              ↓
Domain
├─ Pet / Lifecycle
├─ Genetics / Pedigree
├─ Care / Health
├─ Crops / Food
├─ Inventory
├─ Ownership
└─ Economy / Marketplace
              ↓ ports
Roblox Adapters
├─ persistence
├─ clock
├─ players / identity
├─ remotes
└─ presentation
```

O domínio não pode depender diretamente de `Instance`, `Players`, `DataStoreService`, `MarketplaceService`, GUI ou renderer.

### Autoridade

O servidor é autoridade para:

- IDs e ownership;
- pedigree, genética e reprodução;
- lifecycle, saúde e doença;
- inventário e Coins;
- listings, ofertas e trocas;
- progressão persistente;
- toda operação que crie, transfira ou destrua valor.

O cliente envia intenção e renderiza estado. Ele não calcula resultados econômicos ou invariantes de domínio como fonte de verdade.

## Workflow de engenharia ratificado

### Source control

- Git/GitHub é a fonte de verdade de código e documentação.
- Mudanças de feature usam branch + PR + gates de CI.
- Roblox Studio não substitui o repositório como fonte autoritativa de scripts.

### Sync/build

- **Rojo** é o mecanismo padrão para sincronizar o filesystem com Roblox Studio e para gerar artefatos/place files reproduzíveis.
- O projeto Rojo deve ficar versionado no repositório.
- A major/toolchain usada pelo projeto deve ser pinada no bootstrap técnico; upgrades exigem PR e gate verde.

### Testes

- Regras determinísticas de domínio devem ser exercitáveis com estado, tempo e seed explícitos.
- **Jest Roblox** é o baseline para testes Luau/Roblox da primeira implementação.
- Testes de domínio devem evitar dependência de serviços Roblox quando possível.
- Integrações específicas do runtime recebem testes/smokes separados.
- Green de um SHA anterior não valida um novo HEAD.

### Dependências

- A V1 começa com o menor número possível de dependências externas.
- Caso pacotes externos sejam necessários, o gerenciador e lockfile devem ser versionados no repositório antes de sua adoção.
- Nenhuma dependência pode introduzir regra de produto fora da SPEC/constituição.

## Alternativas consideradas

### Godot como runtime inicial

Mantido como lane de portabilidade/referência, mas rejeitado como runtime inicial porque exigiria assumir mais infraestrutura própria para identidade, persistência e multiplayer antes de provar o loop principal.

### Three.js como runtime inicial

Mantido apenas como referência/prototipação visual quando útil. Não é o runtime de produção da V1.

### Studio-only sem source sync

Rejeitado porque enfraquece diff, revisão, automação, testes reproduzíveis e rastreabilidade do código.

## Consequências

### Positivas

- menor caminho até uma vertical slice online;
- identidade/multiplayer e serviços de plataforma disponíveis;
- workflow compatível com Git e CI;
- regras centrais continuam portáveis para Godot ou outro runtime.

### Custos e riscos

- adapters de persistência/clock/remotes precisam tratar semântica específica do Roblox;
- limites e comportamento de serviços de plataforma tornam T006 obrigatório antes do domínio persistente;
- apresentação e runtime não podem vazar decisões para o domínio.

## Invariantes derivados

1. Roblox é runtime de produção; GODOT e 3JS não assumem ownership de produção sem nova ADR.
2. Regra de domínio crítica não pode depender de frame time ou estado de GUI.
3. Operações econômicas e de ownership são server-authoritative.
4. Persistência e relógio entram por ports/adapters.
5. Código versionado no filesystem/Git é a fonte de verdade técnica.
6. Rojo é o workflow padrão de sync/build da V1.
7. Testes determinísticos pertencem ao contrato de implementação, não a validação manual opcional.

## Correção de toolchain — T007

Durante o bootstrap reproduzível foi verificado que o repositório oficial **Roblox/testez** está arquivado desde 2024. O baseline de testes foi portanto corrigido para **Jest Roblox**, que permanece documentado e usado pelo ecossistema Roblox.

Pacotes Wally pinados para a V1:

```toml
[dev-dependencies]
Jest = "roblox/jest@=3.20.0"
JestGlobals = "roblox/jest-globals@=3.20.0"
```

Essa correção não altera o contrato de produto nem a arquitetura engine-neutral; apenas substitui uma dependência de testes arquivada antes do início da implementação de domínio.

## Próxima decisão

**T006 — ADR de persistência e autoridade de tempo.**

Ela deve fechar, no mínimo:

- modelo de save;
- autoridade do relógio;
- comportamento offline;
- clock rollback;
- idempotência de sucessão;
- estratégia de escrita para operações econômicas.
