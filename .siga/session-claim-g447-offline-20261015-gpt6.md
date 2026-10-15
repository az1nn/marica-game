# SIGA G447 — SPEC-004
Status: CLOSED
Owner: SIGA G447 offline return
Base: c2625f65624fda34a63bca238c8d0d4ce440cfdf
Branch: godot/g447-offline-return-20261015
Scope: deterministic offline elapsed observation persisted through G441/G442, no network dependency, no implicit pet lifecycle ticks. G440–G446 and ARTIST untouched. Claim isolated.

Closeout: PR #115 HEAD 7a6c16657277492261f24201ca0202305d93f0d0 with 13 applicable exact-head checks PASS; Roblox Behavioral skipped. Guarded squash merge master@c866395378f25952f650a2472d2d0b465954cca2. G440–G446 and ARTIST untouched. Offline elapsed observation only, no automatic lifecycle progression. No post-merge master CI claim.
