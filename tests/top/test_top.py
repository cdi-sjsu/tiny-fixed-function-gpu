"""Top-level GPU wrapper integration test suite."""

import pytest

from tests.common.sim_runner import SimulationSuite, run_simulation
from tools.hdl_sources import PROJECT_ROOT, discover_sources

TOP_SUITE = SimulationSuite(
    name="top",
    top="top_smoke",
    test_module="tb_top",
    sources=("rtl/top.sv", "tests/top/top_smoke.sv"),
)


def test_top_smoke() -> None:
    sources = discover_sources(PROJECT_ROOT / "rtl")
    if not sources:
        pytest.skip("No RTL exists yet; top smoke simulation skipped.")
    run_simulation(TOP_SUITE)
