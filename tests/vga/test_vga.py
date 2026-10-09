"""VGA and Framebuffer subsystem simulation suites."""

from __future__ import annotations

import pytest

from tests.common.sim_runner import SimulationSuite, run_simulation
from tools.hdl_sources import PROJECT_ROOT, discover_sources

VGA_SUITES: tuple[SimulationSuite, ...] = ()


@pytest.mark.parametrize(
    "suite",
    VGA_SUITES or (None,),
    ids=lambda suite: suite.name if suite else "no-vga-rtl",
)
def test_vga(suite: SimulationSuite | None) -> None:
    source_dir = PROJECT_ROOT / "rtl/vga_controller"
    if not source_dir.is_dir():
        pytest.skip("No VGA RTL exists yet; hardware simulation skipped.")
    sources = discover_sources(source_dir)
    if not sources:
        pytest.skip("No VGA RTL exists yet; hardware simulation skipped.")
    if suite is None:
        pytest.fail("VGA RTL exists: register a suite in tests/vga/test_vga.py.")
    run_simulation(suite, sources=sources)
