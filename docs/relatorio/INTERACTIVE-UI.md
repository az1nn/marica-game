# RELATORIO — interactive ChatGPT UI contract (SPEC-007)

## Immutable truth
SIGA dispatches RELATORIO as mandatory terminal stage. Reconcile live GitHub HEAD, PR heads, tasks, claims and gates; validate using tools/relatorio/report_contract.py. The read-only UI is a presentation over an immutable snapshot, never a new skill or task executor. A change to HEAD requires a fresh manifest; no state may silently go from MISSING/STALE to PASS.

## Native delivery
Prefer host-supported interactive controls (segmented tabs, filters, detail views, source links, copy action). AppBlock may visualize, but should not own controls when DIL native controls exist. Never claim a static HTML file implements a working ChatGPT UI. If interactivity unavailable, use exactly one canonical inline image; if no native inline image is available, mark VISUAL_BLOCKED explicitly. Text-only only on user request.

## Five tabs
Resumo: state/phase/current unit/default HEAD, blocker/wait, exactly one next action.
Tarefas: original order, status filter and search, owner, actual source link.
Gates: exact SHA and PASS/FAIL/RUNNING/QUEUED/MISSING/STALE/UNVERIFIED; stale green is forbidden.
Grafo: SIGA sole controller with nine specialist edges; blocked ARTIST chain ARCH/GODOT → CENA → LENTE → ARTIST.
Evidências: PR SHA, claims, source URLs and actual captures where available; never imply unverified runtime.

## Accessible, factual, read-only
Mobile-first, keyboard-operable controls, tap-friendly inputs and status text rather than color-only semantics. Local state may filter displayed rows but never modify the source manifest, task order or acceptance. Source links must originate from the canonical repository. Preserve canonical ten report sections and approved full pixel art 2.5D, Godot offline-first animal-first. Visual Mode remains one inline image fallback.

## Commands
- python tools/relatorio/report_contract.py tools/relatorio/demo.json
- python -m unittest discover -s tools/relatorio -p 'test_*.py'
- python tools/skills/validate.py

The demo deliberately contains a fake SHA and DEMO flag; never represent it as current live state. To visualize interactively inside ChatGPT, author native controls from the fresh validated manifest.
