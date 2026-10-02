#!/usr/bin/env python3
"""Validate Maricá Game GAUNTLET evidence manifests."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

CANONICAL_REPO = "az1nn/marica-game"
SHA_RE = re.compile(r"^[0-9a-f]{40}$")
DECISIONS = {"PASS", "FAIL", "BLOCKED", "HUMAN_REQUIRED", "NO_PROGRESS"}
MUTATION_STATUSES = {"PROVED", "BLOCKED", "N/A"}


def _require_mapping(data: dict[str, Any], key: str, errors: list[str]) -> dict[str, Any]:
    value = data.get(key)
    if not isinstance(value, dict):
        errors.append(f"{key} must be an object")
        return {}
    return value


def validate_manifest(data: dict[str, Any]) -> list[str]:
    errors: list[str] = []

    if data.get("schema_version") != 1:
        errors.append("schema_version must be 1")

    if data.get("repository") != CANONICAL_REPO:
        errors.append(f"repository must be {CANONICAL_REPO}")

    target = _require_mapping(data, "target", errors)
    if not isinstance(target.get("task"), str) or not target.get("task"):
        errors.append("target.task is required")

    for field in ("baseline_sha", "candidate_sha"):
        value = target.get(field)
        if not isinstance(value, str) or not SHA_RE.fullmatch(value):
            errors.append(f"target.{field} must be a 40-character lowercase SHA")

    gates = _require_mapping(data, "gates", errors)
    validated_sha = gates.get("validated_sha")
    if not isinstance(validated_sha, str) or not SHA_RE.fullmatch(validated_sha):
        errors.append("gates.validated_sha must be a 40-character lowercase SHA")
    elif validated_sha != target.get("candidate_sha"):
        errors.append("gates.validated_sha must equal target.candidate_sha")

    results = gates.get("results")
    if not isinstance(results, list) or not results:
        errors.append("gates.results must contain at least one gate")
    else:
        for index, result in enumerate(results):
            if not isinstance(result, dict):
                errors.append(f"gates.results[{index}] must be an object")
                continue
            if result.get("status") not in {"PASS", "FAIL", "BLOCKED", "SKIP"}:
                errors.append(f"gates.results[{index}].status is invalid")
            if not isinstance(result.get("name"), str) or not result.get("name"):
                errors.append(f"gates.results[{index}].name is required")

    critic = _require_mapping(data, "critic", errors)
    if not isinstance(critic.get("context_isolated"), bool):
        errors.append("critic.context_isolated must be boolean")
    if not isinstance(critic.get("findings"), list):
        errors.append("critic.findings must be a list")

    mutation = _require_mapping(data, "mutation", errors)
    mutation_required = mutation.get("required")
    mutation_status = mutation.get("status")

    if not isinstance(mutation_required, bool):
        errors.append("mutation.required must be boolean")
    if mutation_status not in MUTATION_STATUSES:
        errors.append("mutation.status is invalid")

    if mutation_required and mutation_status == "N/A":
        errors.append("required mutation proof cannot be N/A")

    if mutation_status == "PROVED":
        for field in ("good_pass", "mutant_fail", "restore_pass"):
            if mutation.get(field) is not True:
                errors.append(f"mutation.{field} must be true when status is PROVED")

    if mutation_status == "BLOCKED":
        blocker = mutation.get("blocker")
        if not isinstance(blocker, str) or not blocker.strip():
            errors.append("mutation.blocker is required when status is BLOCKED")

    regressions = _require_mapping(data, "regressions", errors)
    if regressions.get("status") not in {"NONE", "FOUND", "PARTIAL"}:
        errors.append("regressions.status must be NONE, FOUND or PARTIAL")
    if not isinstance(regressions.get("items"), list):
        errors.append("regressions.items must be a list")

    rounds = data.get("rounds")
    if not isinstance(rounds, int) or rounds < 0 or rounds > 2:
        errors.append("rounds must be an integer from 0 to 2")

    decision = data.get("decision")
    if decision not in DECISIONS:
        errors.append("decision is invalid")

    if mutation_required and mutation_status == "BLOCKED" and decision == "PASS":
        errors.append("decision cannot be PASS while required mutation proof is BLOCKED")

    if critic.get("context_isolated") is False and decision == "PASS":
        errors.append("decision cannot be PASS when fresh-critic isolation was not achieved")

    if decision == "PASS" and regressions.get("status") == "FOUND":
        errors.append("decision cannot be PASS with known regressions")

    next_action = data.get("next")
    if not isinstance(next_action, str) or not next_action.strip():
        errors.append("next is required")

    return errors


def load_manifest(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError("manifest root must be an object")
    return data


def cmd_validate(path: Path) -> int:
    try:
        data = load_manifest(path)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"GAUNTLET MANIFEST: FAIL\n- {exc}")
        return 1

    errors = validate_manifest(data)
    if errors:
        print("GAUNTLET MANIFEST: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1

    print("GAUNTLET MANIFEST: PASS")
    print(f"- repository: {CANONICAL_REPO}")
    print(f"- target: {data['target']['task']}")
    print(f"- decision: {data['decision']}")
    return 0


def cmd_self_check() -> int:
    valid = {
        "schema_version": 1,
        "repository": CANONICAL_REPO,
        "target": {
            "task": "self-check",
            "baseline_sha": "0" * 40,
            "candidate_sha": "1" * 40,
        },
        "gates": {
            "validated_sha": "1" * 40,
            "results": [{"name": "self-check", "status": "PASS"}],
        },
        "critic": {"context_isolated": True, "findings": []},
        "mutation": {
            "required": True,
            "status": "PROVED",
            "good_pass": True,
            "mutant_fail": True,
            "restore_pass": True,
        },
        "regressions": {"status": "NONE", "items": []},
        "rounds": 1,
        "decision": "PASS",
        "next": "return to SIGA",
    }

    invalid = json.loads(json.dumps(valid))
    invalid["mutation"]["mutant_fail"] = False

    if validate_manifest(valid):
        print("GAUNTLET SELF-CHECK: FAIL")
        print("- valid fixture was rejected")
        return 1

    if not validate_manifest(invalid):
        print("GAUNTLET SELF-CHECK: FAIL")
        print("- invalid mutation fixture was accepted")
        return 1

    print("GAUNTLET SELF-CHECK: PASS")
    print("- positive control accepted")
    print("- negative control rejected")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("self-check")
    validate_parser = subparsers.add_parser("validate")
    validate_parser.add_argument("manifest", type=Path)
    args = parser.parse_args()

    if args.command == "self-check":
        return cmd_self_check()
    if args.command == "validate":
        return cmd_validate(args.manifest)
    return 2


if __name__ == "__main__":
    sys.exit(main())
