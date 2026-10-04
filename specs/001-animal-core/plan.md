# SPEC-001 — Implementation Plan

**Status:** READY  
**Strategy:** vertical slice, domain-first, deterministic simulation, Roblox-first with engine-neutral domain

## 1. Product Decisions Frozen by Grilling Session

O Maricá Game é um cozy animal/farming simulator sobre cuidado, continuidade e herança.

Prioridade de produto:

1. **animais e vínculo**;
2. **plantas/alimentos** como suporte direto ao cuidado;
3. **estrutura e expansão da fazenda** como consequência do progresso.

Fantasia inicial:

- o jogador herda uma fazendinha simples da madrinha falecida;
- a propriedade funciona como memória/santuário discreto, sem transformar o jogo em uma narrativa constante de luto;
- o primeiro pet pertencia à madrinha;
- esse fundador pode ser personalizado pelo jogador para criar uma memória própria;
- o fundador é **soulbound** e nunca pode ser vendido/trocado;
- seus descendentes podem entrar normalmente na economia.

Objetivo de sessão curta:

```text
colher → alimentar → interagir → checar saúde → plantar → sair
```

Uma sessão de aproximadamente **3–8 minutos** deve entregar progresso perceptível e relaxante. Atividade direta sempre deve superar AFK; ausência normal não pode virar punição catastrófica.

## 2. Runtime & Portability Decision

### Runtime inicial

A primeira implementação será **Roblox**.

Motivos de produto/entrega:

- multiplayer e identidade de jogador já disponíveis;
- persistência e serviços de plataforma disponíveis;
- menor custo para provar a vertical slice online;
- distribuição/social integrados;
- prazo de protótipo menor que operar backend/multiplayer próprio desde a primeira semana.

A ADR formal ainda deve ser registrada pela T005, mas a direção de produto está congelada: **Roblox-first**.

### Portabilidade para Godot

O domínio não deve depender de Roblox Instances, UI, renderer ou MarketplaceService.

```text
Game Domain
├─ Pet
├─ Genetics
├─ Lifecycle
├─ Care / Health
├─ Crops / Food
├─ Inventory
├─ Economy
├─ Ownership
└─ Marketplace
        ↓ ports/adapters
Roblox Runtime
├─ DataStore
├─ RemoteEvents
├─ Players
└─ presentation
```

Assets devem preferir fontes reutilizáveis fora do Studio, especialmente Blender + glTF/GLB/texturas.

Uma futura migração para Godot deve exigir novos adapters/presentation/networking, não redefinição das regras centrais.

## 3. Architecture Boundaries

```text
Presentation / Camera / UI / VFX
              ↓ commands / queries
Application / Use Cases
              ↓
Domain
├─ animal lifecycle
├─ Mendelian genetics
├─ care / health
├─ lineage / pedigree
├─ crops / food quality
├─ inventory
├─ ownership
└─ marketplace rules
              ↓ ports
Persistence / Clock / Economy / Platform adapters
```

### Server authority

No Roblox, o servidor é autoridade absoluta para:

- pet ownership;
- IDs e pedigree;
- genética e breeding;
- lifecycle, saúde e doença;
- inventário e Coins;
- listings, ofertas e trocas;
- progressão persistente.

O cliente solicita ações e apresenta resultados; nunca decide resultados econômicos ou de ownership.

## 4. Animal Lifecycle Contract

Ciclo alvo: aproximadamente **2–4 semanas de calendário**, configurável.

Fases e fim de vida devem ser suaves e respeitosos.

Ao encerrar a vida, o animal gera automaticamente **exatamente duas sucessoras**, independentemente de reprodução anterior — mecanismo de continuidade “tipo fênix”.

Requisitos:

- sucessão idempotente;
- geração seguinte preserva pedigree;
- avanço genético mínimo é **garantido**;
- sucessão nunca depende de breeding;
- o fundador soulbound permanece histórico da linhagem;
- morte antecipada por abandono não apaga a linhagem, mas deve produzir custo/perda e impedir que negligência seja estratégia neutra.

Pets começam com aproximadamente **4 slots ativos**, expansíveis pela progressão da fazenda.

Sucessoras sem slot disponível entram em Nursery/Legacy Reserve. Reservas podem ser emprestadas ao sistema/NPC e gerar XP reduzido.

Filhotes possuem fase curta obrigatória antes de se tornarem elegíveis para venda/troca.

## 5. Genetics & Affection

A genética V1 será científica, porém simplificada:

- loci com alelos;
- dominância/recessividade legível;
- potencial genético separado de expressão;
- sexo/reprodução simples;
- consanguinidade simples e compreensível;
- mutações espontâneas fora da V1.

