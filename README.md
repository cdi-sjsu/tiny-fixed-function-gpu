# Tiny Fixed Function GPU

A CDI SJSU project to build a fixed-function 3D graphics accelerator in
Verilog/SystemVerilog for an FPGA with VGA output.

The repository currently contains development infrastructure and subsystem planning
notes. There is no implemented RTL or hardware simulation suite yet. The invalid
placeholder wrapper has been removed.

## Project and teams

Track work on the [Fall 2026 Club Project board](https://github.com/orgs/cdi-sjsu/projects/1).
GitHub issues and the board are the authoritative sources for progress, assignments,
and deadlines. The four engineering deliverables below remain open; their current
issue deadlines are October 10, 2026. Planning documentation does not complete them.

| Team | Responsibility | Lead | Source directory | Issue label | Current task |
| --- | --- | --- | --- | --- | --- |
| [GPU Rasterizer](https://github.com/orgs/cdi-sjsu/teams/gpu-rasterizer) | Triangle rasterization, depth, and color | [@Nativity8904](https://github.com/Nativity8904) | [rtl/rasterizer/](rtl/rasterizer/README.md) | Rasterizer Team | [#3: Algorithm comparison and recommendation](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/issues/3) |
| [GPU Geometry](https://github.com/orgs/cdi-sjsu/teams/gpu-geometry) | Vertex transforms and triangle interfaces | [@nicojeda189](https://github.com/nicojeda189) | [rtl/geometry_engine/](rtl/geometry_engine/README.md) | Geometry Team | [#4: Preliminary Geometry Engine interface](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/issues/4) |
| [GPU Python Preprocessing](https://github.com/orgs/cdi-sjsu/teams/gpu-python-preprocessing) | Preprocessing scripts and generated GPU data | To be decided | [scripts/](scripts/README.md) | Python Preprocessing Team | [#5: Sine LUT and FPGA initialization research](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/issues/5) |
| [GPU VGA](https://github.com/orgs/cdi-sjsu/teams/gpu-vga) | Framebuffer and VGA display output | To be decided | [rtl/vga_controller/](rtl/vga_controller/README.md) | VGA Team | [#6: Framebuffer and VGA Controller interface](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/issues/6) |

See [CONTRIBUTING.md](CONTRIBUTING.md) for branches, issue-linked PRs, team reviews,
required checks, and signing guidance.

## Required development environment

Open this repository in its VS Code Dev Container. It provides pinned Verilator,
Verible, Python tooling, TerosHDL, and the Surfer waveform extension. CI builds the
same image and runs the same checks. The previous Nix/direnv environment has been
replaced.

1. Install [VS Code](https://code.visualstudio.com/) and its
   [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).
2. Prepare Docker:
   - **macOS:** Install [Docker Desktop](https://docs.docker.com/desktop/setup/install/mac-install/),
     open it, and wait for the engine to start. Intel and Apple Silicon Macs are supported.
   - **Windows:** Install [WSL 2](https://learn.microsoft.com/windows/wsl/install) with Ubuntu.
     Install [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/)
     with its WSL 2 backend and enable integration for Ubuntu. Restart when prompted,
     complete Ubuntu's first-run setup, and clone into the WSL filesystem for best performance.
3. Clone the repository and open it in VS Code. For a WSL clone, run `code .` from Ubuntu
   with the [WSL extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) installed.
4. Select **Reopen in Container**, or run **Dev Containers: Reopen in Container** from
   the Command Palette (`Shift+Command+P` on macOS, `Ctrl+Shift+P` on Windows).
5. Wait for the image build and automatic `make setup` to finish, then run `make` in
   the container terminal.

The Python environment lives in a container-managed volume. After changing container
configuration, run **Dev Containers: Rebuild Container**. After changing Python
dependencies, update the lockfile with `uv lock` and run `make setup` inside the container.

## Workflows

| Command | Behavior |
| --- | --- |
| `make` | List available workflows. |
| `make setup` | Install development dependencies from `uv.lock`. |
| `make format` | Format Python with Ruff and RTL with Verible. |
| `make check` | Check Python lint/format, Verilator lint, Verible format, project metadata, and all tests. |
| `make test` | Run registered Cocotb simulation suites with Verilator. |
| `make waves` | Run the suites and write VCD traces under `.sim_build/verilator/<suite>/`. |
| `make ci` | Check lockfile consistency, install dependencies, and run the full quality gate. |

With no RTL, HDL commands print an explicit `SKIP` and pytest reports the hardware
simulation as skipped. Passing infrastructure checks does not establish GPU functionality
or hardware coverage. When RTL is added, simulations fail until a suite is registered.
Generated documentation is not part of these workflows.

## Repository structure

```text
.devcontainer/       Required toolchain and TerosHDL configuration
.github/workflows/   Container-based CI
.vscode/             Editor settings and extension recommendations
rtl/                 Future Verilog/SystemVerilog sources
  geometry_engine/   Geometry subsystem planning notes
  rasterizer/        Rasterizer planning notes
  vga_controller/    VGA controller planning notes
scripts/             Python preprocessing overview and future LUT/mesh scripts
tests/
  cocotb/            Simulation runner and future hardware testbenches
  tools/             Infrastructure and EDAM consistency tests
tools/               Shared HDL discovery and quality workflows
CONTRIBUTING.md      Repository contributor and review workflow
edam.yml             TerosHDL source list and future top-level selection
pyproject.toml       Python dependencies and tool configuration
uv.lock              Locked Python environment
Makefile             Local and CI workflows
```

## Adding the first RTL and simulation

1. Add `.v` or `.sv` files under the appropriate `rtl/` subsystem. Discovery is recursive;
   `*_pkg.sv` files come first, followed by other sources in path order.
2. Add each source to `edam.yml` in that same order. Use `verilogSource` for `.v` and
   `systemVerilogSource` for `.sv`. Set `toplevel` to the actual top module name.
3. Add a Cocotb testbench named `tb_<subsystem>.py` in `tests/cocotb/`.
4. Register a `SimulationSuite` in `tests/cocotb/test_runner.py`, specifying a unique
   name, top module, and testbench module name without `.py`. Its optional `sources`
   tuple contains repository-relative paths in compilation order; omitting it compiles
   all discovered RTL. Use `parameters` for parameter overrides.
5. Run `make format`, `make check`, and `make waves`. Open the generated `dump.vcd` in Surfer.

For example, after implementing the matching module and testbench:

```python
SUITES = (
    SimulationSuite(
        name="geometry",
        top="geometry_engine",
        test_module="tb_geometry_engine",
        sources=("rtl/geometry_engine/geometry_engine.sv",),
    ),
)
```

Load `edam.yml` from **TerosHDL > Projects > Add Project > Load project from YAML EDAM**.
The initial project has no sources or top module; hierarchy and simulation become useful
after the first RTL is registered. Select `tiny_fixed_function_gpu` as the current project.

## Git signatures

See the [CDI contributor and Git signature guide](https://github.com/cdi-sjsu/.github/blob/main/CONTRIBUTING.md#git-signatures)
for verifying existing PGP commits, setting up SSH signing, and sharing the host agent
with the container. Signing is configured per contributor; container creation does not import
keys or change Git signing settings.

## Phase 1 direction

- Preprocess mesh data for FPGA use and produce a sine LUT. Issue #5 targets 16-bit
  LUT entries; dimensions, numeric representation, and initialization remain pending.
- Build a geometry engine for scaling, rotation, translation, and perspective
  projection. Issue #4 will define Q8.8 usage, triangle formats, ports, and handshakes.
- Rasterize projected triangles and handle depth and color. The Phase 1 rasterization
  algorithm remains pending the comparison and recommendation in issue #3.
- Store frames in BRAM and drive 640 × 480 VGA at 60 Hz. Issue #6 specifies a
  25.175 MHz pixel clock and RGB444 target; timing, BRAM access, and the comparison
  with 2× scaled 320 × 240 output still need an interface document.

Later phases may explore soft-core CPUs and programmable shaders. Board-specific
Vivado projects, constraints, and synthesis workflows will be defined as the hardware
design takes shape.
