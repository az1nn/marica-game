# ADR-0002 — Persistência e autoridade de tempo

**Status:** ACCEPTED  
**Date:** 2026-09-30  
**Task:** SPEC-001 / T006  
**Depends on:** ADR-0001

## Contexto

O núcleo animal depende de tempo de calendário e estado durável:

- lifecycle de aproximadamente 2–4 semanas;
- cuidado, doença e tratamento;
- saída/retorno após horas ou dias;
- fim de vida;
- criação de exatamente duas sucessoras;
- pedigree persistente;
- futura economia entre jogadores.

Essas regras não podem depender do relógio do cliente, frame time ou timers que desaparecem quando o servidor fecha.

Também é obrigatório impedir duplicação por retry, reconexão, dois servidores tentando gravar o mesmo perfil ou repetição de um evento de sucessão.

## Decisão

### Persistência durável

A V1 usará **Roblox DataStoreService** como storage durável oficial.

Baseline inicial:

```text
DataStore: MaricaPlayerData
Key: user:<userId>

PlayerProfile
├─ schema_version
├─ revision
├─ session
├─ last_observed_at
├─ lineage / pedigree state
├─ active pets
├─ nursery / reserve
├─ care / health state
├─ inventory / crops
├─ Coins
├─ applied_operations
└─ metadata
```

A vertical slice P0 mantém dados que precisam mudar atomicamente no mesmo perfil do jogador enquanto o tamanho e throughput permanecerem seguros.

Não criar um DataStore diferente por jogador.

### Escrita concorrente

Writes que dependem do estado atual usam **`UpdateAsync()`**.

`SetAsync()` não deve ser usado para substituir perfis vivos ou operações que possam receber concorrência/retry.

Cada transformação deve:

1. validar `schema_version`;
2. validar lease/sessão quando aplicável;
3. validar precondições do comando;
4. aplicar a mudança de forma idempotente;
5. incrementar `revision`;
6. persistir `last_observed_at`;
7. retornar o novo snapshot.

Callbacks de `UpdateAsync` permanecem puros e não fazem yield.

### Sessão / lease

Um perfil mutável pertence a no máximo um servidor lógico por vez.

```text
session = {
  token,
  server_job_id,
  acquired_at,
  lease_expires_at
}
```

Aquisição/renovação/liberação do lease ocorre via `UpdateAsync`.

Regras:

- um novo servidor só assume sessão sem owner ou com lease expirado;
- lease é renovado junto ao ciclo normal de persistência;
- falha em adquirir sessão impede iniciar gameplay mutável;
- `PlayerRemoving` e `BindToClose` tentam salvar e liberar a sessão;
- lease expirado permite recuperação após crash sem tornar o perfil permanentemente indisponível.

### Buffer local e autosave

Após load, o servidor mantém um snapshot local autoritativo para gameplay.

Persistência:

- autosave periódico alvo: **180 s**, com jitter;
- salvar em checkpoints críticos;
- salvar no `PlayerRemoving`;
- salvar no `BindToClose`;
- retries transitórios usam backoff exponencial + jitter;
- writes com outcome desconhecido são tratados como potencialmente aplicados e precisam ser reexecutáveis/idempotentes.

Checkpoint crítico inclui, no mínimo:

- criação do fundador;
- fim de vida/sucessão;
- mudanças econômicas;
- transferência de ownership;
- operação que consuma recurso valioso de forma irreversível.

### Autoridade do relógio

O domínio recebe tempo por uma porta:

```text
Clock.now() -> unix_seconds
```

Implementação Roblox de produção:

```text
Workspace:GetServerTimeNow()
```

O cliente nunca fornece timestamps autoritativos.

Persistir:

```text
last_observed_at
born_at
planted_at
health timestamps
operation timestamps relevantes
```

Ao carregar:

```text
raw_now = Clock.now()
logical_now = max(raw_now, last_observed_at)
elapsed = logical_now - last_observed_at
```

Assim, o tempo lógico do perfil nunca anda para trás mesmo se houver anomalia de clock entre sessões.

Políticas de gameplay podem limitar efeitos de ausência por subsystem, mas não alteram a fonte autoritativa do tempo.

### Simulação determinística

Regras temporais recebem `now` explicitamente.

Exemplos:

```text
deriveLifeStage(pet, now)
deriveCareDecay(pet, now)
deriveHealthTransition(pet, now)
deriveCropGrowth(crop, now)
processLifecycle(profile, now, operationId)
```

