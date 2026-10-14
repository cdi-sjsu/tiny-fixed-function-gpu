"""Allow the HDL type-contract checks to execute at simulation startup."""

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def check_type_contract(dut) -> None:
    """HDL initialization fails the simulation if a type contract is violated."""
    await Timer(1, unit="ns")
