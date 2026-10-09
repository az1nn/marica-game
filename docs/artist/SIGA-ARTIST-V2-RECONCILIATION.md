# SIGA — ARTIST V2 / reconciliação e plano de transição

**Data:** 2026-10-09  
**Estado:** APPROVED DIRECTION / PLAN ONLY / NO RUNTIME MUTATION  
**Origem:** `docs/artist/grilling/2026-10-09-v2-direction.md` (G1–G25; aprovação humana explícita)  
**Autoridade:** ORCHESTRATOR/SIGA coordena; ART aprova resultado visual; ARCH integridade técnica; SCENE implementa cenas sob contrato; INSPECTOR/LENTE verifica evidências; REPORTER encerra handoff.

## RECONCILE — estado verificado

- Runtime canônico V1: Godot 4.x, single-player, offline-first; animais → plantas → estrutura da fazenda.
- `docs/VISUAL-DIRECTION.md` no branch de grilling ainda descreve o baseline V1 low-poly; **não** substituir automaticamente.
- Comparação com `master` em 2026-10-09: branch `docs/artist-grilling-v2-20261009` **19 commits à frente e 70 atrás**, com alteração concentrada no documento de grilling antes desta reconciliação. A master evoluiu; não presumir ausência de conflitos sem reconciliar.
- Decisão humana agora autoriza **direção ARTIST V2 G1–G25** (full pixel art 2.5D), não uma implementação cega nem merge automático.
- A constituição exige animal-first, ciclo determinístico, V1 offline, Godot-first; não alterar sistemas ou roadmap de domínio implicitamente.

## CLASSIFY

**RESUME — planejamento e reconciliação documental.** Há uma aprovação de direção a registrar, mas a branch está defasada e ainda não existem evidências visuais/runtime suficientes para implementação aceita. Não declarar PASS de ART/ARCH/LENTE.

## EXECUTE — ondas propostas, com gates

### R0 — Rebase/reconcile documental (obrigatório antes de merge)

1. Reconciliar esta branch com o HEAD de `master` e verificar mudanças concorrentes em specs, roadmap, ledger, CI, skills e arte.
2. Identificar a feature Spec Kit de migração visual e vincular spec → plan → tasks → ADR (se necessário) → evidência; evitar duplicação de workstreams.
3. Atualizar `docs/VISUAL-DIRECTION.md` para distinguir **direção V2 aprovada** de **runtime V1 ainda ativo**, sem afirmar que a migração já ocorreu.
4. Preservar `G1–G25` sem reabrir decisões já tomadas, salvo conflito real com constituição ou runtime.
5. Gate: revisão de diff, ownership e CI; não fazer auto-merge com divergência ou gates desconhecidos.

### R1 — Contrato técnico de renderização (ARCH + ART + SCENE)

1. Selecionar implementação 2.5D Godot (sprites, TileMapLayer/multicamadas, ordem de desenho, pixel-perfect, câmera contextual), documentar restrições e trade-offs.
2. Definir resolução lógica, escala inteira/viewport, snapping, filtros, atlas e política de importação de assets por protótipo, não por suposição.
3. Planejar dia/noite cinematográfico (G18 C) sem efeitos permanentes excessivos; clima/estação por paletas/tiles (G19 A).
4. Gate ARCH: export web/mobile, desempenho, memória, legibilidade e ausência de dependências online no core.

### R2 — Vertical slice visual animal-first (ART + SCENE + LENTE)

1. Criar **um animal representativo** com silhueta fantasia cozy, estados de cuidado e animação por importância (G3, G7, G14).
2. Exibir animal em cena Godot real com UI moderna discreta e responsiva (G11–G13, G23), câmera contextual (G6).
3. Capturar baseline → implementação → comparação A/B; inspecionar regressões e legibilidade em mobile.
4. Gate ART: aprovar sprites, animação e direção; gate LENTE: evidência real e atual; gate ARCH: renderização e performance. REJECT é resultado válido.

### R3 — Plantas (somente após R2 PASS)

1. Sprites por estágio com leitura botânica (G8), animações expressivas para crescimento/colheita (G20).
2. Preservar regras de cultivo já existentes; evidência de evolução e colheita sem sobrecarga visual.

### R4 — Estrutura da fazenda e cidade (somente após R3 PASS)

1. Fazendas densas e orgânicas (G9), overlays de construção contextuais (G21), edifícios modulares (G10/G22).
2. Centro funcional e NPCs híbridos (G15/G16), corte direto entre cenas (G17).
3. Validar clima, estações e dia/noite (G4/G18/G19) nos cenários aprovados.

## VERIFY — gates de aceitação

- **ART:** comparação com G1–G25 e aprovação independente do resultado; low-poly com textura pixelada **não** satisfaz G1/G2.
- **ARCH:** testes Godot headless, export, pixel-perfect, acessibilidade, estabilidade e orçamento de efeitos; não afirmar PASS sem executar.
- **LENTE/INSPECTOR:** captura de runtime recente e verificável, A/B baseline vs proposta, visualização em mobile e evidência sem duplicidade.
- **SIGA:** reconciliação de branch/ownership/CI, contratos de especialistas e nenhum avanço automático com REJECT ou bloqueio.
- **RELATORIO:** produzir handoff curto ao final de cada onda com mudanças, evidências, riscos, estado e próxima ação.

## HANDOFF

- **Decisão ARTIST V2:** APPROVED.
- **Reconciliação com master e Spec Kit:** PENDING.
- **Implementação de cenas/assets:** NOT STARTED.
- **Gates visuais e técnicos:** NOT RUN.
- **Próximo passo executável:** R0 (sincronizar master, inventariar spec/roadmap, reconciliar sem sobrescrever trabalho concorrente).
- **Human gate:** apenas para conflitos materiais, escolhas artísticas ainda não decididas ou rejeição visual após evidência; não solicitar repetição da aprovação G1–G25.
