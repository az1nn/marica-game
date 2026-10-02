#!/usr/bin/env python3
"""Publish the exact Roblox test place and execute behavioral Luau tests via Open Cloud."""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any

API_ROOT = "https://apis.roblox.com"
POLL_SECONDS = 3
MAX_POLLS = 110


def request_json(
    url: str,
    api_key: str,
    *,
    method: str = "GET",
    body: bytes | None = None,
    content_type: str | None = None,
) -> dict[str, Any]:
    headers = {"x-api-key": api_key}
    if content_type:
        headers["Content-Type"] = content_type
    request = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(request, timeout=60) as response:
            payload = response.read()
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"{method} {url} failed with HTTP {exc.code}: {detail}") from exc
    except urllib.error.URLError as exc:
        raise RuntimeError(f"{method} {url} failed: {exc.reason}") from exc

    if not payload:
        return {}
    try:
        decoded = json.loads(payload)
    except json.JSONDecodeError as exc:
        raise RuntimeError(f"{method} {url} returned invalid JSON") from exc
    if not isinstance(decoded, dict):
        raise RuntimeError(f"{method} {url} returned a non-object JSON payload")
    return decoded


def publish_place(api_key: str, universe_id: str, place_id: str, place_file: Path) -> int:
    if not place_file.is_file():
        raise RuntimeError(f"Place file does not exist: {place_file}")

    url = (
        f"{API_ROOT}/universes/v1/{universe_id}/places/{place_id}/versions"
        "?versionType=Published"
    )
    result = request_json(
        url,
        api_key,
        method="POST",
        body=place_file.read_bytes(),
        content_type="application/xml",
    )
    version = result.get("versionNumber")
    if not isinstance(version, int) or version <= 0:
        raise RuntimeError(f"Publish response did not contain a valid versionNumber: {result}")
    return version


def create_task(
    api_key: str,
    universe_id: str,
    place_id: str,
    version: int,
    script: str,
) -> dict[str, Any]:
    url = (
        f"{API_ROOT}/cloud/v2/universes/{universe_id}/places/{place_id}"
        f"/versions/{version}/luau-execution-session-tasks"
    )
    return request_json(
        url,
        api_key,
        method="POST",
        body=json.dumps({"script": script}).encode("utf-8"),
        content_type="application/json",
    )


def get_task(api_key: str, task_path: str) -> dict[str, Any]:
    return request_json(f"{API_ROOT}/cloud/v2/{task_path}", api_key)


def get_logs(api_key: str, task_path: str) -> list[str]:
    result = request_json(f"{API_ROOT}/cloud/v2/{task_path}/logs", api_key)
    entries = result.get("luauExecutionSessionTaskLogs", [])
    messages: list[str] = []
    if isinstance(entries, list):
        for entry in entries:
            if isinstance(entry, dict):
                raw_messages = entry.get("messages", [])
                if isinstance(raw_messages, list):
                    messages.extend(str(message) for message in raw_messages)
    return messages


def wait_for_task(api_key: str, task: dict[str, Any]) -> dict[str, Any]:
    task_path = task.get("path")
    if not isinstance(task_path, str) or not task_path:
        raise RuntimeError(f"Create task response did not contain a path: {task}")

    for _ in range(MAX_POLLS):
        current = get_task(api_key, task_path)
        state = current.get("state")
        if state != "PROCESSING":
            return current
        time.sleep(POLL_SECONDS)

    raise RuntimeError("Luau execution task did not finish before the CI polling deadline")


def required_env(name: str) -> str:
    value = os.environ.get(name, "").strip()
    if not value:
        raise RuntimeError(f"Required environment variable is missing: {name}")
    return value


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--place-file", type=Path, required=True)
    parser.add_argument("--script-file", type=Path, required=True)
    args = parser.parse_args()

    try:
        api_key = required_env("ROBLOX_API_KEY")
        universe_id = required_env("ROBLOX_TEST_UNIVERSE_ID")
        place_id = required_env("ROBLOX_TEST_PLACE_ID")

        script = args.script_file.read_text(encoding="utf-8")
        if not script.strip():
            raise RuntimeError("Behavioral test script is empty")

        version = publish_place(api_key, universe_id, place_id, args.place_file)
        print(f"Published exact test place version: {version}")

        created = create_task(api_key, universe_id, place_id, version, script)
        task = wait_for_task(api_key, created)
        task_path = task.get("path")
        if isinstance(task_path, str) and task_path:
            for message in get_logs(api_key, task_path):
                print(message)

        state = task.get("state")
        if state != "COMPLETE":
            error = task.get("error")
            raise RuntimeError(f"Luau behavioral execution ended in state {state}: {error}")

        output = task.get("output", {})
        print("Luau behavioral execution COMPLETE")
        if output:
            print(json.dumps(output, sort_keys=True))
        return 0
    except (OSError, RuntimeError) as exc:
        print(f"ROBLOX BEHAVIORAL: FAIL\n- {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
