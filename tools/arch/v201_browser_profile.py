#!/usr/bin/env python3
"""SPEC-005 V201: real Chrome browser Canvas2D proxy, NEVER device/Godot runtime PASS."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import struct
import threading
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

from playwright.sync_api import sync_playwright


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "game/assets/arch_probes/S01_A01_v4_original.png"
SHA256 = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"
BLOB = "da7806ebfcb051c8fd32ccdbad4760b7136f97dd"
CONFIGS = (
    ("mobile-dark-half-nearest", 390, 844, 2, True, 0.5, "nearest", "#14242b"),
    ("mobile-dark-fractional-nearest", 390, 844, 2, True, 1.25, "nearest", "#14242b"),
    ("mobile-dark-fractional-linear", 390, 844, 2, True, 1.25, "linear", "#14242b"),
    ("mobile-light-unit-nearest", 432, 768, 1, True, 1, "nearest", "#eee0c4"),
    ("desktop-dark-double-nearest", 1280, 960, 1, False, 2, "nearest", "#14242b"),
    ("desktop-dark-double-linear", 1280, 960, 1, False, 2, "linear", "#14242b"),
)


class QuietHandler(SimpleHTTPRequestHandler):
    def log_message(self, fmt: str, *args: object) -> None:
        pass


def image_size(data: bytes) -> tuple[int, int]:
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise AssertionError("Browser artifact is not a PNG")
    return struct.unpack(">II", data[16:24])


def run(output: Path, head_sha: str) -> dict:
    if not re.fullmatch(r"[0-9a-f]{40}", head_sha):
        raise ValueError("Expected an exact 40-character Git commit SHA")
    if hashlib.sha256(SOURCE.read_bytes()).hexdigest() != SHA256:
        raise AssertionError("Approved V4 PNG was modified")
    output.mkdir(parents=True, exist_ok=True)

    handler = partial(QuietHandler, directory=str(ROOT))
    server = ThreadingHTTPServer(("127.0.0.1", 0), handler)
    server_thread = threading.Thread(target=server.serve_forever, daemon=True)
    server_thread.start()
    url = f"http://127.0.0.1:{server.server_port}/tools/arch/v201_browser_probe.html"
    evidence = []
    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch(
                channel="chrome",
                headless=True,
                args=["--no-sandbox", "--disable-dev-shm-usage"],
            )
            try:
                version = browser.version
                for name, width, height, dpr, mobile, scale, sampling, color in CONFIGS:
                    context = browser.new_context(
                        viewport={"width": width, "height": height},
                        device_scale_factor=dpr,
                        is_mobile=mobile,
                        has_touch=mobile,
                    )
                    try:
                        page = context.new_page()
                        response = page.goto(url, wait_until="load", timeout=30000)
                        if response is None or response.status != 200:
                            raise AssertionError("Browser profile page unavailable")
                        options = {
                            "width": width,
                            "height": height,
                            "scale": scale,
                            "sampling": sampling,
                            "background": color,
                        }
                        metrics = page.evaluate("(opts) => window.v201.run(opts)", options)
                        if metrics["source_pixels"] != [344, 378]:
                            raise AssertionError("Browser loaded an unexpected source")
                        if metrics["canvas_image_smoothing"] != (sampling == "linear"):
                            raise AssertionError("Browser sampling control was not applied")
                        if metrics["touch_emulation"] != mobile:
                            raise AssertionError("Touch emulation mismatch")
                        if metrics["raf_samples"] != 89 or metrics["informative_grid_samples"] < 8:
                            raise AssertionError("Missing browser RAF/render evidence")
                        screenshot = output / f"{name}.png"
                        page.locator("#evidence").screenshot(path=str(screenshot))
                        data = screenshot.read_bytes()
                        if image_size(data) != (width * dpr, height * dpr):
                            raise AssertionError("Browser screenshot dimensions mismatch")
                        evidence.append(
                            {
                                "name": name,
                                "file": screenshot.name,
                                "png_sha256": hashlib.sha256(data).hexdigest(),
                                "png_bytes": len(data),
                                "viewport_css": [width, height],
                                "screenshot_pixels": [width * dpr, height * dpr],
                                "device_pixel_ratio": dpr,
                                "touch_and_mobile_viewport_emulation": mobile,
                                "real_mobile_hardware": False,
                                "scale": scale,
                                "sampling": sampling,
                                "background": color,
                                "metrics": metrics,
                            }
                        )
                    finally:
                        context.close()
            finally:
                browser.close()
    finally:
        server.shutdown()
        server.server_close()

    unique = {entry["png_sha256"] for entry in evidence}
    if len(evidence) != 6 or len(unique) < 5:
        raise AssertionError("Browser raster evidence missing or duplicated")
    for left, right in (
        ("mobile-dark-fractional-nearest", "mobile-dark-fractional-linear"),
        ("desktop-dark-double-nearest", "desktop-dark-double-linear"),
    ):
        a = next(x for x in evidence if x["name"] == left)
        b = next(x for x in evidence if x["name"] == right)
        if a["png_sha256"] == b["png_sha256"]:
            raise AssertionError(f"Nearest/linear comparison is identical: {left}")

    result = {
        "schema_version": 1,
        "task": "SPEC-005 V201/V201a",
        "repository": "az1nn/marica-game",
        "head_sha": head_sha,
        "source_sha256": SHA256,
        "source_git_blob": BLOB,
        "browser_version": version,
        "runtime": "Chrome Canvas2D browser proxy; NOT a Godot web export",
        "real_desktop_chromium_executed": True,
        "mobile_viewport_touch_emulation_executed": True,
        "physical_android_or_ios_executed": False,
        "godot_web_export_executed": False,
        "real_device_fps_certified": False,
        "art_or_production_acceptance": "NOT_EVALUATED",
        "raf_timing_scope": "Chrome RAF intervals on hosted Linux desktop, not Godot game frame times",
        "captures": evidence,
    }
    (output / "manifest.json").write_text(
        json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(
        "MARICA_V201_CHROME_PROXY_PASS "
        f"images={len(evidence)} head={head_sha} "
        "real_device=false godot_web_export=false"
    )
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--head-sha", required=True)
    args = parser.parse_args()
    run(args.output, args.head_sha)
