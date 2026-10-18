#!/usr/bin/env python3
"""Remote QA-001 smoke: proves hosted Vercel Godot, not a static Vercel status page."""
import argparse
import hashlib
import json
import time
import urllib.error
import urllib.request
from pathlib import Path

from playwright.sync_api import sync_playwright


def wait_for_exact_deployment(base: str, head: str):
    uri = base + "/qa-build.json"
    last = "no HTTP response yet"
    for attempt in range(36):
        try:
            request = urllib.request.Request(uri, headers={"User-Agent": "marica-game-qa001-smoke/1"})
            with urllib.request.urlopen(request, timeout=20) as response:
                if response.status != 200:
                    raise RuntimeError(f"HTTP {response.status}")
                data = json.loads(response.read().decode("utf-8"))
            if data.get("head_sha") != head:
                last = f"stale or unproven export SHA={data.get('head_sha')!r}, expected {head}"
            else:
                assert data["godot"] == "4.7.2-stable"
                names = data["export_files"]
                for filename in ("index.html", "index.js", "index.wasm", "index.pck"):
                    assert filename in names and names[filename]["bytes"] > 0, filename
                assert data["gameplay_approved"] is False
                return data
        except urllib.error.HTTPError as ex:
            if ex.code in (401, 403):
                raise RuntimeError(f"QA preview requires authorization: HTTP {ex.code} at {uri}") from ex
            last = f"HTTP {ex.code}"
        except (OSError, ValueError, KeyError, AssertionError, RuntimeError) as ex:
            last = str(ex)
        print(f"QA_HOSTED_WAIT attempt={attempt + 1} detail={last}", flush=True)
        time.sleep(10)
    raise RuntimeError(f"QA-001 hosted preview not verified: {last}")


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def test_browser(base, folder):
    records = []
    with sync_playwright() as p:
        browser = p.chromium.launch(
            channel="chrome", headless=True,
            args=["--no-sandbox", "--disable-dev-shm-usage", "--enable-webgl",
                  "--enable-unsafe-swiftshader", "--use-gl=angle",
                  "--use-angle=swiftshader"])
        try:
            for name, width, height, dpr, mobile in (
                ("portrait-emulated", 390, 844, 2, True),
                ("desktop", 1280, 960, 1, False),
            ):
                context = browser.new_context(
                    viewport={"width": width, "height": height},
                    device_scale_factor=dpr, is_mobile=mobile, has_touch=mobile)
                try:
                    page = context.new_page()
                    errors = []
                    page.on("pageerror", lambda err: errors.append(str(err)))
                    response = page.goto(base + "/", wait_until="domcontentloaded", timeout=45000)
                    assert response is not None and response.status == 200, "HTTP root unavailable"
                    page.wait_for_function("window.__MARICA_QA_GODOT_READY === true", timeout=90000)
                    canvas = page.evaluate("""() => {
                        const c = document.querySelector('canvas');
                        return c ? [c.width, c.height] : null;
                    }""")
                    assert canvas and min(canvas) > 10, "Godot canvas not loaded"
                    assert not errors, f"JS page errors: {errors}"
                    page.wait_for_timeout(1000)
                    target = folder / (name + ".png")
                    page.screenshot(path=str(target))
                    assert target.stat().st_size > 1500, "empty hosted screenshot"
                    records.append({
                        "case": name,
                        "viewport_css": [width, height],
                        "dpr": dpr,
                        "mobile_emulated": mobile,
                        "physical_device": False,
                        "engine_ready": True,
                        "canvas_px": canvas,
                        "png": target.name,
                        "png_sha256": sha256(target),
                    })
                finally:
                    context.close()
        finally:
            browser.close()
    return records


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--url", required=True)
    ap.add_argument("--head", required=True)
    ap.add_argument("--output", required=True, type=Path)
    args = ap.parse_args()
    assert args.url.startswith("https://")
    assert len(args.head) == 40 and all(c in "0123456789abcdef" for c in args.head)
    base = args.url.rstrip("/")
    args.output.mkdir(parents=True, exist_ok=True)
    meta = wait_for_exact_deployment(base, args.head)
    captures = test_browser(base, args.output)
    proof = {
        "kind": "QA-001 deployed Godot Web hosted-browser proof",
        "url": base, "head_sha": args.head,
        "verified": True,
        "godot": meta["godot"],
        "remote_export_file_hashes": meta["export_files"],
        "captures": captures,
        "physical_device_tested": False,
        "full_gameplay_approved": False,
        "artist_runtime_approved": False,
    }
    (args.output / "hosted-proof.json").write_text(json.dumps(proof, indent=2) + "\n")
    print(f"MARICA_QA001_HTTPS_GODOT_BOOT_PASS head={args.head} cases={len(captures)}")


if __name__ == "__main__":
    main()
