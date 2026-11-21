#!/usr/bin/env python3
"""Every converted teleport catches a player only where the Source trigger did, and no route zone is buried in a pit; the check is gs-map-convert's tools/check_zone_fidelity.py.

    tools/check_zone_fidelity.py                  every map (what CI runs)
    tools/check_zone_fidelity.py surf_mesa ...    these maps
    tools/check_zone_fidelity.py -v               list every problem, not the first few per map

Failures not fixed yet are held by exact count in tools/zone_fidelity_known.json.
gs-map-convert is a sibling checkout (`../gs-map-convert`, where gs-bootstrap clones it) or `$GS_MAP_CONVERT_PATH`.
"""

import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

for _p in (os.environ.get("GS_MAP_CONVERT_PATH", ""), os.path.join(ROOT, "..", "gs-map-convert")):
    if _p and os.path.isfile(os.path.join(_p, "tools", "check_zone_fidelity.py")):
        sys.path.insert(0, os.path.join(_p, "tools"))
        break
else:
    sys.exit("check_zone_fidelity: gs-map-convert was not found. Clone it beside this repository or set GS_MAP_CONVERT_PATH.")
import check_zone_fidelity  # noqa: E402

sys.exit(check_zone_fidelity.main(root=ROOT))
