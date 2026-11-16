#!/bin/bash
# publish_packs.sh --member-of ASSET [--site URL] [--token-file FILE] [--dry-run] id... : stage each map (tools/stage_packs.sh) and
# publish it as the pack gamemann/<id>, a member of the collection page ASSET (Airdrift's is airdrift-maps), through dot-cloud's
# shared tools/publish_pack.sh, which refuses Valve-origin files before any upload. --member-of is required: a bare publish of a map
# pack makes a standalone Workshop page.
# The version is 0.0.0-<12 hex of the staged tree's sha256>, so an unchanged map republishes as the same version (a resume, not a new one).
# GS_CLOUD: dot-cloud checkout (default ../dot-cloud). GS_MAP_CONVERT / MODEL_STORE: see stage_packs.sh.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLOUD="${GS_CLOUD:-${DOT_CLOUD:-$HERE/../dot-cloud}}"
MEMBER=""; PASS=(); IDS=()
while [ $# -gt 0 ]; do
    case "$1" in
        --member-of) MEMBER="${2:?}"; shift 2 ;;
        --site|--token-file) PASS+=("$1" "${2:?}"); shift 2 ;;
        --dry-run) PASS+=("$1"); shift ;;
        --*) echo "publish_packs: unknown flag $1" >&2; exit 2 ;;
        *) IDS+=("$1"); shift ;;
    esac
done
[ -n "$MEMBER" ] || { echo "publish_packs: --member-of ASSET is required (a bare map pack gets a page of its own)" >&2; exit 2; }
[ ${#IDS[@]} -gt 0 ] || { echo "publish_packs: name the map ids to publish" >&2; exit 2; }
[ -x "$CLOUD/tools/publish_pack.sh" ] || { echo "publish_packs: no dot-cloud at $CLOUD (set GS_CLOUD)" >&2; exit 2; }
OUT="$(mktemp -d)"; trap 'rm -rf "$OUT"' EXIT
"$HERE/tools/stage_packs.sh" "$OUT/stage" "${IDS[@]}"
for id in "${IDS[@]}"; do
    src="$OUT/stage/$id"
    [ -d "$src" ] || { echo "publish_packs: $id was not staged" >&2; exit 1; }
    hash="$(python3 -P - "$src" <<'PY'
import hashlib, os, sys
root = sys.argv[1]
h = hashlib.sha256()
for dp, dn, fn in os.walk(root):
    dn.sort()
    for f in sorted(fn):
        p = os.path.join(dp, f)
        h.update(os.path.relpath(p, root).encode() + b"\n" + open(p, "rb").read() + b"\0")
print(h.hexdigest()[:12])
PY
)"
    # The lock is scratch: a maps repo pins nothing, the game finds members through the collection.json.
    "$CLOUD/tools/publish_pack.sh" publish --source "$src" --id "$id" --kind pack --version "0.0.0-$hash" --member-of "$MEMBER" \
        --lock "$OUT/content.lock.json" --lock-optional --no-import "${PASS[@]}"
done
