#!/usr/bin/env python3
"""Old name of tools/airdriftmaps.py, kept for callers from before the rename."""
import os
import runpy

runpy.run_path(os.path.join(os.path.dirname(os.path.abspath(__file__)), "airdriftmaps.py"), run_name="__main__")
