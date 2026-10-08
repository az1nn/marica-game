#!/usr/bin/env python3
"""G416 fixture schema/provenance validation. This is NOT a domain parity oracle."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
CATALOG = ROOT / "game/tests/fixtures/golden.json"
VALID_STATUSES = {"ACTIVE_SELFTEST", "ACTIVE_PARITY", "PENDING_PORT"}
APPROVED_PARITY = {"pet_id.from_string": ("G420", "game/src/domain/pet_id.gd")}


def validate(document: Any, root: Path = ROOT) -> list[str]:
    errors: list[str] = []
    if not isinstance(document, dict):
        return ["root must be a JSON object"]
    if document.get("schema_version") != 1:
        errors.append("schema_version must be 1")
    contracts = document.get("contracts")
    if not isinstance(contracts, list) or not contracts:
        return errors + ["contracts must be a nonempty array"]

    known_contracts: set[str] = set()
    active = 0
    pending = 0
    verified = 0
    for contract in contracts:
        if not isinstance(contract, dict):
            errors.append("contract must be an object")
            continue
        key = contract.get("id")
        if not isinstance(key, str) or not key:
            errors.append("contract id is required")
            continue
        if key in known_contracts:
            errors.append(f"duplicate contract: {key}")
        known_contracts.add(key)
        status = contract.get("status")
        if status not in VALID_STATUSES:
            errors.append(f"{key}: unknown status {status!r} (cannot imply parity)")
        if key == "harness.deep_equal" and status != "ACTIVE_SELFTEST":
            errors.append("harness.deep_equal must stay ACTIVE_SELFTEST")
        if status == "ACTIVE_SELFTEST" and key != "harness.deep_equal":
            errors.append(f"{key}: only harness.deep_equal may execute before domain port")
        if status == "ACTIVE_PARITY":
            approved = APPROVED_PARITY.get(key)
            if approved is None:
                errors.append(f"{key}: domain parity activation is not authorized")
            elif contract.get("milestone") != approved[0] or contract.get("adapter") != approved[1]:
                errors.append(f"{key}: incorrect parity milestone or adapter")
            if approved is not None and not (root / approved[1]).is_file():
                errors.append(f"{key}: missing executable Godot parity adapter")
            if contract.get("source") != "src/shared/domain/PetId.luau":
                errors.append(f"{key}: parity requires exact legacy source provenance")
        milestone = contract.get("milestone")
        if not isinstance(milestone, str) or not milestone.startswith("G4"):
            errors.append(f"{key}: invalid SPEC-004 milestone")
        source = contract.get("source")
        if not isinstance(source, str):
            errors.append(f"{key}: source path required")
        else:
            path = Path(source)
            if path.is_absolute() or ".." in path.parts or not (root / path).is_file():
                errors.append(f"{key}: invalid or missing provenance source {source}")
        cases = contract.get("cases")
        if not isinstance(cases, list) or not cases:
            errors.append(f"{key}: cases must be nonempty")
            continue
        seen: set[str] = set()
        for case in cases:
            if not isinstance(case, dict):
                errors.append(f"{key}: case must be an object")
                continue
            case_id = case.get("id")
            if not isinstance(case_id, str) or not case_id:
                errors.append(f"{key}: case id required")
                continue
            if case_id in seen:
                errors.append(f"{key}: duplicate case {case_id}")
            seen.add(case_id)
            if not isinstance(case.get("invariant"), str) or not case["invariant"].strip():
                errors.append(f"{key}/{case_id}: missing invariant")
            if not isinstance(case.get("input"), dict):
                errors.append(f"{key}/{case_id}: input must be an object")
            has_expected = "expected" in case
            has_error = "expected_error" in case
            if has_expected == has_error:
                errors.append(f"{key}/{case_id}: specify exactly one expected or expected_error")
            elif has_error and (
                not isinstance(case["expected_error"], str) or not case["expected_error"].strip()
            ):
                errors.append(f"{key}/{case_id}: expected_error must be a string")
            if status == "ACTIVE_SELFTEST":
                active += 1
                if has_error or not isinstance(case.get("expected"), dict):
                    errors.append(f"{key}/{case_id}: self-test needs result object")
                elif type(case["expected"].get("equal")) is not bool:
                    errors.append(f"{key}/{case_id}: expected.equal must be boolean")
                input_data = case.get("input")
                if not isinstance(input_data, dict) or set(input_data) != {"left", "right"}:
                    errors.append(f"{key}/{case_id}: self-test input needs left/right")
            elif status == "ACTIVE_PARITY":
                verified += 1
                if not isinstance(case.get("input"), dict) or set(case["input"]) != {"value"}:
                    errors.append(f"{key}/{case_id}: PetId parity requires one value input")
                if has_expected and case.get("expected", {}).keys() != {"id"}:
                    errors.append(f"{key}/{case_id}: PetId success must expect id")
            elif status == "PENDING_PORT":
                pending += 1

    if active == 0:
        errors.append("at least one executable harness self-test is required")
    if pending == 0:
        errors.append("deferred domain parity cases must remain explicitly visible")
    if verified == 0:
        errors.append("at least one real domain parity fixture is required after G420")
    return errors


def main() -> int:
    try:
        document = json.loads(CATALOG.read_text(encoding="utf-8"))
    except (OSError, ValueError) as error:
        print(f"G416: cannot load fixture catalog: {error}", file=sys.stderr)
        return 1
    errors = validate(document)
    if errors:
        for error in errors:
            print(f"G416 SCHEMA FAIL: {error}", file=sys.stderr)
        return 1
    active = sum(len(c["cases"]) for c in document["contracts"] if c["status"] == "ACTIVE_SELFTEST")
    pending = sum(len(c["cases"]) for c in document["contracts"] if c["status"] == "PENDING_PORT")
    verified = sum(len(c["cases"]) for c in document["contracts"] if c["status"] == "ACTIVE_PARITY")
    print(
        f"MARICA_G416_CATALOG_VALID active={active} verified={verified} "
        f"pending={pending} parity=NOT_YET_PROVEN"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
