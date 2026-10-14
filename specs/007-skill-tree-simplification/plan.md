# SPEC-007 — Plano

1. Reconciliar master, PRs, claims e baseline SHA; manter PR #77 intocado.
2. Migrar protocolo de concorrência para SIGA e manter helper/scripts até comprovar equivalência.
3. Migrar GAUNTLET para QA adversarial preservando execução isolada e evidências históricas.
4. Arquivar ROBLOX/3JS como documentação read-only e retirar somente dispatch ativo.
5. Atualizar skill_tree.json, dispatch, routing_cases, validate.py, README, SKILL-TREE e handoffs.
6. Corrigir rubricas low-poly desatualizadas em LENTE/RELATORIO.
7. Executar testes de roteamento, skill validation, Godot CI e web preview exact-head; comparar com baseline.
8. Abrir PR; reconciliar concorrência novamente; merge com SHA guard apenas após gates verdes; RELATORIO final.

Rollback: reverter commit da refatoração, mantendo SPEC-007 e trilha de auditoria.

## Extensão: entrega GPT UI interativa
1. Criar manifesto JSON versionado com schema, campos de origem, exact SHA e estados de gate, separado de desenho/layout.
2. Adaptar RELATORIO e SIGA para preferir apresentação interativa nativa quando disponível, preservando imagem inline como fallback; não usar links de download como substituto.
3. Criar roteiro/artefato de demonstração do painel em UI, sem presumir que um arquivo estático executa DIL/AppBlock.
4. Validar JSON, snapshot stale, missing/unverified, filtros, deep-links, ordem canônica, dispositivos estreitos, acessibilidade e zero ações mutáveis.
