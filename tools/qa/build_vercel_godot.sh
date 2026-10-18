#!/usr/bin/env bash
# QA-001 only: build a browser-testable Godot scene in Vercel's ephemeral build worker.
# No changes to checked-in game/project.godot, default production page or image sources.
set -Eeuo pipefail
umask 022

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"
test "$(cat game/.godot-version)" = "4.7.2-stable"
test -f game/scenes/qa_web_preview.tscn
test -f game/scenes/v203_portrait_preview.tscn
grep -Fq 'func pan_by_screen_delta(' game/src/presentation/v203_portrait_preview.gd
echo 'b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e  game/assets/arch_probes/S01_A01_v4_original.png' | sha256sum --check

if [[ -n "${VERCEL_GIT_COMMIT_SHA:-}" ]]; then
  test "$(git rev-parse HEAD)" = "$VERCEL_GIT_COMMIT_SHA"
fi
SOURCE_SHA="$(git rev-parse HEAD)"
OUT="$REPO_ROOT/build/qa-preview"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/marica-qa001-vercel.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$OUT" "$WORK/bin" "$WORK/project" "$WORK/data"
cp -a game/. "$WORK/project/"
echo "MARICA_QA001_EXPORT_BUILD_START head=$SOURCE_SHA"

# Reuse the SHA256-pinned official binaries verified by upstream PR #134.
curl --fail --location --retry 3 --retry-all-errors --max-time 600 -o "$WORK/godot.zip" \
  'https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_linux.x86_64.zip'
echo "cadd3204e728a35d3f13adb7fd0d7902636b79f6b95c40c265eb73b6c35329e4  $WORK/godot.zip" | sha256sum --check
unzip -q "$WORK/godot.zip" -d "$WORK/bin"
GODOT="$WORK/bin/Godot_v4.7.2-stable_linux.x86_64"
chmod +x "$GODOT"

curl --fail --location --retry 3 --retry-all-errors --max-time 900 -o "$WORK/godot-templates.tpz" \
  'https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_export_templates.tpz'
echo "f298490b8d44d934be425a5a65a51bf15f422428b229a06a6e11d9ffea248011  $WORK/godot-templates.tpz" | sha256sum --check

# HOME is ephemeral for Vercel builds. Official export templates are required by Godot.
TEMPLATES="$HOME/.local/share/godot/export_templates/4.7.2.stable"
mkdir -p "$TEMPLATES"
unzip -q -j "$WORK/godot-templates.tpz" 'templates/web*' -d "$TEMPLATES"
find "$TEMPLATES" -maxdepth 1 -type f -name '*web*release*' | grep -q .

python3 - "$WORK/project/project.godot" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
content = p.read_text(encoding='utf-8')
old = 'run/main_scene="res://scenes/smoke.tscn"'
assert content.count(old) == 1, "canonical default Godot scene must be untouched"
content = content.replace(old, 'run/main_scene="res://scenes/qa_web_preview.tscn"')
content += '\n[rendering]\nrenderer/rendering_method="gl_compatibility"\nrenderer/rendering_method.mobile="gl_compatibility"\n'
p.write_text(content, encoding='utf-8')
PY

cat > "$WORK/project/export_presets.cfg" <<'EOF'
[preset.0]

name="Web"
platform="Web"
runnable=true
advanced_options=false
dedicated_server=false
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path=""
encrypt_pck=false
encrypt_directory=false
script_export_mode=2

[preset.0.options]

custom_template/debug=""
custom_template/release=""
variant/extensions_support=false
variant/thread_support=false
vram_texture_compression/for_desktop=true
vram_texture_compression/for_mobile=false
html/canvas_resize_policy=2
html/focus_canvas_on_start=true
progressive_web_app/enabled=false
EOF

timeout 120s "$GODOT" --headless --editor --path "$WORK/project" --import --quit
timeout 240s "$GODOT" --headless --path "$WORK/project" --export-release Web "$OUT/index.html"
test -s "$OUT/index.html"
test -s "$OUT/index.wasm"
test -s "$OUT/index.pck"
test -s "$OUT/index.js"

# Publish provenance separately from the original source binary. The game marker
# is set ONLY by the real Godot QA scene after mount, never by this script or HTML.
python3 - "$OUT" "$SOURCE_SHA" <<'PY'
import hashlib
import json
from pathlib import Path
import sys

output = Path(sys.argv[1])
head = sys.argv[2]
assert len(head) == 40
files = {}
for path in sorted(output.iterdir()):
    if path.is_file():
        files[path.name] = {"bytes": path.stat().st_size, "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}
data = {
    "kind": "Marica Game isolated QA-001 V206 Godot Web diagnostic",
    "head_sha": head,
    "godot": "4.7.2-stable",
    "public_host_requested": "Vercel PR preview (hosting smoke test pending)",
    "gameplay_approved": False,
    "artist_runtime_approved": False,
    "physical_device_tested": False,
    "original_png_sha256": "b8089122d323de7dc7c235604f752ce2643990a867aceaead60409d700e2aa7e",
    "export_files": files,
}
(output / "qa-build.json").write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY
git diff --exit-code -- game/project.godot
echo "MARICA_QA001_VERCEL_EXPORT_PASS head=$SOURCE_SHA"
