import random

import cocotb
import pytest
from cocotb.clock import Clock
from cocotb.triggers import ReadOnly, RisingEdge

from tb.common.models.button_model import ButtonModel
from tools.sim_runner import SimulationSuite, run_simulation


@cocotb.test()
async def check_behavior(dut):
    """Checks all stages of button behavior"""
    STABLE_COUNT = int(dut.STABLE_COUNT.value)
    BUTTON_MODE = int(dut.BUTTON_MODE.value)
    model = ButtonModel(STABLE_COUNT=STABLE_COUNT, BUTTON_MODE=BUTTON_MODE)
    expected = 0
    actual = 0

    dut.clk.value = 0
    dut.rst_n.value = 0

    Clock(dut.clk, 10, unit="us").start()

    # Check reset
    model.step(rst_n=1, btn_i=1)
    expected = model.get_btn_o()

    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    ReadOnly()
    actual = int(dut.btn_o.value)

    assert expected == actual, "Failed: Check reset, Expected: {expected}, Actual: {actual}"

    # Check debounce
    dut.rst_n.value = 0
    dut.btn_i.value = 1

    for _ in range(STABLE_COUNT):
        model.step(rst_n=0, btn_i=1)
        expected = model.get_btn_o()

        await RisingEdge(dut.clk)
        ReadOnly()
        actual = int(dut.btn_o.value)

        assert expected == actual, "Check debounce, Expected: {expected}, Actual: {actual}"

    # Check hold
    dut.btn_i.value = 1

    for _ in range(random.randrange(1, STABLE_COUNT * 2)):
        model.step(rst_n=0, btn_i=1)
        expected = model.get_btn_o()

        await RisingEdge(dut.clk)
        ReadOnly()
        actual = int(dut.btn_o.value)

        assert expected == actual, "Check hold, Expected: {expected}, Actual: {actual}"

    # Check release
    dut.btn_i.value = 1
    for _ in range(random.randrange(1, STABLE_COUNT * 2)):
        model.step(rst_n=0, btn_i=0)
        expected = model.get_btn_o()

        await RisingEdge(dut.clk)
        ReadOnly()
        actual = int(dut.btn_o.value)

        assert expected == actual, "Check hold, Expected: {expected}, Actual: {actual}"


@pytest.mark.parametrize("stable_count", [1, 4, 100])
@pytest.mark.parametrize("button_mode", [0, 1], ids=["pulse", "sustained"])
def test_button(stable_count: int, button_mode: int):
    run_simulation(
        SimulationSuite(
            name=f"button_mode{button_mode}_cnt{stable_count}",
            top="button",
            test_module="tb.common.test_button",
            sources=("rtl/common/button.sv",),
            parameters={
                "BUTTON_MODE": button_mode,
                "STABLE_COUNT": stable_count,
            },
        )
    )
