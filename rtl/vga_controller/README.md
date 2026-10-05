# Framebuffer and VGA Controller

[GPU VGA](https://github.com/orgs/cdi-sjsu/teams/gpu-vga) owns framebuffer access
and VGA display output. The lead is to be decided. Future RTL belongs in this
directory.

## Current status and task

There is no framebuffer/VGA RTL or registered hardware testbench yet.
[Issue #6: Framebuffer and VGA Controller interface](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/issues/6),
tracked with the **VGA Team** label, targets 640 × 480 at 60 Hz with a 25.175 MHz
pixel clock and 12-bit RGB444. The deliverable must document horizontal/vertical
timing, pixel format, and dual-port BRAM signals, addressing, and access timing.
It must also compare native 640 × 480 with 2× scaled 320 × 240 and explain scaling
constraints. The interface and scaling choice remain pending; this overview does
not complete that deliverable.

## Documentation and verification

Keep the framebuffer/VGA interface document and later design notes in Markdown
beside the sources here, and link them from this overview and issue #6 when available.
Coordinate framebuffer writes and pixel consumption with the rasterizer team.
Board-specific clocks, constraints, and synthesis setup will follow the design.

Use the [Dev Container and Make workflows](../../README.md#make-workflows). When adding
RTL, update `edam.yml` and register a Cocotb suite in `tests/cocotb/test_runner.py`
with its testbench under `tests/cocotb/`.
Run `make format`, `make check`, and `make waves`; run `make ci` before review.
Until RTL exists, HDL checks and hardware simulation explicitly skip.

Consult the [project board](https://github.com/orgs/cdi-sjsu/projects/1) and issue #6
for current progress and deadlines, and [CONTRIBUTING.md](../../CONTRIBUTING.md)
for review requirements.
