# Geometry Engine

[GPU Geometry](https://github.com/orgs/cdi-sjsu/teams/gpu-geometry), led by
[@nicojeda189](https://github.com/nicojeda189), owns vertex transforms and triangle
interfaces. Planned operations include scaling, rotation, translation, and
perspective projection. Future RTL belongs in this directory.

## Current status and task

There is no geometry RTL or registered hardware testbench yet.
[Issue #4: Preliminary Geometry Engine interface](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/issues/4),
tracked with the **Geometry Team** label, calls for vertex and triangle formats,
Q8.8 usage and coordinate formats, port widths, and handshake timing. These interface
decisions remain pending; this overview does not define the interface or complete
that deliverable.

## Documentation and verification

Keep the preliminary interface document and later design notes in Markdown beside
the sources here. Link them from this overview and issue #4 when available. Include
when data is valid and accepted, and coordinate the interfaces with rasterization
and Python preprocessing.

Use the [Dev Container and Make workflows](../../README.md#make-workflows). When adding
RTL, update `edam.yml` and register a Cocotb suite in `tests/cocotb/test_runner.py`
with its testbench under `tests/cocotb/`.
Run `make format`, `make check`, and `make waves`; run `make ci` before review.
Until RTL exists, HDL checks and hardware simulation explicitly skip.

Consult the [project board](https://github.com/orgs/cdi-sjsu/projects/1) and issue #4
for current progress and deadlines, and [CONTRIBUTING.md](../../CONTRIBUTING.md)
for review requirements.
