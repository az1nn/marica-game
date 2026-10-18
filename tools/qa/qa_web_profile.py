#!/usr/bin/env python3
"""QA-001 real Godot WebAssembly test. Chrome mobile case is emulated, not physical."""
import argparse
import hashlib
import json
import re
import threading
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

from PIL import Image
from playwright.sync_api import sync_playwright


class Handler(SimpleHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def inspect(path, width, height):
    with Image.open(path) as im:
        assert im.size == (width, height), "screenshot dimensions do not match viewport"
        rgb = im.convert("RGB")
        colors = {
            rgb.getpixel((x, y))
            for y in range(5, height, max(8, height // 35))
            for x in range(5, width, max(8, width // 35))
        }
    assert len(colors) >= 8, "blank or noninformative rendering"
    return len(colors)


def run(web_dir, output, head):
    assert re.fullmatch("[0-9a-f]{40}", head), "exact Git commit required"
    for name in ("index.html", "index.wasm", "index.pck"):
        assert (web_dir / name).is_file() and (web_dir / name).stat().st_size, name
    output.mkdir(parents=True, exist_ok=True)
    server = ThreadingHTTPServer(
        ("127.0.0.1", 0), partial(Handler, directory=str(web_dir))
    )
    threading.Thread(target=server.serve_forever, daemon=True).start()
    captures = []
    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch(
                channel="chrome", headless=True,
                args=["--no-sandbox", "--disable-dev-shm-usage",
                      "--enable-webgl", "--enable-unsafe-swiftshader",
                      "--use-gl=angle", "--use-angle=swiftshader"])
            try:
                for name, w, h, dpr, mobile in (
                    ("portrait-emulated", 390, 844, 2, True),
                    ("desktop", 1280, 960, 1, False),
                ):
                    ctx = browser.new_context(
                        viewport={"width": w, "height": h},
                        device_scale_factor=dpr, is_mobile=mobile, has_touch=mobile)
                    try:
                        page = ctx.new_page()
                        errors = []
                        page.on("pageerror", lambda err: errors.append(str(err)))
                        result = page.goto(
                            f"http://127.0.0.1:{server.server_port}/index.html",
                            wait_until="domcontentloaded", timeout=45000)
                        assert result is not None and result.status == 200
                        page.wait_for_function(
                            "window.__MARICA_QA_GODOT_READY === true",
                            timeout=90000)
                        canvas = page.evaluate("""() => {
                            const c = document.querySelector('canvas');
                            return c ? [c.width, c.height] : null;
                        }""")
                        assert canvas and min(canvas) >= 10, "real Godot canvas missing"
                        assert not errors, f"JavaScript errors: {errors}"
                        page.wait_for_timeout(1000)
                        screenshot = output / (name + ".png")
                        page.screenshot(path=str(screenshot))
                        colors = inspect(screenshot, w * dpr, h * dpr)
                        captures.append({
                            "case": name, "viewport_css": [w, h],
                            "dpr": dpr, "mobile_emulation": mobile,
                            "physical_device": False, "ready_marker": True,
                            "canvas_px": canvas, "png": screenshot.name,
                            "png_sha256": sha(screenshot), "sample_colors": colors,
                        })
                    finally:
                        ctx.close()
            finally:
                browser.close()
    finally:
        server.shutdown()
        server.server_close()
    manifest = {
        "task": "QA-001", "head_sha": head, "godot": "4.7.2-stable",
        "web_assembly_booted": True, "physical_device_tested": False,
        "gameplay_approved": False, "artist_runtime_approved": False,
        "public_hosted": False,
        "original_png_sha256":
            "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e",
        "export": {
            p.name: {"bytes": p.stat().st_size, "sha256": sha(p)}
            for p in sorted(web_dir.iterdir()) if p.is_file()
        },
        "captures": captures,
    }
    (output / "manifest.json").write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8")
    print(f"MARICA_QA001_WEB_BOOT_PASS head={head} cases=2 hosted=false")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--web-dir", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--head-sha", required=True)
    args = parser.parse_args()
    run(args.web_dir, args.output, args.head_sha)
