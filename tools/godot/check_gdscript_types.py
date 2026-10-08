#!/usr/bin/env python3
"""Lightweight project typing guard; Godot remains the source of syntax truth."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

_FUNCTION = re.compile(r"^\s*(?:static\s+)?func\s+[A-Za-z_][A-Za-z0-9_]*\s*\(")
_VARIABLE = re.compile(r"^\s*(?:@onready\s+)?var\s+([A-Za-z_][A-Za-z0-9_]*)(.*)$")


def _parameters(signature: str) -> list[str]:
    """Split parameters without splitting types such as Dictionary[String, int]."""
    opening = signature.find("(")
    closing = signature.rfind(")")
    params = signature[opening + 1 : closing]
    if not params.strip():
        return []
    output: list[str] = []
    depth = 0
    start = 0
    for index, char in enumerate(params):
        if char in "([{":
            depth += 1
        elif char in ")]}":
            depth -= 1
        elif char == "," and depth == 0:
            output.append(params[start:index].strip())
            start = index + 1
    output.append(params[start:].strip())
    return output


def validate(source: str) -> list[tuple[int, str]]:
    errors: list[tuple[int, str]] = []
    signature_parts: list[str] = []
    signature_start = 0
    for number, raw_line in enumerate(source.splitlines(), start=1):
        line = raw_line.split("#", 1)[0]
        stripped = line.strip()
        if signature_parts:
            signature_parts.append(stripped)
        elif _FUNCTION.match(line):
            signature_parts = [stripped]
            signature_start = number
        else:
            match = _VARIABLE.match(line)
            if match:
                tail = match.group(2).strip()
                if not (tail.startswith(":") or tail.startswith(":=")):
                    errors.append((number, f"variable '{match.group(1)}' needs a type or := inference"))
        if signature_parts and ")" in stripped and stripped.endswith(":"):
            signature = " ".join(signature_parts)
            trailing = signature[signature.rfind(")") + 1 :]
            if not re.fullmatch(r"\s*->\s*[A-Za-z_][A-Za-z0-9_]*(?:\[[^\]]+\])?\s*:", trailing):
                errors.append((signature_start, "function needs explicit -> return type"))
            for parameter in _parameters(signature):
                if parameter and ":" not in parameter.split("=", 1)[0]:
                    errors.append((signature_start, f"parameter '{parameter}' needs an explicit type"))
            signature_parts = []
    if signature_parts:
        errors.append((signature_start, "unfinished function signature"))
    return errors


def collect(paths: list[Path]) -> list[Path]:
    files: set[Path] = set()
    for path in paths:
        if path.is_file() and path.suffix == ".gd":
            files.add(path)
        elif path.is_dir():
            files.update(
                p for p in path.rglob("*.gd")
                if not any(part in ("addons", ".godot") for part in p.parts)
            )
    return sorted(files)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="+", type=Path)
    args = parser.parse_args()
    scripts = collect(args.paths)
    if not scripts:
        print("ERROR: no first-party .gd scripts found")
        return 1
    failed = 0
    for path in scripts:
        for line, message in validate(path.read_text(encoding="utf-8")):
            print(f"{path}:{line}: G415: {message}")
            failed += 1
    print(f"G415 typing guard: {len(scripts)} scripts, {failed} errors")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
