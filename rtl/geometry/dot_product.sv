`timescale 1ns / 1ps
`default_nettype none

//! @title Dot Product
//! @author Geometry Team
//!
//! Geometry transform scaffold; arithmetic implementation is pending.
module dot_product (
    /* verilator lint_off UNUSED */
    /* verilator lint_off UNDRIVEN */
    input gpu_pkg::xyzw_vector_t v_0,  //! Input homogeneous vector.
    input gpu_pkg::transformation_matrix_t m,  //! Transformation matrix.
    output gpu_pkg::xyzw_vector_t v  //! Transformed vector.
    /* verilator lint_on UNUSED */
    /* verilator lint_on UNDRIVEN */
);

endmodule

`default_nettype wire
