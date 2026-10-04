"""Run HDL tools, explicitly reporting the initial empty-source state."""

from __future__ import annotations

import argparse
import subprocess

import yaml

from tools.hdl_sources import PROJECT_ROOT, discover_sources

FORMAT_ARGS = ["--indentation_spaces=4", "--column_limit=100"]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=["lint", "format", "verify"])
    action = parser.parse_args().action
    sources = discover_sources(PROJECT_ROOT / "rtl")
    if not sources:
        print(f"SKIP HDL {action}: no RTL sources exist yet.")
        return

    if action == "lint":
        metadata = yaml.safe_load((PROJECT_ROOT / "edam.yml").read_text())
        top = metadata.get("toplevel")
        if not isinstance(top, str) or not top.strip():
            raise ValueError("Set edam.yml toplevel to the actual top module before linting RTL.")
        subprocess.run(
            [
                "verilator",
                "--lint-only",
                "--Wall",
                "--top-module",
                top,
                *[str(source.path) for source in sources],
            ],
            check=True,
        )
    else:
        mode = "--inplace" if action == "format" else "--verify"
        for source in sources:
            subprocess.run(
                ["verible-verilog-format", mode, *FORMAT_ARGS, str(source.path)], check=True
            )


if __name__ == "__main__":
    main()
