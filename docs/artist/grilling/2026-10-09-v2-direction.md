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

**Resposta humana:** B — UI moderna discreta.

**Decisão provisória:** HUD, menus, inventário e painéis usam interface limpa, tipografia contemporânea legível e controles claros; elementos pixel art são acentos visuais. Preservar contraste, alvos de toque e navegação mobile-first. O mundo continua integralmente pixel art 2.5D.

## G12 — Feedback visual das interações

**Pergunta:** Como comunicar ações, estados e recompensas sem poluir visualmente a fazenda?

- A — Minimalista: destaques de seleção, ícones simples e mensagens curtas, com poucos efeitos.
- B — Cartoon expressivo: partículas, saltos e reações visuais marcantes em quase toda ação.
- C — Diegético: feedback integrado ao mundo por gestos dos animais e sinais contextuais.
- D — Híbrido hierárquico: feedback discreto na rotina e expressivo em vínculos e marcos importantes.

**Resposta humana:** A — Minimalista.

**Decisão provisória:** utilizar realces de seleção, ícones simples e mensagens curtas para estados, ações e recompensas, com efeitos pontuais e parcimoniosos. A escolha não elimina a expressividade de animações dos animais aprovada em G7, mas evita sobrecarregar o HUD e o cenário.

## G13 — Paleta e contraste da interface

**Pergunta:** Qual tratamento cromático deve orientar a UI moderna discreta sobre os ambientes dinâmicos da fazenda?

- A — Neutra clara: superfícies claras e tipografia escura, com acentos discretos.
- B — Neutra escura: painéis grafite translúcidos, texto claro e acentos contidos.
- C — Adaptativa ao ambiente: tema claro/escuro alterna conforme cena e horário, mantendo contraste.
- D — Neutra fixa com acentos contextuais: base de interface consistente, independente do clima/horário, e pequenas cores de estado semanticamente estáveis.

**Resposta humana:** D — Neutra fixa com acentos contextuais.

**Decisão provisória:** manter uma base cromática de interface consistente e legível independentemente de horário, clima ou estação; usar acentos contextuais discretos e cores de estado semanticamente estáveis. Preservar UI moderna discreta (G11 B), feedback minimalista (G12 A), contraste e acessibilidade mobile-first. A decisão não fixa ainda tokens ou valores hexadecimais.

## G14 — Representação visual dos estados dos animais

**Pergunta:** Como diferenciar fome, higiene, afeição, saúde e outros estados relevantes sem sobrecarregar a UI?

- A — Ícones semânticos: símbolos claros e estados textuais curtos, com indicação de severidade.
- B — Barras compactas: medidores numéricos ou de progresso para cada estado, sempre visíveis.
- C — Expressão do animal: poses, expressões e sinais no próprio sprite como canal principal de estado.
- D — Híbrido sob demanda: visão geral com poucos alertas semânticos e detalhes completos ao selecionar o animal, apoiados por sua expressão visual.

**Resposta humana:** D — Híbrido sob demanda.

**Decisão provisória:** visão geral com alertas semânticos essenciais; seleção do animal abre detalhes dos estados já previstos, apoiados por expressões dos sprites. Preservar G11 B, G12 A e G13 D. Não criar novos atributos de gameplay.

## G15 — Identidade visual do centro da cidade

**Pergunta:** Como o centro da cidade deve se relacionar visualmente com a fazenda, preservando full pixel art 2.5D?

- A — Vila rural contínua: mesma arquitetura e paleta da fazenda, com ruas e serviços mais concentrados.
- B — Vila fantástica: formas lúdicas e ornamentos mágicos mais evidentes, mantendo leitura de NPCs e serviços.
- C — Centro funcional: ruas claras, fachadas distintas e sinalização forte para localizar serviços rapidamente.
- D — Híbrida: continuidade cozy com a fazenda, identidade própria para serviços/NPCs e composição funcional acessível.

**Resposta humana:** C — Centro funcional.

**Decisão provisória:** ruas, fachadas e sinalização priorizam identificação imediata de serviços e NPCs. Preservar coerência full pixel art 2.5D, fantasia cozy e legibilidade mobile. Não ampliar serviços ou gameplay sem DESIGN.

