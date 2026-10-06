# Tiny Fixed Function GPU: Rasterization Options & Meeting Agenda

Choose the design for the CDI SJSU Tiny Fixed Function GPU and agree on the first
demo. The options below are discussion inputs; no architecture or roadmap is
selected here.

**Project context:** The repository targets the Digilent Arty S7-50. The VGA team’s
current task uses 640 × 480 output at 60 Hz and RGB444 color, with native rendering
versus 2× scaled 320 × 240 still open. Memory figures below count raw pixel data;
actual BRAM use depends on packing, port configuration, and other subsystem needs.

## Design options

| Decision | Available options and tradeoffs | Meeting question |
| --- | --- | --- |
| **Rasterization algorithm** | **Bounding-box edge functions (Pineda):** regular traversal and addition-based edge updates, but tests pixels outside the triangle, especially for thin triangles. **Scanline traversal (DDA):** fills horizontal spans with less outside-triangle work, but needs edge setup, vertex ordering, and careful span/edge handling. | Which traversal best balances implementation effort, pixel throughput, and expected triangle shapes? |
| **Render resolution** | **Native 640 × 480:** finer detail, with four times the pixels and storage of 320 × 240. **320 × 240, scaled 2×:** lower memory and rendering work, with visibly larger pixels and repetition in both scanout dimensions. | What image detail and frame rate should the demo target, and what memory architecture supports it? |
| **Visibility** | **Software back-to-front sorting:** avoids depth memory, but a single triangle order cannot correctly resolve all intersecting geometry. **Hardware depth buffer:** resolves visibility per pixel regardless of triangle submission order, but adds storage, comparison, clearing, and read/write coordination. | What scenes must render correctly, and where should visibility be resolved? |
| **Depth precision** | **8-bit:** less storage, but coarser depth can make nearby surfaces compete for the same value. **16-bit:** finer depth distinctions at twice the storage. Both depend on the depth mapping and camera near/far range. | If depth buffering is included, what precision does the demo scene need? |
| **Shading and interpolation** | **Flat color:** one color per triangle and minimal interpolation. **Affine Gouraud:** smoothly interpolates vertex colors in screen space, with added arithmetic. **Perspective-correct attributes:** accounts for projection when interpolating colors or future texture coordinates, with added reciprocal/division work. | What visible shading capability should the first demo include? |
| **Screen coordinates** | **Integer pixels:** smaller values and simpler setup, but vertices can visibly snap during motion. **Fixed-point subpixel coordinates:** smoother positioning, with wider arithmetic and rounding rules to define. | What coordinate range and fractional precision should geometry and rasterization share? |
| **Triangle setup ownership** | **Geometry/preprocessing:** sends prepared bounds and edge/interpolation data, widening the packet and coupling the producer to rasterization. **Rasterizer:** accepts projected vertices and computes setup locally, reducing packet contents but adding setup work there. | Which team owns triangle setup, and what data crosses the interface? |
| **Triangle transfer** | **Direct ready/valid:** allows backpressure with little buffering, but stalls geometry while the rasterizer is busy. **Ready/valid with a FIFO:** lets geometry run ahead temporarily, using extra storage; sustained throughput still depends on rasterization. | How much buffering is needed between the teams? |
| **Near-plane handling** | **Reject crossing triangles:** simpler control, but whole triangles can disappear as they approach the camera. **Clip before projection:** preserves the visible portion, but generates new vertices and sometimes additional triangles. | Are disappearing triangles acceptable in the demo, or is clipping required? |

## Memory comparison

RGB444 uses 12 bits per pixel. These figures cover one color buffer and, where
shown, one depth buffer; they exclude padding and other storage.

| Render resolution | Color only | Color + 8-bit depth | Color + 16-bit depth |
| --- | ---: | ---: | ---: |
| 320 × 240 | 921,600 bits | 1,536,000 bits | 2,150,400 bits |
| 640 × 480 | 3,686,400 bits | 6,144,000 bits | 8,601,600 bits |

Compare these requirements with usable board memory before selecting a design.
Discuss on-chip BRAM versus external memory if the chosen buffers require it.

## First demo and team deliverables

- **Demo goal:** a static triangle, multiple overlapping triangles, or a rotating
  3D object? Each exercises a different amount of integration.
- **Initial features:** which visibility, shading, and clipping options belong in
  the first demo, and which can wait?
- **Verification:** who owns the Python reference model, RTL comparison, and VGA
  display checks? Include shared-edge coverage, off-screen triangles, and interface
  stalls; include depth/clipping checks if those features are selected.
- **Integration:** agree on triangle fields, coordinate/depth formats, handshake,
  framebuffer access, and ownership of buffer clearing. Define shared-edge rules
  and memory timing once the relevant design choices are made.
- **Meeting outcome:** record selected options, unresolved questions, owners, and
  the next deliverable for each team.
