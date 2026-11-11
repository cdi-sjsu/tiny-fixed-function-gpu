`timescale 1ns / 1ps

package gpu_pkg;
    // GEOMETRY -> RASTERIZER:

    // Projected vertex attributes
    // Screen origin is top left, X goes right, Y goes down.
    localparam int COORD_WIDTH = 20;
    /* verilator lint_off UNUSEDPARAM */
    localparam int COORD_FRAC_BITS = 4;
    /* verilator lint_on UNUSEDPARAM */
    typedef logic signed [COORD_WIDTH-1:0] screen_coord_t;

    // Depth after projection (smaller is closer).
    // All ones is reserved for clearing.
    localparam int DEPTH_WIDTH = 16;
    typedef logic [DEPTH_WIDTH-1:0] depth_t;

    typedef logic [11:0] rgb444_t;  // Color: {red[3:0], green[3:0], blue[3:0]}

    // Vertices, triangles, and commands:
    typedef struct packed {
        screen_coord_t x;
        screen_coord_t y;
        depth_t z;
        rgb444_t color;
    } raster_vertex_t;

    typedef struct packed {
        raster_vertex_t v0;
        raster_vertex_t v1;
        raster_vertex_t v2;
    } raster_triangle_t;

    typedef struct packed {
        logic end_frame;  // 0: draw triangle; 1: end of frame
        raster_triangle_t triangle;
    } raster_command_t;

    // RASTERIZER -> FRAMEBUFFER:

    // color writes
    typedef struct packed {
        pixel_addr_t address;  // Pixel index: y * RENDER_WIDTH + x
        rgb444_t color;
    } color_write_t;

    // RASTERIZER -> VGA: 

    // render dimensions and pixel addressing:
    localparam int RENDER_WIDTH = 640;
    localparam int RENDER_HEIGHT = 480;
    localparam int PIXEL_COUNT = RENDER_WIDTH * RENDER_HEIGHT;
    localparam int PIXEL_X_WIDTH = (RENDER_WIDTH > 1) ? $clog2(RENDER_WIDTH) : 1;
    localparam int PIXEL_Y_WIDTH = (RENDER_HEIGHT > 1) ? $clog2(RENDER_HEIGHT) : 1;
    localparam int PIXEL_ADDR_WIDTH = (PIXEL_COUNT > 1) ? $clog2(PIXEL_COUNT) : 1;
    typedef logic [PIXEL_X_WIDTH-1:0] pixel_x_t;
    typedef logic [PIXEL_Y_WIDTH-1:0] pixel_y_t;
    typedef logic [PIXEL_ADDR_WIDTH-1:0] pixel_addr_t;

endpackage
