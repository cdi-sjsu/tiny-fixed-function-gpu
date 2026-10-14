// dot product module that does this: mx + my + mz + mw
module dot_product
    import typedefs::*;
(
    /* verilator lint_off UNUSED */
    /* verilator lint_off UNDRIVEN */
    input xyzw_vector v_0,
    input transformation_matrix m,
    output xyzw_vector v
    /* verilator lint_on UNUSED */
    /* verilator lint_on UNDRIVEN */
);

    // all the main math stuff goes here
    // sequential vs. combinatoiral implementation? I'd say preferrably combinatorial or we'll have to change it later for efficiency

endmodule
