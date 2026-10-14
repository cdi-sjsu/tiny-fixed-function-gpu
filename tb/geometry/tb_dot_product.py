"""Check that the dot_product skeleton elaborates and simulation starts."""

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def smoke_dot_product(dut) -> None:
    """Initial smoke test verifying elaboration."""
    await Timer(1, unit="ns")
