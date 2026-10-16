#!/usr/bin/env python3
"""Run an *exported Godot WebAssembly probe* in hosted desktop Chrome.

Only Chrome on a Linux runner and a mobile viewport emulation are measured.
NEVER interpret this as physical Android/iOS or a production-game FPS pass.
"""
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

from PIL import Image
from playwright.sync_api import sync_playwright

CASES = (
    ("desktop-godot-web", 1280, 960, 1, False),
    ("mobile-emulated-godot-web", 390, 844, 2, True),
)


class QuietHandler(SimpleHTTPRequestHandler):
    def log_message(self, fmt: str, *args: object) -> None:
        pass


def inspect_capture(path: Path, width: int, height: int) -> dict:
    data = path.read_bytes()
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise AssertionError("Godot web artifact is not a PNG")
    if struct.unpack(">II", data[16:24]) != (width, height):
        raise AssertionError("Godot web screenshot geometry mismatch")
    with Image.open(path) as raw:
        pixels = raw.convert("RGB")
        colors = set()
        for y in range(8, height, max(8, height // 45)):
            for x in range(8, width, max(8, width // 45)):
                colors.add(pixels.getpixel((x, y)))
    if len(colors) < 8:
        raise AssertionError("Godot scene appears flat/empty")
    return {
        "png_sha256": hashlib.sha256(data).hexdigest(),
        "png_bytes": len(data),
        "informative_sample_colors": len(colors),
    }


def execute(web_dir: Path, output: Path, head_sha: str) -> dict:
    if not re.fullmatch(r"[0-9a-f]{40}", head_sha):
        raise ValueError("Expected exact Git head SHA")
    if not (web_dir / "index.html").is_file():
        raise AssertionError("Godot Web export is missing")
    output.mkdir(parents=True, exist_ok=True)

    handler = partial(QuietHandler, directory=str(web_dir))
    server = ThreadingHTTPServer(("127.0.0.1", 0), handler)
    threading.Thread(target=server.serve_forever, daemon=True).start()
    url = f"http://127.0.0.1:{server.server_port}/index.html"
    captures = []
    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch(
                channel="chrome",
                headless=True,
                args=[
                    "--no-sandbox",
                    "--disable-dev-shm-usage",
                    "--enable-webgl",
                    "--enable-unsafe-swiftshader",
                    "--use-gl=angle",
                    "--use-angle=swiftshader",
                ],
            )
            try:
                version = browser.version
                for name, width, height, dpr, mobile in CASES:
                    context = browser.new_context(
                        viewport={"width": width, "height": height},
                        device_scale_factor=dpr,
                        is_mobile=mobile,
                        has_touch=mobile,
                    )
                    try:
                        page = context.new_page()
                        page_errors: list[str] = []
                        page.on("pageerror", lambda error: page_errors.append(str(error)))
                        response = page.goto(url, wait_until="domcontentloaded", timeout=45000)
                        if response is None or response.status != 200:
                            raise AssertionError("Godot Web export not served over HTTP")
                        page.wait_for_function(
                            "window.__MARICA_ARCH_V201_GODOT_READY === true",
                            timeout=90000,
                        )
                        page.wait_for_timeout(2000)
                        gl_info = page.evaluate(
                            """() => {
                                const canvas = document.querySelector('canvas');
                                return {
                                    exists: !!canvas,
                                    width: canvas ? canvas.width : 0,
                                    height: canvas ? canvas.height : 0,
                                    browser_dpr: devicePixelRatio,
                                    canvas_count: document.querySelectorAll('canvas').length,
                                    user_agent: navigator.userAgent
                                };
                            }"""
                        )
                        if not gl_info["exists"] or gl_info["width"] < 10:
                            raise AssertionError("Godot WebGL canvas missing after runtime ready")
                        if gl_info["browser_dpr"] != dpr:
                            raise AssertionError("Godot browser device pixel ratio mismatch")
                        raf = page.evaluate(
                            """async () => {
                                const frames = [];
                                let prev = null;
                                for (let i = 0; i < 90; i++) {
                                    await new Promise(resolve => requestAnimationFrame(now => {
                                        if (prev !== null) frames.push(now - prev);
                                        prev = now;
                                        resolve();
                                    }));
                                }
                                frames.sort((a, b) => a - b);
                                return {
                                    samples: frames.length,
                                    p50_ms: frames[Math.floor((frames.length - 1) * .5)],
                                    p95_ms: frames[Math.floor((frames.length - 1) * .95)],
                                    over_34_ms: frames.filter(x => x > 34).length
                                };
                            }"""
                        )
                        if raf["samples"] != 89 or raf["p95_ms"] <= 0:
                            raise AssertionError("No real browser RAF observations")
                        screenshot = output / f"{name}.png"
                        page.screenshot(path=str(screenshot))
                        inspected = inspect_capture(screenshot, width * dpr, height * dpr)
                        captures.append(
                            {
                                "name": name,
                                "viewport_css": [width, height],
                                "device_pixel_ratio": dpr,
                                "mobile_viewport_emulated": mobile,
                                "physical_mobile_device": False,
                                "engine_webassembly_runtime_ready": True,
                                "file": screenshot.name,
                                "webgl_canvas": gl_info,
                                "raf": raf,
                                "page_errors": page_errors,
                                **inspected,
                            }
                        )
                    finally:
                        context.close()
            finally:
                browser.close()
    finally:
        server.shutdown()
        server.server_close()

    if len(captures) != len(CASES):
        raise AssertionError("Godot Web missing test cases")
    result = {
        "schema_version": 1,
        "repository": "az1nn/marica-game",
        "task": "SPEC-005 V201",
        "head_sha": head_sha,
        "runtime": "REAL Godot 4.7.2 WebAssembly/WebGL2 in hosted desktop Chrome",
        "browser_version": version,
        "godot_web_export_executed": True,
        "physical_android_or_ios_executed": False,
        "mobile_case_emulated": True,
        "fps_release_gate": "NOT_CERTIFIED",
        "art_review": "NOT_EVALUATED",
        "raf_scope": "Browser RAF cadence; NOT instrumented Godot engine frame time or physical GPU",
        "captures": captures,
    }
    (output / "manifest.json").write_text(
        json.dumps(result, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    for item in captures:
        print(
            f"MARICA_V201_GODOT_WEB_SAMPLE name={item['name']} "
            f"raf_p95_ms={item['raf']['p95_ms']:.2f} "
            f"colors={item['informative_sample_colors']} "
            "physical_device=false"
        )
    print(
        f"MARICA_V201_GODOT_WEB_PASS head={head_sha} "
        "cases=2 physical_mobile=false art_accept=false"
    )
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--web-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--head-sha", required=True)
    options = parser.parse_args()
    execute(options.web_dir, options.output, options.head_sha)
