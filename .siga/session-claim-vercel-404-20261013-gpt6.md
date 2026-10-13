Task: DEPLOY-404 / Vercel static preview repair
Owner: SIGA/GODOT GPT-6 2026-10-13 America/Sao_Paulo
Base: master@d5baecd158f50942c1b575a60e52244eda141f1b
Branch: fix/vercel-preview-404-20261013@d5baecd158f50942c1b575a60e52244eda141f1b
Scope: vercel.json, public/ technical status page and health marker, dedicated static-preview CI test. No gameplay/export claims. No changes to SPEC-004 milestones or ARTIST identity.
Opened: 2026-10-13 America/Sao_Paulo
Status: CLOSED / MERGED PR #78 / WEB_ROOT_VERIFIED
Concurrency: PR #77 ARTIST docs-only; no overlap with web preview contract. Post-claim barrier mandatory.
Next: verify no drift, publish static output, validate exact-head CI, guarded merge and close claim.

Closed: 2026-10-13 America/Sao_Paulo
Candidate PR head: eb89cdc071ca6ea37395dee91fd169c9cf97953c
Result: exact-head guarded squash merge PR #78 into master@46bb2cd4334008eb108d00387c7e1c1a4cb4071c.
Gates: Vercel public output and HTTP root, Godot CI, Validate skills, Roblox CI PASS at PR and post-merge HEAD. Roblox Behavioral SKIPPED/nonrequired.
Deploy: production https://marica-game.vercel.app returned HTTP 200, no redirects, pt-BR HTML in independent external scan (Agent Ready id ShQAz2BWE3). Feature/PR preview is protected and redirects to Vercel login; do not advertise that URL as publicly accessible.
Cause: no index.html, public output directory, or vercel.json was present in canonical root. New static technical status shell serves / and /health.txt. Godot gameplay export (G500) and scene gates (G450+) remain pending; technical preview is not gameplay.
Concurrency: PR #77 ARTIST docs-only, no overlap with web contract; master head checked before closure.
Next: G433 under SPEC-004; Vercel public production is fixed, but preview auth protection remains a project-setting human gate if anonymous branch previews are needed.
