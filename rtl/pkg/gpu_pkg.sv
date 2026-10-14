`timescale 1ns / 1ps

package gpu_pkg;
    typedef struct packed {
        logic signed [31:0] x;
        logic signed [31:0] y;
        logic [31:0] z;  // Unsigned depth; zero is valid.
        logic w;
    } xyzw_vector_t;

    typedef struct packed {
        xyzw_vector_t vector_1;
        xyzw_vector_t vector_2;
        xyzw_vector_t vector_3;
    } display_triangle_t;

    // Packed rows and columns descend: the first assignment-pattern element is [3][3].
    typedef logic signed [3:0][3:0][31:0] transformation_matrix_t;

endpackage
