# SIGA — V201/V201a evidence audit (non-production)

Base: master@bbfc4a24e5da5ab0015fbda83bffc6f2109461f6 (2026-10-15). Owner: SIGA → ARCH, isolated documentation-only claim. Existing open PR #77 owns ARTIST files and original PNG; this lane touches neither. Other V201 historical claims marked CLOSED; recheck claims/PRs before merge.

## Verified existing technical evidence
- PR #88: unchanged founder V4 source copied into an isolated Godot 4.7.2 import probe; hash/alpha/native texture/filter/feet anchor assertions and GOOD→BAD→RESTORE filter mutation. Technical-only, merged.
- PR #97: exact-head Godot 4.7.2 Xvfb/Mesa four rendered captures, light/dark mobile-sized and nearest/linear desktop controls; capture run 38613081336, merged. Desktop emulator / Xvfb is NOT a real mobile device or browser benchmark.
- Original ARTIST V4 SHA-256: b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e; original blob da7806ebfcb051c8fd32ccdbad4760b7136f97dd; 344×378 RGBA. PR #77 remains draft.

## Pending gates (fail closed)
- V201: measure representative mobile/web frame-time, pixel edge fidelity under integer and fractional zoom, alpha fringes over light/dark/terrain, layer ordering, camera and UI occlusion; document actual logical resolution, zoom policy and measured device/browser conditions.
- V201a: ratify import/filter/compression/atlas/pivot/resource sizing, source provenance and licensing; inspect production-equivalent sample without changing source PNG.
- CENA V203: independent playable sample after ARCH; LENTE V204/V205: exact-head baseline/A-B; ARTIST: separate runtime decision.
- Exact PR #123 HEAD `8662c20bc1bd5078d9569830b235c06f2e9b302e`: 16 checks SUCCESS and 1 optional `open-cloud-tests` SKIPPED. This verifies branch integrity only; it does not close runtime/production or human gates, task checkboxes, or PR #77.

Next: ARCH execute measured Godot prototype, retain source hash and settings plus reproducible captures, then independent LENTE/ARTIST review. This document is evidence reconciliation, not new executable proof.
