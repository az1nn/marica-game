# SPEC-009 — Matriz obrigatória de homologação web (4 células)

**Status:** APPROVED INTENT / GOVERNANCE BOOTSTRAP
**Priority:** P1 — QA / release gating
**Owner:** SIGA → QA (execução), ARCH (integridade técnica), tester humano (resultado físico)
**Decision:** 2026-10-18, aprovação explícita do usuário
**Constitutional baseline:** v2.0.0 → amendment v2.1.0 proposed under Q901

## 1. Objetivo

Toda funcionalidade interativa da build **web** do Maricá Game deve ser avaliada com a mesma matriz fixa **plataforma × navegador**. Não é um quarto tipo de runtime: são **quatro execuções independentes** do mesmo contrato de aceitação.

| ID estável | Plataforma | Navegador | Execução mínima |
| --- | --- | --- | --- |
| **WD-CH** | Web Desktop | Chrome | Navegador desktop real |
| **WD-FF** | Web Desktop | Firefox | Navegador desktop real |
| **WA-CH** | Web Android | Chrome | Android físico / Chrome real |
| **WA-FF** | Web Android | Firefox | Android físico / Firefox real |

**Regra de completude:** `4/4 PASS` na versão candidata/deployed HEAD autorizado. `PASS` em Chrome **não substitui** Firefox; desktop **não substitui** Android; emulação mobile não substitui aparelho Android físico.

## 2. Critérios mínimos repetidos nas quatro células

Para cada versão sujeita ao gate web, executar ao menos:
1. Boot real Godot WebAssembly, renderização visível do canvas e build identificada (HEAD SHA, URL e/ou manifesto de artefato verificado).
2. Zoom **in** e **out** e manutenção do enquadramento/responsividade esperados.
3. Clique/toque no **personagem** com retorno visual coerente.
4. Clique/toque na **fazenda/terreno** com retorno visual coerente.
5. Arrastar/pan na fazenda sem clique/seleção acidental; registrar restrições de deslocamento por viewport separadamente.
6. Captura de eventual erro de console/renderização/interação e recuperação, se aplicável.

Interações adicionais de uma feature entram na checklist correspondente, **sem reduzir** a matriz de quatro. Para QA-only, validação do feedback não implica confirmação de gameplay, cuidado/salvamento ou direitos/arte.

## 3. Contrato de evidências por célula

Cada resultado registra: ID; `PASS | FAIL | BLOCKED | NOT_RUN | INCONCLUSIVE`; data/hora; testador; hardware/aparelho; SO e versão; navegador e versão; resolução/viewport (DPR quando relevante); URL com contexto de autenticação **sem credenciais**; SHA exato da build (ou bloqueio explícito para identificá-lo); passos e resultados observados; evidências reproduzíveis (captura, log ou breve relato de teste).

- Uma observação sem identificação do navegador **não** pode ser automaticamente atribuída a WD-CH ou WD-FF.
- Um teste automatizado Chrome/Playwright, emulação touch, headless, smoke CI ou screenshot é **evidência complementar**, não substitui homologação manual/real nas células exigidas.
- Quando o SHA hospedado ainda não é verificável, a célula fica `BLOCKED/INCONCLUSIVE` para **aceitação de release**, mesmo que a interação tenha funcionado visualmente.
- Quando uma célula falha, registrar defeito e retestar **essa célula** após a correção em novo HEAD; mudar HEAD exige revalidar a matriz vinculada à candidata ou explicitar a política de reaproveitamento por equivalência validada sob ARCH/QA.
- Se Vercel exigir login, manter proteção e testar com acesso autorizado; nunca remover SSO para marcar PASS.

## 4. Gates e precedência

- **GATE-WEB-MATRIX:** só está **PASS** com as quatro células `PASS` vinculadas a um commit/deployment rastreável; qualquer `FAIL/BLOCKED/NOT_RUN/INCONCLUSIVE` mantém o gate aberto.
- **GATE-TECH:** CI no exact-HEAD deve estar conforme contrato da branch; CI por si só não aprova GATE-WEB-MATRIX.
- **GATE-RELEASE:** GATE-WEB-MATRIX não substitui gates independentes ARCH, LENTE, ARTIST, propriedade dos assets, direitos, preview autenticado, performance, persistência ou autorização para merge.
- **GATE-CONCURRENCY:** nenhuma alteração documental pode roubar ownership da SPEC-008, PR #139 ou PRs CENA/hosting; reconciliar após merge de SPEC-009 no ramo apropriado.

## 5. Histórico e migração

Em 2026-10-18, o tester relatou que **zoom in/out, clique no personagem e clique na fazenda funcionaram em notebook Windows via browser**, mas não informou qual navegador. Registrar como **observação desktop Windows positiva, navegador não identificado**; **nenhuma das células WD-CH/WD-FF passa automaticamente**. Testes físicos Android Chrome/Firefox ainda não foram informados.

Aplicar este padrão em novas specs, critérios de aceite web, QA de PR e relatórios SIGA. A SPEC-008 (#133/#138, PR #139) deve **adotar a matriz somente por mudança separada e autorizada**, sem reabrir seu claim CLOSED_FOR_WRITES nem alterar histórico de testes.

## 6. Fora de escopo

Não modifica engine, jogo, assets, CI de QA-002, Vercel, branch do PR #139, testemunhos passados, nem autoriza merge. A matriz não é teste de app Android nativo ou de Roblox: aplica-se ao **jogo executado via navegador web**.
