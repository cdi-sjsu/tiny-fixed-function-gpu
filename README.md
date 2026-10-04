# Tiny Fixed Function GPU

A CDI SJSU project to build a fixed-function 3D graphics accelerator in
Verilog/SystemVerilog for an FPGA with VGA output.

The repository currently contains development infrastructure and subsystem planning
notes. There is no implemented RTL or hardware simulation suite yet. The invalid
placeholder wrapper has been removed.

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
scripts/             Future mesh preprocessing scripts
tests/
  cocotb/            Simulation runner and future hardware testbenches
  tools/             Infrastructure and EDAM consistency tests
tools/               Shared HDL discovery and quality workflows
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

## Phase 1 goals

- Convert OBJ mesh vertices into Q8.8 fixed-point lookup tables suitable for FPGA memory.
- Build a geometry engine for scaling, rotation, translation, and perspective projection.
- Connect geometry and rasterization through a ready/valid handshake.
- Rasterize projected triangles, with Pineda/edge functions as the initial candidate;
  interpolate depth and color.
- Store frames in a BRAM framebuffer and drive 640 × 480 VGA at 60 Hz.

Later phases may explore soft-core CPUs and programmable shaders. Board-specific
Vivado projects, constraints, and synthesis workflows will be defined as the hardware
design takes shape.
