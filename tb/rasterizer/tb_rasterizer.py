"""Rasterizer subsystem smoke testbench."""

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def smoke_rasterizer_top(dut) -> None:
    """Check that rasterizer_top elaborates and simulation starts."""
    await Timer(1, unit="ns")
