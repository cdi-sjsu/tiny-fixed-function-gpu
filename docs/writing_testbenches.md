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

### Step 1: Write the Cocotb Test Logic (`tb/<subsystem>/tb_<module>.py`)

Create a Python file with your Cocotb coroutines using `@cocotb.test()`:

```python
"""Smoke and unit tests for the foo module."""

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_foo(dut) -> None:
    # Drive input signals
    dut.v_0.value = 0
    await Timer(10, unit="ns")

    # Assert expected outputs
    assert dut.v.value == 0
```

For reference, look at the [documentation](https://docs.cocotb.org/en/stable/index.html) and [examples](https://github.com/cocotb/cocotb/tree/master/examples).

### Step 2: Register the Suite (`tb/<subsystem>/test_<subsystem>.py`)

Add your `SimulationSuite` to the subsystem tuple:

```python
<SUBSYSTEM>_SUITES: tuple[SimulationSuite, ...] = (
    SimulationSuite(
        name="foo",
        top="foo",
        test_module="tb_foo",
        sources=("<subsystem>/foo.sv",),
    ),
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
make tb TARGET=top
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
