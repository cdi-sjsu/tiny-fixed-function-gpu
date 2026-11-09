`timescale 1ns / 1ps

package geometry_pkg;

    // Geometry uses signed 32-bit fixed point with 16 fractional bits.
    localparam int GEOMETRY_WIDTH = 32;
    localparam int GEOMETRY_FRAC_BITS = 16;
    typedef logic signed [GEOMETRY_WIDTH-1:0] geometry_scalar_t;
    localparam geometry_scalar_t GEOMETRY_ONE = geometry_scalar_t'(1) << GEOMETRY_FRAC_BITS;

    // Homogeneous vector before perspective division.
    typedef struct packed {
        geometry_scalar_t x;
        geometry_scalar_t y;
        geometry_scalar_t z;
        geometry_scalar_t w;
    } xyzw_vector_t;

    // Geometry-space triangle, before conversion to screen coordinates.
    typedef struct packed {
        xyzw_vector_t vector_1;
        xyzw_vector_t vector_2;
        xyzw_vector_t vector_3;
    } geometry_triangle_t;

    typedef geometry_scalar_t [3:0][3:0] transformation_matrix_t;

endpackage
