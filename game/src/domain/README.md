# Domain

Engine-independent deterministic game rules live here.

Constraints:
- no Node, SceneTree, UI, HTTP or concrete storage dependencies;
- critical time and RNG enter explicitly;
- state remains serializable for versioned local saves and golden parity tests.
