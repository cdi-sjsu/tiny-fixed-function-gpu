# Rasterization Group Meeting 3

**Date & Time:** 2026-11-10 | 12:00 – 13:00 (PST)<br>
**Location / Link:** ENGR 370
**Facilitator:** Kyle Ringor
**Note Taker:** Kyle Ringor
**Meeting Status:** Scheduled

---

### Attendees
* **Present:** Kyle - @Nativity8904, Sean — @imnttoxicanymore, Wint — @wintlaekyaw, Rayland — @raylandho
* **Absent / Excused:** None

---

### Agenda & Objectives
1. Wint's research: Z-buffer integration and barycentric weights.
2. Tour of new packages: `gpu_pkg` and `rasterizer_pkg`.
3. Tour of new RTL modules and scaffolding.
4. Implementation assignments and next steps.

---

### Discussion Points

#### 1. Wint's Z-Buffer Research: Barycentric Weights

Wint's action item from Meeting 2 was to research [Z-buffer integration with Pineda (#25)](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/issues/25).

##### Barycentric Weights from Edge Functions

![Wint's barycentric weight derivation](assets/wint_barycentric_weights.jpg)

Key questions to review and discuss:

* How are barycentric weights computed from the Pineda edge functions?
  * Edge values $e_0, e_1, e_2$ are proportional to signed areas of sub-triangles.
  * Normalized weights: $\lambda_i = e_i / (e_0 + e_1 + e_2)$, where the denominator is the signed area of the full triangle.
  * We precompute $1 / \text{area}$ during triangle setup to avoid dividing every pixel.
* How do barycentric weights map to depth and color interpolation?
  * $z = \lambda_0 z_0 + \lambda_1 z_1 + \lambda_2 z_2$ gives affine depth.
  * Same formula for Gouraud R, G, B channels.
  * The design currently uses **affine Gouraud** (screen-space planes), not perspective-correct — confirm this is acceptable for the first demo.
##### Z-Buffer Pipeline

![Wint's Z-buffer pipeline flowchart](assets/wint_zbuffer_pipeline.jpg)

* How does the Z-buffer integrate with the pipeline?
  * `pixel_commit` reads depth, compares new < stored (smaller = closer), then writes depth and color if it passes.
  * `buffer_clear` initializes depth to `DEPTH_CLEAR` (`all ones`) and color to the background before each frame.
  * `z_buffer` module owns BRAM storage; RAM size confirmed to fit on the Arty A7-100T (see Open Questions).

**Open Questions:**
* Did Wint's research identify any issues with the affine-only depth formulation, or do we need perspective-correct depth?
* What BRAM resources does a 640 × 480 × 16-bit depth buffer require, and do we fit on the Arty A7-100T?

---

#### 2. New Package Contents

The last PR (#55) split the original `gpu_pkg` into three packages and added SV interfaces. Walk the team through the changes.

##### `gpu_pkg` (shared types — Geometry → Rasterizer and Rasterizer → Framebuffer/VGA)

| Type / Parameter | Description |
| :--- | :--- |
| `COORD_WIDTH = 20`, `COORD_FRAC_BITS = 4` | Fixed-point screen coordinate, origin top-left, X right, Y down |
| `screen_coord_t` | `logic signed [19:0]` |
| `DEPTH_WIDTH = 16`, `depth_t` | 16-bit unsigned depth; all-ones reserved for clear |
| `rgb444_t` | `{red[3:0], green[3:0], blue[3:0]}` |
| `raster_vertex_t` | `{x, y, z, color}` — one vertex on the interface |
| `raster_triangle_t` | `{v0, v1, v2}` |
| `raster_command_t` | `{end_frame, triangle}` — `end_frame=1` signals end of frame |
| `color_write_t` | `{address, color}` — Rasterizer → Framebuffer write packet |
| `RENDER_WIDTH/HEIGHT`, `PIXEL_COUNT` | 640 × 480 = 307,200 pixels |
| `pixel_x_t`, `pixel_y_t`, `pixel_addr_t` | Computed log2 widths; address = y × 640 + x |

##### `rasterizer_pkg` (internal rasterizer types)

| Type / Parameter | Description |
| :--- | :--- |
| `EDGE_WIDTH = 2 * COORD_WIDTH + 2 = 42` | Extra bits for intermediate edge products |
| `edge_value_t` | `logic signed [41:0]` |
| `ATTR_WIDTH = 48`, `ATTR_FRAC_BITS = 16` | Fixed-point for depth and color interpolation |
| `attribute_t` | `logic signed [47:0]` |
| `color_attribute_t` | `{r, g, b}` — each channel is `attribute_t`; signed to handle gradients |
| `DEPTH_CLEAR` | `'1` (all ones — cannot be drawn with strict `<` test) |
| `triangle_setup_t` | Full setup: bounds, edge start/dx/dy, inclusive-edge flags, z/color start/dx/dy |
| `raster_sample_t` | Walker output: pixel (x,y), edges, z, interpolated color |
| `fragment_t` | After interpolation: (x,y), rounded `depth_t`, packed `rgb444_t` |
| `depth_write_t` | `{address, depth}` — Z-buffer write packet |

##### `geometry_pkg` (new, Geometry Team's types)

| Type / Parameter | Description |
| :--- | :--- |
| `GEOMETRY_WIDTH = 32`, `GEOMETRY_FRAC_BITS = 16` | Signed 32-bit fixed-point, 16 fractional bits |
| `geometry_scalar_t` | `logic signed [31:0]` |
| `GEOMETRY_ONE` | `1 << 16` |
| `xyzw_vector_t` | Homogeneous `{x, y, z, w}` before perspective division |
| `geometry_triangle_t` | `{vector_1, vector_2, vector_3}` |
| `transformation_matrix_t` | `4×4` matrix of `geometry_scalar_t` |

##### New SV Interfaces

| Interface | Purpose |
| :--- | :--- |
| `stream_if #(DATA_T)` | Generic ready/valid channel; `producer` and `consumer` modports |
| `memory_read_if #(ADDR_T, DATA_T)` | Decoupled read request + response with separate handshakes |
| `memory_write_if #(DATA_T)` | Write request + completion (done) with separate handshakes |

---

#### 3. New RTL Modules

The PR also added new scaffold modules. All are unimplemented (outputs tied to safe stub values) with detailed `TODO` comments. Walk through each so everyone knows their assignment.

##### `rasterizer_top` (wiring complete, all sub-modules stubbed)

The pipeline is fully connected. Data flow:

```
commands (raster_command_t stream)
  → [frame_controller: draw_enable gating]
  → triangle_fifo (sync_fifo)
  → triangle_setup
  → bbox_walker
  → edge_evaluator  ← (existing, implemented)
  → fragment_interpolator
  → pixel_commit ←→ z_buffer
                 → color_write (external framebuffer)
                 → fence → frame_controller → frame_done

buffer_clear ←→ z_buffer (depth) + color_write (color)
memory_write_mux: selects commit vs. clear owner per buffer
```

##### New modules needing implementation

| Module | Responsibility | Status |
| :--- | :--- | :--- |
| [`frame_controller`](../../../rtl/rasterizer/frame_controller.sv) | IDLE → CLEAR → DRAW → DRAIN → DONE state machine; gates `draw_enable`; issues `clear_start`; waits for `fence` before asserting `frame_done` | Stubbed |
| [`triangle_setup`](../../../rtl/rasterizer/triangle_setup.sv) | Normalize winding; clamp bounding box to screen; compute unbiased edge values, top-left flags, and depth/color gradients at first pixel center | Stubbed |
| [`bbox_walker`](../../../rtl/rasterizer/bbox_walker.sv) | Walk xmin..xmax, ymin..ymax; step edge, z, and color accumulators; skip empty triangles; pass end-of-frame markers | Stubbed |
| [`fragment_interpolator`](../../../rtl/rasterizer/fragment_interpolator.sv) | Round and clamp depth to `depth_t`; round and clamp each color channel to 0..15; pack `rgb444_t` | Stubbed |
| [`pixel_commit`](../../../rtl/rasterizer/pixel_commit.sv) | Read depth; compare new < stored; write depth + color; wait for both completions; pass end-of-frame fence after all writes done | Stubbed |
| [`buffer_clear`](../../../rtl/rasterizer/buffer_clear.sv) | Walk addresses 0..PIXEL_COUNT-1; write both color and depth per pixel; signal done after all writes | Stubbed |
| [`z_buffer`](../../../rtl/rasterizer/z_buffer.sv) | BRAM storage for 16-bit depth; read/write via `memory_read_if` / `memory_write_if`; RAM budget confirmed for Arty A7-100T | Stubbed |
| [`memory_write_mux`](../../../rtl/common/memory_write_mux.sv) | Routes writes and completions to one of two requesters based on `select_b` | **Implemented** |

##### Existing implemented module
* [`edge_evaluator`](../../../rtl/rasterizer/edge_evaluator.sv) — coverage test: inside is positive, respects `inclusive_edge` top-left flags.

##### Pending `edam.yml` change

An unstaged `edam.yml` modification adds the seven new RTL files to the build. Needs review and commit.

---

#### 4. Open Design Questions

* **Z-buffer BRAM size:** 640 × 480 × 16-bit = 4,915,200 bits ≈ 600 KB. The Arty A7-100T has 4.86 Mb of BRAM (135 × 36Kb blocks), which comfortably fits both the depth buffer and color framebuffer on-chip. No external memory should be needed.
* **Perspective-correct depth/color:** Current plan is affine Gouraud. Is that sufficient for the first demo, or do we need a reciprocal/division stage?
* **`triangle_setup` winding normalization:** When winding is flipped, vertex colors must be swapped to match the new $v_0, v_1, v_2$ assignment. Confirm the swap strategy.
* **`pixel_commit` depth address:** `address = y * RENDER_WIDTH + x` — confirm this is computed by a multiply or a shift-and-add, and whether it should live here or in `triangle_setup`.
* **Testbench coverage:** `tb/rasterizer/` currently only has an `__init__.py`. Who writes the rasterizer testbench and what scenarios does it cover first?

---

### Key Decisions Made

*(To be filled in during the meeting)*

---

### Action Items

| Task | Owner | Due Date | Status |
| :--- | :--- | :--- | :--- |
| Present Z-buffer and barycentric weight research | Wint — @wintlaekyaw | 2026-11-09 (this meeting) | Due |
| Implement `frame_controller` | TBD | TBD | Unassigned |
| Implement `triangle_setup` | TBD | TBD | Unassigned |
| Implement `bbox_walker` | TBD | TBD | Unassigned |
| Implement `fragment_interpolator` | TBD | TBD | Unassigned |
| Implement `pixel_commit` | TBD | TBD | Unassigned |
| Implement `buffer_clear` | TBD | TBD | Unassigned |
| Implement `z_buffer` | TBD | TBD | Unassigned |
| Commit `edam.yml` changes | TBD | TBD | Pending |
| Write rasterizer testbench | TBD | TBD | Unassigned |

---

### Next Steps & Follow-Up
* **Next Meeting:** TBD
* **Artifacts / Links:**
  * [Meeting 2: Pineda walkthrough and interface design](meeting_2.md)
  * [Meeting 1: Rasterization options](meeting_1.md)
  * [Rasterization algorithms, interfaces, and pseudocode: issue #19](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/issues/19)
  * [Research Z-buffer integration with Pineda: issue #25](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/issues/25)
  * [PR #55: Split RTL packages, add SV interfaces, order sources by kind](https://github.com/cdi-sjsu/tiny-fixed-function-gpu/pull/55)
