# SPEC-001 — Animal Core

**Status:** PRODUCT CONTRACT / DELIVERY MOVED TO SPEC-004  
**Priority:** P0  
**Constitution:** v2.0.0

> Runtime/delivery amendment (2026-10-07): SPEC-004 + ADR-0004 govern implementation. Any Roblox-first, multiplayer-first or player-marketplace V1 language below is superseded by Constitution v2.0.0.

## 1. Problem

O Maricá Game precisa de um núcleo jogável em que um animal tenha identidade, potencial genético, necessidades de cuidado, envelhecimento, fim de vida e continuidade de linhagem. O jogador não deve perder todo o progresso quando um ciclo termina.

## 2. Goal

Entregar uma vertical slice que prove o loop principal:

**receber pet → cuidar → observar evolução → chegar ao fim da vida → receber duas sucessoras → continuar a linhagem**

Reprodução simples permanece extensão do núcleo. Marketplace player-to-player foi movido para pós-V1 pela Constituição v2.0.0 e não é pré-requisito de release.

## 3. User Stories

### US-001 — Receber o pet fundador — P1

Como jogador, quero receber meu primeiro pet para iniciar uma linhagem.

**Acceptance criteria**

- O primeiro pet pode ser identificado como fundador.
- O pet fundador herdado da madrinha possui flag soulbound.
- O sistema bloqueia venda e troca desse pet específico.
- O pedigree começa na geração inicial.

### US-002 — Cuidar do animal — P1

Como jogador, quero alimentar/cuidar/tratar meu pet para influenciar sua saúde e desenvolvimento.

**Acceptance criteria**

- O pet possui estado de cuidado mensurável.
- A qualidade do cuidado altera a expressão do potencial genético.
- Negligência prolongada pode gerar doença.
- Doença não tratada pode gerar morte e custo/perda.

### US-003 — Evoluir ao longo do tempo — P1

Como jogador, quero perceber fases da vida e mudanças no animal.

**Acceptance criteria**

- O ciclo total alvo é configurável dentro de aproximadamente 2–4 semanas.
- O sistema deriva idade/fase a partir do tempo persistido.
- Reiniciar o cliente não reinicia idade.
- Mudanças de fase são legíveis para o jogador.

### US-004 — Encerrar a vida com continuidade — P1

Como jogador, quero que o fim da vida preserve a história da linhagem e abra a próxima geração.

**Acceptance criteria**

- O fim da vida é tratado sem apresentação gráfica agressiva.
- Um pet encerrado não volta ao estado ativo.
- Duas sucessoras são criadas automaticamente.
- Ambas registram ancestralidade.
- A nova geração possui avanço genético garantido segundo uma regra determinística/testável.
- O jogador consegue continuar jogando com a nova geração.

### US-005 — Preservar vínculo e propriedade — POST-V1 TRANSFER CONTRACT

Como proprietário, quero que um pet mantenha sua história quando mudar de dono.

**Acceptance criteria**

- Transferência altera o owner atual.
- Afeição/vínculo não é zerado na transferência.
- Founder/breeder/pedigree continuam disponíveis como histórico.
- Descendentes do fundador soulbound podem ser transferíveis.

### US-006 — Negociar descendentes — POST-V1

Como jogador, quero vender, receber ofertas ou trocar pets elegíveis por moeda interna ou outros pets.

**Acceptance criteria**

- Vendedor define livremente o preço.
- Não existe preço sugerido obrigatório/artificial.
- O sistema suporta oferta e troca.
- Transação finalizada entra no histórico.
- Soulbound não pode ser listado, ofertado ou trocado.

## 4. Functional Requirements

### Identity & lineage

- **FR-001** Cada pet deve possuir ID imutável.
- **FR-002** Cada pet deve possuir geração e referência de linhagem.
- **FR-003** Relações parentais/ancestrais relevantes devem persistir.
- **FR-004** O sistema deve preservar founder/breeder como metadados históricos.
- **FR-005** O owner atual deve ser separado do histórico de origem.

### Lifecycle

- **FR-006** Nascimento/início de vida deve possuir timestamp persistente.
- **FR-007** A vida alvo deve ser configurável na faixa de design de 2–4 semanas.
- **FR-008** Fases devem ser derivadas de regras determinísticas.
- **FR-009** O estado final deve impedir ações incompatíveis com pet ativo.

