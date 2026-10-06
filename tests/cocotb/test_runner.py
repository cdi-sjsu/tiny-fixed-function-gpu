"""Register GPU simulation suites here as real RTL and testbenches are added."""

from __future__ import annotations

import os
import shutil
from dataclasses import dataclass, field

import pytest
from cocotb_tools.runner import get_runner

from tools.hdl_sources import PROJECT_ROOT, discover_sources


@dataclass(frozen=True)
class SimulationSuite:
    name: str
    top: str
    test_module: str
    # Paths relative to the repository root; an empty tuple compiles all RTL.
    sources: tuple[str, ...] = ()
    parameters: dict[str, int] = field(default_factory=dict)


# Example once matching RTL and a Cocotb testbench exist:
# SimulationSuite("geometry", "geometry_engine", "tb_geometry_engine")
SUITES: tuple[SimulationSuite, ...] = (
    SimulationSuite(
        "top",
        "top_smoke",
        "tb_top",
        sources=("rtl/top.sv", "tests/cocotb/top_smoke.sv"),
    ),
)


@pytest.mark.parametrize(
    "suite", SUITES or (None,), ids=lambda suite: suite.name if suite else "no-rtl"
)
def test_simulation(suite: SimulationSuite | None) -> None:
    sources = discover_sources(PROJECT_ROOT / "rtl")
    if not sources:
        pytest.skip("No RTL exists yet; no hardware simulation or coverage was performed.")
    if suite is None:
        pytest.fail(
            "RTL exists: register at least one SimulationSuite in tests/cocotb/test_runner.py."
        )

    simulator = os.getenv("SIM", "verilator")
    waves = os.getenv("WAVES") == "1"
    build_dir = PROJECT_ROOT / ".sim_build" / simulator / suite.name
    runner = get_runner(simulator)
    if simulator == "verilator" and "OBJCACHE" not in os.environ and shutil.which("ccache") is None:
        os.environ["OBJCACHE"] = ""
    runner.build(
        sources=[PROJECT_ROOT / path for path in suite.sources]
        if suite.sources
        else [source.path for source in sources],
        hdl_toplevel=suite.top,
        parameters=suite.parameters,
        build_dir=build_dir,
        always=True,
        clean=True,
        timescale=("1ns", "1ps"),
        waves=waves,
    )
    runner.test(
        hdl_toplevel=suite.top,
        test_module=suite.test_module,
        test_dir=build_dir,
        build_dir=build_dir,
        waves=waves,
    )
