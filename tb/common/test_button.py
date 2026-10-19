import random

import cocotb
import pytest
from cocotb.clock import Clock
from cocotb.triggers import ReadOnly, RisingEdge

from tb.common.models.button_model import ButtonModel
from tb.helpers.functions.reset import reset
from tools.sim_runner import SimulationSuite, run_simulation


async def _check_hold_state(dut, *, model: ButtonModel, level: int) -> tuple[int, int]:
    model.step(rst_n=0, btn_i=level)
    expected = model.get_btn_o()

    await RisingEdge(dut.clk)
    ReadOnly()
    actual = int(dut.btn_o.value)

    return expected, actual


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

    await reset(dut)
    actual = int(dut.btn_o.value)

    assert expected == actual

    dut.rst_n.value = 0

    # Check debounce
    for _ in range(STABLE_COUNT):
        expected, actual = await _check_hold_state(dut, model=model, level=1)
        assert expected == actual

    # Check hold
    for _ in range(random.randrange(1, STABLE_COUNT * 2)):
        expected, actual = await _check_hold_state(dut, model=model, level=1)
        assert expected == actual

    # Check release
    for _ in range(random.randrange(1, STABLE_COUNT * 2)):
        expected, actual = await _check_hold_state(dut, model=model, level=0)
        assert expected == actual


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
