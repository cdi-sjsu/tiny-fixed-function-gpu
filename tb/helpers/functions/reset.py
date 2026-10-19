from cocotb.triggers import ReadOnly, RisingEdge


async def reset(dut):
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    ReadOnly()
