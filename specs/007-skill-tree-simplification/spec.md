# SPEC-007 — Simplificação do grafo de skills

## Intent
Reduzir 14 nós (SIGA + 13) para 10 nós (SIGA + 9), sem reduzir autoridade, gates, rastreabilidade ou segurança de concorrência.

## Target
Ativos: SIGA, DESIGN, LORE, ARCH, GODOT, ARTIST, CENA, LENTE, QA, RELATORIO.
Desativar dispatch de 3JS e ROBLOX; arquivar seus contratos e referências históricas, sem apagar evidências. Incorporar GAUNTLET como modo adversarial independente de QA e siga-concurrency como barreira obrigatória interna de SIGA.

## Invariantes
SIGA é entrada e retorno únicos. Sem tarefa executável antes de spec/plan/tasks versionados. Preservar isolamento builder/critic, GOOD→BAD→RESTORE, regression hunter, LENTE→ARTIST, human acceptance, SHA exato, claims, optimistic writes, overlap, guarded merge, RELATORIO inline e histórico.
Godot offline-first, animal→planta→fazenda; Roblox é fonte histórica; Three.js não é runtime V1. Full pixel art 2.5D é baseline; low-poly não deve reaparecer como orientação.

## Acceptance
Grafo com 9 especialistas distintos, 9 arestas SIGA→owner, aliases sem destinos órfãos; testes de roteamento atualizados; validadores e documentação consistentes; CI Godot/skills/web sem regressão. Nenhum merge sem evidência exact-head e verificação de PR #77.

## RELATORIO interativo — extensão aprovada em 2026-10-14
Preservar o dashboard visual canônico e sua ordem factual, oferecendo painel interativo nativo no ChatGPT quando o cliente suportar controles. Interações locais: abas Resumo/Tarefas/Gates/Grafo/Evidências, filtros de tarefa/status, drill-down por PR/gate, links de fonte e ações de copiar. Deve renderizar informação verificável, não navegar ou mutar o repositório automaticamente. Snapshot imutável com repo, branch, exact HEAD e timestamp verificado; toda interação deve identificar evidência ausente, stale ou unknown. Fallback: imagem inline única; se nenhum renderer visual estiver disponível, VISUAL_BLOCKED explícito. Evitar HTML arbitrário sem superfície confiável e nunca afirmar que AppBlock está ativo onde não está. Não perder acessibilidade mobile, nem a aparência/semântica do relatório canônico.
