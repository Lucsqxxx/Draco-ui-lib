#!/usr/bin/env python3
"""Static distribution checks that do not require a Roblox client."""

from __future__ import annotations

import re
import subprocess
import sys
import hashlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    subprocess.run([sys.executable, str(ROOT / "tools" / "build_distribution.py"), "--check"], check=True)
    source = (ROOT / "DracoUI.luau").read_text(encoding="utf-8")
    distribution = (ROOT / "Draco.lua").read_text(encoding="utf-8")

    if "require(" in distribution or "script." in distribution:
        raise SystemExit("distribution contains a local dependency")
    expected_digest = hashlib.sha256(source.encode("utf-8")).hexdigest()
    if f"Source SHA-256: {expected_digest}" not in distribution:
        raise SystemExit("distribution source fingerprint is stale")
    for method in ("CreateWindow", "Notify", "CreateTheme", "PresetSheet"):
        if not re.search(rf"function\s+DracoUI:{method}", distribution):
            raise SystemExit(f"distribution does not expose {method}")
    if not distribution.rstrip().endswith("return DracoUI"):
        raise SystemExit("distribution does not return DracoUI")
    if "return DracoUI" not in source:
        raise SystemExit("source does not return DracoUI")

    print("distribution checks passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
