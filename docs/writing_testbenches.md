# Writing and Running Testbenches

This guide explains how to implement hardware testbenches using Cocotb and Verilator.

---

## Architecture Overview

* **`rtl/`**: Synthesizable Verilog and SystemVerilog code only.
* **`tb/`**: Hardware verification testbenches and Cocotb test logic.
* **`tests/`**: Tests for repository tooling and metadata consistency.

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
        sources=("rtl/<subsystem>/foo.sv",),
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

## Shared GPU Types

Import `gpu_pkg` for synthesizable types. The simulation runner prepends files
from `rtl/pkg/` before suite sources and removes duplicate paths. Set
`auto_packages=False` only for suites that intentionally manage package sources.
List verification-only packages such as `tb/common/test_pkg.sv` explicitly before
the modules that use them.

`xyzw_vector_t` contains signed 32-bit `x` and `y`, unsigned 32-bit `z`, and
one-bit `w`. Depth can be zero; a high-bit `z` compares as a positive unsigned
value. `transformation_matrix_t` uses packed `[3:0][3:0][31:0]` dimensions.
The first row of an assignment pattern is row 3, and its first element is
column 3. Thus the existing translation fixture places its translation terms
at `[3][0]`, `[2][0]`, and `[1][0]`. Consumers must use this ordering.
