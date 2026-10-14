#!/usr/bin/env python3
"""Strict read-only snapshot contract for SIGA interactive reporting."""
from __future__ import annotations
import argparse
import json
import re
from pathlib import Path
CANONICAL = "az1nn/marica-game"
CLASSIFICATIONS = {"ADVANCE", "RESUME", "WATCH", "BLOCKED"}
GATE_STATES = {"PASS", "FAIL", "RUNNING", "QUEUED", "MISSING", "STALE", "SKIPPED", "UNVERIFIED"}
TASK_STATES = {"DONE", "ACTIVE", "PENDING", "WATCH", "BLOCKED"}
SHA = re.compile(r"^[a-f0-9]{40}$")

def exact_sha(value, label):
    if not isinstance(value, str) or not SHA.fullmatch(value):
        raise ValueError(f"{label} must be 40-character exact SHA")

def source(value, label):
    if not isinstance(value, str) or not value.startswith("https://github.com/az1nn/marica-game/"):
        raise ValueError(f"{label} must be canonical GitHub URL")

def validate(snapshot):
    if not isinstance(snapshot, dict) or snapshot.get("schema_version") != 1:
        raise ValueError("invalid schema_version")
    if snapshot.get("repository") != CANONICAL:
        raise ValueError("cross-repository report forbidden")
    if snapshot.get("classification") not in CLASSIFICATIONS:
        raise ValueError("invalid classification")
    if not isinstance(snapshot.get("branch"), str) or not snapshot["branch"]:
        raise ValueError("missing branch")
    exact_sha(snapshot.get("head_sha"), "head_sha")
    if not isinstance(snapshot.get("next_action"), str) or not snapshot["next_action"].strip():
        raise ValueError("exactly one next_action required")
    source(snapshot.get("source_url"), "source_url")
    for name in ("tasks", "gates", "prs", "evidence"):
        if not isinstance(snapshot.get(name), list):
            raise ValueError(f"{name} must be array")
    ids = set()
    for task in snapshot["tasks"]:
        if not isinstance(task, dict) or not task.get("id") or task.get("status") not in TASK_STATES:
            raise ValueError("invalid task")
        if task["id"] in ids:
            raise ValueError("duplicate task ID")
        ids.add(task["id"])
        source(task.get("source_url"), "task.source_url")
    for gate in snapshot["gates"]:
        if not isinstance(gate, dict) or not gate.get("name") or gate.get("status") not in GATE_STATES:
            raise ValueError("invalid gate")
        if gate["status"] == "PASS":
            exact_sha(gate.get("head_sha"), "gate.head_sha")
            if gate["head_sha"] != snapshot["head_sha"]:
                raise ValueError("stale gate cannot be PASS")
            source(gate.get("source_url"), "gate.source_url")
    for pr in snapshot["prs"]:
        if not isinstance(pr, dict) or not isinstance(pr.get("number"), int):
            raise ValueError("invalid PR")
        exact_sha(pr.get("head_sha"), "pr.head_sha")
        source(pr.get("url"), "pr.url")
    for ev in snapshot["evidence"]:
        if not isinstance(ev, dict) or not isinstance(ev.get("label"), str):
            raise ValueError("invalid evidence")
        source(ev.get("url"), "evidence.url")
    return snapshot

def choose_surface(interactive_available=False, image_available=False, explicit_text=False):
    """Never mistake downloaded or static HTML for a delivered native report."""
    if explicit_text:
        return "TEXT"
    if interactive_available:
        return "INTERACTIVE"
    if image_available:
        return "VISUAL"
    return "VISUAL_BLOCKED"


def tasks_filtered(snapshot, status="ALL", search=""):
    validate(snapshot)
    if status != "ALL" and status not in TASK_STATES:
        raise ValueError("invalid filter")
    q = search.casefold().strip()
    return [x for x in snapshot["tasks"] if (status == "ALL" or x["status"] == status)
            and q in (x["id"] + " " + x.get("title", "")).casefold()]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("file", type=Path)
    args = parser.parse_args()
    validate(json.loads(args.file.read_text(encoding="utf-8")))
    print("INTERACTIVE REPORT CONTRACT: PASS")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
