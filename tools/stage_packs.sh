#!/bin/bash
# stage_packs.sh OUT [id...] : one directory per map, OUT/<id>/, in the layout a per-map pack gamemann/<id> is published from:
#   maps/<id>/ without textures/                (the manifest, .bin, our lightmap, licence.json, provides.json at the pack root)
#   worlds/<id>/<id>.{json,bin,doc.json}        (the dot-map world document; game-g2gfast's G2GBspMap draws it from here)
#   worlds/<id>/textures/fb_*                   (the CC0 fallbacks it names; full PBR sets come from the store)
#   worlds/<id>/models/                         (exactly the library models it draws, via dot-map-convert's `bsp.py bundle`)
# No id stages every map that has a world. A map is refused, not staged, when its coverage report names an unmapped texture,
# model or sound, or a flat-colour texture (owner policy: publish only what is mapped to free/own assets).
#
# PUBLISH RULE: maps/<id>/textures/ is the importer's decode of the SOURCE map's pakfile (third-party or Valve art) and is
# NEVER copied. publish_pack.sh refuses Valve-origin files again (dot-cloud tools/check_valve_files.py) before any upload.
# Our worlds/ is flat (worlds/<id>.json, shared worlds/textures/); `bsp.py bundle` reads a world folder, so each world is
# assembled in a scratch folder first.
# DOT_MAP_CONVERT: dot-map-convert checkout (default ../dot-map-convert). MODEL_STORE: the model store (default $DOT_ART_LIBRARY/models, else ~/art-library/models;
# ./model-library holds only the picks of the last local convert).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${1:?usage: stage_packs.sh OUT [id...]}"; shift
CONVERT="${DOT_MAP_CONVERT:-$HERE/../dot-map-convert}"
STORE="${MODEL_STORE:-${DOT_ART_LIBRARY:-$HOME/art-library}/models}"
[ -f "$CONVERT/bsp.py" ] || { echo "stage_packs: no dot-map-convert at $CONVERT (set DOT_MAP_CONVERT)" >&2; exit 2; }
IDS=("$@")
[ ${#IDS[@]} -gt 0 ] || mapfile -t IDS < <(cd "$HERE/worlds" && ls -- *.coverage.json 2>/dev/null | sed 's/\.coverage\.json$//')
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
mkdir -p "$OUT"
staged=0; refused=()
for id in "${IDS[@]}"; do
    w="$HERE/worlds/$id"
    if [ ! -f "$w.json" ] || [ ! -f "$w.bin" ] || [ ! -d "$HERE/maps/$id" ]; then
        echo "stage_packs: $id has no worlds/$id.json + .bin or no maps/$id/, skipped" >&2; refused+=("$id"); continue
    fi
    # Unmapped art is never published; the coverage report is the converter's own count.
    if ! why="$(python3 -P - "$w.coverage.json" <<'PY'
import json, sys
try:
    c = json.load(open(sys.argv[1])).get("counts", {})
except (OSError, ValueError):
    sys.exit("no coverage report")
bad = ["%s %d" % (k, c.get(k, 0)) for k in ("textures_unmapped", "textures_flat", "models_unmapped", "sounds_unmapped") if c.get(k, 0)]
sys.exit(", ".join(bad) if bad else 0)
PY
)" 2>&1; then
        echo "stage_packs: $id not staged: $why" >&2; refused+=("$id"); continue
    fi
    src="$TMP/$id"; mkdir -p "$src/textures"
    cp "$w.json" "$w.bin" "$src/"
    [ -f "$w.doc.json" ] && cp "$w.doc.json" "$src/"
    # The fallback textures the world names (fallback_file is relative to the world folder).
    python3 -P - "$w.json" <<'PY' > "$TMP/$id.tex"
import json, sys
lic = json.load(open(sys.argv[1])).get("licence", {})
for t in lic.get("textures", []):
    f = t.get("fallback_file") or ""
    if f:
        print(f)
PY
    while read -r rel; do
        case "$rel" in textures/fb_*|textures/gen_*) ;; *) echo "stage_packs: $id names $rel, not a fallback texture" >&2; exit 1 ;; esac
        [ -f "$HERE/worlds/$rel" ] || { echo "stage_packs: $id: missing worlds/$rel" >&2; exit 1; }
        cp "$HERE/worlds/$rel" "$src/textures/"
    done < <(sort -u "$TMP/$id.tex")
    rm -rf "${OUT:?}/$id"; mkdir -p "$OUT/$id/worlds"
    (cd "$HERE/maps/$id" && tar cf - --exclude=./textures .) | tar xf - -C "$OUT/$id"
    python3 -P "$CONVERT/bsp.py" bundle "$src" --out "$OUT/$id/worlds" --store "$STORE" --strict
    # The world's own art carries its own licence: each fallback texture and bundled model gets the longest-prefix entry in the
    # pack's licence.json (the site picks the longest matching path), so CC0/CC-BY art is credited as itself, not as the map.
    python3 -P - "$OUT/$id" "$id" "$w.json" "$STORE" <<'PY'
import json, os, sys
pack, mid, world, store = sys.argv[1:]
lic_path = os.path.join(pack, "licence.json")
entries = json.load(open(lic_path))
pre = "worlds/%s/" % mid
for t in json.load(open(world)).get("licence", {}).get("textures", []):
    f = t.get("fallback_file")
    if f and os.path.isfile(os.path.join(pack, pre + f)):
        entries.append({"paths": [pre + f], "licence": t["licence"], "author": t["author"], "url": t["url"],
                        "title": "%s (%s)" % (t.get("generic") or os.path.basename(f), t.get("source", ""))})
models = os.path.join(pack, pre + "models")
for dp, dn, fn in os.walk(models):
    if "model.glb" not in fn:
        continue
    rel = os.path.relpath(dp, models)
    meta = json.load(open(os.path.join(store, rel, "model.json")))
    entries.append({"paths": [pre + "models/" + rel + "/"], "licence": meta["licence"], "author": meta["author"],
                    "url": meta["url"], "title": meta.get("name") or rel})
with open(lic_path, "w") as fh:
    fh.write(json.dumps(entries, indent=2) + "\n")
PY
    # An `.import` marker names the importing project's .godot cache, absent from a delivered pack.
    find "$OUT/$id" -name '*.import' -delete
    [ ! -e "$OUT/$id/textures" ] || { echo "stage_packs: $id: a source textures/ folder reached the pack" >&2; exit 1; }
    staged=$((staged + 1))
done
echo "stage_packs: $staged staged in $OUT, ${#refused[@]} not staged${refused[*]:+: ${refused[*]}}"
[ "$staged" -gt 0 ]
