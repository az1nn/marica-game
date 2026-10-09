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

**Resposta humana:** D — Híbrida por importância.

**Decisão provisória:** animações de rotina dos animais usam ciclos econômicos e legíveis; vínculos, cuidados relevantes, eventos e evolução recebem expressividade reforçada, com sprites e timing consistentes com full pixel art 2.5D e escala hierárquica. A escolha não autoriza ampliar mecânicas, produção de assets ou custos de animação sem planejamento e validação.

## G8 — Linguagem visual das plantas e cultivos

**Pergunta:** Como representar visualmente plantas e seus estágios de crescimento em pixel art 2.5D?

- A — Botânica reconhecível: espécies facilmente identificáveis, estágios simples e proporções plausíveis.
- B — Fantasia cozy: plantas estilizadas, formas expressivas e detalhes mágicos discretos, sem novas mecânicas.
- C — Progressão visual rica: estágios de crescimento marcadamente distintos, com variação de folhagem, flores e frutos.
- D — Híbrida: leitura botânica clara com fantasia cozy e evolução visual evidente, controlando densidade e custo de produção.

**Resposta humana:** D — Híbrida.

**Decisão provisória:** plantas mantêm leitura botânica identificável e estágios de crescimento visualmente distintos, com estilização fantasia cozy e detalhes mágicos discretos. A escala hierárquica, a grade de pixels e o custo de produção devem permanecer coerentes com G1–G7; não adicionar espécies, sistemas mágicos ou novos ciclos de cultivo sem decisão de DESIGN.

## G9 — Composição e densidade da fazenda

**Pergunta:** Como equilibrar densidade, caminhos e áreas interativas na composição pixel art 2.5D?

- A — Compacta e organizada: canteiros regulares, corredores amplos e leitura funcional imediata.
- B — Orgânica e acolhedora: caminhos sinuosos, vegetação espontânea e pequenos detalhes ambientais.
- C — Densa e viva: muitos elementos, decoração e atividades visíveis, com risco maior de ruído visual.
- D — Híbrida com hierarquia: núcleo funcional legível para animais e cultivos, bordas orgânicas e detalhes ambientais graduais.

**Resposta humana:** D — Híbrida com hierarquia.

**Decisão provisória:** o núcleo da fazenda prioriza legibilidade de animais, cultivos e interações, com caminhos funcionais; bordas orgânicas e detalhes ambientais são introduzidos gradualmente. Preservar composição compacta e densa sem obstrução visual, respeitando câmera contextual, escala hierárquica e acessibilidade mobile. Não autoriza construir cenas ou expandir escopo.

## G10 — Linguagem visual das construções e estruturas

**Pergunta:** Qual identidade devem ter celeiros, cercas, abrigos, oficinas e estruturas da fazenda?

- A — Rural tradicional: madeira, telhas, pedra e silhuetas reconhecíveis, com acabamento pixel art simples.
- B — Fantasia artesanal: volumes lúdicos, telhados expressivos, ornamentos delicados e materiais acolhedores.
- C — Modular funcional: peças repetíveis, estruturas claras e expansão visual sistemática, com menor custo de produção.
- D — Híbrida: arquitetura rural reconhecível, detalhes de fantasia cozy e módulos reutilizáveis sob grade pixel art consistente.

**Resposta humana:** D — Híbrida.

**Decisão provisória:** construções rurais reconhecíveis recebem detalhes de fantasia cozy discretos e são compostas por módulos reutilizáveis, respeitando a grade e a escala hierárquica full pixel art 2.5D. Silhuetas e pontos de interação devem ser legíveis em mobile. Não autoriza novos edifícios, mecânicas ou assets sem planejamento.

## G11 — Interface e HUD no mundo pixel art

**Pergunta:** Qual linguagem visual deve orientar HUD, menus, inventário e painéis de cuidado dos animais?

- A — Pixel art integral: molduras, ícones, tipografia e controles rigidamente pixelados.
- B — UI moderna discreta: interface limpa, tipografia legível e elementos pixel art apenas como acentos.
- C — Livro de fazenda: painéis inspirados em madeira, papel e caderno ilustrado, com acabamento pixel art.
- D — Híbrida acessível: ícones e molduras pixel art, tipografia e controles modernos legíveis, áreas de toque generosas e hierarquia mobile-first.

**Resposta:** PENDENTE.

## Gates

1. Não alterar estilo V1 ativo nem código/cenas/assets neste estágio.
2. Consolidar respostas da sessão em proposta ARTIST V2 para aprovação humana explícita.
3. Após aprovação, reconciliar direção visual, specs, pipeline de CENA e evidência LENTE sob SIGA.
4. Respeitar ordem de produto Animals → Plants → Farm Structure.
