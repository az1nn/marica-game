# QA-001 / SPEC-008 Q804 — immutable HTTPS host qualification

**Authority:** issue #133 (P1), QA tracker #129, draft PR #134 source.
**Candidate:** isolated V206 Godot 4.7.2 Web export only; **not** full gameplay, not production.
**Current state:** STAGING WORK ONLY. **NO PUBLIC HOST / NO HUMAN QA ACCEPT / NO MERGE.**

## Source truth

- Source PR #134 exact HEAD: `8edfec42f8499b8818fc03c9415ef59abd23518b`.
- Completed source GitHub Actions run: `39148569671` and artifact `12144586145` / `qa001-godot-web-8edfec42f8499b8818fc03c9415ef59abd23518b`.
- Source artifact SHA-256 digest of ZIP (GitHub metadata): `8030a52f418bcec78f772b232438264ff2e6353a36cbe0342c030e39e2941ad3`.
- Original founder V4 PNG SHA-256: `b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e`.
- CI source artifact expires **2026-11-01** unless rebuilt and requalified.
- CENA #132 and #128, ARCH #126, LENTE #130, ARTIST #77 remain draft/independent.

## Scoped implementation

The `QA-001 HTTPS Host Qualification` workflow reads the exact source run and downloads its artifact using GitHub Actions' limited read permissions. The staging script:

1. Confirms the manifest's task, Godot version, SHA and actual browser-boot evidence.
2. Copies only exported files, preserving their original bytes. Every file's byte count and SHA-256 must match the source manifest.
3. Adds a distinct `qa001-provenance.json` describing this **staging** candidate, with `published: false` and `human_qa_accepted: false`.
4. Runs deterministic unit tests, including GOOD→BAD→RESTORE corruption detection, and uploads a `qa001-host-candidate-<HEAD>` artifact.
5. Optionally, if a URL has **already been explicitly approved and deployed** elsewhere, manually dispatches the workflow with `target_url`. It must be an uncredentialed HTTPS root serving the identical source files and provenance marker; CI compares remote hashes, then checks an actual Chrome Godot-ready marker and canvas at 390×844 mobile emulation and 1280×960 desktop.

No publishing token, Vercel config, production site or source asset is modified by this lane.

## Required before completing Q804

- [ ] Authorized destination (e.g. an isolated Vercel QA project or configured GitHub Pages environment), including asset distribution rights and public visibility decision.
- [ ] Deploy the byte-identical staging site *as a separate explicitly approved action*; do not redeploy the existing informational Vercel production/status root silently.
- [ ] External HTTPS smoke must pass for the deployed URL with immutable SHA/provenance and engine-ready browser evidence.
- [ ] Document the exact public URL, provider, deployed build identity, and CI run link in issue #133 / tracker #129.
- [ ] No ARTIST runtime acceptance, full G452 gameplay, or physical mobile/browser approval inferred from emulated Chrome.

## Required for Q805 (separate HUMAN_REQUIRED gate)

Independent tester opens the verified deployed URL on a physical Android device and desktop, tries the limited founder/farm framing and panning, records browser/viewport/screenshots and **QA access verdict ACCEPT / REVISE / REJECT**. ARTIST/LENTE/ARCH rights/import/performance gates remain independent and open.

## How to run the isolated staging checks

```sh
cd tools/qa
python3 -m unittest -v test_qa_https_gate.py
cd ../..
python3 tools/qa/qa_https_gate.py stage \
  --artifact /path/to/source-actions-artifact \
  --site /tmp/qa001-site \
  --source-sha 8edfec42f8499b8818fc03c9415ef59abd23518b \
  --source-run-id 39148569671
python3 tools/qa/qa_https_gate.py verify \
  --site /tmp/qa001-site \
  --source-sha 8edfec42f8499b8818fc03c9415ef59abd23518b
```

**Next authoritative action:** qualify exact staging PR HEAD, then obtain host/rights decision and deploy only after approval. Keep #133 open and all PRs draft.

## Verified Q804 predeploy slice (2026-10-18)

**First staging feature HEAD** `ee6535bf272e7c59b8da75b2875e605b8510bc1d` verified by 17 GitHub Actions runs: **16 SUCCESS, 1 optional Roblox Behavioral SKIPPED, 0 failure/pending**.

- [Actual host-qualification run #39154693438](https://github.com/az1nn/marica-game/actions/runs/39154693438): PASS. It downloaded source run #39148569671, checked all source export hashes, passed Python mutation/regression tests and produced identical static staging bytes.
- [Immutable, non-hosted candidate #12147040005](https://github.com/az1nn/marica-game/actions/runs/39154693438/artifacts/12147040005): `qa001-host-candidate-ee6535bf272e7c59b8da75b2875e605b8510bc1d`, retained for 14 days.
- This documentation change and subsequent claim closeout **move the branch HEAD**; green source feature CI cannot be represented as final PR exact-head until the new checks finish.
- **No published HTTPS URL**, remote smoke has NOT run, Q804/Q805 remain unchecked, #133 remains P1 OPEN.

**Authoritative next gate:** a permitted host and asset distribution decision; then external deploy of these **exact** files, external boot/hash smoke, and human mobile/desktop retest.
