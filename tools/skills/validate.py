#!/usr/bin/env python3
"""Validate the Maricá Game repository-local skill operating system."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

from dispatch import decide, roadmap_tasks

REQUIRED_SKILLS = (
    "siga",
    "design",
    "arch",
    "lore",
    "artist",
    "cena",
    "qa",
    "lente",
    "relatorio",
    "godot",
)

REQUIRED_DOCS = (
    "docs/SIGA-HANDOFF.md",
    "docs/LORE-HANDOFF.md",
    "docs/ARTIST-HANDOFF.md",
    "docs/CENA-HANDOFF.md",
    "docs/ROBLOX-HANDOFF.md",
    "docs/QA-HANDOFF.md",
    "docs/LENTE-HANDOFF.md",
    "docs/VISUAL-DIRECTION.md",
    "docs/lore/CANON.md",
    "docs/SIGA-CONCURRENCY.md",
    "docs/SKILL-TREE.md",
)

GAUNTLET_REQUIRED_FILES = (
    "tools/gauntlet/gauntlet.py",
    "docs/gauntlet/T018-SHADOW-PILOT.json",
    "specs/003-agentic-quality-loop/spec.md",
    "specs/003-agentic-quality-loop/plan.md",
    "specs/003-agentic-quality-loop/tasks.md",
)

CANONICAL_REPO = "az1nn/marica-game"
SIGA_PATH = Path(".agents/skills/siga/SKILL.md")
RELATORIO_PATH = Path(".agents/skills/relatorio/SKILL.md")

SIGA_REQUIRED_MARKERS = (
    "## Repository identity lock",
    "## Mandatory lifecycle",
    "### RECONCILE",
    "### SPEC_GATE",
    "### CLASSIFY",
    "### ROUTE",
    "### CONCURRENCY BARRIER",
    "### EXECUTE",
    "## VERIFY",
    "## MERGE / WATCH",
    "## PERSIST",
    "## CONTINUE",
    "docs/SIGA-CONCURRENCY.md",
    "## Dispatch decision contract",
    "tools/skills/skill_tree.json",
    "No task mutation without a committed Spec Kit roadmap",
    "python tools/skills/validate.py",
    ".agents/skills/qa/SKILL.md",
    "interactive native UI surface",
    "VISUAL_BLOCKED",
)

RELATORIO_REQUIRED_MARKERS = (
    "## Inline delivery contract",
    "## Interactive delivery path",
    "interactive native UI surface",
    "VISUAL_BLOCKED",
    "download-only",
    "### Composition QA gate",
    "### Render manifest",
    "### Density limits",
)

REPO_REFERENCE_RE = re.compile(r"\baz1nn/([A-Za-z0-9_.-]+)\b")
TASK_ID_RE = re.compile(r"\bT\d{3,}\b")


def parse_name(text: str) -> str | None:
    match = re.search(r"(?m)^name:\s*([^\s]+)\s*$", text)
    return match.group(1) if match else None


def repository_operating_files(root: Path) -> tuple[Path, ...]:
    skill_files = tuple(
        root / ".agents" / "skills" / skill / "SKILL.md"
        for skill in REQUIRED_SKILLS
    )
    support_files = (
        root / ".agents" / "skills" / "README.md",
        root / "docs" / "SIGA-HANDOFF.md",
        root / "docs" / "SIGA-CONCURRENCY.md",
        root / ".siga" / "README.md",
    )
    return skill_files + support_files


def validate_repository_references(path: Path, text: str, errors: list[str], root: Path) -> None:
    for match in REPO_REFERENCE_RE.finditer(text):
        reference = f"az1nn/{match.group(1)}"
        if reference != CANONICAL_REPO:
            errors.append(
                "cross-repository authority reference: "
                f"{path.relative_to(root)} -> {reference}"
            )



def validate_skill_graph(root: Path, errors: list[str]) -> int:
    """Guard against missing authorities, recursive/peer calls and routing regressions."""
    config_file = root / "tools/skills/skill_tree.json"
    cases_file = root / "tools/skills/routing_cases.json"
    dispatcher_file = root / "tools/skills/dispatch.py"
    for path in (config_file, cases_file, dispatcher_file):
        if not path.is_file():
            errors.append(f"missing dispatch artifact: {path.relative_to(root)}")
    if not config_file.is_file() or not cases_file.is_file():
        return 0
    try:
        graph = json.loads(config_file.read_text(encoding="utf-8"))
        cases = json.loads(cases_file.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, UnicodeError) as exc:
        errors.append(f"invalid skill dispatch JSON: {exc}")
        return 0

    expected = set(REQUIRED_SKILLS) - {"siga"}
    actual = graph.get("specialists", [])
    if len(actual) != len(set(actual)) or set(actual) != expected:
        errors.append("skill graph specialists must match REQUIRED_SKILLS, no duplicates")
    if graph.get("repository") != CANONICAL_REPO:
        errors.append("skill graph repository lock mismatch")
    if graph.get("orchestrator") != "siga" or graph.get("returns_to") != "siga":
        errors.append("SIGA must be the single orchestrator/return controller")
    rules = graph.get("rules", {})
    if rules.get("gauntlet_is_qa_mode") is not True or rules.get("concurrency_is_siga_barrier") is not True:
        errors.append("mandatory QA adversarial and SIGA concurrency rules missing")
    if (rules.get("strict_spec_kit") is not True
            or rules.get("bootstrap_only_commit") is not True
            or rules.get("peer_direct_calls") is not False
            or rules.get("concept_is_runtime_acceptance") is not False
            or rules.get("anti_starvation_runs") != 2):
        errors.append("skill graph must encode strict Spec Kit and separated visual gates")

    edges = graph.get("edges", [])
    if (not isinstance(edges, list)
            or any(edge.get("from") != "siga" or edge.get("to") not in expected
                   for edge in edges if isinstance(edge, dict))
            or any(not isinstance(edge, dict) for edge in edges)
            or len(edges) != len(expected)
            or {edge.get("to") for edge in edges if isinstance(edge, dict)} != expected):
        errors.append("only acyclic SIGA -> registered specialist dispatch edges allowed")
    aliases = graph.get("aliases", {})
    for alias, target in aliases.items():
        if target not in set(REQUIRED_SKILLS):
            errors.append(f"alias {alias} references missing skill {target}")
    if aliases.get("scene") != "cena" or aliases.get("architecture") != "arch":
        errors.append("SCENE/CENA or ARCH alias missing")
    if graph.get("review_paths", {}).get("visual") != ["lente", "artist"]:
        errors.append("visual review must route LENTE then ARTIST")
    if graph.get("review_paths", {}).get("code") != ["arch", "qa"]:
        errors.append("code review must route ARCH then QA")
    if aliases.get("review") != "qa" or aliases.get("release") != "siga":
        errors.append("review and release routes must respect QA/SIGA authority")

    spec_dir = root / "specs/006-single-entry-skill-orchestration"
    if not all((spec_dir / name).is_file() for name in ("spec.md", "plan.md", "tasks.md")):
        errors.append("SPEC-006 incomplete: no implementation is admitted")
    elif "O601" not in (spec_dir / "tasks.md").read_text(encoding="utf-8"):
        errors.append("SPEC-006 task trace missing")
    if not roadmap_tasks(root):
        errors.append("no executable Spec Kit task found in repository")

    total = 0
    for scenario in cases if isinstance(cases, list) else []:
        total += 1
        try:
            got = decide(scenario["request"], graph)
            wanted = scenario["expect"]
            for field in ("action", "owner"):
                if got.get(field) != wanted[field]:
                    errors.append(f"routing scenario {scenario.get('name', total)}: "
                                  f"{field} expected {wanted[field]}, got {got.get(field)}")
        except (ValueError, KeyError, TypeError, AttributeError) as exc:
            errors.append(f"routing scenario {scenario.get('name', total)} failed: {exc}")
    if total < 8:
        errors.append("routing regression fixtures insufficient")
    return total


def validate_visual_v2_authority(root: Path, errors: list[str]) -> None:
    artist = root / ".agents/skills/artist/SKILL.md"
    cena = root / ".agents/skills/cena/SKILL.md"
    if artist.is_file():
        text = artist.read_text(encoding="utf-8")
        for marker in ("## Approved V2 baseline", "full pixel art 2.5D",
                       "specs/005-pixel-art-v2-migration/",
                       "concept ACCEPT", "LENTE", "ARCH"):
            if marker not in text:
                errors.append(f"ARTIST current direction/gates marker missing: {marker}")
    if cena.is_file():
        text = cena.read_text(encoding="utf-8")
        for marker in ("## Approved visual baseline", "full pixel art 2.5D",
                       "Godot V1", "SIGA"):
            if marker not in text:
                errors.append(f"CENA current direction/routing marker missing: {marker}")

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    args = parser.parse_args()
    root = Path(args.root).resolve()

    errors: list[str] = []

    discovered = {item.parent.name for item in (root / ".agents" / "skills").glob("*/SKILL.md")}
    if discovered != set(REQUIRED_SKILLS):
        errors.append("active skill discovery must match exactly ten approved nodes: "
                      + str(sorted(discovered)))

    for skill in REQUIRED_SKILLS:
        path = root / ".agents" / "skills" / skill / "SKILL.md"
        if not path.is_file():
            errors.append(f"missing skill: {path.relative_to(root)}")
            continue
        text = path.read_text(encoding="utf-8")
        if parse_name(text) != skill:
            errors.append(f"front matter name mismatch: {path.relative_to(root)}")
        if CANONICAL_REPO not in text:
            errors.append(f"canonical repository lock missing: {path.relative_to(root)}")

    for rel in REQUIRED_DOCS:
        if not (root / rel).is_file():
            errors.append(f"missing support doc: {rel}")

    for rel in GAUNTLET_REQUIRED_FILES:
        if not (root / rel).is_file():
            errors.append(f"missing GAUNTLET file: {rel}")

    for path in repository_operating_files(root):
        if not path.is_file():
            continue
        validate_repository_references(
            path,
            path.read_text(encoding="utf-8"),
            errors,
            root,
        )

    siga_file = root / SIGA_PATH
    if siga_file.is_file():
        siga_text = siga_file.read_text(encoding="utf-8")

        for marker in SIGA_REQUIRED_MARKERS:
            if marker not in siga_text:
                errors.append(f"SIGA orchestration marker missing: {marker}")

        task_ids = sorted(set(TASK_ID_RE.findall(siga_text)))
        if task_ids:
            errors.append(
                "SIGA must derive task state live and cannot hard-code task IDs: "
                + ", ".join(task_ids)
            )

    relatorio_file = root / RELATORIO_PATH
    if relatorio_file.is_file():
        relatorio_text = relatorio_file.read_text(encoding="utf-8")
        for marker in RELATORIO_REQUIRED_MARKERS:
            if marker not in relatorio_text:
                errors.append(f"RELATORIO delivery marker missing: {marker}")

    routing_count = validate_skill_graph(root, errors)
    import subprocess
    report_tests = subprocess.run([sys.executable, "-m", "unittest", "discover", "-s",
                                   str(root / "tools" / "relatorio"), "-p", "test_*.py"],
                                  cwd=root, text=True, capture_output=True)
    if report_tests.returncode:
        errors.append("interactive report tests failed: " + report_tests.stderr[-1200:])
    validate_visual_v2_authority(root, errors)

    if errors:
        print("SKILLS VALIDATION: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1

    print("SKILLS VALIDATION: PASS")
    print(f"- repository lock: {CANONICAL_REPO}")
    print(f"- skills: {len(REQUIRED_SKILLS)} (SIGA plus nine specialists)")
    print(f"- support docs: {len(REQUIRED_DOCS)}")
    print(f"- historical GAUNTLET evidence files: {len(GAUNTLET_REQUIRED_FILES)}")
    print("- interactive report contract tests: PASS")
    print("- SIGA flow markers: PASS")
    print("- RELATORIO native-inline markers: PASS")
    print("- cross-repository authority scan: PASS")
    print("- hard-coded SIGA task IDs: none")
    print(f"- routing fixtures: {routing_count} PASS")
    print("- single entry, Spec Kit admission and visual V2 markers: PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
