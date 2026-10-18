#!/usr/bin/env python3
"""QA-001 Q804: fail-closed staging and HTTPS verification of immutable Godot Web exports.

Never deploys or claims public hosting. Requires the source exact-head CI manifest.
"""
import argparse
import hashlib
import json
import re
import shutil
from pathlib import Path
from urllib.parse import urlparse
from urllib.request import Request, urlopen

SHA_PATTERN = re.compile(r"[0-9a-f]{40}\Z")
HASH_PATTERN = re.compile(r"[0-9a-f]{64}\Z")
REQUIRED = {"index.html", "index.wasm", "index.pck"}
PROVENANCE = "qa001-provenance.json"


class GateError(ValueError):
    """An integrity, provenance, or hosted-runtime gate failed."""


def digest(data):
    return hashlib.sha256(data).hexdigest()


def read_json(path):
    return json.loads(Path(path).read_text(encoding="utf-8"))


def export_file(source, name):
    """Upload-artifact may preserve the qa001-export subdirectory."""
    root = Path(source)
    direct = root / name
    nested = root / "qa001-export" / name
    return direct if direct.is_file() else nested


def validate(source, source_sha):
    source = Path(source)
    if not SHA_PATTERN.fullmatch(source_sha):
        raise GateError("source SHA must be a complete Git commit SHA")
    manifest_path = source / "manifest.json"
    if not manifest_path.is_file():
        manifest_path = source / "qa001-browser" / "manifest.json"
    manifest = read_json(manifest_path)
    if manifest.get("task") != "QA-001" or manifest.get("head_sha") != source_sha:
        raise GateError("wrong task or artifact source SHA")
    if manifest.get("godot") != "4.7.2-stable":
        raise GateError("unapproved engine version")
    if manifest.get("web_assembly_booted") is not True:
        raise GateError("source browser-boot evidence missing")
    if manifest.get("public_hosted") is not False:
        raise GateError("source artifact incorrectly claims publication")
    if manifest.get("artist_runtime_approved") is not False:
        raise GateError("source artifact incorrectly claims visual acceptance")
    exports = manifest.get("export")
    if not isinstance(exports, dict) or not REQUIRED.issubset(exports):
        raise GateError("required Godot Web exports missing")
    for name, entry in exports.items():
        if not isinstance(name, str) or not name or name != Path(name).name or name.startswith("."):
            raise GateError("unsafe export filename")
        if name == PROVENANCE or name == "manifest.json":
            raise GateError("reserved export filename")
        if not isinstance(entry, dict):
            raise GateError("invalid export entry")
        wanted_hash, wanted_bytes = entry.get("sha256"), entry.get("bytes")
        if not isinstance(wanted_hash, str) or not HASH_PATTERN.fullmatch(wanted_hash):
            raise GateError("invalid export SHA-256")
        if type(wanted_bytes) is not int or wanted_bytes <= 0:
            raise GateError("invalid export byte count")
        path = export_file(source, name)
        if not path.is_file() or path.is_symlink():
            raise GateError("export missing or symbolic link")
        raw = path.read_bytes()
        if len(raw) != wanted_bytes or digest(raw) != wanted_hash:
            raise GateError("export hash/size mismatch: " + name)
    return manifest


