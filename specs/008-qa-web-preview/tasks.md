# SPEC-008 — Verifiable tasks

- [x] Q800 SIGA reconcile source PR #132, exclusive claim and post-claim barrier (2026-10-18).
- [x] Q801 QA-only scene wrapper and Godot browser-ready marker — proposed; CI pending.
- [x] Q802 SHA-pinned official Web export without persisted project.godot mutation — CI pending.
- [x] Q803 Browser boot, nonblank viewport captures, artifact file hashes on exact HEAD — CI pending.
- [ ] Q804 Public HTTPS deployment of identical Web artifact + deployed URL marker and boot smoke — NOT IMPLEMENTED; separate host/rights gate.
- [ ] Q805 Actual tester mobile/desktop retry with QA-001 verdict — HUMAN_REQUIRED.

Retain QA-001 P1 OPEN until Q804/Q805. No merge/production or ARTIST runtime acceptance.

Q801–Q803 exact code HEAD `52c39ddad4058fe5e919527c17e82996e87b7e01`: 16 SUCCESS, one optional SKIP, [QA-001 native browser run #39148410625](https://github.com/az1nn/marica-game/actions/runs/39148410625) PASS. Post-closeout HEAD must rerun. Q804/Q805 are **not** complete.
