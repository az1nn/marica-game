#!/usr/bin/env python3
"""Deterministic *advisory* SIGA routing; does not execute tasks or mutate a repository.

SIGA remains the decision-maker after reconciling live GitHub state, task priority,
claims and exact-head evidence. This tool fails closed on missing Spec Kit admission.
"""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


def roadmap_tasks(root: Path) -> set[str]:
    """Only unchecked executable task IDs with a complete local Spec Kit count."""
    out: set[str] = set()
    specs = root / "specs"
    if not specs.is_dir():
        return out
    for tasks_file in specs.glob("*/tasks.md"):
        folder = tasks_file.parent
        if not (folder / "spec.md").is_file() or not (folder / "plan.md").is_file():
            continue
        content = tasks_file.read_text(encoding="utf-8")
        out.update(re.findall(r"(?m)^\s*-\s*\[ \]\s*\*\*([A-Za-z][A-Za-z0-9-]*)\*\*", content))
    return out


def decide(request: dict[str, Any], graph: dict[str, Any]) -> dict[str, str]:
    """Return first safe dispatch *proposal*, not a verified execution."""
    if not request.get("roadmap_ready", False):
        return {"action": "BOOTSTRAP_SPEC", "owner": "siga",
                "reason": "Commit spec/plan/tasks only before implementation"}
    if not request.get("task_id"):
        return {"action": "TASK_SPEC_REQUIRED", "owner": "siga",
                "reason": "Add a scoped task to the committed roadmap before execution"}

    specialists = set(graph["specialists"])
    for dep in request.get("dependencies", []):
        if dep.get("state") in ("PASS", "DONE", "ACCEPTED"):
            continue
        owner = str(dep.get("owner", ""))
        if dep.get("actionable", True) and owner in specialists:
            return {"action": "ROUTE_DEPENDENCY", "owner": owner,
                    "reason": "First unresolved actionable dependency: " + str(dep.get("task", ""))}
        if dep.get("kind") == "human":
            return {"action": "HUMAN_REQUIRED", "owner": "siga",
                    "reason": "First prerequisite needs a genuine human decision"}
        return {"action": "CAPABILITY_BLOCKED", "owner": "siga",
                "reason": "Missing prerequisite lacks an executable specialist"}

    lanes = [lane for lane in request.get("ready_lanes", [])
             if lane.get("safe", False)
             and lane.get("owner") in specialists
             and lane.get("task_id")
             and lane.get("prerequisites_clear", True)
             and int(lane.get("missed_runs", 0)) >= int(graph["rules"]["anti_starvation_runs"])]
    lanes.sort(key=lambda lane: (-int(lane.get("missed_runs", 0)),
                                 int(lane.get("priority", 100)),
                                 str(lane["task_id"])))
    if lanes and not request.get("strict_p0_dependency", False):
        return {"action": "DISPATCH_READY_LANE", "owner": str(lanes[0]["owner"]),
                "reason": "Prevent starvation of ready task: " + str(lanes[0]["task_id"])}

    if request.get("human_gate", False):
        return {"action": "HUMAN_REQUIRED", "owner": "siga",
                "reason": "All runnable prerequisites resolved; genuine human gate pending"}
    if request.get("capability_blocked", False):
        return {"action": "CAPABILITY_BLOCKED", "owner": "siga",
                "reason": "Required execution or evidence capability unavailable"}

    intent = str(request.get("intent", "auto")).lower().strip().replace(" ", "-")
    owner = graph["aliases"].get(intent)
    if owner is None:
        return {"action": "TASK_SPEC_REQUIRED", "owner": "siga",
                "reason": "Unknown intent: require explicit scoped task/owner"}
    if owner == "siga":
        return {"action": "RECONCILE_AND_SELECT", "owner": "siga",
                "reason": "Select a safe bounded task using live priority and claims"}
    return {"action": "DISPATCH", "owner": owner,
            "reason": "Admitted task: " + str(request["task_id"])}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    parser.add_argument("--intent", default="auto")
    parser.add_argument("--task", default="")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    graph = json.loads((root / "tools/skills/skill_tree.json").read_text(encoding="utf-8"))
    tasks = roadmap_tasks(root)
    # A named completed or absent task is NOT an active runnable task.
    admitted = args.task if args.task in tasks else ""
    proposal = decide({"intent": args.intent,
                       "roadmap_ready": bool(tasks),
                       "task_id": admitted}, graph)
    print(json.dumps(proposal, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
