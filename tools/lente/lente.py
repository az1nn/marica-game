#!/usr/bin/env python3
"""Versioned LENTE evidence-run scaffolder for Maricá Game."""

from __future__ import annotations

import argparse
import json
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path


KINDS = ("pages", "scenes", "objects", "videos")


def now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def run_id() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")


def write_json(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def cmd_start(root: Path, head: str | None, scope: str) -> int:
    run = root / "artifacts" / "lente" / "runs" / run_id()
    counter = 2
    while run.exists():
        run = root / "artifacts" / "lente" / "runs" / f"{run_id()}-{counter}"
        counter += 1

    for kind in KINDS:
        (run / kind).mkdir(parents=True, exist_ok=True)
    (run / "findings").mkdir(parents=True, exist_ok=True)

    manifest = {
        "schema_version": 1,
        "project": "marica-game",
        "repository": "az1nn/marica-game",
        "scope": scope,
        "head": head,
        "created_at": now(),
        "evidence": [],
        "findings": [],
    }
    write_json(run / "manifest.json", manifest)
    (run / "CAVEMAN.md").write_text(
        "# LENTE CAVEMAN\n\n"
        f"Scope: {scope}\n"
        f"Head: {head or 'unknown'}\n"
        "Seen: pending fresh capture\n"
        "Broken: pending review\n"
        "Good: pending review\n"
        "Route: pending\n"
        "Next: record exact-head evidence.\n",
        encoding="utf-8",
    )
    print(run.relative_to(root))
    return 0


def load(run: Path) -> dict:
    path = run / "manifest.json"
    if not path.is_file():
        raise SystemExit(f"manifest not found: {path}")
    return json.loads(path.read_text(encoding="utf-8"))


def cmd_record(root: Path, run_arg: str, kind: str, file_arg: str, target: str, metadata: str | None) -> int:
    run = (root / run_arg).resolve() if not Path(run_arg).is_absolute() else Path(run_arg).resolve()
    source = Path(file_arg).resolve()
    if not source.is_file():
        raise SystemExit(f"evidence file not found: {source}")

    manifest = load(run)
    dest_dir = run / kind
    index = len(list(dest_dir.iterdir())) + 1
    dest = dest_dir / f"{index:03d}-{target}{source.suffix.lower()}"
    shutil.copy2(source, dest)

    extra = {}
    if metadata:
        extra = json.loads(metadata)

    manifest["evidence"].append({
        "kind": kind,
        "target": target,
        "path": str(dest.relative_to(run)),
        "recorded_at": now(),
        "metadata": extra,
    })
    write_json(run / "manifest.json", manifest)
    print(dest.relative_to(root) if dest.is_relative_to(root) else dest)
    return 0


def cmd_finding(root: Path, run_arg: str, finding_id: str, severity: str, owner: str, observation: str, next_action: str) -> int:
    run = (root / run_arg).resolve() if not Path(run_arg).is_absolute() else Path(run_arg).resolve()
    manifest = load(run)
    entry = {
        "id": finding_id,
        "severity": severity,
        "owner": owner,
        "observation": observation,
        "next": next_action,
        "created_at": now(),
        "status": "OPEN",
    }
    manifest["findings"].append(entry)
    write_json(run / "manifest.json", manifest)
    path = run / "findings" / f"{finding_id}.md"
    path.write_text(
        f"# {finding_id}\n\n"
        f"Severity: {severity}\nOwner: {owner}\nStatus: OPEN\n\n"
        f"## Observation\n\n{observation}\n\n"
        f"## Next\n\n{next_action}\n",
        encoding="utf-8",
    )
    print(path.relative_to(root) if path.is_relative_to(root) else path)
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    sub = parser.add_subparsers(dest="command", required=True)

    start = sub.add_parser("start")
    start.add_argument("--head")
    start.add_argument("--scope", default="all")

    record = sub.add_parser("record")
    record.add_argument("--run", required=True)
    record.add_argument("--kind", choices=KINDS, required=True)
    record.add_argument("--file", required=True)
    record.add_argument("--target", required=True)
    record.add_argument("--metadata", help="JSON object with viewport/platform/camera/etc.")

    finding = sub.add_parser("finding")
    finding.add_argument("--run", required=True)
    finding.add_argument("--id", required=True)
    finding.add_argument("--severity", choices=("P0", "P1", "P2", "P3"), required=True)
    finding.add_argument("--owner", choices=("ARTIST", "CENA", "ROBLOX", "LORE", "SIGA", "QA"), required=True)
    finding.add_argument("--observation", required=True)
    finding.add_argument("--next", required=True)

    args = parser.parse_args()
    root = Path(args.root).resolve()

    if args.command == "start":
        return cmd_start(root, args.head, args.scope)
    if args.command == "record":
        return cmd_record(root, args.run, args.kind, args.file, args.target, args.metadata)
    if args.command == "finding":
        return cmd_finding(root, args.run, args.id, args.severity, args.owner, args.observation, args.next)
    return 2


if __name__ == "__main__":
    sys.exit(main())