## G16 — Identidade visual dos NPCs da cidade

**Pergunta:** Como distinguir NPCs, profissões e serviços sem competir visualmente com os animais?

- A — Silhuetas profissionais: vestimentas e acessórios reconhecíveis, com cores funcionais.
- B — Fantasia caricatural: personagens expressivos e figurinos lúdicos marcantes.
- C — Sinalização contextual: aparência simples e profissão comunicada por placas e ícones próximos.
- D — Híbrida: silhuetas claras, acessórios profissionais discretos e sinalização contextual, com animais mantendo protagonismo.

**Resposta humana:** D — Híbrida.

**Decisão provisória:** NPCs usam silhuetas legíveis, acessórios profissionais discretos e sinalização contextual de serviços, preservando a identidade full pixel art 2.5D e a clareza do centro funcional (G15 C). Animais permanecem protagonistas; não ampliar elenco, profissões ou sistemas sem DESIGN/LORE.

## G17 — Transições visuais entre fazenda e cidade

**Pergunta:** Como a mudança entre fazenda e centro urbano deve ser apresentada visualmente?

- A — Corte direto: troca de cena imediata com transição curta e discreta.
- B — Caminho contínuo: deslocamento visual pelo mapa sem tela de transição, mantendo escala e orientação.
- C — Vinheta ilustrada: transição curta em pixel art com arte contextual e sensação de viagem.
- D — Híbrida funcional: navegação rápida com transição discreta por padrão e vinhetas pontuais em momentos narrativos importantes.

**Resposta humana:** A — Corte direto.

**Decisão provisória:** deslocamento entre fazenda e cidade usa troca direta de cena com transição curta e discreta, priorizando rapidez, previsibilidade e legibilidade mobile. Não incluir deslocamento contínuo, vinhetas ilustradas ou efeitos narrativos extras sem nova aprovação. Esta decisão visual não altera regras de navegação ou persistência do gameplay.

## G18 — Representação visual do ciclo de dia e noite

**Pergunta:** Como comunicar a passagem do dia para a noite preservando a leitura da fazenda e dos animais?

- A — Paletas por período: manhã, tarde, entardecer e noite com mudanças discretas de cores, sem efeitos adicionais.
- B — Iluminação pixel art: paletas por período com luzes e sombras estilizadas em camadas.
- C — Atmosfera cinematográfica: transições marcantes, brilhos, sombras profundas e efeitos ambientais expressivos.
- D — Híbrida legível: paletas e luzes pixel art por período, com limites de contraste e prioridade para leitura de animais e interações.

**Resposta humana:** C — Atmosfera cinematográfica.

**Decisão provisória:** ciclo de dia/noite com transições cromáticas marcantes, brilhos, sombras profundas e efeitos ambientais expressivos em full pixel art 2.5D. Validar contraste, leitura dos animais/interações e desempenho mobile antes de implementar. Não criar mecânicas novas.

## G19 — Representação visual do clima e das estações

**Pergunta:** Como chuva, vento, neblina e mudanças sazonais devem afetar a aparência da fazenda?

- A — Paletas e tiles sazonais: variações de cor e vegetação, com poucos efeitos animados.
- B — Partículas pixel art: chuva, folhas e vento animados, mantendo cenários essencialmente estáveis.
- C — Transformação ambiental: mudanças visíveis em vegetação, solo, céu e iluminação, com efeitos atmosféricos ricos.
- D — Híbrida escalonável: base de paletas e tiles por clima/estação, efeitos atmosféricos opcionais conforme desempenho e legibilidade.

**Resposta humana:** A — Paletas e tiles sazonais.

**Decisão provisória:** clima e estações alteram sobretudo paletas, tiles e vegetação, com animação ambiental limitada. Diferenciar esta escolha de G18 C: cinematografia se aplica ao ciclo dia/noite; clima e estações permanecem visualmente econômicos. Sem mecânicas climáticas adicionais.

## G20 — Clareza visual do cultivo e da colheita

**Pergunta:** Como distinguir visualmente os estágios das plantas e indicar o momento de colheita?