Contrato de avanço:

```text
successor_genome = advance(parent_genome, lineage_context, seed)
```

Requisitos:

- avanço mínimo garantido;
- caps/balanceamento;
- determinismo com seed fixa;
- testes impedindo regressão abaixo da garantia.

### T020 — avanço genético garantido

ADR-0003 congela a regra V1 sobre o `GeneticPotential` normalizado:

- passo nominal: **0.05**;
- ordenar nomes de traits antes de qualquer seleção;
- `seed mod N` escolhe o primeiro trait candidato;
- exatamente um trait com capacidade restante recebe `min(0.05, 1 - valor)`;
- traits saturados são pulados ciclicamente;
- nenhum trait pode regredir;
- igualdade só é permitida quando todo o potencial já está saturado em `1`;
- T021 deve derivar seeds de sucessoras sem redefinir esta regra.

### T021 — geração determinística de sucessoras

A composição V1 usa um primitive de uma sucessora por chamada:

```text
Succession.createSuccessor(parent, successorId, successionSeed, successorOrdinal)
```

Contrato:

- o parent precisa estar com lifecycle encerrado;
- o ID da sucessora é explícito e validado pelo domínio de Pet;
- `deriveGeneticSeed(seed, ordinal) = seed + ordinal - 1`, mantendo repetibilidade e direções distintas por ordinal;
- o potencial genético usa exclusivamente `Genetics.advancePotential` de T020;
- a sucessora nasce em lifecycle juvenil/ativo, cuidado e saúde default, afeição 0 e não herda `soulbound` do fundador;
- a linhagem avança uma geração e registra o parent encerrado como pai direto;
- T022 é responsável por orquestrar **exatamente duas** sucessoras;
- T023 é responsável por idempotência do encerramento/sucessão.

Afeição/vínculo é parte central do valor do pet.

Separar:

```text
genetic affinity potential
        +
life care / interaction history
        =
expressed bond
```

Ao vender/trocar um pet, o vínculo/afeição persistido acompanha o animal junto com a propriedade. Founder, breeder e pedigree permanecem como histórico.

Qualquer novo dono pode continuar evoluindo a linhagem.

## 6. Care, Health & Neglect

Cuidado diário deve permanecer simples e legível.

Estados principais:

- fome;
- higiene;
- afeto;
- energia;
- saúde.

Fluxo de negligência:

```text
healthy → neglected → sick → critical → early end of life
```

Regras:

- cuidado modifica fortemente a expressão do potencial genético;
- abandono é a punição mais severa do jogo;
- animal doente exige tratamento e gera custo;
- doença ignorada pode causar morte;
- ausência normal por horas/uma noite não equivale a abandono;
- automação futura pode reduzir tarefas, mas **nunca substituir afeto/interação**.

Veterinário existe como NPC/local físico no centro da cidade.

## 7. Crops, Food & Farming

Plantio é parte do loop principal, não um minigame separado.

V1 deve provar:

- plantio;
- crescimento por timestamps persistentes;
- colheita;
- alimentos por espécie;
- opção genérica/emergencial quando necessário;
- qualidade de alimento simples;
- alimentação impactando cuidado/expressão do animal;
- plantas podendo secar/morrer por negligência, com punição muito mais leve que a de animais.

Não usar loops/timers independentes por planta quando o estado puder ser derivado de tempo persistido.

Exemplo:

```text
growth = (server_now - planted_at) / growth_duration
```

A produção vegetal alimenta diretamente animais e economia.

## 8. Economy & Marketplace

A V1 utiliza **uma moeda interna (Coins)**.

Marketplace inicial:

- descendentes elegíveis podem ser listados;
- preço definido livremente pelo vendedor;
- nenhuma raridade/preço sugerido artificial;
- ofertas;
- trocas;
- histórico auditável de transferências;
- soulbound nunca entra no mercado.

O valor emergente do pet deve vir de:

- linhagem;
- genótipo/fenótipo;
- geração;
- histórico de cuidado;
- vínculo;
- pedigree;
- preferências reais dos jogadores.

Robux/payment rails ficam fora do núcleo inicial e só entram em spec/ADR próprio após a economia interna estar estável.

## 9. World, Art & UX

Direção visual congelada para prototipagem:

- personagens próprios e estilizados;
- **low-poly fofo + texturas pixeladas / pixel art 3D**;
- fazenda compacta e densa;
- referências leves a Maricá/Brasil/litoral/vegetação/frutas, sem obrigação de representação literal;
- câmera **isométrica/elevada com zoom**, a validar pelo protótipo;
- possibilidade de aproximar para interação íntima com pets.

V1 não prioriza customização pesada de casa.

