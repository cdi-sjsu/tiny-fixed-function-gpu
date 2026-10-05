# Python Preprocessing

[GPU Python Preprocessing](https://github.com/orgs/cdi-sjsu/teams/gpu-python-preprocessing)
owns preprocessing scripts and generated GPU data, including lookup tables and
future mesh conversion. The lead is to be decided. Add future preprocessing Python
sources under `scripts/`; `tools/` contains development infrastructure such as HDL
discovery and quality workflows.

## Current status and task

No preprocessing implementation or generated LUT is committed yet.
[Issue #5: Sine LUT and FPGA initialization research](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/issues/5),
tracked with the **Python Preprocessing Team** label, calls for a generated sine LUT,
its dimensions and numeric representation, and FPGA import instructions. Target
16-bit entries and document an alternative width if more suitable. Research
`$readmemh`/`$readmemb` or the appropriate tool-supported initialization mechanism.
The representation, width decision, initialization method, and generated data remain
pending; this overview does not generate a LUT or complete that deliverable.

## Documentation and verification

Keep script usage, reproducible generation commands, numeric formats, and FPGA
import instructions in this directory beside the future scripts. Link the completed
LUT and documentation from this overview and issue #5. Agree on generated-data
locations with the consuming RTL team when the import workflow is defined.

Use the [Dev Container and Make workflows](../README.md#workflows). Run `make format`
and `make check` for Python changes and `make ci` before review. Add focused pytest
tests under `tests/` for numeric correctness, dimensions, reproducibility, and output
format when scripts are implemented. Hardware import verification will require real
RTL and a [registered Cocotb suite](../README.md#adding-the-first-rtl-and-simulation);
HDL checks and hardware simulation explicitly skip in the current empty-RTL state.

Consult the [project board](https://github.com/orgs/cdi-sjsu/projects/1) and issue #5
for current progress and deadlines, and [CONTRIBUTING.md](../CONTRIBUTING.md)
for review requirements.
