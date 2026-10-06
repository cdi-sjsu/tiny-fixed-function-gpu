"""Check shell elaboration and simulation startup, without exercising GPU behavior."""

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def smoke_top(dut) -> None:
    """Elaborate the portless wrapper through its test-only harness."""
    await Timer(1, unit="ns")
    assert dut.shell_loaded.value == 1
