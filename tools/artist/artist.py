#!/usr/bin/env python3
"""Append-only ARTIST run scaffolder for Maricá Game."""

from __future__ import annotations

import argparse
import json
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path


IMAGE_KINDS = ("concept", "before", "after", "detail", "compare")


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def run_id() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")


def slug(value: str) -> str:
    cleaned = "".join(ch.lower() if ch.isalnum() else "-" for ch in value.strip())
    return "-".join(part for part in cleaned.split("-") if part) or "unnamed"


def write_json(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def load_manifest(run: Path) -> dict:
    path = run / "manifest.json"
    if not path.is_file():
        raise SystemExit(f"manifest not found: {path}")
    return json.loads(path.read_text(encoding="utf-8"))


def save_manifest(run: Path, manifest: dict) -> None:
    manifest["updated_at"] = utc_now()
    write_json(run / "manifest.json", manifest)


def cmd_validate(root: Path) -> int:
    required = (
        root / ".agents/skills/artist/SKILL.md",
        root / "docs/VISUAL-DIRECTION.md",
        root / "docs/ARTIST-HANDOFF.md",
    )
    missing = [str(path.relative_to(root)) for path in required if not path.is_file()]
    if missing:
        print("ARTIST VALIDATION: FAIL")
        for rel in missing:
            print(f"- missing: {rel}")
        return 1
    print("ARTIST VALIDATION: PASS")
    return 0


def cmd_start(root: Path, scene: str, object_name: str | None) -> int:
    scene_slug = slug(scene)
    target_slug = scene_slug if not object_name else f"{scene_slug}--object-{slug(object_name)}"
    base = root / "artifacts" / "artist" / "runs" / run_id()
    run = base / target_slug
    counter = 2
    while run.exists():
        run = base / f"{target_slug}-{counter}"
        counter += 1

    for kind in IMAGE_KINDS:
        (run / "images" / kind).mkdir(parents=True, exist_ok=True)

    manifest = {
        "schema_version": 1,
        "project": "marica-game",
        "repository": "az1nn/marica-game",
        "scene": scene_slug,
        "object": slug(object_name) if object_name else None,
        "state": "BRIEFED",
        "created_at": utc_now(),
        "updated_at": utc_now(),
        "evidence": [],
        "reviews": [],
    }
    write_json(run / "manifest.json", manifest)
    (run / "BRIEF.md").write_text(
        f"# ARTIST Brief — {target_slug}\n\n"
        "## Player purpose\n\n"
        "TBD\n\n"
        "## Three key silhouettes / interactions\n\n"
        "1. TBD\n2. TBD\n3. TBD\n\n"
        "## Camera / framing\n\nTBD\n\n"
        "## Lore / spec constraints\n\nTBD\n",
        encoding="utf-8",
    )
    (run / "PROMPT.md").write_text("# Generation Prompt\n\nTBD\n", encoding="utf-8")
    (run / "NEGATIVE.md").write_text(
        "# Negative Prompt\n\n"
        "photorealism, default Roblox avatar identity, visual clutter, unreadable mobile UI, "
        "generic asset-store collage\n",
        encoding="utf-8",
    )
    (run / "CAVEMAN.md").write_text(
        f"# CAVEMAN\n\nState: BRIEFED\nCreated: {manifest['created_at']}\nNext: complete brief and generate one concept.\n",
        encoding="utf-8",
    )
    print(run.relative_to(root))
    return 0


def cmd_record(root: Path, run_arg: str, kind: str, file_arg: str, commit: str | None, platform: str | None) -> int:
    run = (root / run_arg).resolve() if not Path(run_arg).is_absolute() else Path(run_arg).resolve()
    source = Path(file_arg).resolve()
    if not source.is_file():
        raise SystemExit(f"evidence file not found: {source}")
    if kind not in IMAGE_KINDS:
        raise SystemExit(f"unsupported kind: {kind}")

    manifest = load_manifest(run)
    destination_dir = run / "images" / kind
    destination_dir.mkdir(parents=True, exist_ok=True)
    index = len(list(destination_dir.iterdir())) + 1
    destination = destination_dir / f"{kind}-v{index:03d}{source.suffix.lower()}"
    shutil.copy2(source, destination)

    record = {
        "kind": kind,
        "path": str(destination.relative_to(run)),
        "recorded_at": utc_now(),
        "commit": commit,
        "platform": platform,
    }
    manifest.setdefault("evidence", []).append(record)
    save_manifest(run, manifest)
    print(destination.relative_to(root) if destination.is_relative_to(root) else destination)
    return 0


def cmd_review(root: Path, run_arg: str, stage: str, decision: str, reviewer: str, notes: str) -> int:
    run = (root / run_arg).resolve() if not Path(run_arg).is_absolute() else Path(run_arg).resolve()
    manifest = load_manifest(run)
    review = {
        "stage": stage,
        "decision": decision,
        "reviewer": reviewer,
        "notes": notes,
        "reviewed_at": utc_now(),
    }
    manifest.setdefault("reviews", []).append(review)

    if stage == "concept":
        manifest["state"] = "CONCEPT_ACCEPTED" if decision == "ACCEPT" else "CONCEPT_REVISE"
    else:
        manifest["state"] = "IMPLEMENTATION_ACCEPTED" if decision == "ACCEPT" else "IMPLEMENTATION_REVISE"

    save_manifest(run, manifest)
    with (run / "CAVEMAN.md").open("a", encoding="utf-8") as handle:
        handle.write(
            f"\n## Review {review['reviewed_at']}\n"
            f"Stage: {stage}\nDecision: {decision}\nReviewer: {reviewer}\nNotes: {notes}\n"
        )
    print(f"{run}: {manifest['state']}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("validate")

    start = sub.add_parser("start")
    start.add_argument("--scene", required=True)
    start.add_argument("--object")

    record = sub.add_parser("record")
    record.add_argument("--run", required=True)
    record.add_argument("--kind", choices=IMAGE_KINDS, required=True)
    record.add_argument("--file", required=True)
    record.add_argument("--commit")
    record.add_argument("--platform")

    review = sub.add_parser("review")
    review.add_argument("--run", required=True)
    review.add_argument("--stage", choices=("concept", "implementation"), required=True)
    review.add_argument("--decision", choices=("ACCEPT", "REVISE", "REJECT"), required=True)
    review.add_argument("--reviewer", required=True)
    review.add_argument("--notes", required=True)

    args = parser.parse_args()
    root = Path(args.root).resolve()

    if args.command == "validate":
        return cmd_validate(root)
    if args.command == "start":
        return cmd_start(root, args.scene, args.object)
    if args.command == "record":
        return cmd_record(root, args.run, args.kind, args.file, args.commit, args.platform)
    if args.command == "review":
        return cmd_review(root, args.run, args.stage, args.decision, args.reviewer, args.notes)
    return 2


if __name__ == "__main__":
    sys.exit(main())
