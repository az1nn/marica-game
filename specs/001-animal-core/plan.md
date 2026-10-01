# SPEC-001 — Implementation Plan

**Status:** DRAFT  
**Strategy:** vertical slice, domain-first, deterministic simulation

## 1. Delivery Strategy

A implementação deve começar pelo domínio puro antes de UI, arte ou marketplace completo.

Sequência:

1. modelar identidade, lifecycle, genética e cuidado;
2. criar relógio/simulação determinística;
3. provar ciclo completo por testes;
4. expor o loop em UI mínima jogável;
5. adicionar persistência;
6. adicionar propriedade/transferência;
7. adicionar marketplace;
8. adicionar reprodução simples.

## 2. Architecture Boundaries

```text
Presentation
    ↓ commands / queries
Application
    ↓
Animal Domain
├─ lifecycle
├─ genetics
├─ care / health
├─ lineage
└─ ownership rules
    ↓ ports
Persistence / Clock / Economy adapters
```

O domínio não deve depender diretamente de UI, renderer ou serviço externo.

## 3. Determinism

Funções críticas devem aceitar estado + tempo/seed explícitos e devolver resultado verificável:

- cálculo de fase;
- degradação de cuidado;
- progressão de doença;
- morte;
- geração de sucessoras;
- avanço genético;
- validação soulbound.

Isso permite simular semanas em milissegundos nos testes sem esperar tempo real.

## 4. Persistence

Persistir no mínimo:

- identidade e linhagem;
- timestamps;
- estado de cuidado/saúde;
- potencial e expressão;
- afeição;
- lifecycle state;
- ownership history.

Nunca basear idade apenas em contador de frames/sessão.

## 5. Genetic Advancement Contract

A implementação deve definir uma função explícita:

```text
successor_genome = advance(parent_genome, lineage_context, seed)
```

Requisitos:

- avanço mínimo garantido;
- resultado limitado por caps/balanceamento;
- determinismo quando seed for fixada;
- testes de propriedade para impedir regressão abaixo da garantia.

O algoritmo concreto ainda é decisão técnica.

## 6. Time & Failure Model

Casos obrigatórios de teste:

- jogador fecha o jogo e volta horas/dias depois;
- múltiplas transições de fase entre sessões;
- pet cruza limite de doença offline;
- pet cruza limite de fim de vida offline;
- sucessão não duplica ao recarregar;
- relógio retrocede;
- comando de transferência chega duas vezes.

## 7. Vertical Slice Gate

Antes de marketplace, a build deve demonstrar:

```text
Founder
  ↓
Care / Neglect
  ↓
Trait expression + Health
  ↓
Aging
  ↓
End of life
  ↓
2 successors
  ↓
Next generation playable
```

## 8. Testing Gates

Mínimo recomendado:

- unit tests de invariantes de domínio;
- property tests para genética/sucessão quando suportado;
- persistence round-trip;
- simulation test de 4 semanas aceleradas;
- test de idempotência para encerramento/sucessão;
- integration test de ownership restriction.

## 9. Technical Decisions Not Yet Frozen

O repositório não deve assumir silenciosamente:

- Godot, web ou outro runtime;
- backend obrigatório;
- blockchain/NFT;
- multiplayer síncrono;
- algoritmo genético específico.

Essas escolhas devem virar ADR/spec antes de criarem lock-in.
