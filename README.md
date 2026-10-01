# Maricá Game

Jogo de criação, cuidado e evolução de animais virtuais com linhagens persistentes, genética, ciclo de vida curto e economia entre jogadores.

> Estado atual: **Foundation / Spec Kit bootstrap**  
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
- Marketplace usa moeda interna, preço livre, ofertas, trocas e histórico.
- Não existe preço sugerido artificial.
- Cuidado afeta fortemente a expressão do potencial genético.
- Abandono é a punição mais severa: doença, custo e possível morte se não houver tratamento.

## Estrutura Spec Kit

```text
.specify/
  memory/
    constitution.md
specs/
  001-animal-core/
    spec.md
    plan.md
    tasks.md
```

## Próximo marco

Implementar a primeira vertical slice jogável do ciclo:

**receber pet → cuidar → evoluir → encerrar ciclo de vida → gerar sucessores → manter pedigree**

O marketplace entra após o ciclo animal básico estar funcional e testável.