- A — Silhuetas por estágio: sprites distintos de semente, broto, crescimento e maturidade, sem indicadores adicionais.
- B — Marcadores discretos: ícones ou pequenos destaques mostram plantas prontas e que exigem cuidado.
- C — Animação expressiva: movimento e efeitos pixel art evidenciam crescimento e colheita.
- D — Híbrida funcional: silhuetas botânicas legíveis por estágio, com indicadores discretos somente quando relevantes ou ao selecionar.

**Resposta humana:** C — Animação expressiva.

**Decisão provisória:** comunicar crescimento e colheita por movimento, brilho e efeitos pixel art expressivos, preservando estágios botânicos reconhecíveis (G8 D). Aplicar animações em eventos relevantes sem converter o HUD minimalista (G12 A) em interface carregada. Não modificar duração, regras ou atributos do cultivo sem DESIGN.

## G21 — Leitura visual da estrutura e expansão da fazenda

**Pergunta:** Como comunicar limites de terrenos, áreas utilizáveis e futuras expansões sem poluir a estética cozy?

- A — Delimitação orgânica: cercas, caminhos, vegetação e relevo comunicam os espaços sem grade visível.
- B — Grade permanente: tiles e divisões sempre aparentes para facilitar posicionamento e planejamento.
- C — Destaque de construção: mundo orgânico na exploração e grade/áreas válidas apenas ao construir ou reorganizar.
- D — Híbrida contextual: limites orgânicos na exploração, overlays discretos para planejamento e feedback visual específico para expansão.

**Resposta humana:** D — Híbrida contextual.

**Decisão provisória:** limites de terrenos e áreas da fazenda são orgânicos na exploração, com overlays discretos de planejamento e feedback visual específico para expansão. Preservar densidade funcional (G9 D), modularidade de estruturas (G10 D) e UI minimalista (G12 A). Não alterar mecânicas de construção, desbloqueio ou economia sem DESIGN.

## G22 — Identidade visual dos edifícios e melhorias

**Pergunta:** Como representar visualmente a evolução de construções e instalações da fazenda sem perder coesão?

- A — Mudanças sutis: melhorias por pequenos detalhes, conservação e ornamentos, com silhueta estável.
- B — Evolução em estágios: cada nível ganha silhueta e volume claramente distintos, com maior destaque visual.
- C — Personalização cosmética: materiais, cores e decoração diferenciáveis, sem linguagem obrigatória de níveis.
- D — Híbrida modular: silhueta-base reconhecível, expansões funcionais visíveis e detalhes cosméticos discretos.

**Resposta técnica ARTIST (delegação para decisões não críticas):** D — Híbrida modular.

**Decisão provisória:** conservar a silhueta-base reconhecível dos edifícios, mostrar expansões funcionais de modo visualmente identificável e limitar detalhes cosméticos para preservar legibilidade e coesão. Não pressupor níveis, módulos ou personalizações inexistentes no DESIGN. Esta resposta foi inferida autonomamente a pedido do usuário, não é aprovação final da direção V2.

## G23 — Legibilidade e escalabilidade no mobile

**Pergunta técnica:** Como escalar sprites, cenários e HUD em telas pequenas e diferentes proporções?

- A — Escala única: manter a mesma densidade e tamanho aparente em todos os dispositivos.
- B — Zoom livre: deixar escala e legibilidade principalmente a cargo da câmera.
- C — Layout e enquadramento responsivos: preservar grid pixel-perfect com ajustes de enquadramento e HUD por dispositivo.
- D — Recriação por dispositivo: múltiplos conjuntos artísticos por resolução.

**Resposta técnica ARTIST (delegação):** C — Layout e enquadramento responsivos.

**Decisão provisória:** preservar inteireza de pixels na arte, sprites sem blur, alvos de toque confortáveis, HUD limpo e leitura de animais e interações em telas pequenas. Ajustar enquadramento e layout por viewport, sem alterar gameplay ou contrariar câmera contextual (G6 D). Definir resolução-base e escalas exatas apenas em protótipo validado.

## G24 — Hierarquia de efeitos e desempenho visual

**Pergunta técnica:** Como conciliar a atmosfera cinematográfica (G18 C), as animações de cultivo (G20 C) e o feedback minimalista (G12 A) com o desempenho?

