# Tiny Fixed Function GPU

A CDI SJSU project to build a fixed-function 3D graphics accelerator in
SystemVerilog targeting the
[Digilent Arty S7-50](https://digilent.com/shop/arty-s7-spartan-7-fpga-development-board/)
FPGA with VGA output.

## Project and Teams

[Fall 2026 Club Project Board](https://github.com/orgs/cdi-sjsu/projects/1)

| Team | Responsibility | Lead | Members | Source directory | Issue label |
| --- | --- | --- | --- | --- | --- |
| [GPU Rasterizer](https://github.com/orgs/cdi-sjsu/teams/gpu-rasterizer) | Triangle rasterization, depth, and color | [@Nativity8904](https://github.com/Nativity8904) | [@Forensic257](https://github.com/Forensic257)<br>[@Umar316798](https://github.com/Umar316798)<br>[@raylandho](https://github.com/raylandho)<br>[@wintlaekyaw](https://github.com/wintlaekyaw)<br>[@imnttoxicanymore](https://github.com/imnttoxicanymore) | [rtl/rasterizer/](rtl/rasterizer/) | Rasterizer Team |
| [GPU Geometry](https://github.com/orgs/cdi-sjsu/teams/gpu-geometry) | Vertex transforms and triangle interfaces | [@nicojeda189](https://github.com/nicojeda189) | [@Moodlethenoodle](https://github.com/Moodlethenoodle)<br>[@Sachin-Swami21](https://github.com/Sachin-Swami21)<br>[@imnttoxicanymore](https://github.com/imnttoxicanymore) | [rtl/geometry/](rtl/geometry/) | Geometry Team |
| [GPU Python Preprocessing](https://github.com/orgs/cdi-sjsu/teams/gpu-python-preprocessing) | Preprocessing scripts and generated GPU data | To be decided | No members assigned | `scripts/` | Python Preprocessing Team |
| [GPU VGA](https://github.com/orgs/cdi-sjsu/teams/gpu-vga) | Framebuffer and VGA display output | To be decided | [@DelosReyesJordan](https://github.com/DelosReyesJordan) | [rtl/vga/](rtl/vga/) | VGA Team |

## Getting Started

1. **Prepare Docker & Environment:**
   - **Windows:**
     1. Open PowerShell as Administrator and run:
        ```powershell
        wsl --install
        ```
        Restart your PC if prompted, then launch Ubuntu from the Start menu to set your username and password.
     2. Install [Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/). Ensure **Use the WSL 2 based engine** is checked during installation.
     3. Open Docker Desktop, go to **Settings > Resources > WSL Integration**, turn on integration for **Ubuntu**, and select **Apply & restart**.
   - **macOS:**
     Install [Docker Desktop for Mac](https://docs.docker.com/desktop/setup/install/mac-install/), open it, and wait for the engine to start.

2. **Install VS Code & Extensions:**
   - Install [VS Code](https://code.visualstudio.com/).
   - Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) (and the [WSL extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) on Windows).

3. **Clone and Open in Container:**
   - Clone this repository.
   - Open the repository folder in VS Code.
   - When prompted, select **Reopen in Container**, or open the Command Palette (`Ctrl+Shift+P` on Windows, `Cmd+Shift+P` on macOS) and run **Dev Containers: Reopen in Container**.

4. **Verify & Configure:**
   - Run `make` in the container terminal to list available workflows.
   - Configure TerosHDL using the steps below.

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
| `make` | Show help message. |
| `make edam` | Refresh the TerosHDL source list from `rtl/`. |
| `make format` | Format Python and HDL code. |
| `make check` | Run full lint, format check, and all tests. |
| `make test` | Run software and tooling tests (`tests/`). |
| `make tb` | Run hardware simulation testbenches (`tb/`). |
| `make waves` | Run testbenches and record VCD waveforms. |

The Dev Container installs dependencies automatically. The `edam.yml` source list
regenerates during container setup and before formatting, checking, or running
tests and simulations. After adding, removing, or renaming RTL files, use
`make edam` to refresh it immediately before reloading the TerosHDL project.
Project metadata such as the project name and selected top module remains configured
in `edam.yml`; only the source list is generated.

## Repository structure

```text
.devcontainer/       Required toolchain and TerosHDL configuration
.github/workflows/   Container-based CI
.vscode/             Editor settings and extension recommendations
constraints/         FPGA board pin constraints (Arty S7-50 XDC)
rtl/                 Synthesizable Verilog/SystemVerilog sources
  top.sv             Minimal GPU integration wrapper
  pkg/               Shared GPU packages, structs, and vector typedefs
  common/            Shared hardware utility modules
  geometry/          Geometry subsystem sources
  rasterizer/        Rasterizer subsystem sources
  vga/               VGA subsystem sources
scripts/             Python preprocessing overview and future LUT/mesh scripts
tb/                  Hardware verification and Cocotb simulation suites
  common/            Testbenches for shared hardware utility modules
  geometry/          Geometry subsystem testbenches and simulation suites
  rasterizer/        Rasterizer subsystem testbenches and simulation suites
  top/               Top-level GPU wrapper and smoke tests
  vga/               VGA controller and framebuffer simulation suites
tests/               Repository, toolchain, and metadata consistency tests
  tools/             EDAM and HDL discovery consistency tests
tools/               Shared simulation runner, HDL discovery, and quality workflows
CONTRIBUTING.md      Repository contributor and review workflow
edam.yml             TerosHDL source list and top-level selection
pyproject.toml       Python dependencies and tool configuration
uv.lock              Locked Python environment
Makefile             Local and CI workflows
```
