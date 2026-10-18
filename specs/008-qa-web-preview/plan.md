# SPEC-008 — SIGA implementation plan

1. Reconcile exact source #132 at 82860359df7649a9bb0d0fd14e6fcbdf302eb57e and claim new isolated QA-only paths.
2. Add QA-only wrapper scene, preserving all parent CENA code; readiness marker arises from native Godot scene after child mount.
3. Use GitHub Actions exact-head export with pinned official Godot/Web templates. Temporary project override selects QA scene, then restores default smoke bootstrap without committing changes.
4. Launch Web export via local HTTP and Chrome WebGL/SwiftShader; produce actual screenshots and SHA-256 manifest. Save downloadable artifact.
5. Keep claim open until exact-head CI evaluated. Independently choose HTTPS host, rights and external deploy workflow. Real devices and human QA retest afterward.
