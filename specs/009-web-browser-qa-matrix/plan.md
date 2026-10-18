# SPEC-009 — Plano de adoção

1. **Q900 (bootstrap):** criar o Spec Kit (spec, plan, tasks) em branch isolada, registrar escopo do claim e vincular a decisão humana à matriz de quatro células.
2. **Q901 (governança):** elevar a regra a contrato global na constituição, com versão 2.1.0 e log de alteração; não modificar o código ou ownership atual de QA-002.
3. **Q902 (validação):** inspecionar diff restrito, verificabilidade das células e CI do HEAD; publicar PR documental independente, mantendo-o sem merge.
4. **Q903 (adoção posterior):** sob novo claim e após integrar o padrão, ajustar specs/008 e checklists de QA aplicáveis, sem falsificar os testes Windows já declarados e sem fechar gates físicos Android.
5. **Q904 (homologação):** humano executa e registra WD-CH, WD-FF, WA-CH, WA-FF no mesmo build web; QA avalia 4/4 e gates independentes antes de release.

Independência: Q900–Q902 podem avançar sem tocar PR #139 nem seu ancestral #135; Q903–Q904 são um handoff futuro, não um PASS implícito.
