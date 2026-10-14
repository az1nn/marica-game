import unittest
from report_contract import choose_surface, tasks_filtered, validate

SRC = "https://github.com/az1nn/marica-game/blob/master/specs/007-skill-tree-simplification/tasks.md"
HEAD = "a" * 40

def snapshot():
    return {
        "schema_version": 1, "repository": "az1nn/marica-game",
        "branch": "refactor/spec-007-skill-tree-10", "head_sha": HEAD,
        "default_branch": "master", "default_head_sha": "b" * 40,
        "classification": "RESUME", "next_action": "Demo only, verify live state",
        "source_url": SRC, "demo": True,
        "tasks": [{"id": "O709", "title": "Interactive report", "status": "ACTIVE", "source_url": SRC},
                  {"id": "O710", "title": "Test fallback", "status": "PENDING", "source_url": SRC}],
        "gates": [{"name": "Validate skills", "status": "MISSING"}],
        "prs": [{"number": 93, "head_sha": HEAD,
                 "url": "https://github.com/az1nn/marica-game/pull/93"}],
        "evidence": [{"label": "SPEC-007", "url": SRC}],
    }

class InteractiveReportContractTest(unittest.TestCase):
    def test_valid_demo(self):
        self.assertEqual(validate(snapshot())["repository"], "az1nn/marica-game")
    def test_missing_base_head_forbidden(self):
        x = snapshot(); x.pop("default_head_sha")
        with self.assertRaises(ValueError): validate(x)
    def test_cross_repo_forbidden(self):
        x = snapshot(); x["repository"] = "az1nn/growing-rio"
        with self.assertRaises(ValueError): validate(x)
    def test_stale_pass_forbidden(self):
        x = snapshot(); x["gates"] = [{"name":"CI","status":"PASS","head_sha":"b"*40,"source_url":SRC}]
        with self.assertRaises(ValueError): validate(x)
    def test_missing_source_cannot_pass(self):
        x = snapshot(); x["gates"] = [{"name":"CI","status":"PASS","head_sha":HEAD}]
        with self.assertRaises(ValueError): validate(x)
    def test_filter_search(self):
        self.assertEqual([x["id"] for x in tasks_filtered(snapshot(),"ACTIVE","interactive")],["O709"])
        self.assertEqual(tasks_filtered(snapshot(),"DONE"),[])
    def test_native_surface_and_fallback(self):
        self.assertEqual(choose_surface(True, True), "INTERACTIVE")
        self.assertEqual(choose_surface(False, True), "VISUAL")
        self.assertEqual(choose_surface(False, False), "VISUAL_BLOCKED")
        self.assertEqual(choose_surface(True, True, True), "TEXT")
    def test_source_lock(self):
        x=snapshot();x["tasks"][0]["source_url"]="https://example.org"
        with self.assertRaises(ValueError): validate(x)

if __name__ == "__main__":
    unittest.main()
