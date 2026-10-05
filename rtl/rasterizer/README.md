# Rasterizer

[GPU Rasterizer](https://github.com/orgs/cdi-sjsu/teams/gpu-rasterizer), led by
[@Nativity8904](https://github.com/Nativity8904), owns triangle rasterization and
the planned depth and color processing. Future RTL belongs in this directory.

## Current status and task

There is no rasterizer RTL or registered hardware testbench yet. The Phase 1
algorithm is pending [issue #3: Rasterization algorithm recommendation](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/issues/3),
tracked with the **Rasterizer Team** label. Compare candidate algorithms and their
implementation tradeoffs, recommend an approach, and present it at the next meeting.
This overview does not select an algorithm or complete that deliverable.

## Documentation and verification

Keep the comparison, recommendation, and later design notes in Markdown beside
the sources here, and link them from this overview and issue #3 when available.
Document triangle inputs, generated fragments, depth/color behavior, and integration
with geometry and framebuffer interfaces as those decisions are made.

Use the [Dev Container and Make workflows](../../README.md#make-workflows). When adding
RTL, update `edam.yml` and register a Cocotb suite in `tests/cocotb/test_runner.py`
with its testbench under `tests/cocotb/`.
Run `make format`, `make check`, and `make waves`; run `make ci` before review.
Until RTL exists, HDL checks and hardware simulation explicitly skip.

Consult the [project board](https://github.com/orgs/cdi-sjsu/projects/1) and issue #3
for current progress and deadlines, and [CONTRIBUTING.md](../../CONTRIBUTING.md)
for review requirements.
