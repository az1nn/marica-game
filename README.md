# Maricá Game

Jogo single-player de criação, cuidado e evolução de animais virtuais com linhagens persistentes, genética, cultivo e expansão de fazenda, com competição online assíncrona opcional.

> Estado atual: **Godot V1 transition / SPEC-004**  
> Fonte de verdade de produto: `.specify/memory/constitution.md` + `specs/`.

## Visão

O núcleo do Maricá Game é o vínculo com animais que vivem, evoluem, deixam descendentes e carregam uma história de linhagem entre diferentes donos. Cuidado e genética devem importar de verdade; o mercado permite circulação dos descendentes sem apagar pedigree ou origem.

## Prioridades já fechadas

1. **Animais** são o sistema principal.
2. **Plantas** vêm depois do núcleo animal.

## Decisões V1

- Vida de um pet: aproximadamente **2–4 semanas de calendário**.
- O fim da vida é tratado de forma suave e respeitosa.
- Ao morrer, o pet gera automaticamente **duas crias/sucessoras**, em uma lógica “tipo fênix”, sem depender de reprodução prévia.
- A sucessão garante **avanço genético** da linhagem.
- O primeiro pet herdado da madrinha é **soulbound**: nunca pode ser vendido ou trocado.
- Descendentes desse pet podem circular normalmente.
- A afeição/vínculo acompanha a propriedade quando um pet é vendido ou trocado; o novo dono pode continuar evoluindo a linhagem.
- Founder, breeder e pedigree permanecem como histórico.
- Sexo, reprodução e consanguinidade serão simples na V1.
- Mutações espontâneas ficam fora da V1.
- A V1 usa economia local; marketplace player-to-player foi movido para pós-V1.
- Um marketplace futuro continua sem preço sugerido artificial.
- Cuidado afeta fortemente a expressão do potencial genético.
- Abandono é a punição mais severa: doença, custo e possível morte se não houver tratamento.

## Estrutura Spec Kit

```text
.specify/
  memory/
    constitution.md
specs/
  001-animal-core/          # product contract / historical Roblox delivery
  003-agentic-quality-loop/
  004-godot-v1-transition/ # active executable roadmap
```

## Próximo marco

Implementar a primeira vertical slice jogável do ciclo:

**receber pet → cuidar → evoluir → encerrar ciclo de vida → gerar sucessores → manter pedigree**

Após o núcleo animal, a ordem da V1 é plantas → estrutura da fazenda → progressão/cidade → leaderboard online opcional.


## Agent Operating System

O projeto usa skills locais versionadas, derivadas do padrão consolidado no `growing-rio`:

- **SIGA** — orquestra continuação, concorrência, gates e merge.
- **LORE** — cânone narrativo.
- **ARTIST** — direção visual e aprovação.
- **CENA** — materialização de cenas/assets.
- **ROBLOX** — migration source / future-port lane.
- **QA** — gates automatizados.
- **LENTE** — evidência visual versionada.
- **RELATORIO** — status CAVEMAN.
- **GODOT** — runtime canônico de produção da V1.
- **3JS** — lane de referência/portabilidade.

Catálogo: `.agents/skills/README.md`.

Validação mínima:

~~~bash
python tools/skills/validate.py
python tools/artist/artist.py validate
~~~
