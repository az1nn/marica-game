#!/usr/bin/env python3
"""Deterministic QA-001 host qualification tests, including GOOD→BAD→RESTORE."""
import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from qa_https_gate import GateError, https_base, stage, validate, verify

SOURCE_SHA = "8edfec42f8499b8818fc03c9415ef59abd23518b"


class HostGateTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        root = Path(self.tmp.name)
        self.source = root / "original"
        self.site = root / "site"
        self.source.mkdir()
        exports = {}
        for name, data in (
            ("index.html", b"<!doctype html><canvas></canvas>"),
            ("index.wasm", b"\x00asm QA TEST"),
            ("index.pck", b"TEST PCK"),
            ("index.js", b"console.log('qa');"),
        ):
            (self.source / name).write_bytes(data)
            exports[name] = {
                "sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data)}
        self.manifest = {
            "task": "QA-001", "head_sha": SOURCE_SHA,
            "godot": "4.7.2-stable", "web_assembly_booted": True,
            "public_hosted": False, "artist_runtime_approved": False,
            "export": exports,
        }
        (self.source / "manifest.json").write_text(json.dumps(self.manifest))

    def test_exact_bytes_good_bad_restore(self):
        stage(self.source, self.site, SOURCE_SHA, 39148569671)
        self.assertEqual(verify(self.site, SOURCE_SHA)["source_sha"], SOURCE_SHA)
        # BAD MUTANT: flip a byte after staging, preserving size.
        original = (self.site / "index.wasm").read_bytes()
        (self.site / "index.wasm").write_bytes(b"X" + original[1:])
        with self.assertRaisesRegex(GateError, "not identical"):
            verify(self.site, SOURCE_SHA)
        (self.site / "index.wasm").write_bytes(original)
        self.assertEqual(verify(self.site, SOURCE_SHA)["source_sha"], SOURCE_SHA)

    def test_source_wrong_sha_is_rejected(self):
        with self.assertRaisesRegex(GateError, "source SHA"):
            validate(self.source, "0" * 40)

    def test_source_corruption_rejected(self):
        (self.source / "index.pck").write_bytes(b"tampered")
        with self.assertRaisesRegex(GateError, "hash/size mismatch"):
            validate(self.source, SOURCE_SHA)

    def test_wrong_metadata_rejected(self):
        self.manifest["public_hosted"] = True
        (self.source / "manifest.json").write_text(json.dumps(self.manifest))
        with self.assertRaisesRegex(GateError, "incorrectly claims publication"):
            validate(self.source, SOURCE_SHA)

    def test_http_and_credentialed_urls_rejected(self):
        for url in ("http://example.com", "https://user:pass@example.com",
                    "https://example.com/../qa", "https://example.com/?token=foo"):
            with self.subTest(url=url), self.assertRaises(GateError):
                https_base(url)
        self.assertEqual(https_base("https://example.com/qa"), "https://example.com/qa/")

    def test_overwrite_refused(self):
        stage(self.source, self.site, SOURCE_SHA, 39148569671)
        with self.assertRaisesRegex(GateError, "nonempty"):
            stage(self.source, self.site, SOURCE_SHA, 39148569671)

    def test_no_extra_files_on_deploy(self):
        stage(self.source, self.site, SOURCE_SHA, 39148569671)
        (self.site / "not-from-export.txt").write_text("injected")
        with self.assertRaisesRegex(GateError, "unexpected staging"):
            verify(self.site, SOURCE_SHA)


if __name__ == "__main__":
    unittest.main()
