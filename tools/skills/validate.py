#!/usr/bin/env python3
"""Validate the Maricá Game repository-local skill operating system."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

REQUIRED_SKILLS = (
    "siga",
    "siga-concurrency",
    "lore",
    "artist",
    "cena",
    "roblox",
    "qa",
    "lente",
    "relatorio",
    "godot",
    "3js",
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
)

CANONICAL_REPO = "az1nn/marica-game"
SIGA_PATH = Path(".agents/skills/siga/SKILL.md")

SIGA_REQUIRED_MARKERS = (
    "## Repository identity lock",
    "## Mandatory lifecycle",
    "### RECONCILE",
    "### CLASSIFY",
    "### ROUTE",
    "### CONCURRENCY BARRIER",
    "### EXECUTE",
    "## VERIFY",
    "## MERGE / WATCH",
    "## PERSIST",
    "## CONTINUE",
    ".agents/skills/siga-concurrency/SKILL.md",
    "python tools/skills/validate.py",
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


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    args = parser.parse_args()
    root = Path(args.root).resolve()

    errors: list[str] = []

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

    if errors:
        print("SKILLS VALIDATION: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1

    print("SKILLS VALIDATION: PASS")
    print(f"- repository lock: {CANONICAL_REPO}")
    print(f"- skills: {len(REQUIRED_SKILLS)}")
    print(f"- support docs: {len(REQUIRED_DOCS)}")
    print("- SIGA flow markers: PASS")
    print("- cross-repository authority scan: PASS")
    print("- hard-coded SIGA task IDs: none")
    return 0


if __name__ == "__main__":
    sys.exit(main())
