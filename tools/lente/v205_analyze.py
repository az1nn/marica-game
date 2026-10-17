#!/usr/bin/env python3
"""LENTE: independently measure exact-HEAD rendered Godot PNG evidence (not an ARTIST gate)."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from PIL import Image, ImageChops

SOURCE_SHA = "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e"
CENA_HEAD = "001e0469b4d848e4c005a62e888e4de12af767f4"


def metrics(image_path: Path) -> dict:
    image = Image.open(image_path).convert("RGB")
    width, height = image.size
    backdrop = image.getpixel((0, 0))
    flat = Image.new("RGB", image.size, backdrop)
    delta = ImageChops.difference(image, flat)
    bbox = delta.getbbox()
    diff = delta.convert("L")
    foreground = sum(1 for value in diff.getdata() if value > 3)
    left = any(sum(delta.getpixel((0, y))) > 9 for y in range(height))
    right = any(sum(delta.getpixel((width - 1, y))) > 9 for y in range(height))
    return {
        "sha256": hashlib.sha256(image_path.read_bytes()).hexdigest(),
        "width": width,
        "height": height,
        "bg_rgb": backdrop,
        "foreground_fraction": round(foreground / (width * height), 5),
        "bbox_xyxy_exclusive": list(bbox) if bbox else None,
        "vertical_bbox_fraction": round((bbox[3] - bbox[1]) / height, 5)
        if bbox
        else 0,
        "touches_left": left,
        "touches_right": right,
        "blank_top_pixels": bbox[1] if bbox else height,
        "blank_bottom_pixels": height - bbox[3] if bbox else height,
    }


def sampling_difference(p1: Path, p2: Path) -> int:
    first = Image.open(p1).convert("RGB")
    second = Image.open(p2).convert("RGB")
    if first.size != second.size:
        raise ValueError("A/B sample mismatch")
    return sum(1 for v in ImageChops.difference(first, second).convert("L").getdata() if v > 2)


def measure(manifest_path: Path, target_dir: Path, expected_head: str) -> dict:
    source = json.loads(manifest_path.read_text(encoding="utf-8"))
    if source["lente_head"] != expected_head or len(source["frames"]) != 7:
        raise ValueError("Wrong exact HEAD or incorrect A/B frame count")
    if source["source_cena_head"] != CENA_HEAD or source["source_sha256"] != SOURCE_SHA:
        raise ValueError("CENA/source provenance does not match")
    if source["browser"] != "NOT_TESTED" or source["art_runtime"] != "NOT_EVALUATED":
        raise ValueError("Misrepresented runtime certification")
    frames = {}
    for frame in source["frames"]:
        filepath = manifest_path.parent / frame["file"]
        if not filepath.is_file():
            raise ValueError("Missing frame: " + frame["file"])
        result = metrics(filepath)
        if [result["width"], result["height"]] != frame["viewport"]:
            raise ValueError("Viewport/image mismatch: " + frame["file"])
        if result["foreground_fraction"] < 0.01:
            raise ValueError("Blank/flat scene: " + frame["file"])
        frames[frame["name"]] = result

    portrait = frames["portrait-current-nearest-dark"]
    desktop = frames["desktop-current-nearest-dark"]
    p_nearest = manifest_path.parent / "portrait-current-nearest-dark.png"
    p_linear = manifest_path.parent / "portrait-current-linear-dark.png"
    d_nearest = manifest_path.parent / "desktop-current-nearest-dark.png"
    d_linear = manifest_path.parent / "desktop-current-linear-dark.png"
    portrait_ab = sampling_difference(p_nearest, p_linear)
    desktop_ab = sampling_difference(d_nearest, d_linear)
    if portrait_ab < 20 or desktop_ab < 20:
        raise ValueError("A/B nearest-linear negative control did not produce differences")

    if not (portrait["touches_left"] and portrait["touches_right"]):
        raise ValueError("Expected known portrait crop evidence missing: re-review")
    if not portrait["vertical_bbox_fraction"] < 0.7:
        raise ValueError("Expected known portrait vertical void changed: re-review")
    if not (desktop["foreground_fraction"] < 0.3):
        raise ValueError("Expected known desktop negative-space changed: re-review")

    findings = [
        {
            "id": "LENTE-V205-001",
            "severity": "P1",
            "owner": "CENA",
            "status": "OPEN",
            "observation": "390x844 full frame crops scene at both horizontal edges",
            "acceptance": "Real Godot scene no unintended farm/navigation clipping in required mobile safe layout",
        },
        {
            "id": "LENTE-V205-002",
            "severity": "P1",
            "owner": "CENA",
            "status": "OPEN",
            "observation": "390x844 portrait has excessive blank canvas above and below farm",
            "acceptance": "Approved mobile camera composition with quantified visual bounds and HUD safe areas",
        },
        {
            "id": "LENTE-V205-003",
            "severity": "P2",
            "owner": "CENA",
            "status": "OPEN",
            "observation": "Desktop frame has large background negative space; world is still placeholder debug geometry",
            "acceptance": "Approved desktop composition and non-placeholder farm scene evidence",
        },
        {
            "id": "LENTE-V205-004",
            "severity": "P1",
            "owner": "SIGA",
            "status": "BLOCKED_BY_DEPENDENCY",
            "observation": "Preview contains no real HUD, hydrated founder, depth overlap, physical device or exported WebGL candidate",
            "acceptance": "Independent game scene, HUD/accessibility, occlusion/feet and browser/device evidence before runtime sign-off",
        },
    ]
    summary = {
        "schema_version": 1,
        "source_scene": "res://scenes/v203_portrait_preview.tscn",
        "lente_exact_head": expected_head,
        "cena_source_head": CENA_HEAD,
        "source_png_sha256": SOURCE_SHA,
        "renderer": source["renderer"],
        "scope": "real Godot hosted software-rendered diagnostic only",
        "verdict": "REVISE",
        "art_concept": "PRESERVED_ACCEPT",
        "art_runtime": "NOT_EVALUATED",
        "physical_mobile": False,
        "browser_webgl": False,
        "frames": frames,
        "ab_different_pixels": {"portrait": portrait_ab, "desktop": desktop_ab},
        "findings": findings,
    }
    target_dir.mkdir(parents=True, exist_ok=True)
    (target_dir / "analysis.json").write_text(
        json.dumps(summary, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    (target_dir / "CAVEMAN.md").write_text(
        "# LENTE V205 — " + expected_head + "\n\n"
        "Seen: fresh Godot 4.7.2 independent portrait/desktop sampling A/B, source intact.\n"
        "Broken: portrait left/right crop and vertical dead canvas; desktop large unused background; "
        "HUD/occlusion/handset/WebGL unverified.\n"
        "Good: original V4 concept/source preserved; nearest-vs-linear observable; founder recognizable.\n"
        "Route: LENTE-V205-001/002/003 → CENA; LENTE-V205-004 → SIGA/ARCH/GODOT.\n"
        "Next: CENA revise mobile framing, then LENTE exact-HEAD rendered WebGL scene + "
        "HUD/feet/depth/real-device matrices; independent ARTIST runtime review afterward.\n"
        "\n**Verdict: REVISE for scene composition only. NO MERGE / no SPEC completion.**\n",
        encoding="utf-8",
    )
    return summary


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    parser.add_argument("--head", required=True)
    args = parser.parse_args()
    result = measure(args.manifest, args.out, args.head)
    print(
        "MARICA_LENTE_V205_ANALYSIS_PASS status=REVISE"
        " portrait_diff=" + str(result["ab_different_pixels"]["portrait"])
        + " desktop_diff=" + str(result["ab_different_pixels"]["desktop"])
    )


if __name__ == "__main__":
    main()