Testes usam `FakeClock`; nenhum teste de domínio precisa esperar tempo real.

### Idempotência

Comandos críticos recebem `operation_id`.

O perfil mantém um ledger limitado de operações críticas aplicadas ou marcadores específicos por agregado.

Sucessão:

- o fim de vida possui identidade estável;
- os dois successor IDs são determinísticos a partir do evento + ordinal ou ficam persistidos antes de exposição;
- replay do mesmo evento retorna o mesmo resultado;
- `UpdateAsync` do perfil aplica encerramento + exatamente duas sucessoras na mesma transformação P0.

Resultado obrigatório:

```text
same lifecycle end event replayed N times
=> exactly 2 successors total
```

### MemoryStore

**MemoryStoreService não é fonte de verdade durável.**

Pode ser usado posteriormente para:

- locks/coordenação efêmera;
- filas;
- marketplace cross-server;
- cache curto.

Qualquer estado necessário após expiração/crash deve existir em DataStore.

### Marketplace e transferências cross-player

DataStore não oferece uma transação ACID multi-key genérica para dois perfis de jogadores.

Portanto, P1 não pode implementar trade como duas gravações ingênuas.

Antes de T041/T044+, a implementação deve introduzir um protocolo durável de transação/idempotência, por exemplo:

```text
Transaction
PREPARED -> COMMITTED -> APPLIED
```

com operation ID estável e recovery/replay seguro.

MemoryStore pode coordenar o fluxo, mas o commit durável pertence ao DataStore.

### Schema e migrações

Todo perfil possui `schema_version`.

Mudanças de schema exigem migração determinística, versionada e testada.

O loader:

1. lê versão;
2. migra sequencialmente;
3. valida invariantes;
4. só então libera gameplay mutável.

### Ambientes

Studio/teste não deve gravar acidentalmente no namespace de produção.

O adapter deve separar nomes/escopos de ambiente, por exemplo:

```text
MaricaPlayerData_dev
MaricaPlayerData_staging
MaricaPlayerData_prod
```

## Falhas e comportamento obrigatório

### Load indisponível

Após retries limitados, não iniciar gameplay mutável com perfil vazio improvisado. Falhar fechado com erro recuperável ao jogador.

### Save indisponível

- manter snapshot local;
- retry com backoff/jitter;
- não confirmar operação econômica crítica como durável antes da confirmação necessária;
- registrar erro observável.

### Clock rollback

Nunca produzir `elapsed < 0`.

### Replay de sucessão

Nunca criar mais de duas sucessoras para o mesmo evento.

### Cliente adulterado

Timestamp, ownership, Coins, genética, health e lifecycle enviados pelo cliente nunca substituem estado autoritativo.

## Alternativas consideradas

### ProfileStore como dependência obrigatória inicial

Não selecionado nesta ADR. É compatível com a arquitetura e pode ser reavaliado, mas a primeira vertical slice usará primitives oficiais e um adapter estreito para minimizar dependências e manter o contrato explícito.

### MemoryStore como persistência principal

Rejeitado: é armazenamento efêmero e expira.

### Relógio do dispositivo/cliente

Rejeitado: pode divergir/manipular e não é autoridade de domínio.

### Timers em execução por entidade

Rejeitado como fonte de verdade: desaparecem com shutdown e não representam corretamente progresso offline.

## Consequências

### Positivas

- save/load e progresso offline ficam testáveis;
- regras de tempo tornam-se determinísticas;
- sucessão pode ser exactly-once do ponto de vista de domínio;
- concorrência de perfil é tratada explicitamente;
- arquitetura continua portável.

### Custos

- lease/retry/migração precisam de testes próprios;
- marketplace exigirá protocolo transacional adicional;
- autosave e checkpoints precisam respeitar budgets do DataStore.

## Gates derivados

Antes de declarar persistência pronta:

1. round-trip do perfil;
2. lease concorrente;
3. retry de write com outcome desconhecido;
4. clock rollback;
5. offline catch-up;
6. migração de schema;
7. replay de sucessão sem duplicação;
8. namespace de teste isolado.

## Próxima execução

**T007 — Bootstrap do toolchain Roblox/Rojo/TestEZ e CI reproduzível.**

Depois: T010 — entidade Pet e IDs imutáveis.
