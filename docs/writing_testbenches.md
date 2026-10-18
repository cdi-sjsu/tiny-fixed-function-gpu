# Writing and Running Testbenches

This guide explains how to implement hardware testbenches using Cocotb and Verilator.

---

## Architecture Overview

* **`rtl/`**: Synthesizable Verilog and SystemVerilog code only.
* **`tb/`**: Hardware verification testbenches and Cocotb test logic.
* **`tests/`**: Tests for other components. Don't touch this.

---

## Adding a Testbench for a New Module

Adding verification for a new subsystem module takes two steps:

### Step 1: Write the Cocotb Test Logic (`tb/<subsystem>/test_<module>.py`)

Create a Python file with your Cocotb coroutines using `@cocotb.test()`. For example, `tb/common/test_foo.py` for a module named `foo`. Replace the example paths, ports, parameters, and expected values with your module's.

```python
"""Simple unit test for foo."""

import cocotb
import pytest
from cocotb.clock import Clock
from cocotb.triggers import ReadOnly, RisingEdge

from tools.sim_runner import SimulationSuite, run_simulation


@cocotb.test()
async def check_reset(dut) -> None:
    # Initialize inputs and hold reset
    dut.clk.value = 0
    dut.rst_n.value = 0
    dut.data_i.value = 0
    Clock(dut.clk, 10, unit="ns").start()

    await RisingEdge(dut.clk)
    await ReadOnly()

    # Assert expected outputs
    assert int(dut.data_o.value) == 0
```

For reference, look at the [documentation](https://docs.cocotb.org/en/stable/index.html) and [examples](https://github.com/cocotb/cocotb/tree/master/examples).

### Step 2: Add the Pytest Launcher (Same File)

Pytest builds and launches the simulation. Cocotb runs all `@cocotb.test()` functions in `test_module`. Keep their names outside the `test_*` pattern so pytest only collects the launcher.

Add this below your Cocotb tests:

```python
@pytest.mark.parametrize("width", [8, 16, 32])
@pytest.mark.parametrize("depth", [4, 16])
def test_foo(width: int, depth: int) -> None:
    run_simulation(
        SimulationSuite(
            name=f"foo_width{width}_depth{depth}",
            top="foo",
            test_module="tb.common.test_foo",
            sources=("rtl/common/foo.sv",),
            parameters={
                "WIDTH": width,
                "DEPTH": depth,
            },
        )
    )
```

---

## Running Testbenches

### Run Hardware Testbenches
```bash
make tb
```

### Target a Specific Subsystem
You can target any subsystem folder directly:
```bash
make tb TARGET=geometry
make tb TARGET=rasterizer
make tb TARGET=common
```

### Target a Specific Module
```bash
make tb TARGET=common/test_foo.py
```

### Run with Waveform Traces
To generate `.vcd` waveform traces for GTKWave or Surfer:
```bash
make waves TARGET=geometry
```
The waveform trace will be generated at:
```text
.sim_build/verilator/<suite_name>/dump.vcd
```
