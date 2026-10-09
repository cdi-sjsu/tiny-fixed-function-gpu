"""Rasterizer subsystem simulation suites."""

from __future__ import annotations

import pytest

from tests.common.sim_runner import SimulationSuite, run_simulation
from tools.hdl_sources import PROJECT_ROOT, discover_sources

RASTERIZER_SUITES: tuple[SimulationSuite, ...] = ()


@pytest.mark.parametrize(
    "suite",
    RASTERIZER_SUITES or (None,),
    ids=lambda suite: suite.name if suite else "no-rasterizer-rtl",
)
def test_rasterizer(suite: SimulationSuite | None) -> None:
    source_dir = PROJECT_ROOT / "rtl/rasterizer"
    if not source_dir.is_dir():
        pytest.skip("No rasterizer RTL exists yet; hardware simulation skipped.")
    sources = discover_sources(source_dir)
    if not sources:
        pytest.skip("No rasterizer RTL exists yet; hardware simulation skipped.")
    if suite is None:
        pytest.fail(
            "Rasterizer RTL exists: register a suite in tests/rasterizer/test_rasterizer.py."
        )
    run_simulation(suite, sources=sources)
