#!/usr/bin/python3
# SPDX-License-Identifier: MIT
"""Wait for a native cave transaction before reconciling host intent."""
from pathlib import Path
import subprocess
import sys


def main():
    args = sys.argv[1:]
    if not args or args[0] not in {"resolve", "uninstall", "purge"}:
        raise ValueError("use resolve, uninstall or purge with native cave arguments")
    if any(arg in {"--root", "--environment", "-E"}
           or arg.startswith(("--root=", "--environment=", "-E")) for arg in args):
        raise ValueError("foreign root/environment selection cannot activate the host")
    status = subprocess.run(["cave", "--environment", "portage", *args]).returncode
    readonly = any(arg in {"--help", "-h", "--version"} for arg in args)
    execute = any(arg in {"--execute", "-x"} for arg in args)
    if readonly or not execute:
        return status
    engine = Path("/usr/sbin/nix-profile-engine")
    activation = subprocess.run([str(engine), "reconcile"]).returncode if engine.exists() else 0
    return status or activation


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError) as error:
        print("paludis-impurifier: " + str(error), file=sys.stderr)
        sys.exit(1)
