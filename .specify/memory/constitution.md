# Maricá Game Constitution

**Version:** 2.0.0  
**Ratified:** 2026-09-30  
**Amended:** 2026-10-07  
**Status:** ACTIVE

Esta constituição registra as regras de produto já aprovadas. Specs, implementação, UX e balanceamento não podem contrariá-la silenciosamente.

## I. Animal First

O sistema de animais é o núcleo do jogo e tem prioridade sobre sistemas secundários.

- A primeira vertical slice precisa funcionar apenas com o ciclo do animal.
- Plantas entram imediatamente depois do núcleo animal e devem reforçar cuidado/alimentação.
- Estrutura da fazenda vem depois de animais e plantas e deve ampliar capacidade/progressão.
- Features secundárias ou online não podem bloquear a entrega do ciclo animal.

## II. Ciclo de Vida Curto, Legível e Respeitoso

- Um pet vive aproximadamente **2 a 4 semanas de calendário**.
- O envelhecimento precisa ser perceptível e compreensível pelo jogador.
- O fim da vida deve ser apresentado de forma suave e respeitosa, sem exploração gráfica ou punitivismo gratuito.
- A morte faz parte do loop econômico e genético, mas não deve invalidar todo o investimento do jogador.

## III. Sucessão Fênix e Progresso de Linhagem

Ao fim da vida, o pet gera automaticamente **duas crias/sucessoras**.

Regras obrigatórias:

1. A sucessão não depende de o jogador ter realizado reprodução prévia.
2. A nova geração deve carregar pedigree e origem.
3. A nova geração deve possuir avanço genético garantido em relação à geração encerrada.
4. O sistema deve preservar continuidade emocional e mecânica da linhagem.
5. A sucessão automática não elimina sistemas de sexo ou reprodução; apenas garante continuidade da linhagem.

## IV. Propriedade, Vínculo e Pedigree

- O vínculo/afeição acumulado pertence ao histórico do pet e não deve ser perdido por mudanças futuras de propriedade.
- Founder, breeder, geração, pais/ancestrais e histórico de propriedade podem permanecer registrados como histórico imutável.
- Transferência futura de propriedade não pode resetar progresso genético nem vínculo.

### Exceção fundadora

O primeiro pet herdado da madrinha é **soulbound**:

- nunca pode ser vendido ou trocado;
- seus descendentes podem ser elegíveis para sistemas de transferência futuros;
- a restrição pertence ao pet fundador, não à linhagem inteira.

## V. Cuidado Expressa o Potencial Genético

Genética define potencial; cuidado define quanto desse potencial é efetivamente expresso.

- Bom cuidado deve produzir diferença material e observável.
- Negligência deve degradar estado, desempenho e/ou expressão do potencial.
- Abandono é a punição mais severa do sistema de cuidado.
- Um animal abandonado pode adoecer.
- Sem tratamento, a doença pode levar à morte.
- Doença e tratamento devem produzir custo e perda econômica reais para o jogador.

O jogo não deve recompensar uma estratégia dominante de “comprar genética e ignorar cuidado”.

## VI. Reprodução V1 Simples

Na V1:

- sexo existe como atributo/sistema simples;
- reprodução existe em forma simples;
- consanguinidade deve ser representada de forma simples e legível;
- mutações espontâneas não fazem parte do escopo inicial.

Complexidade genética adicional só entra após o loop básico estar funcional, testado e compreensível.

## VII. Economia V1 Local; Marketplace Pós-V1

A V1 single-player usa economia local e não depende de comércio entre jogadores.

Na V1:

- Coins são moeda de progressão local;
- preços/serviços de NPC podem existir;
- nenhum marketplace player-to-player é requisito de release;
- nenhuma operação econômica online pode bloquear o core.

A visão de marketplace futuro continua compatível com:

- preço definido livremente pelo vendedor;
- ofertas;
- trocas;
- histórico de transações/propriedade;
- continuidade do pedigree após transferência;
- ausência de preço sugerido artificial como âncora obrigatória.

Marketplace player-to-player exige spec/ADR pós-V1 antes de retornar ao roadmap executável.

## VIII. Fonte da Verdade e Mudança Controlada

Hierarquia documental:

1. .specify/memory/constitution.md
2. feature specs em specs/
3. planos e tasks
4. implementação

Qualquer mudança que contradiga esta constituição exige:

1. alteração explícita deste documento;
2. incremento de versão;
3. registro do motivo;
4. atualização das specs afetadas.

## IX. Qualidade da V1

O núcleo animal só é considerado pronto quando o ciclo completo puder ser exercitado de ponta a ponta:

**aquisição → cuidado → evolução → envelhecimento → fim da vida → sucessão → pedigree persistente**

A V1 expandida também deve provar:

**plantar → crescer offline → colher → alimentar → expandir capacidade da fazenda**

As regras determinísticas do domínio devem ser automatizáveis em testes. Balanceamento pode mudar; invariantes constitucionais não.

## X. Godot-First, Single-Player e Offline-First

- **Godot 4.x é o runtime canônico de produção da V1.**
- A implementação principal usa GDScript tipado, salvo ADR posterior explícita.
- A V1 deve ser plenamente jogável sem conexão.
- Animal, plantas, fazenda, inventário, progressão, cidade/serviços e save não podem depender de backend para funcionar.
- Rede é uma camada opcional por adapters.
- Roblox deixa de ser runtime obrigatório da V1 e passa a ser possível target futuro de port/distribuição.
- Nenhum requisito, serviço, CI ou human gate específico de Roblox pode bloquear a V1 Godot.

## XI. Online Fino e Competição Assíncrona

A primeira capacidade online da V1, se entregue, é leaderboard/placar assíncrono.

- Leaderboard não faz parte do core loop.
- Falha ou ausência de rede deve degradar para gameplay offline.
- Cliente não é autoridade de score.
- Submissões públicas devem ser verificadas/validadas no backend.
- Fórmula de score, identidade, privacidade e provider exigem spec/ADR próprias.
- Multiplayer síncrono, visitas online e marketplace entre jogadores ficam fora da V1.

## XII. Portabilidade e Fronteira de Domínio

- Regras de domínio não podem depender diretamente de Node/SceneTree/UI, storage concreto ou serviço de rede.
- Tempo e RNG críticos devem ser explícitos/injetáveis quando necessários à determinismo.
- Save deve possuir schema versionado e migrations.
- Código legado Roblox pode permanecer temporariamente como fonte de contratos/fixtures, mas não governa novas decisões de produção.
- Código Roblox só deve ser removido depois de paridade verificável dos contratos que ainda importam.

## XIII. Ordem Constitucional da V1

A prioridade de entrega é:

1. **Animals**
2. **Plants**
3. **Farm Structure**
4. **Progression**
5. **City / Services**
6. **Online Leaderboard**

Uma fase posterior não pode forçar arquitetura que prejudique uma fase anterior.

---

## Amendment Log

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-09-30 | Constituição inicial baseada nas decisões de produto já aprovadas. |
| 2.0.0 | 2026-10-07 | Godot torna-se runtime canônico; V1 passa a single-player/offline-first; marketplace player-to-player vai para pós-V1; leaderboard online vira camada complementar; ordem Animals → Plants → Farm Structure é formalizada. |