- A — Efeitos máximos: manter todos os efeitos simultaneamente.
- B — Prioridade por foco: enfatizar somente os eventos/áreas relevantes ao jogador e limitar sobreposições.
- C — Sem pós-processamento: eliminar efeitos ambientais custosos.
- D — Configuração irrestrita: deixar toda escolha visual ao jogador.

**Resposta técnica ARTIST (delegação):** B — Prioridade por foco.

**Decisão provisória:** aplicar efeitos expressivos no mundo em momentos significativos e controlar sua simultaneidade e custo; manter HUD discreto. Cinematografia de dia/noite não implica efeitos permanentes em cada objeto; clima e estação seguem predominantemente com paletas e tiles (G19 A). Medir no Godot alvo com LENTE/performance antes de aceitação.

## G25 — Critério de validação da direção visual V2

**Pergunta técnica:** Qual evidência deve preceder a substituição do baseline V1?

- A — Aprovação textual: aceitar a descrição sem comparação visual.
- B — Um único mockup: avaliar uma captura estática como suficiente.
- C — Pacote de evidências comparativas: sprites, cenas e UI representativos com validação independente.
- D — Implementação total: trocar todo o jogo antes de avaliar o resultado.

**Resposta técnica ARTIST (delegação):** C — Pacote de evidências comparativas.

**Decisão provisória:** após aprovação humana da proposta, preparar implementação incremental em escopo separado, com exemplos dos três pilares Animals → Plants → Farm Structure, UI mobile e momentos dia/noite. Validar sprites pixel-perfect, legibilidade, efeitos, navegação, desempenho, acessibilidade, evidência visual LENTE e comparação A/B independente do executor. Não confundir mockup com runtime aprovado; reject continua válido.

## Consolidação provisória ARTIST V2 — síntese e conflitos

- **Núcleo visual:** full pixel art (G1), mundo 2.5D por sprites/tilemaps (G2), fantasia cozy (G3), escala hierárquica (G5) e câmera contextual (G6).
- **Animais:** expressividade por importância (G7) com estados informativos apenas sob demanda (G14); prioridade narrativa e visual preservada.
- **Plantas:** crescimento botânico reconhecível (G8) e animações expressivas em momentos importantes (G20).
- **Fazenda:** densidade funcional e orgânica (G9), estruturas reconhecíveis (G10), construção contextual (G21), melhorias modulares propostas (G22).
- **Cidade:** orientação funcional (G15), NPCs híbridos (G16), corte direto entre cenas (G17).
- **UI:** moderna e discreta (G11), feedback minimalista (G12), paleta estável (G13), responsividade pixel-perfect proposta (G23).
- **Ambiente:** ciclo dinâmico (G4), dia/noite cinematográfico (G18), estações de baixo custo por paleta/tiles (G19), efeitos com prioridade por foco proposta (G24).
- **Conflitos resolvidos na proposta:** efeitos cinematográficos e animações expressivas pertencem ao mundo e a eventos significativos, não à sobrecarga do HUD; clima/estação permanecem econômicos; performance e contraste não são negociáveis na verificação.
- **Validação sugerida:** evidência comparativa incremental G25 C, com gates ARTIST, ARCH, LENTE e SIGA conforme autoridade de domínio.
- **Proveniência:** G1–G21 são respostas humanas preservadas; G22–G25 são decisões técnicas inferidas por ARTIST sob delegação do usuário. Nenhuma decisão técnica equivale a aprovação humana do novo baseline.

## Gate de aprovação final

**Estado:** PROPOSTA CONSOLIDADA / AGUARDA APROVAÇÃO HUMANA EXPLÍCITA.

A mudança de baseline low-poly para full pixel art 2.5D é material e deve ser validada pelo usuário antes de substituir `docs/VISUAL-DIRECTION.md` ou abrir implementação visual. Não alterar código, cenas, assets ou runtime enquanto este gate estiver aberto.

## Gates

1. Não alterar estilo V1 ativo nem código/cenas/assets neste estágio.
2. Proposta ARTIST V2 consolidada com G1–G21 humanas e G22–G25 técnicas delegadas; aguarda aprovação humana explícita.
3. Após aprovação, reconciliar direção visual, specs, pipeline de CENA e evidência LENTE sob SIGA.
4. Respeitar ordem de produto Animals → Plants → Farm Structure.
