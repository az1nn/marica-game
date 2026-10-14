#!/usr/bin/env python3
"""SPEC-004 G440: structural & cross-record proof for offline animal save v1.

Not a SaveStore/load implementation and not a Godot runtime test.
Requires jsonschema==4.26.0, installed by the dedicated exact-head workflow.
"""
from __future__ import annotations

from copy import deepcopy
import json
from pathlib import Path

from jsonschema import Draft202012Validator, ValidationError

ROOT = Path(__file__).resolve().parents[2]
SCHEMA = ROOT / "game/docs/save-schema-v1.schema.json"
FIXTURES = ROOT / "game/tests/fixtures"
NAMES = ("save_v1_minimal.json", "save_v1_founder.json", "save_v1_succession.json")
SAFE_INT = 9007199254740991


def assert_semantics(document: dict) -> None:
    pets = document["pets"]
    events = document["succession_events"]
    for pet_id, pet in pets.items():
        assert pet["id"] == pet_id, "Pet map key differs from immutable ID"
        ped = pet["pedigree"]
        assert set(pet["geneticPotential"]) == set(pet["expressedTraits"]), "Trait keys changed on save"
        for key, expressed in pet["expressedTraits"].items():
            assert expressed <= pet["geneticPotential"][key] + 1e-10, "Expressed > potential"
        assert (ped["generation"] == 0) == (not ped["parentPetIds"]), "Founder/parent cardinality mismatch"
        if ped["generation"] > 0:
            assert not pet["soulbound"], "Descendant inherited founder soulbound"
        for direct_parent in ped["parentPetIds"]:
            assert direct_parent in pets, "Pedigree parent lost from historical archive"
            preceding = pets[direct_parent]["pedigree"]
            assert preceding["lineageId"] == ped["lineageId"], "Lineage drift"
            assert preceding["generation"] < ped["generation"], "Pedigree generation cycle"
            assert preceding["founderPetId"] == ped["founderPetId"], "Founder ancestry drift"
        assert ped["founderPetId"] in pets, "Founder archive missing"
        founder = pets[ped["founderPetId"]]
        assert founder["pedigree"]["generation"] == 0, "Founder entry is not generation zero"
        assert founder["pedigree"]["lineageId"] == ped["lineageId"], "Founder lineage drift"

    all_successors = set()
    for parent_id, marker in events.items():
        assert parent_id in pets, "Event parent was not preserved"
        parent = pets[parent_id]
        assert parent["lifecycle"]["status"] == "ended", "Event parent is not terminal"
        assert marker["parent_snapshot"] == parent, "Event replay parent snapshot drift"
        assert marker["succession_seed"] <= SAFE_INT, "Succession seed exceeds safe integer"
        for child_id in marker["successor_ids"]:
            assert child_id not in all_successors, "Successor ID claimed by multiple events"
            all_successors.add(child_id)
            assert child_id != parent_id, "Parent reused as own successor"
            assert child_id in pets, "Completed marker without successor snapshot"
            child = pets[child_id]
            child_ped = child["pedigree"]
            parent_ped = parent["pedigree"]
            assert child_ped["parentPetIds"] == [parent_id], "Direct parent not preserved"
            assert child_ped["generation"] == parent_ped["generation"] + 1, "Wrong successor generation"
            assert child_ped["lineageId"] == parent_ped["lineageId"], "Successor lineage drift"
            assert child_ped["founderPetId"] == parent_ped["founderPetId"], "Successor founder drift"


def expect_invalid_schema(validator: Draft202012Validator, item: dict) -> None:
    try:
        validator.validate(item)
    except ValidationError:
        return
    raise AssertionError("Schema accepted intentionally corrupted fixture")


def expect_invalid_semantics(validator: Draft202012Validator, item: dict) -> None:
    validator.validate(item)
    try:
        assert_semantics(item)
    except AssertionError:
        return
    raise AssertionError("Cross-record guard accepted intentionally corrupted fixture")


def main() -> None:
    schema = json.loads(SCHEMA.read_text(encoding="utf-8"))
    Draft202012Validator.check_schema(schema)
    validator = Draft202012Validator(schema)
    samples = {}
    for name in NAMES:
        doc = json.loads((FIXTURES / name).read_text(encoding="utf-8"))
        validator.validate(doc)
        assert_semantics(doc)
        samples[name] = doc

    full = samples["save_v1_succession.json"]
    negative = deepcopy(full)
    negative["schema_version"] = 2
    expect_invalid_schema(validator, negative)
    negative = deepcopy(full)
    negative["revision"] = -1
    expect_invalid_schema(validator, negative)
    negative = deepcopy(full)
    negative["last_observed_at"] = -100
    expect_invalid_schema(validator, negative)
    negative = deepcopy(full)
    negative["succession_events"]["pet-founder-001"]["successor_ids"][1] = "pet-child-001"
    expect_invalid_schema(validator, negative)
    negative = deepcopy(full)
    negative["pets"]["pet-founder-001"]["lifecycle"].pop("endReason")
    expect_invalid_schema(validator, negative)
    negative = deepcopy(full)
    negative["pets"]["pet-child-001"]["id"] = "forged-id"
    expect_invalid_semantics(validator, negative)
    negative = deepcopy(full)
    negative["succession_events"]["pet-founder-001"]["successor_ids"][1] = "missing-child"
    expect_invalid_semantics(validator, negative)
    negative = deepcopy(full)
    negative["succession_events"]["pet-founder-001"]["parent_snapshot"]["affection"] = 0.3
    expect_invalid_semantics(validator, negative)
    negative = deepcopy(full)
    negative["pets"]["pet-child-002"]["soulbound"] = True
    expect_invalid_semantics(validator, negative)
    print("MARICA_G440_SCHEMA_PASS samples=3 negative=9 cross_record=PASS engine=NOT_RUN")


if __name__ == "__main__":
    main()
