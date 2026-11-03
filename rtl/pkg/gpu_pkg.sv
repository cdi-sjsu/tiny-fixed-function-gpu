`timescale 1ns / 1ps

package gpu_pkg;
    typedef struct packed {
        logic signed [31:0] x;
        logic signed [31:0] y;
        logic [31:0] z;  // Must be positive
        logic w;
        // logic [11:0] rgb;
    } xyzw_vector_t;

    typedef struct packed {
        xyzw_vector_t vector_1;
        xyzw_vector_t vector_2;
        xyzw_vector_t vector_3;
    } display_triangle_t;

    typedef logic signed [3:0][3:0][31:0] transformation_matrix_t;

endpackage
