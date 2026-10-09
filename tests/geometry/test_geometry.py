"""Geometry engine subsystem simulation suites."""

from __future__ import annotations

import pytest

from tests.common.sim_runner import SimulationSuite, run_simulation
from tools.hdl_sources import PROJECT_ROOT, discover_sources

GEOMETRY_SUITES: tuple[SimulationSuite, ...] = ()


@pytest.mark.parametrize(
    "suite",
    GEOMETRY_SUITES or (None,),
    ids=lambda suite: suite.name if suite else "no-geometry-rtl",
)
def test_geometry(suite: SimulationSuite | None) -> None:
    source_dir = PROJECT_ROOT / "rtl/geometry"
    if not source_dir.is_dir():
        pytest.skip("No geometry RTL exists yet; hardware simulation skipped.")
    sources = discover_sources(source_dir)
    if not sources:
        pytest.skip("No geometry RTL exists yet; hardware simulation skipped.")
    if suite is None:
        pytest.fail("Geometry RTL exists: register a suite in tests/geometry/test_geometry.py.")
    run_simulation(suite, sources=sources)