Mundo inicial inclui:

- fazenda persistente do jogador;
- centro da cidade;
- veterinário;
- mercado;
- sementes/alimentos;
- lago e pesca simples.

Clima/estações começam leves/visuais.

Jogadores podem visitar propriedades; ações que alterem pets/plantações de terceiros exigem permissão.

Notificações externas/offline somente com opt-in explícito do usuário.

Áudio/trilha pode ser adicionado depois do núcleo funcional.

## 10. Progression & AFK

Progressão:

- reputação/nível libera capacidades;
- Coins constroem/expandem;
- aproximadamente 4 slots de animais ativos no início;
- estrutura da fazenda aumenta capacidade ao longo do jogo.

AFK/offline:

- plantas continuam crescendo por tempo persistido;
- vínculo relevante não é obtido sem interação;
- pets em reserva/empréstimo recebem XP reduzido;
- ausência normal não deve gerar punição catastrófica;
- retorno ativo deve ser claramente mais valioso que permanecer AFK.

## 11. Determinism

Funções críticas devem aceitar estado + tempo/seed explícitos e devolver resultado verificável:

- cálculo de fase;
- degradação de cuidado;
- progressão de doença;
- fim de vida;
- geração de duas sucessoras;
- avanço genético;
- Mendelian inheritance;
- validação soulbound;
- crescimento de crops;
- transferências/marketplace.

Isso permite simular semanas em milissegundos nos testes.

## 12. Persistence

Persistir no mínimo:

### Pet

- ID imutável;
- lineage/pedigree;
- founder/breeder/current owner;
- timestamps;
- genótipo/potencial;
- traits expressos;
- cuidado/saúde;
- afeição/vínculo;
- lifecycle state;
- ownership history.

### Farm

- Coins/inventário;
- crops e timestamps;
- estruturas/capacidade;
- active slots e reserve;
- progressão/reputação.

Nunca basear idade ou crescimento apenas em frames/tempo da sessão.

## 13. Time & Failure Model

Casos obrigatórios:

- jogador fecha e retorna horas/dias depois;
- múltiplas transições de fase entre sessões;
- crop amadurece offline;
- animal cruza limite de doença offline;
- animal cruza fim de vida offline;
- sucessão não duplica ao recarregar;
- relógio retrocede;
- transferência/listing chega duas vezes;
- comprador/vendedor desconecta durante operação;
- soulbound é rejeitado pelo domínio independentemente da UI.

## 14. Extended Vertical Slice Gate

Antes de expansão de conteúdo, a build deve provar:

```text
Inherited farm + Founder
          ↓
Care / Feed / Daily interaction
          ↓
Crop → Harvest → Food
          ↓
Trait expression + Health
          ↓
Aging
          ↓
Respectful end of life
          ↓
2 automatic successors
          ↓
Next generation playable
          ↓
Eligible descendant can be transferred/listed
```

Primeiro conteúdo alvo:

- 1 fazenda compacta;
- 1 centro simples;
- pet fundador;
- +2 espécies;
- 3 cultivos;
- 1 árvore frutífera;
- cuidado diário;
- doença/tratamento;
- genética/pedigree;
- sucessão automática;
- save persistente;
- Coins;
- marketplace mínimo;
- pesca simples.

## 15. Testing Gates

Mínimo:

- unit tests de invariantes;
- property tests para genética/sucessão quando suportado;
- persistence round-trip;
- simulação acelerada de 4 semanas;
- idempotência de encerramento/sucessão;
- integration test de soulbound/ownership;
- server-authority tests para operações econômicas;
- crop offline progression;
- save/load de farm + pets;
- multiplayer mínimo com servidor + clientes antes do release gate.

## 16. Delivery Order

Ordem obrigatória:

1. Pet + identidade + lifecycle;
2. cuidado + saúde + doença;
3. genética + pedigree + legado;
4. crops + alimentos;
5. persistência;
6. Coins/economia;
7. ownership/marketplace;
8. centro/social;
9. arte/polimento e expansão de conteúdo.

Marketplace e conteúdo secundário não devem atrasar a prova do ciclo animal.

## 17. Decisions Deferred to ADR / Future Specs

Ainda precisam de decisão formal ou spec própria:

- detalhes da stack/tooling Roblox (Studio sync/Rojo/etc.);
- formato exato de persistência e autoridade de relógio;
- schema final Mendeliano;
- fee/limites finais de marketplace;
- empréstimo player-to-player;
- monetização/Robux;
- mutações espontâneas;
- automação avançada;
- música/trilha;
- eventual estratégia de migração operacional para Godot.

Esses itens não podem invalidar os contratos de domínio congelados acima.
