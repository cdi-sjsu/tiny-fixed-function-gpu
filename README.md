# Tiny Fixed Function GPU

A CDI SJSU project to build a fixed-function 3D graphics accelerator in
SystemVerilog targeting the
[Digilent Arty S7-50](https://digilent.com/shop/arty-s7-spartan-7-fpga-development-board/)
FPGA with VGA output.

## Project and Teams

[Fall 2026 Club Project Board](https://github.com/orgs/cdi-sjsu/projects/1)

| Team | Responsibility | Members | Source directory | Issue label |
| --- | --- | --- | --- | --- |
| [GPU Rasterizer](https://github.com/orgs/cdi-sjsu/teams/gpu-rasterizer) | Triangle rasterization, depth, and color | [@Nativity8904](https://github.com/Nativity8904) **(lead)**<br>[@Forensic257](https://github.com/Forensic257)<br>[@Umar316798](https://github.com/Umar316798) <br>[@raylandho](https://github.com/raylandho) <br>[@wintlaekyaw](https://github.com/wintlaekyaw) <br>[@imnttoxicanymore](https://github.com/imnttoxicanymore) | [rtl/rasterizer/](rtl/rasterizer/README.md) | Rasterizer Team |
| [GPU Geometry](https://github.com/orgs/cdi-sjsu/teams/gpu-geometry) | Vertex transforms and triangle interfaces | [@nicojeda189](https://github.com/nicojeda189) **(lead)**<br>[@Moodlethenoodle](https://github.com/Moodlethenoodle) | [rtl/geometry_engine/](rtl/geometry_engine/README.md) | Geometry Team |
| [GPU Python Preprocessing](https://github.com/orgs/cdi-sjsu/teams/gpu-python-preprocessing) | Preprocessing scripts and generated GPU data | Lead: To be decided<br>No members assigned | `scripts/` | Python Preprocessing Team |
| [GPU VGA](https://github.com/orgs/cdi-sjsu/teams/gpu-vga) | Framebuffer and VGA display output | Lead: To be decided<br>[@DelosReyesJordan](https://github.com/DelosReyesJordan) | [rtl/vga_controller/](rtl/vga_controller/README.md) | VGA Team |

## Getting Started

1. Install [VS Code](https://code.visualstudio.com/) and its
   [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).
2. Prepare Docker:
   - **macOS:** Install [Docker Desktop](https://docs.docker.com/desktop/setup/install/mac-install/),
     open it, and wait for the engine to start. Intel and Apple Silicon Macs are supported.
   - **Windows:** Install [WSL 2](https://learn.microsoft.com/windows/wsl/install) with Ubuntu.
     Install [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/)
     with its WSL 2 backend and enable integration for Ubuntu. Restart when prompted and complete Ubuntu's first-run setup.
3. Clone the repository and open it in VS Code.
4. Select **Reopen in Container**, or run **Dev Containers: Reopen in Container** from
   the Command Palette (`Shift+Command+P` on macOS, `Ctrl+Shift+P` on Windows).
5. Run `make` in the container terminal to see available commands.
6. Configure TerosHDL using the steps below.

### TerosHDL project

The Dev Container includes TerosHDL and its dependencies. To load this project:

1. Select the TerosHDL icon in the VS Code Activity Bar.
2. Under **Projects**, select **Add Project**.
3. Select **Load project from YAML EDAM**.
4. In the file picker, select `edam.yml` from the repository root, then select
   **Select YAML EDAM files**.
5. Select `tiny_fixed_function_gpu` to make it the current project.
6. In the **Sources** list, right-click `rtl/top.sv` and choose
   **Select source as toplevel**.

## `make` workflows

| Command | Behavior |
| --- | --- |
| `make` | List available workflows. |
| `make setup` | Install development dependencies from `uv.lock`. |
| `make format` | Format Python with Ruff and RTL with Verible. |
| `make check` | Check Python lint/format, Verilator lint, Verible format, project metadata, and all tests. |
| `make test` | Run registered Cocotb simulation suites with Verilator. |
| `make waves` | Run the suites and write VCD traces under `.sim_build/verilator/<suite>/`. |
| `make ci` | Check lockfile consistency, install dependencies, and run the full quality check. |

## Repository structure

```text
.devcontainer/       Required toolchain and TerosHDL configuration
.github/workflows/   Container-based CI
.vscode/             Editor settings and extension recommendations
rtl/                 Verilog/SystemVerilog sources
  top.sv             Minimal GPU integration wrapper
  geometry_engine/   Geometry subsystem planning notes
  rasterizer/        Rasterizer planning notes
  vga_controller/    VGA controller planning notes
scripts/             Python preprocessing overview and future LUT/mesh scripts
tests/
  cocotb/            Simulation runner and top-level smoke test
  tools/             Infrastructure and EDAM consistency tests
tools/               Shared HDL discovery and quality workflows
CONTRIBUTING.md      Repository contributor and review workflow
edam.yml             TerosHDL source list and top-level selection
pyproject.toml       Python dependencies and tool configuration
uv.lock              Locked Python environment
Makefile             Local and CI workflows
```
