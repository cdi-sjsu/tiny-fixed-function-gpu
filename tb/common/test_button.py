import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ReadOnly, RisingEdge

from tb.common.models.button_model import ButtonModel
from tb.common.sim_runner import SimulationSuite, run_simulation


@cocotb.test()
async def check_behavior(dut):
    """NOT FINISHED"""
    model = ButtonModel(STABLE_COUNT=dut.STABLE_COUNT.value, BUTTON_MODE=dut.BUTTON_MODE.value)

    dut.clk.value = 0
    dut.rst_n.value = 0

    Clock(dut.clk, 10, unit="us").start()

    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    await ReadOnly()

    assert int(dut.btn_o.value) == model.step(
        rst_n=1,
        btn_i=1,
    )


def test_button():
    run_simulation(
        SimulationSuite(
            name="button",
            top="button",
            test_module="tb.common.test_button",
            sources=("rtl/common/button.sv",),
            parameters={
                "BUTTON_MODE": 1,
                "STABLE_COUNT": 4,
            },
        )
    )
