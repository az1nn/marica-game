#!/usr/bin/env python3
"""QA-002: assert actual Godot WebAssembly InputEvent mouse/touch, not injected JS state."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import threading
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

from playwright.sync_api import sync_playwright


class QuietHandler(SimpleHTTPRequestHandler):
    def log_message(self, fmt: str, *args: object) -> None:
        pass


def _sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _get_state(page) -> dict:
    result = page.evaluate("window.__MARICA_QA_TAP_STATE || null")
    if not isinstance(result, dict):
        raise AssertionError("Godot QA tap marker missing")
    if result.get("source") != "Godot InputEvent (QA-only)":
        raise AssertionError("QA state did not come from Godot runtime")
    if result.get("gameplay_enabled") is not False:
        raise AssertionError("QA-only marker incorrectly claims gameplay")
    return result


def _wait_state(page, expected_count: int, expected_selection: str) -> dict:
    page.wait_for_function(
        """([count, selection]) => {
            const d = window.__MARICA_QA_TAP_STATE;
            return d && d.count === count && d.selection === selection;
        }""",
        arg=[expected_count, expected_selection],
        timeout=12000,
    )
    return _get_state(page)


def _godot_to_css(page, xy: list[float]) -> tuple[float, float]:
    metrics = page.evaluate(
        """() => {
            const c = document.querySelector('canvas');
            if (!c) throw Error("Godot canvas absent");
            const r = c.getBoundingClientRect();
            return {left:r.left, top:r.top, cssW:r.width, cssH:r.height,
                    pixelW:c.width, pixelH:c.height};
        }"""
    )
    if min(metrics["pixelW"], metrics["pixelH"], metrics["cssW"], metrics["cssH"]) <= 0:
        raise AssertionError("Godot canvas has no rendered dimensions")
    x = metrics["left"] + xy[0] * metrics["cssW"] / metrics["pixelW"]
    y = metrics["top"] + xy[1] * metrics["cssH"] / metrics["pixelH"]
    if not (metrics["left"] + 12 < x < metrics["left"] + metrics["cssW"] - 12):
        raise AssertionError(f"founder center not visible horizontally: {x} {metrics}")
    if not (metrics["top"] + 12 < y < metrics["top"] + metrics["cssH"] - 12):
        raise AssertionError(f"founder center not visible vertically: {y} {metrics}")
    return x, y


def _touch_swipe(context, page, start: tuple[float, float]) -> None:
    cdp = context.new_cdp_session(page)
    x, y = start
    cdp.send("Input.dispatchTouchEvent", {
        "type": "touchStart", "touchPoints": [{"id": 4, "x": x, "y": y}]
    })
    for i in range(1, 12):
        cdp.send("Input.dispatchTouchEvent", {
            "type": "touchMove",
            "touchPoints": [{"id": 4, "x": x - 9 * i, "y": y}],
        })
        page.wait_for_timeout(20)
    cdp.send("Input.dispatchTouchEvent", {"type": "touchEnd", "touchPoints": []})


def test(web_dir: Path, output: Path, head: str) -> dict:
    if not re.fullmatch("[0-9a-f]{40}", head):
        raise ValueError("Exact commit SHA required")
    for name in ("index.html", "index.js", "index.wasm", "index.pck"):
        if not (web_dir / name).is_file():
            raise AssertionError(f"Godot Web export missing {name}")
    output.mkdir(parents=True, exist_ok=True)
    handler = partial(QuietHandler, directory=str(web_dir))
    server = ThreadingHTTPServer(("127.0.0.1", 0), handler)
    threading.Thread(target=server.serve_forever, daemon=True).start()
    cases = []
    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch(
                channel="chrome",
                headless=True,
                args=[
                    "--no-sandbox", "--disable-dev-shm-usage",
                    "--enable-webgl", "--enable-unsafe-swiftshader",
                    "--use-gl=angle", "--use-angle=swiftshader",
                ],
            )
            try:
                for name, width, height, dpr, mobile in (
                    ("desktop-mouse", 1280, 960, 1, False),
                    ("portrait-touch-emulated", 390, 844, 2, True),
                ):
                    context = browser.new_context(
                        viewport={"width": width, "height": height},
                        device_scale_factor=dpr, is_mobile=mobile, has_touch=mobile,
                    )
                    try:
                        page = context.new_page()
                        errors: list[str] = []
                        page.on("pageerror", lambda error: errors.append(str(error)))
                        response = page.goto(
                            f"http://127.0.0.1:{server.server_port}/index.html",
                            wait_until="domcontentloaded", timeout=45000,
                        )
                        if response is None or response.status != 200:
                            raise AssertionError("Godot Web HTML not served")
                        page.wait_for_function(
                            "window.__MARICA_QA_GODOT_READY === true", timeout=90000
                        )
                        page.wait_for_function(
                            "window.__MARICA_QA_TAP_STATE && "
                            "window.__MARICA_QA_TAP_STATE.founder_center", timeout=12000
                        )
                        before = _get_state(page)
                        if before["count"] != 0 or before["selection"] != "none":
                            raise AssertionError("Expected a fresh unselected QA scene")
                        screenshot_before = output / f"{name}-before.png"
                        page.screenshot(path=str(screenshot_before))
                        px, py = _godot_to_css(page, before["founder_center"])
                        if mobile:
                            page.touchscreen.tap(px, py)
                        else:
                            page.mouse.click(px, py)
                        selected = _wait_state(page, 1, "founder")
                        if selected["count"] != 1:
                            raise AssertionError("Physical gesture caused a duplicate selection")
                        page.wait_for_timeout(300)
                        if _get_state(page)["count"] != 1:
                            raise AssertionError("Touch-generated synthetic mouse counted twice")
                        screenshot_after = output / f"{name}-selected.png"
                        page.screenshot(path=str(screenshot_after))
                        if _sha(screenshot_before.read_bytes()) == _sha(
                            screenshot_after.read_bytes()
                        ):
                            raise AssertionError("QA selection did not visibly change the screen")
                        if mobile:
                            # A real CDP touch stream; DOM and Godot event counts diagnose routing.
                            start_camera = selected["camera_x"]
                            page.evaluate(
                                """() => {
                                    window.__QA002_DOM_TOUCH = {start:0,move:0,end:0};
                                    for (const [name,key] of [
                                        ['touchstart','start'],['touchmove','move'],
                                        ['touchend','end']]) {
                                        document.addEventListener(name, () => {
                                            window.__QA002_DOM_TOUCH[key] += 1;
                                        }, {capture:true,passive:true});
                                    }
                                }"""
                            )
                            _touch_swipe(context, page, (px, py + 110))
                            page.wait_for_timeout(450)
                            trace = page.evaluate("window.__QA002_DOM_TOUCH")
                            end_state = _get_state(page)
                            print(
                                "QA002_WEB_GESTURE_DIAG "
                                f"dom={trace} before_x={start_camera} "
                                f"after={end_state}", flush=True
                            )
                            if end_state["count"] != 1:
                                raise AssertionError("Drag accidentally triggered tap")
                            can_pan_horizontally = (
                                end_state["portrait_policy_active"]
                                and end_state["horizontal_pan_range"] > 1
                            )
                            pan_delta = abs(end_state["camera_x"] - start_camera)
                            if can_pan_horizontally and pan_delta <= 1:
                                raise AssertionError(
                                    "Web touch input arrived but camera failed to pan "
                                    f"within an allowed range: dom={trace}, godot={end_state}"
                                )
                            if not can_pan_horizontally:
                                print(
                                    "QA002_PAN_BOUNDARY_BLOCKED "
                                    f"viewport={end_state['viewport_size']} "
                                    f"portrait={end_state['portrait_policy_active']} "
                                    f"range={end_state['horizontal_pan_range']}",
                                    flush=True,
                                )
                        if errors:
                            raise AssertionError("Godot browser JS page errors: " + str(errors))
                        cases.append({
                            "name": name,
                            "head_sha": head,
                            "mobile_viewport_emulated": mobile,
                            "real_android_device": False,
                            "real_godot_webassembly": True,
                            "tap_source": "Playwright touchscreen.tap" if mobile else "Playwright mouse.click",
                            "tap_count": selected["count"],
                            "tap_selection": selected["selection"],
                            "founder_css_position": [round(px, 2), round(py, 2)],
                            "drag_did_not_count_as_tap": mobile,
                            "browser_touch_pan_observation": (
                                "NO_AVAILABLE_PAN_RANGE"
                                if mobile and not (
                                    end_state["portrait_policy_active"]
                                    and end_state["horizontal_pan_range"] > 1
                                )
                                else "MOVED" if mobile else "NOT_TESTED_DESKTOP"
                            ),
                            "before_png": screenshot_before.name,
                            "after_png": screenshot_after.name,
                            "before_sha256": _sha(screenshot_before.read_bytes()),
                            "after_sha256": _sha(screenshot_after.read_bytes()),
                        })
                    finally:
                        context.close()
            finally:
                browser.close()
    finally:
        server.shutdown()
        server.server_close()
    if len(cases) != 2:
        raise AssertionError("QA-002 expects exactly mouse and emulated touch evidence")
    result = {
        "task": "SPEC-008 Q806 / QA-002 #138",
        "head_sha": head,
        "engine": "Godot 4.7.2 WebAssembly on hosted Chrome",
        "real_device_verified": False,
        "production_gameplay_verified": False,
        "qa_tap_input_verified": True,
        "cases": cases,
    }
    (output / "manifest.json").write_text(
        json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(f"MARICA_QA002_WEB_INPUT_PASS head={head} cases=2 real_android=false")
    return result


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--web-dir", type=Path, required=True)
    ap.add_argument("--output", type=Path, required=True)
    ap.add_argument("--head", required=True)
    args = ap.parse_args()
    test(args.web_dir, args.output, args.head)
