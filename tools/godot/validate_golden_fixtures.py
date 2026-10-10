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
APPROVED_PARITY = {
    "pet_id.from_string": ("G420", "game/src/domain/pet_id.gd", "src/shared/domain/PetId.luau"),
    "lineage_id.from_string": (
        "G421", "game/src/domain/lineage_id.gd", "src/shared/domain/LineageId.luau"
    ),
    "pedigree.create": ("G421", "game/src/domain/pedigree.gd", "src/shared/domain/Pedigree.luau"),
    "lifecycle.transitions": ("G422", "game/src/domain/lifecycle.gd", "src/shared/domain/Lifecycle.luau"),
    "simulation_time.observe": (
        "G423", "game/src/domain/simulation_time.gd", "src/shared/domain/SimulationTime.luau"
    ),
    "genetics.new_potential": ("G424", "game/src/domain/genetics.gd", "src/shared/domain/Genetics.luau"),
    "genetics.express": ("G424", "game/src/domain/genetics.gd", "src/shared/domain/Genetics.luau"),
    "care.create": ("G425", "game/src/domain/care.gd", "src/shared/domain/Care.luau"),
    "care.quality": ("G425", "game/src/domain/care.gd", "src/shared/domain/Care.luau"),
    "care.expression_factors": (
        "G425", "game/src/domain/care.gd", "src/shared/domain/Care.luau"
    ),
    "health.create": ("G426", "game/src/domain/health.gd", "src/shared/domain/Health.luau"),
    "health.advance": ("G426", "game/src/domain/health.gd", "src/shared/domain/Health.luau"),
    "health.treat": ("G426", "game/src/domain/health.gd", "src/shared/domain/Health.luau"),
    "health.terminal_risk": (
        "G426", "game/src/domain/health.gd", "src/shared/domain/Health.luau"
    ),
    "soulbound.create": ("G427", "game/src/domain/soulbound.gd", "src/shared/domain/Soulbound.luau"),
    "soulbound.is_transferable": (
        "G427", "game/src/domain/soulbound.gd", "src/shared/domain/Soulbound.luau"
    ),
    "soulbound.assert_transferable": (
        "G427", "game/src/domain/soulbound.gd", "src/shared/domain/Soulbound.luau"
    ),
    "pet.soulbound": ("G427", "game/src/domain/pet.gd", "src/shared/domain/Pet.luau"),
    "affection.create": ("G428", "game/src/domain/affection.gd", "src/shared/domain/Affection.luau"),
    "affection.increase": ("G428", "game/src/domain/affection.gd", "src/shared/domain/Affection.luau"),
    "pet.affection": ("G428", "game/src/domain/pet.gd", "src/shared/domain/Pet.luau"),
    "pet.composite": ("G429", "game/src/domain/pet.gd", "src/shared/domain/Pet.luau"),
}


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
            if approved is not None and contract.get("source") != approved[2]:
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
                if key in {"pet_id.from_string", "lineage_id.from_string"}:
                    if not isinstance(case.get("input"), dict) or set(case["input"]) != {"value"}:
                        errors.append(f"{key}/{case_id}: ID parity requires exactly one value input")
                    if has_expected and set(case.get("expected", {})) != {"id"}:
                        errors.append(f"{key}/{case_id}: ID success must expect id")
                if key == "pedigree.create":
                    fields = {"lineageId", "generation", "founderPetId", "parentPetIds"}
                    if not isinstance(case.get("input"), dict):
                        errors.append(f"{key}/{case_id}: pedigree input must be object")
                    elif not set(case["input"]).issubset(fields):
                        errors.append(f"{key}/{case_id}: unrecognized pedigree input fields")
                    if has_expected and (
                        not isinstance(case.get("expected"), dict)
                        or set(case["expected"]) != fields
                    ):
                        errors.append(f"{key}/{case_id}: pedigree success must expect canonical snapshot")
                if key == "lifecycle.transitions":
                    data = case.get("input")
                    actions = data.get("actions") if isinstance(data, dict) else None
                    if not isinstance(data, dict) or set(data) != {"actions"} or not isinstance(actions, list):
                        errors.append(f"{key}/{case_id}: lifecycle requires actions array")
                    else:
                        for action in actions:
                            if not isinstance(action, dict):
                                errors.append(f"{key}/{case_id}: action must be an object")
                            elif action.get("op") == "advance" and set(action) != {"op", "stage"}:
                                errors.append(f"{key}/{case_id}: advance requires stage")
                            elif action.get("op") == "endLife" and set(action) != {"op", "reason"}:
                                errors.append(f"{key}/{case_id}: endLife requires reason")
                            elif action.get("op") not in {"advance", "endLife"}:
                                errors.append(f"{key}/{case_id}: unrecognized lifecycle action")
                    if has_expected:
                        expected = case.get("expected")
                        valid = [
                            {"stage", "status", "terminal"},
                            {"stage", "status", "endReason", "terminal"},
                        ]
                        if not isinstance(expected, dict) or set(expected) not in valid:
                            errors.append(f"{key}/{case_id}: lifecycle success must expect canonical snapshot")
                        elif type(expected["terminal"]) is not bool:
                            errors.append(f"{key}/{case_id}: lifecycle terminal must be boolean")
                if key in {"genetics.new_potential", "genetics.express"}:
                    data = case.get("input")
                    if not isinstance(data, dict):
                        errors.append(f"{key}/{case_id}: genetics input must be object")
                    elif key == "genetics.new_potential" and set(data) != {"values"}:
                        errors.append(f"{key}/{case_id}: potential requires only values")
                    elif key == "genetics.express" and (
                        "potential" not in data or not set(data).issubset({"potential", "factors"})
                    ):
                        errors.append(f"{key}/{case_id}: expression requires potential, optional factors")
                    if has_expected:
                        expected = case.get("expected")
                        if not isinstance(expected, dict) or any(
                            not isinstance(k, str) or not k.strip()
                            or type(v) not in (int, float) or not (0 <= v <= 1)
                            for k, v in expected.items()
                        ):
                            errors.append(f"{key}/{case_id}: genetics success needs bounded trait map")
                if key in {"care.create", "care.quality", "care.expression_factors"}:
                    data = case.get("input")
                    if not isinstance(data, dict):
                        errors.append(f"{key}/{case_id}: care input must be object")
                    elif key == "care.expression_factors":
                        if "potential" not in data or not set(data).issubset({"values", "potential"}):
                            errors.append(
                                f"{key}/{case_id}: care factors need potential, optional values"
                            )
                    elif not set(data).issubset({"values"}):
                        errors.append(f"{key}/{case_id}: care input may only contain values")
                    if isinstance(data, dict) and "values" in data and (
                        data["values"] is not None and not isinstance(data["values"], dict)
                    ):
                        errors.append(f"{key}/{case_id}: care values must be object or null")
                    if has_expected:
                        expected = case.get("expected")
                        care_fields = {"hunger", "hygiene", "affection", "energy"}
                        if key == "care.create":
                            valid = isinstance(expected, dict) and set(expected) == care_fields
                        elif key == "care.quality":
                            valid = isinstance(expected, dict) and set(expected) == {"quality"}
                        else:
                            valid = isinstance(expected, dict)
                        if not valid or any(
                            type(v) not in (int, float) or not (0 <= v <= 1)
                            for v in expected.values()
                        ):
                            errors.append(
                                f"{key}/{case_id}: care success must be normalized canonical result"
                            )
                if key.startswith("soulbound.") or key == "pet.soulbound":
                    data = case.get("input")
                    allowed = {"id", "soulbound"} if key == "pet.soulbound" else {"value"}
                    if not isinstance(data, dict) or not set(data).issubset(allowed):
                        errors.append(f"{key}/{case_id}: invalid Soulbound input fields")
                    if key == "pet.soulbound" and (not isinstance(data, dict) or "id" not in data):
                        errors.append(f"{key}/{case_id}: Pet soulbound requires id")
                    if has_expected:
                        expected = case.get("expected")
                        fields = (
                            {"id", "soulbound", "transferable"} if key == "pet.soulbound"
                            else {"soulbound"} if key == "soulbound.create"
                            else {"transferable"}
                        )
                        if not isinstance(expected, dict) or set(expected) != fields:
                            errors.append(f"{key}/{case_id}: invalid Soulbound canonical result")
                        elif not all(
                            type(expected[name]) is bool
                            for name in fields - {"id"}
                        ):
                            errors.append(f"{key}/{case_id}: Soulbound result must contain booleans")
                if key in {"affection.create", "affection.increase", "pet.affection"}:
                    data = case.get("input")
                    allowed = {
                        "affection.create": {"value"},
                        "affection.increase": {"state", "gain"},
                        "pet.affection": {"id", "soulbound", "affection", "gain", "replace"},
                    }
                    if not isinstance(data, dict) or not set(data).issubset(allowed[key]):
                        errors.append(f"{key}/{case_id}: invalid Affection input fields")
                    if key == "pet.affection" and (
                        not isinstance(data, dict)
                        or "id" not in data
                        or {"gain", "replace"}.issubset(data)
                    ):
                        errors.append(f"{key}/{case_id}: Pet affection needs id and one update action")
                    if has_expected:
                        expected = case.get("expected")
                        keys = (
                            {"id", "soulbound", "affection"} if key == "pet.affection"
                            else {"affection"}
                        )
                        if not isinstance(expected, dict) or set(expected) != keys:
                            errors.append(f"{key}/{case_id}: invalid Affection canonical result")
                        elif (
                            type(expected["affection"]) not in (int, float)
                            or not (0 <= expected["affection"] <= 1)
                            or (
                                key == "pet.affection"
                                and (
                                    type(expected["id"]) is not str
                                    or type(expected["soulbound"]) is not bool
                                )
                            )
                        ):
                            errors.append(f"{key}/{case_id}: affection result must be normalized")
                if key.startswith("health."):
                    data = case.get("input")
                    allowed = {
                        "health.create": {"values"},
                        "health.advance": {"state", "care", "elapsedHours"},
                        "health.treat": {"state", "treatment"},
                        "health.terminal_risk": {"state"},
                    }
                    if not isinstance(data, dict) or not set(data).issubset(allowed[key]):
                        errors.append(f"{key}/{case_id}: invalid Health input fields")
                    if key == "health.advance" and (
                        not isinstance(data, dict) or not {"care", "elapsedHours"}.issubset(data)
                    ):
                        errors.append(f"{key}/{case_id}: health advance needs care/elapsedHours")
                    if key == "health.treat" and (
                        not isinstance(data, dict) or "treatment" not in data
                    ):
                        errors.append(f"{key}/{case_id}: health treatment needs treatment")
                    if has_expected:
                        expected = case.get("expected")
                        if key == "health.terminal_risk":
                            if not isinstance(expected, dict) or (
                                set(expected) != {"terminal"}
                                or type(expected.get("terminal")) is not bool
                            ):
                                errors.append(f"{key}/{case_id}: invalid terminal risk result")
                        else:
                            record = (
                                expected.get("state")
                                if key == "health.treat" and isinstance(expected, dict)
                                else expected
                            )
                            fields = {"status", "neglectHours", "untreatedHours"}
                            valid_record = (
                                isinstance(record, dict)
                                and set(record) == fields
                                and record.get("status")
                                in {"healthy", "neglected", "sick", "critical"}
                                and all(
                                    type(record.get(field)) in (int, float)
                                    and record[field] >= 0
                                    for field in {"neglectHours", "untreatedHours"}
                                )
                            )
                            if not valid_record:
                                errors.append(f"{key}/{case_id}: invalid canonical health state")
                            if key == "health.treat" and (
                                not isinstance(expected, dict)
                                or set(expected) != {"state", "cost"}
                                or type(expected.get("cost")) is not int
                            ):
                                errors.append(f"{key}/{case_id}: invalid treatment result")
                if key == "pet.composite":
                    data = case.get("input")
                    allowed = {
                        "id", "pedigree", "potential", "care", "health",
                        "soulbound", "affection", "lifecycleActions", "actions",
                    }
                    if (
                        not isinstance(data, dict)
                        or not {"id", "pedigree"}.issubset(data)
                        or not set(data).issubset(allowed)
                        or not isinstance(data.get("id"), str)
                        or not isinstance(data.get("pedigree"), dict)
                    ):
                        errors.append(f"{key}/{case_id}: composite needs id and pedigree")
                    elif any(
                        name in data and not isinstance(data[name], dict)
                        for name in {"potential", "care", "health"}
                    ):
                        errors.append(f"{key}/{case_id}: composite states must be objects")
                    if isinstance(data, dict):
                        valid_ops = {
                            "withCare", "withHealth", "withFactors", "advanceHealth",
                            "treat", "gainAffection", "withAffection",
                            "withLifecycle", "endLife",
                        }
                        for name in ("actions", "lifecycleActions"):
                            sequence = data.get(name, [])
                            if not isinstance(sequence, list):
                                errors.append(f"{key}/{case_id}: {name} must be an array")
                            elif any(
                                not isinstance(action, dict)
                                or not isinstance(action.get("op"), str)
                                or (
                                    name == "actions"
                                    and action["op"] not in valid_ops
                                )
                                or (
                                    name == "lifecycleActions"
                                    and action["op"] not in {"advance", "endLife"}
                                )
                                for action in sequence
                            ):
                                errors.append(f"{key}/{case_id}: invalid composite action")
                    if has_expected:
                        expected = case.get("expected")
                        fields = {
                            "id", "pedigree", "lifecycle", "geneticPotential",
                            "expressedTraits", "careState", "healthState",
                            "soulbound", "affection", "active", "transferable",
                        }
                        if (
                            not isinstance(expected, dict)
                            or set(expected) not in [fields, fields | {"cost"}]
                            or any(type(expected[name]) is not bool for name in
                                   ("soulbound", "active", "transferable"))
                            or type(expected["affection"]) not in (int, float)
                            or not 0 <= expected["affection"] <= 1
                            or not isinstance(expected["pedigree"], dict)
                            or not isinstance(expected["lifecycle"], dict)
                            or not isinstance(expected["geneticPotential"], dict)
                            or not isinstance(expected["expressedTraits"], dict)
                            or not isinstance(expected["careState"], dict)
                            or not isinstance(expected["healthState"], dict)
                            or ("cost" in expected and type(expected["cost"]) is not int)
                        ):
                            errors.append(
                                f"{key}/{case_id}: composite needs canonical full snapshot"
                            )
                if key == "simulation_time.observe":
                    data = case.get("input")
                    if not isinstance(data, dict) or set(data) != {"lastObservedAt", "clockNow"}:
                        errors.append(f"{key}/{case_id}: time input requires lastObservedAt/clockNow")
                    if has_expected:
                        expected = case.get("expected")
                        names = {"rawNow", "logicalNow", "elapsed"}
                        if not isinstance(expected, dict) or set(expected) != names:
                            errors.append(f"{key}/{case_id}: time result must be canonical observation")
                        elif any(type(expected[k]) not in (int, float) for k in names):
                            errors.append(f"{key}/{case_id}: time result needs numeric timestamps")
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
