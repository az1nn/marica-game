# SPEC-008 — SIGA implementation plan

1. Reconcile immutable CENA #132 and QA export #134; preserve Godot 4.7.2 source and per-head artifacts.
2. Build opt-in QA wrapper, hash-preserved V4 image and engine-owned browser ready marker; never change production default smoke scene.
3. Use official SHA-pinned Godot Web export templates, isolated ephemeral project preset and real Chrome WebGL/SwiftShader.
4. Publish exact-head WASM/PCK + PNG/manifest artifacts; hosted QA access Q804 must be authenticated/reconciled independently.
5. After human report [QA-002 #138](https://github.com/az1nn/marica-game/issues/138), Q806: add a QA-only `InputEvent` handler at wrapper level, touching/clicking founder reports visible diagnostic selection, ground taps report farm selection, pan drags do not activate; preserve original CENA input handler. No care/save/affection state.
6. Validate with native Godot scene/input tests, *real exported WebAssembly* in Linux Chrome mouse + mobile-touch emulation, before/after PNG and exact-head hashes; prove mutation BAD on disabled tap. No physical-device or LENTE/ARTIST pass is inferred.
7. Q807: require real Android Firefox and desktop confirmation against the HTTPS deployed HEAD (with authorized SSO), including a tap and drag test. Only then consider closing QA-002. Q804/Q805, ARCH rights, ARTIST visual and production merge remain independent.

Execute Q806 only under a new disjoint SIGA claim stacked on unchanged QA hosting PR #135; ownership/handoff and exact-head barrier mandatory.