### Genetics

- **FR-010** O domínio deve separar potencial genético de expressão atual.
- **FR-011** Cuidado deve modificar expressão sem reescrever silenciosamente o pedigree.
- **FR-012** Sucessores automáticos devem satisfazer uma regra de avanço genético garantido.
- **FR-013** A regra de avanço deve possuir limite/balanceamento para impedir crescimento infinito não controlado.
- **FR-014** Mutações espontâneas ficam desabilitadas na V1.

### Care & health

- **FR-015** O domínio deve representar cuidado/necessidades essenciais.
- **FR-016** Negligência acumulada deve poder causar doença.
- **FR-017** Tratamento deve consumir recurso/custo.
- **FR-018** Doença não tratada deve poder causar morte.
- **FR-019** Estado de saúde precisa ser persistente.

### Ownership & economy

- **FR-020** Soulbound deve ser uma restrição de domínio, não apenas de UI.
- **FR-021** Transferência não deve apagar afeição nem pedigree.
- **FR-022 [POST-V1]** Marketplace futuro deve utilizar moeda interna.
- **FR-023 [POST-V1]** Preço futuro é informado pelo vendedor sem preço sugerido obrigatório.
- **FR-024 [POST-V1]** Ofertas, trocas e transações futuras devem produzir histórico auditável.

### Reproduction

- **FR-025** Sexo deve existir em modelo simples na V1.
- **FR-026** Reprodução deve existir em modelo simples.
- **FR-027** Consanguinidade deve possuir uma regra simples e legível.
- **FR-028** Sucessão automática no fim da vida funciona independentemente de reprodução prévia.

## 5. Core Domain Draft

```text
Pet
├─ id
├─ lineage_id
├─ generation
├─ founder_id
├─ breeder_id
├─ owner_id
├─ sex
├─ soulbound
├─ born_at
├─ life_stage
├─ lifecycle_state
├─ genetic_potential
├─ expressed_traits
├─ care_state
├─ health_state
├─ affection
└─ pedigree references

OwnershipEvent
├─ pet_id
├─ from_owner
├─ to_owner
├─ type
└─ timestamp

MarketplaceEvent
├─ pet_id
├─ type
├─ currency/value or trade reference
├─ parties
└─ timestamp
```

Campos exatos e storage são responsabilidade do plano de implementação.

## 6. Invariants

1. Pet soulbound nunca muda de owner por venda/troca.
2. Transferência válida nunca apaga pedigree.
3. Transferência válida nunca zera afeição.
4. Pet encerrado não retorna à vida ativa.
5. Encerramento natural dispara exatamente duas sucessoras.
6. Sucessoras pertencem à geração seguinte.
7. Sucessão sempre satisfaz a regra de avanço genético definida.
8. Reprodução não é requisito para sucessão automática.

## 7. Non-goals V1

- Mutações espontâneas.
- Genética biologicamente completa.
- Mercado com preço recomendado pelo sistema.
- Reprodução altamente simulada.
- Sistemas secundários que atrasem a prova do ciclo animal.
- Multiplayer síncrono e marketplace player-to-player.
- Dependência de backend para o core single-player.
- Conteúdo de plantas antes da estabilização do núcleo animal.

## 8. Open Technical Decisions

Estas decisões não alteram o contrato de produto e devem ser fechadas no plano técnico:

- runtime/tooling Godot minor/test runner, sob SPEC-004;
- formato final do schema de save local;
- autoridade do relógio e proteção contra clock manipulation;
- representação numérica da genética;
- algoritmo exato de avanço garantido;
- granularidade das fases de vida;
- fórmula, identidade e provider do leaderboard assíncrono.

## 9. Definition of Done

SPEC-001 está implementada quando uma execução automatizada e uma sessão manual conseguem provar:

1. criação do fundador;
2. cuidado alterando expressão;
3. negligência → doença → tratamento ou morte;
4. avanço temporal persistente;
5. encerramento de vida;
6. criação exata de duas sucessoras;
7. pedigree preservado;
8. avanço genético verificado;
9. restrição soulbound aplicada no domínio.
