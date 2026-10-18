#!/usr/bin/env python3
"""QA-002 real Godot/WebAssembly input proof (Chrome emulation != physical device)."""
import argparse
import hashlib
import json
import re
import threading
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

from PIL import Image, ImageChops
from playwright.sync_api import sync_playwright


class QuietHandler(SimpleHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def exercise(web_dir: Path, output: Path, head: str) -> None:
    assert re.fullmatch(r"[a-f0-9]{40}", head), "exact Git HEAD required"
    for filename in ("index.html", "index.js", "index.wasm", "index.pck", "qa-build.json"):
        path = web_dir / filename
        assert path.is_file() and path.stat().st_size > 0, filename
    provenance = json.loads((web_dir / "qa-build.json").read_text())
    assert provenance["head_sha"] == head
    assert provenance["godot"] == "4.7.2-stable"
    assert provenance["original_png_sha256"] == (
        "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"
    )
    output.mkdir(parents=True, exist_ok=True)
    server = ThreadingHTTPServer(
        ("127.0.0.1", 0), partial(QuietHandler, directory=str(web_dir))
    )
    threading.Thread(target=server.serve_forever, daemon=True).start()
    records = []
    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch(
                channel="chrome",
                headless=True,
                args=[
                    "--no-sandbox", "--disable-dev-shm-usage", "--enable-webgl",
                    "--enable-unsafe-swiftshader", "--use-gl=angle",
                    "--use-angle=swiftshader",
                ],
            )
            try:
                for case, w, h, dpr, mobile in [
                    ("android-touch-emulated", 390, 844, 2, True),
                    ("desktop-mouse", 1280, 960, 1, False),
                ]:
                    context = browser.new_context(
                        viewport={"width": w, "height": h},
                        device_scale_factor=dpr,
                        is_mobile=mobile,
                        has_touch=mobile,
                    )
                    try:
                        page = context.new_page()
                        errors = []
                        page.on("pageerror", lambda error: errors.append(str(error)))
                        response = page.goto(
                            f"http://127.0.0.1:{server.server_port}/index.html",
                            wait_until="domcontentloaded",
                            timeout=45000,
                        )
                        assert response and response.status == 200
                        page.wait_for_function(
                            "window.__MARICA_QA_GODOT_READY === true", timeout=90000
                        )
                        center = page.evaluate("window.__MARICA_QA_FOUNDER_CENTER")
                        assert isinstance(center, list) and len(center) == 2, center
                        gx, gy = map(float, center)
                        canvas = page.evaluate("""() => {
                            const c = document.querySelector('canvas');
                            const r = c.getBoundingClientRect();
                            return {x:r.x, y:r.y, w:r.width, h:r.height,
                                    pixels_w:c.width, pixels_h:c.height};
                        }""")
                        assert canvas["pixels_w"] > 0 and canvas["pixels_h"] > 0
                        # Godot coordinates are canvas/render pixels; Playwright
                        # mouse and touchscreen expect browser CSS coordinates.
                        x = canvas["x"] + gx * canvas["w"] / canvas["pixels_w"]
                        y = canvas["y"] + gy * canvas["h"] / canvas["pixels_h"]
                        print(f"QA002_POINTER case={case} godot={center} css={[x, y]} canvas={canvas}", flush=True)
                        assert 0 <= x < w and 0 <= y < h, f"{case}: pet outside viewport"
                        assert page.evaluate("window.__MARICA_QA_SELECTIONS") == 0
                        page.wait_for_timeout(500)
                        before = output / f"{case}-before.png"
                        page.screenshot(path=str(before))
                        if mobile:
                            page.touchscreen.tap(x, y)
                        else:
                            page.mouse.click(x, y)
                        page.wait_for_function(
                            "window.__MARICA_QA_SELECTIONS === 1", timeout=10000
                        )
                        page.wait_for_timeout(1100)  # Catch synthetic duplicate mouse.
                        assert page.evaluate("window.__MARICA_QA_SELECTIONS") == 1
                        assert page.evaluate("window.__MARICA_QA_SELECTION_TEXT") == (
                            "Cachorro fundador selecionado"
                        )
                        after = output / f"{case}-selected.png"
                        page.screenshot(path=str(after))
                        with Image.open(before) as left, Image.open(after) as right:
                            assert left.size == right.size == (w*dpr, h*dpr)
                            assert ImageChops.difference(
                                left.convert("RGB"), right.convert("RGB")
                            ).getbbox() is not None, "no visible change after tap"
                        # A real pointer drag must not trigger another pet selection.
                        if mobile:
                            cdp = context.new_cdp_session(page)
                            cdp.send("Input.dispatchTouchEvent", {
                                "type": "touchStart",
                                "touchPoints": [{"x": x, "y": y, "id": 1}],
                            })
                            for distance in (28, 60, 100):
                                cdp.send("Input.dispatchTouchEvent", {
                                    "type": "touchMove",
                                    "touchPoints": [{"x": x + distance, "y": y, "id": 1}],
                                })
                            cdp.send("Input.dispatchTouchEvent", {
                                "type": "touchEnd", "touchPoints": [],
                            })
                        else:
                            page.mouse.move(x, y)
                            page.mouse.down()
                            page.mouse.move(x + 100, y, steps=8)
                            page.mouse.up()
                        page.wait_for_timeout(400)
                        assert page.evaluate("window.__MARICA_QA_SELECTIONS") == 1, (
                            f"{case}: drag triggered false selection"
                        )
                        assert not errors, f"{case}: page errors: {errors}"
                        records.append({
                            "case": case, "viewport_css": [w, h], "dpr": dpr,
                            "physical_device": False, "godot_marker": True,
                            "selection_count_after_tap": 1,
                            "selection_count_after_drag": 1,
                            "native_visible_feedback": True,
                            "before_sha256": sha(before), "after_sha256": sha(after),
                        })
                    finally:
                        context.close()
            finally:
                browser.close()
    finally:
        server.shutdown()
        server.server_close()
    manifest = {
        "issue": 138, "head_sha": head, "godot": "4.7.2-stable",
        "godot_web_input_proof": True, "deployed_https_proven": False,
        "physical_android_verified": False, "gameplay_approved": False,
        "artist_runtime_approved": False, "cases": records,
    }
    (output / "manifest.json").write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    print(f"MARICA_QA002_INPUT_PASS head={head} cases={len(records)}")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--web-dir", type=Path, required=True)
    ap.add_argument("--output", type=Path, required=True)
    ap.add_argument("--head-sha", required=True)
    args = ap.parse_args()
    exercise(args.web_dir, args.output, args.head_sha)
