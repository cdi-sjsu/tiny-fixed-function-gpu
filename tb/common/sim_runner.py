"""Shared simulation runner utilities for subsystem and integration Cocotb testbenches."""

from __future__ import annotations

import os
import shutil
from collections.abc import Sequence
from dataclasses import dataclass, field
from pathlib import Path

import pytest
from cocotb_tools.runner import get_runner

from tools.hdl_sources import PROJECT_ROOT, HdlSource, discover_sources


@dataclass(frozen=True)
class SimulationSuite:
    name: str
    top: str
    test_module: str
    # Paths relative to the repository root; empty compiles discovered subsystem sources.
    sources: tuple[str, ...] = ()
    parameters: dict[str, int] = field(default_factory=dict)
    auto_packages: bool = True


def _resolve_sources(
    suite_sources: tuple[str, ...],
    discovered_sources: Sequence[HdlSource | Path] | None,
    include_packages: bool = True,
) -> list[Path]:
    """Resolve and order HDL sources, prepending shared packages automatically."""
    packages: list[Path] = []
    if include_packages:
        pkg_dir = PROJECT_ROOT / "rtl/pkg"
        if pkg_dir.is_dir():
            packages = [s.path for s in discover_sources(pkg_dir)]

    raw_sources: list[Path] = []
    if suite_sources:
        raw_sources = [PROJECT_ROOT / path for path in suite_sources]
    elif discovered_sources is not None:
        raw_sources = [s.path if isinstance(s, HdlSource) else s for s in discovered_sources]

    ordered: list[Path] = []
    for path in packages + raw_sources:
        resolved = path.resolve()
        if resolved not in ordered:
            ordered.append(resolved)
    return ordered


def run_simulation(
    suite: SimulationSuite,
    *,
    sources: Sequence[HdlSource | Path] | None = None,
    simulator: str | None = None,
    waves: bool | None = None,
) -> None:
    """Build and execute a Cocotb simulation suite."""
    sim = simulator or os.getenv("SIM", "verilator")
    record_waves = waves if waves is not None else (os.getenv("WAVES") == "1")
    build_dir = PROJECT_ROOT / ".sim_build" / sim / suite.name
    if shutil.which(sim) is None:
        pytest.skip(f"Simulator '{sim}' executable not found in PATH; simulation skipped.")

    runner = get_runner(sim)
    if sim == "verilator" and "OBJCACHE" not in os.environ and shutil.which("ccache") is None:
        os.environ["OBJCACHE"] = ""

    resolved_sources = _resolve_sources(
        suite.sources, sources, include_packages=suite.auto_packages
    )

    env = dict(os.environ)
    python_paths = [
        str(PROJECT_ROOT),
        str(PROJECT_ROOT / "tb"),
    ]
    if "PYTHONPATH" in env:
        python_paths.append(env["PYTHONPATH"])
    env["PYTHONPATH"] = os.pathsep.join(python_paths)

    runner.build(
        sources=resolved_sources,
        hdl_toplevel=suite.top,
        parameters=suite.parameters,
        build_dir=build_dir,
        always=True,
        clean=True,
        timescale=("1ns", "1ps"),
        waves=record_waves,
    )
    runner.test(
        hdl_toplevel=suite.top,
        test_module=suite.test_module,
        test_dir=build_dir,
        build_dir=build_dir,
        waves=record_waves,
        extra_env=env,
    )