def stage(source, output, source_sha, run_id):
    if type(run_id) is not int or run_id <= 0:
        raise GateError("invalid immutable source run id")
    manifest = validate(source, source_sha)
    source, output = Path(source).resolve(), Path(output).resolve()
    if output == source or source in output.parents or output in source.parents:
        raise GateError("site output must not overlap the source artifact")
    output.mkdir(parents=True, exist_ok=True)
    if any(output.iterdir()):
        raise GateError("refusing to overwrite nonempty staging directory")
    for name in manifest["export"]:
        shutil.copyfile(export_file(source, name), output / name)
    provenance = {
        "schema_version": 1,
        "task": "QA-001",
        "source_sha": source_sha,
        "source_run_id": run_id,
        "engine": manifest["godot"],
        "export": manifest["export"],
        "published": False,
        "human_qa_accepted": False,
        "scope": "isolated V206 technical composition, not gameplay or production",
    }
    (output / PROVENANCE).write_text(
        json.dumps(provenance, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    verify(output, source_sha)
    print("QA001_HOST_STAGING_PASS source=" + source_sha + " public=false")


def verify(site, source_sha):
    site = Path(site)
    data = read_json(site / PROVENANCE)
    if data.get("source_sha") != source_sha or not SHA_PATTERN.fullmatch(source_sha):
        raise GateError("staging source SHA mismatch")
    if data.get("task") != "QA-001" or data.get("published") is not False:
        raise GateError("incorrect staging provenance/status")
    exports = data.get("export")
    if not isinstance(exports, dict) or not REQUIRED.issubset(exports):
        raise GateError("staging exports missing")
    if set(p.name for p in site.iterdir()) != set(exports) | {PROVENANCE}:
        raise GateError("unexpected staging files")
    for name, info in exports.items():
        if name != Path(name).name or name.startswith("."):
            raise GateError("unsafe staging filename")
        path = site / name
        if not path.is_file() or path.is_symlink():
            raise GateError("staging file unavailable")
        raw = path.read_bytes()
        if len(raw) != info.get("bytes") or digest(raw) != info.get("sha256"):
            raise GateError("staging bytes not identical: " + name)
    return data


def https_base(url):
    parts = urlparse(url)
    if (parts.scheme != "https" or not parts.hostname or parts.username or
            parts.password or parts.query or parts.fragment or parts.port not in (None, 443)):
        raise GateError("HTTPS URL must be public, uncredentialed, and query-free")
    if ".." in parts.path.split("/"):
        raise GateError("invalid HTTPS URL path")
    return url.rstrip("/") + "/"


def remote_bytes(url):
    req = Request(url, headers={"User-Agent": "Marica-QA001-Hash-Gate/1.0"})
    with urlopen(req, timeout=90) as response:
        if response.status != 200:
            raise GateError("public origin returned HTTP " + str(response.status))
        return response.read()


def smoke(site, source_sha, url, output):
    prov = verify(site, source_sha)
    base = https_base(url)
    remote_prov = json.loads(remote_bytes(base + PROVENANCE).decode("utf-8"))
    if remote_prov != prov:
        raise GateError("public host provenance differs from exact source artifact")
    for name, info in prov["export"].items():
        raw = remote_bytes(base + name)
        if len(raw) != info["bytes"] or digest(raw) != info["sha256"]:
            raise GateError("hosted bytes differ: " + name)

    # A matching asset bundle does not prove that the Godot engine actually boots.
    from playwright.sync_api import sync_playwright
    output = Path(output)
    output.mkdir(parents=True, exist_ok=True)
    captures = []
    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(
            channel="chrome", headless=True,
            args=["--no-sandbox", "--disable-dev-shm-usage",
                  "--enable-webgl", "--enable-unsafe-swiftshader",
                  "--use-gl=angle", "--use-angle=swiftshader"])
        try:
            for case, width, height, dpr, mobile in (
                ("mobile-emulated", 390, 844, 2, True),
                ("desktop", 1280, 960, 1, False),
            ):
                context = browser.new_context(
                    viewport={"width": width, "height": height},
                    device_scale_factor=dpr, is_mobile=mobile, has_touch=mobile)
                try:
                    page = context.new_page()
                    errors = []
                    page.on("pageerror", lambda err: errors.append(str(err)))
                    result = page.goto(base + "index.html", wait_until="domcontentloaded", timeout=45000)
                    if result is None or result.status != 200:
                        raise GateError("hosted game HTML not accessible")
                    page.wait_for_function("window.__MARICA_QA_GODOT_READY === true", timeout=90000)
                    canvas = page.evaluate("""() => {
                        const c = document.querySelector('canvas');
                        return c ? [c.width, c.height] : null;
                    }""")
                    if not canvas or min(canvas) < 10 or errors:
                        raise GateError("hosted Godot boot/canvas/JS error")
                    shot = output / (case + ".png")
                    page.screenshot(path=str(shot))
                    captures.append({"case": case, "canvas": canvas, "screenshot_sha256": digest(shot.read_bytes()), "mobile_emulated": mobile, "physical_device": False})
                finally:
                    context.close()
        finally:
            browser.close()
    (output / "host-smoke.json").write_text(
        json.dumps({"source_sha": source_sha, "url": base, "boot": True,
                    "human_qa_accepted": False, "physical_device_tested": False,
                    "captures": captures}, indent=2) + "\n", encoding="utf-8")
    print("QA001_PUBLIC_HTTPS_BOOT_PASS source=" + source_sha + " human=false")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    s = sub.add_parser("stage")
    s.add_argument("--artifact", required=True)
    s.add_argument("--site", required=True)
    s.add_argument("--source-sha", required=True)
    s.add_argument("--source-run-id", type=int, required=True)
    v = sub.add_parser("verify")
    v.add_argument("--site", required=True)
    v.add_argument("--source-sha", required=True)
    h = sub.add_parser("smoke")
    h.add_argument("--site", required=True)
    h.add_argument("--source-sha", required=True)
    h.add_argument("--url", required=True)
    h.add_argument("--output", required=True)
    args = parser.parse_args()
    try:
        if args.command == "stage":
            stage(args.artifact, args.site, args.source_sha, args.source_run_id)
        elif args.command == "verify":
            verify(args.site, args.source_sha)
            print("QA001_SITE_HASH_PASS")
        else:
            smoke(args.site, args.source_sha, args.url, args.output)
    except (GateError, ValueError, OSError, KeyError, TypeError) as err:
        parser.exit(status=1, message="QA001_GATE_FAIL: " + str(err) + "\n")


if __name__ == "__main__":
    main()
