`timescale 1ns / 1ps

package rasterizer_pkg;
    // Edge calculations.
    // Extra bits leave room for intermediate results.
    localparam int EDGE_WIDTH = 2 * gpu_pkg::COORD_WIDTH + 2;
    typedef logic signed [EDGE_WIDTH-1:0] edge_value_t;

    // Internal depth and color calculations.
    localparam int ATTR_WIDTH = 48;
    localparam int ATTR_FRAC_BITS = 16;
    typedef logic signed [ATTR_WIDTH-1:0] attribute_t;

    // Color channels use the same fixed-point scale as depth.
    // A channel value of 15.0 is stored as 15 << ATTR_FRAC_BITS.
    // Keep channels signed: gradients and off-triangle samples can be negative.
    typedef struct packed {
        attribute_t r;
        attribute_t g;
        attribute_t b;
    } color_attribute_t;

    // Smaller depth wins. This value cannot be drawn with a strict < test.
    localparam gpu_pkg::depth_t DEPTH_CLEAR = '1;

    // Triangle setup -> bounding-box walker
    typedef struct packed {
        logic end_frame;
        logic empty;  // Skip degenerate or fully off-screen triangles

        // Pixel bounds, inclusive
        gpu_pkg::pixel_x_t xmin;
        gpu_pkg::pixel_x_t xmax;
        gpu_pkg::pixel_y_t ymin;
        gpu_pkg::pixel_y_t ymax;

        // Values at the first pixel center. One value per triangle edge.
        edge_value_t [2:0] edge_start;
        // Change for one whole pixel right or down
        edge_value_t [2:0] edge_dx;
        edge_value_t [2:0] edge_dy;
        // Include samples exactly on these edges (top-left rule).
        logic [2:0] inclusive_edge;

        // Initial depth and steps, using ATTR_FRAC_BITS fractional bits
        attribute_t z_start;
        attribute_t z_dx;
        attribute_t z_dy;

        // Affine Gouraud color at the first pixel center, then steps per pixel.
        // Swap colors with their vertices when normalizing winding.
        color_attribute_t color_start;
        color_attribute_t color_dx;
        color_attribute_t color_dy;
    } triangle_setup_t;

    // Walker -> coverage test -> depth conversion
    typedef struct packed {
        logic end_frame;  // Other fields are ignored when set
        gpu_pkg::pixel_x_t x;
        gpu_pkg::pixel_y_t y;

        // Unbiased edges at this pixel center. Inside is positive.
        edge_value_t [2:0] edges;
        logic [2:0] inclusive_edge;
        attribute_t z;  // Internal fixed-point depth
        color_attribute_t color;  // Interpolated channels, not packed RGB444 yet
    } raster_sample_t;

    // Covered pixel -> depth test and commit
    typedef struct packed {
        logic end_frame;  // Other fields are ignored when set
        gpu_pkg::pixel_x_t x;
        gpu_pkg::pixel_y_t y;
        gpu_pkg::depth_t z;  // Rounded and clamped to the Z-buffer format
        gpu_pkg::rgb444_t color;
    } fragment_t;

    // Pixel commit / clear -> Z-buffer
    typedef struct packed {
        gpu_pkg::pixel_addr_t address;  // Pixel index: y * RENDER_WIDTH + x
        gpu_pkg::depth_t depth;
    } depth_write_t;

endpackage
