import copy
import json
import unittest
from pathlib import Path

from validate_golden_fixtures import CATALOG, ROOT, validate


class GoldenFixtureSchemaTests(unittest.TestCase):
    def setUp(self):
        self.catalog = json.loads(CATALOG.read_text(encoding="utf-8"))

    def test_valid_versioned_catalog(self):
        self.assertEqual(validate(self.catalog, ROOT), [])

    def test_rejects_fake_executable_domain_parity(self):
        fixture = copy.deepcopy(self.catalog)
        fixture["contracts"][1]["status"] = "ACTIVE_SELFTEST"
        self.assertTrue(any("only harness.deep_equal" in e for e in validate(fixture)))

    def test_rejects_unsupported_implicit_pass(self):
        fixture = copy.deepcopy(self.catalog)
        fixture["contracts"][1]["status"] = "PARITY_PASS"
        self.assertTrue(any("unknown status" in e for e in validate(fixture)))

    def test_rejects_unauthorized_future_parity(self):
        fixture = copy.deepcopy(self.catalog)
        pending = next(c for c in fixture["contracts"] if c["id"] == "genetics.advance_potential")
        pending["status"] = "ACTIVE_PARITY"
        pending["adapter"] = "game/src/domain/pet_id.gd"
        self.assertTrue(any("not authorized" in e for e in validate(fixture)))

    def test_rejects_wrong_executable_adapter(self):
        fixture = copy.deepcopy(self.catalog)
        fixture["contracts"][1]["adapter"] = "game/tests/golden_fixture_runner.gd"
        self.assertTrue(any("incorrect parity milestone or adapter" in e for e in validate(fixture)))

    def test_rejects_future_time_parity(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "simulation_time.observe")
        contract["status"] = "ACTIVE_PARITY"
        contract["adapter"] = "game/src/domain/pedigree.gd"
        self.assertTrue(any("incorrect parity milestone or adapter" in e for e in validate(fixture)))

    def test_rejects_pedigree_adapter_swap(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "pedigree.create")
        contract["adapter"] = "game/src/domain/pet_id.gd"
        self.assertTrue(any("incorrect parity" in e for e in validate(fixture)))

    def test_rejects_pedigree_source_drift(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "pedigree.create")
        contract["source"] = "src/shared/domain/LineageId.luau"
        self.assertTrue(any("requires exact legacy source" in e for e in validate(fixture)))

    def test_rejects_pedigree_expected_partial_snapshot(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "pedigree.create")
        contract["cases"][0]["expected"].pop("parentPetIds")
        self.assertTrue(any("canonical snapshot" in e for e in validate(fixture)))

    def test_rejects_lifecycle_invalid_action(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "lifecycle.transitions")
        contract["cases"][0]["input"]["actions"] = [{"op": "rewind", "stage": "juvenile"}]
        self.assertTrue(any("unrecognized lifecycle action" in e for e in validate(fixture)))

    def test_rejects_lifecycle_partial_success(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "lifecycle.transitions")
        contract["cases"][0]["expected"].pop("terminal")
        self.assertTrue(any("canonical snapshot" in e for e in validate(fixture)))

    def test_rejects_lifecycle_wrong_source(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "lifecycle.transitions")
        contract["source"] = "src/shared/domain/Pedigree.luau"
        self.assertTrue(any("requires exact legacy source" in e for e in validate(fixture)))

    def test_rejects_time_wrong_source(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "simulation_time.observe")
        contract["source"] = "src/shared/domain/Lifecycle.luau"
        self.assertTrue(any("requires exact legacy source" in e for e in validate(fixture)))

    def test_rejects_time_incomplete_input(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "simulation_time.observe")
        contract["cases"][0]["input"].pop("clockNow")
        self.assertTrue(any("time input requires" in e for e in validate(fixture)))

    def test_rejects_time_partial_snapshot(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "simulation_time.observe")
        contract["cases"][0]["expected"].pop("elapsed")
        self.assertTrue(any("canonical observation" in e for e in validate(fixture)))

    def test_rejects_genetics_wrong_adapter(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "genetics.express")
        contract["adapter"] = "game/src/domain/lifecycle.gd"
        self.assertTrue(any("incorrect parity milestone or adapter" in e for e in validate(fixture)))

    def test_rejects_genetics_wrong_source(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "genetics.new_potential")
        contract["source"] = "src/shared/domain/Lifecycle.luau"
        self.assertTrue(any("requires exact legacy source" in e for e in validate(fixture)))

    def test_rejects_genetics_missing_potential(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "genetics.express")
        contract["cases"][0]["input"] = {"factors": {}}
        self.assertTrue(any("expression requires potential" in e for e in validate(fixture)))

    def test_rejects_genetics_out_of_range_expected(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "genetics.new_potential")
        contract["cases"][0]["expected"]["size"] = 9.0
        self.assertTrue(any("bounded trait map" in e for e in validate(fixture)))

    def test_rejects_genetics_wrong_success_shape(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "genetics.new_potential")
        contract["cases"][0]["expected"] = {"size": "1"}
        self.assertTrue(any("bounded trait map" in e for e in validate(fixture)))

    def test_requires_g430_genetic_advancement_pending(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "genetics.advance_potential")
        contract["status"] = "ACTIVE_PARITY"
        self.assertTrue(any("not authorized" in e for e in validate(fixture)))

    def test_rejects_care_wrong_adapter(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "care.quality")
        contract["adapter"] = "game/src/domain/genetics.gd"
        self.assertTrue(any("incorrect parity" in e for e in validate(fixture)))

    def test_rejects_care_wrong_source(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "care.create")
        contract["source"] = "src/shared/domain/Genetics.luau"
        self.assertTrue(any("requires exact legacy source" in e for e in validate(fixture)))

    def test_rejects_care_missing_genetic_potential(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(
            c for c in fixture["contracts"] if c["id"] == "care.expression_factors"
        )
        contract["cases"][0]["input"] = {"values": {"hunger": 0.5}}
        self.assertTrue(any("care factors need potential" in e for e in validate(fixture)))

    def test_rejects_care_partial_success_snapshot(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "care.create")
        contract["cases"][0]["expected"].pop("energy")
        self.assertTrue(any("normalized canonical result" in e for e in validate(fixture)))

    def test_rejects_care_out_of_bounds_quality(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "care.quality")
        contract["cases"][0]["expected"]["quality"] = 2
        self.assertTrue(any("normalized canonical result" in e for e in validate(fixture)))

    def test_rejects_health_wrong_source(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "health.advance")
        contract["source"] = "src/shared/domain/Care.luau"
        self.assertTrue(any("requires exact legacy source" in e for e in validate(fixture)))

    def test_rejects_health_invalid_snapshot(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "health.create")
        contract["cases"][0]["expected"].pop("untreatedHours")
        self.assertTrue(any("canonical health state" in e for e in validate(fixture)))

    def test_rejects_health_missing_elapsed(self):
        fixture = copy.deepcopy(self.catalog)
        contract = next(c for c in fixture["contracts"] if c["id"] == "health.advance")
        contract["cases"][0]["input"].pop("elapsedHours")
        self.assertTrue(any("health advance needs" in e for e in validate(fixture)))

    def test_rejects_missing_provenance(self):
        fixture = copy.deepcopy(self.catalog)
        fixture["contracts"][1]["source"] = "../../foreign-repo/README.md"
        self.assertTrue(any("provenance" in e for e in validate(fixture)))

    def test_rejects_duplicate_case(self):
        fixture = copy.deepcopy(self.catalog)
        fixture["contracts"][0]["cases"].append(copy.deepcopy(fixture["contracts"][0]["cases"][0]))
        self.assertTrue(any("duplicate case" in e for e in validate(fixture)))

    def test_rejects_conflicting_expectation(self):
        fixture = copy.deepcopy(self.catalog)
        fixture["contracts"][1]["cases"][0]["expected_error"] = "unexpected"
        self.assertTrue(any("exactly one" in e for e in validate(fixture)))

    def test_rejects_empty_executable_suite(self):
        fixture = copy.deepcopy(self.catalog)
        fixture["contracts"] = fixture["contracts"][1:]
        self.assertTrue(any("executable harness" in e for e in validate(fixture)))

    def test_rejects_schema_drift(self):
        fixture = copy.deepcopy(self.catalog)
        fixture["schema_version"] = 99
        self.assertTrue(any("schema_version" in e for e in validate(fixture)))


if __name__ == "__main__":
    unittest.main()
