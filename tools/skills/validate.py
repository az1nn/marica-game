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


def parse_name(text: str) -> str | None:
    match = re.search(r"(?m)^name:\s*([^\s]+)\s*$", text)
    return match.group(1) if match else None


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

    if errors:
        print("SKILLS VALIDATION: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1

    print("SKILLS VALIDATION: PASS")
    print(f"- repository lock: {CANONICAL_REPO}")
    print(f"- skills: {len(REQUIRED_SKILLS)}")
    print(f"- support docs: {len(REQUIRED_DOCS)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
