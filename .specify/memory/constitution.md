# Maricá Game Constitution

**Version:** 1.0.0  
**Ratified:** 2026-09-30  
**Status:** ACTIVE

Esta constituição registra as regras de produto já aprovadas. Specs, implementação, UX e balanceamento não podem contrariá-la silenciosamente.

## I. Animal First

O sistema de animais é o núcleo do jogo e tem prioridade sobre sistemas secundários.

- A primeira vertical slice precisa funcionar apenas com o ciclo do animal.
- Plantas são prioridade posterior ao núcleo animal.
- Features secundárias não podem bloquear a entrega do ciclo animal.

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

- O vínculo/afeição acumulado acompanha o pet quando sua propriedade muda.
- O novo dono pode continuar cuidando e evoluindo aquela linhagem.
- Founder, breeder, geração, pais/ancestrais e histórico de propriedade podem permanecer registrados como histórico imutável.
- Transferência de propriedade não reseta progresso genético nem vínculo.

### Exceção fundadora

O primeiro pet herdado da madrinha é **soulbound**:

- nunca pode ser vendido ou trocado;
- seus descendentes podem ser vendidos ou trocados;
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

## VII. Economia Livre entre Jogadores

O marketplace opera com **moeda interna**.

Deve suportar:

- preço definido livremente pelo vendedor;
- ofertas;
- trocas;
- histórico de transações/propriedade;
- continuidade do pedigree após transferência.

O jogo **não deve impor preço sugerido artificial** como âncora de valor.

## VIII. Fonte da Verdade e Mudança Controlada

Hierarquia documental:

1. `.specify/memory/constitution.md`
2. feature specs em `specs/`
3. planos e tasks
4. implementação

Qualquer mudança que contradiga esta constituição exige:

1. alteração explícita deste documento;
2. incremento de versão;
3. registro do motivo;
4. atualização das specs afetadas.

## IX. Qualidade da V1

A V1 do núcleo animal só é considerada pronta quando o ciclo completo puder ser exercitado de ponta a ponta:

**aquisição → cuidado → evolução → envelhecimento → fim da vida → sucessão → pedigree persistente**

As regras determinísticas do domínio devem ser automatizáveis em testes. Balanceamento pode mudar; invariantes constitucionais não.

---

## Amendment Log

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-09-30 | Constituição inicial baseada nas decisões de produto já aprovadas. |
