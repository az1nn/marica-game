# GODOT HANDOFF

Status: G441 VERIFIED / ADVANCE G442
Authority: Constitution v2.0.0 · SPEC-004 · ADR-0004.
Runtime: Godot 4.7.2-stable · typed GDScript · offline-first single-player.

Delivered:
- G410–G436 deterministic animal domain, succession and bounded GAUNTLET; G440 normative versioned save schema and negative fixtures.
- G441 local adapter `MaricaLocalSaveStore` and `MaricaSaveV1Validator`: user:// file I/O; absent vs corrupt separation; closed v1 JSON envelope + pet/lineage/ledger cross-record checks; duplicate JSON key rejection; optimistic revision and injected monotonic clock; detached snapshot return.
- Tests: independent G441 Godot headless runner with G440 fixtures and fail-closed paths; stale revision GOOD → BAD → RESTORE mutation.

Verified:
- G441 PR #96 exact head `42018f778d81405d08bb5b438103b2c2bf19f490`: G441 Local SaveStore, Godot CI, G440 Save Schema, ARCH V201 Source Import, Validate skills, Roblox CI and Web Preview Contract PASS; Roblox Behavioral SKIPPED/nonrequired.
- Guarded squash merge master@`4f58a8251a4e9ccfd4c89d9a370b913081ccecbd`: Godot CI, Validate skills, Roblox CI and Web Preview Contract PASS.

Limits:
- **NOT G442**: writes are direct, not crash-atomic and there is no backup/recovery, temp rename guarantee or restored previous valid save.
- **NOT G443–G447**: no schema migrations, domain-instance hydration, cross-restart succession marker guarantee or hours/days offline catch-up proof.
- ARTIST #77 and screenshot #97 are distinct draft lanes; runtime visual approval absent. Issue #86 all-saturated trait genetic progression is not settled.

Next: **G442** — atomic save + backup/recovery, using the current G441 SaveStore revision guard and schema v1 without weakening fail-closed validation.

## SIGA bounded G452 diagnostic — 2026-10-15 (supersedes stale G441-next note for this lane)

- Repo: `az1nn/marica-game`, master reference `bbfc4a24e5da5ab0015fbda83bffc6f2109461f6`. SPEC-004 G440–G447/G450/G451 are merged; G452 runtime full-scene and G453–G458 gates stay open.
- [PR #125](https://github.com/az1nn/marica-game/pull/125) (draft) implements an **opt-in**, technical founder placement scene using strictly validated/hydrated G440/G444 save data, unique soulbound G0 and existing G451 isometric camera. It will not synthesize a missing profile, mutate persistence/domain, or replace `smoke.tscn`.
- Source ARTIST S01-A01 V4 preserved at SHA-256 `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`, ARCH-only test copy; PR #77 unchanged.
- Technical pre-closeout PR head `f4c371b7` had Godot CI, G452 GOOD/BAD/RESTORE, G450/G451, ARCH V201, G440–G447, Validate skills and Roblox CI PASS (17 checks SUCCESS, 1 SKIPPED). **New docs commits invalidate exact-head evidence until rerun.**
- **Not shipped:** no camera/asset scaling policy for mobile/browser; no production sprite import/atlas/licensing approval, no ARTIST runtime acceptance, no LENTE real A/B; V201/V201a/V202–V205 remain open. PR #124 contains separately reviewed eight-capture raster probe and is draft.
- Single next action: ARCH V201/V201a complete measured real-device/browser + approved import scale/atlas policy before CENA/LENTE/ARTIST production acceptance; keep PR #125 draft and no merge.
