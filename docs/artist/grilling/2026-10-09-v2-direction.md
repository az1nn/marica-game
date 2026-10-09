# ARTIST Grilling — Maricá Game — proposta V2 (em coleta)

- Data de abertura: 2026-10-09
- Repositório: az1nn/marica-game
- Origem: decisão humana explícita na sessão ARTIST Grilling
- Estado: DRAFT / PROVISIONAL / NÃO IMPLEMENTAR
- Autoridade: direção visual proposta; não substitui `docs/VISUAL-DIRECTION.md` até aprovação final e reconciliação por ARTIST + SIGA

## G1 — Identidade artística principal

**Resposta humana, literal:** `full pixel art`.

**Interpretação mínima aprovada:** a identidade visual integral do jogo será pixel art, em vez de usar pixelização apenas como textura em modelos 3D low-poly. Esta é uma mudança material em relação ao baseline V1; o registro é provisório até o encerramento e aprovação da sessão ARTIST V2.

**Não inferir ainda:** tecnologia 2D vs 2.5D vs 3D, projeção de câmera definitiva, pixel density, resolução-base, tipos de sprites, iluminação, pipeline de assets ou alterações no runtime Godot.

## G2 — Forma de representar a fazenda e os animais

**Pergunta:** Com a direção full pixel art, qual apresentação visual devemos usar para a fazenda e os animais?

- A — Sprites 2D isométricos: toda a arte em sprites e tiles pixelados, profundidade simulada e animação frame a frame.
- B — Pixel art 2.5D: sprites/tilemaps pixelados com cenários multicamada, efeitos discretos de profundidade e luz.
- C — Pixel art com mundo 3D real: geometria 3D renderizada rigidamente em pixels, sem estética low-poly suavizada nem texturas apenas pixeladas.
- D — Híbrido: personagens em sprites pixelados e cenários 3D, ambos com pixelização coerente.

**Resposta humana:** B — Pixel Art 2.5D.

**Decisão provisória:** sprites/tilemaps pixelados com cenários multicamada, profundidade e iluminação estilizada. Preservar G1 full pixel art. Não interpretar 2.5D como autorização para arte low-poly ou substituição do runtime Godot.

## G3 — Linguagem visual dos animais

**Pergunta:** Qual proporção e expressividade devem orientar os sprites dos animais?

- A — Chibi arredondado: cabeças grandes, corpos compactos, expressões marcantes.
- B — Naturalista estilizado: anatomia reconhecível, proporções próximas às espécies reais.
- C — Fantasia cozy: silhuetas originais, traços lúdicos e detalhes mágicos discretos.
- D — Híbrido por espécie: proporções distintas, com consistência de pixel density e animação.

**Resposta humana:** C — Fantasia cozy.

**Decisão provisória:** animais com silhuetas originais, traços lúdicos e detalhes mágicos discretos, preservando expressividade, legibilidade e identidade full pixel art 2.5D. Não implica novas mecânicas mágicas ou mudança de lore sem decisão específica.

## G4 — Atmosfera cromática e iluminação

**Pergunta:** Qual atmosfera visual deve dominar a fazenda?

- A — Primavera luminosa: verdes frescos, céu claro e cores vivas, sombras suaves.
- B — Pastel aconchegante: tons delicados, luz difusa e sensação tranquila.
- C — Tropical encantado: vegetação exuberante, cores quentes e acentos mágicos discretos.
- D — Ciclo dinâmico: identidade cromática que varia fortemente com hora, clima e estações.

**Resposta humana:** D — Ciclo dinâmico.

**Decisão provisória:** a identidade cromática da fazenda varia significativamente com hora, clima e estações, mantendo coerência de pixel art 2.5D, legibilidade dos animais e fantasia cozy. Não implica implementação de simulação climática ou estações no gameplay sem spec própria.

## G5 — Densidade de pixels e detalhamento

**Pergunta:** Qual escala de detalhamento deve orientar sprites, tiles e animações em toda a V2?

- A — Pixel art macro: pixels grandes e formas simples, leitura imediata em telas pequenas.
- B — Pixel art intermediária: silhuetas claras com detalhes moderados, equilíbrio entre expressividade e produção.
- C — Pixel art refinada: pixels menores, texturas e animações mais detalhadas, maior custo de produção.
- D — Escala hierárquica: personagens e interações em pixels maiores; cenário e fundos com detalhes mais finos, sob grade e escala coerentes.

**Resposta humana:** D — Escala hierárquica.

**Decisão provisória:** sprites dos animais, expressões e pontos de interação priorizam pixels maiores e leitura mobile; cenários e fundos podem usar detalhes mais finos sob grade, proporções e escala visual coerentes. Evitar mistura arbitrária de resoluções, filtros suavizados e inconsistência de pixel density. A resolução-base e o tamanho exato dos tiles permanecem indefinidos.

## G6 — Enquadramento e câmera da fazenda

**Pergunta:** Como o jogador deve enxergar e navegar pela fazenda em pixel art 2.5D?

- A — Isométrica fixa: ângulo constante e deslocamento pela fazenda, composição rigorosa e previsível.
- B — Isométrica com zoom: ângulo constante, zoom controlado e enquadramento adaptável para interações e mobile.
- C — Top-down inclinado: leitura próxima ao alto, profundidade por camadas e foco em precisão de interação.
- D — Câmera contextual: enquadramento geral isométrico, transições de câmera específicas para cuidados e eventos, mantendo legibilidade.

**Resposta humana:** D — Câmera contextual.

**Decisão provisória:** a navegação geral mantém composição isométrica pixel art 2.5D; cuidados com animais e eventos podem receber enquadramentos contextuais para expressividade e legibilidade, sem implicar câmera 3D, zoom obrigatório ou implementação imediata. Transições devem respeitar grade visual, orientação espacial e acessibilidade mobile.

## G7 — Animação e expressividade dos animais

**Pergunta:** Qual linguagem de movimento deve orientar os animais da V2?

- A — Minimalista: poucos frames e poses-chave, priorizando produção rápida e leitura.
- B — Clássica frame a frame: ciclos pixel art fluidos e consistentes, com custo moderado.
- C — Expressiva e reativa: animações de idle, humor, cuidado e interação com exagero cartoon controlado.
- D — Híbrida por importância: animações simples para rotina e ciclos expressivos para vínculos, eventos e momentos especiais.

**Resposta:** PENDENTE.

## Gates

1. Não alterar estilo V1 ativo nem código/cenas/assets neste estágio.
2. Consolidar respostas da sessão em proposta ARTIST V2 para aprovação humana explícita.
3. Após aprovação, reconciliar direção visual, specs, pipeline de CENA e evidência LENTE sob SIGA.
4. Respeitar ordem de produto Animals → Plants → Farm Structure.
