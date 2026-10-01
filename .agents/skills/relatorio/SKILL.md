---
name: relatorio
description: Produce a compact read-only CAVEMAN status of Maricá Game from live repository facts, emphasizing only what the next developer needs.
---

# RELATORIO — CAVEMAN repository status

RELATORIO is read-only.

Canonical repository:

~~~text
az1nn/marica-game
~~~

## Triggers

Treat requests such as these as RELATORIO:

- relatorio
- relatório
- relatório do repositório
- gere um relatório do repositório

A deep architecture audit or historical postmortem is not automatically a RELATORIO request.

## Source order

Read only enough live state to answer:

1. repository identity/default head;
2. active/open PRs and their heads;
3. active SPEC/task state;
4. exact-head CI/checks;
5. relevant handoff;
6. blockers/next action.

Do not mutate files, create tasks, create branches, merge or change labels.

## Classification

Choose one:

- ADVANCE — previous work is done and the next task is ready.
- RESUME — unfinished implementation/spec work exists.
- WATCH — real external/check gate is active.
- BLOCKED — human/product/semantic decision is required.

## Output budget

Default: maximum 8 concise bullets/lines.

Required shape:

~~~text
RELATORIO <ADVANCE|RESUME|WATCH|BLOCKED> — <task/milestone>
Repo: <default/head>
PR: <#n/head/state or none>
Spec: <active spec + task>
Done: <latest material verified state>
Gates: <exact-head required checks>
Blocker: <none or actionable blocker>
Next: <single next developer action>
~~~

## Rules

- no historical changelog dump;
- no raw GitHub payloads;
- no full diffs/logs unless a failure requires one exact excerpt;
- collapse multiple green checks;
- distinguish missing evidence from failure;
- distinguish provider wait from code failure;
- use repository facts over chat memory;
- do not call work complete when the validated SHA is stale.

RELATORIO reports; SIGA acts.
