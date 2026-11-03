#!/usr/bin/env python3
"""Build, parse, and smoke-test the single-file Draco distribution.

The Luau smoke test supplies a small Roblox-shaped fake runtime. It verifies
the loader contract and lifecycle behavior without pretending to test actual
Roblox rendering or input dispatch.
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def run(command: list[str]) -> None:
    subprocess.run(command, cwd=ROOT, check=True)


def sibling(binary: str, luau: Path | None) -> Path | None:
    if luau:
        candidate = luau.with_name(binary)
        if candidate.exists():
            return candidate
    found = shutil.which(binary)
    return Path(found) if found else None


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--luau",
        type=Path,
        help="path to the Luau CLI; enables the Roblox-shaped smoke test",
    )
    args = parser.parse_args()

    run([sys.executable, "tools/verify_distribution.py"])

    luau = args.luau.resolve() if args.luau else sibling("luau", None)
    compiler = sibling("luau-compile", luau)
    if compiler:
        run([str(compiler), "--only-parse", "DracoUI.luau"])
        run([str(compiler), "--only-parse", "Draco.lua"])
    else:
        print("Luau CLI not found; skipped parser and runtime smoke checks")
        return 0

    if not luau:
        print("Luau CLI compiler found but runtime executable is unavailable")
        return 0

    distribution = (ROOT / "Draco.lua").read_text(encoding="utf-8")
    harness = (ROOT / "tools" / "smoke_test.luau").read_text(encoding="utf-8")
    if "]=]" in distribution:
        raise SystemExit("distribution contains the smoke-test delimiter")
    script = "local DISTRIBUTION = [=[\n" + distribution + "\n]=]\n" + harness
    with tempfile.NamedTemporaryFile(
        mode="w", encoding="utf-8", suffix=".luau", dir="/tmp/opencode", delete=False
    ) as handle:
        handle.write(script)
        smoke_path = Path(handle.name)
    try:
        run([str(luau), str(smoke_path)])
    finally:
        smoke_path.unlink(missing_ok=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
