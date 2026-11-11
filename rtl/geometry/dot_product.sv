`timescale 1ns / 1ps
`default_nettype none

//! @title Dot Product
//! @author Geometry Team

// pipelined implementation (3 cycles)
module dot_product
    import gpu_pkg::xyzw_vector_t;

(
    input wire valid_in,  // need this if there's no data coming in
    input wire clock,
    input wire reset,
    input xyzw_vector_t vector1,
    input xyzw_vector_t vector2,
    output logic [65:0] dot,
    output logic valid_out
);

    // multiply
    logic [63:0] product_x, product_y, product_z, product_w;
    logic valid_s1;

    always_ff @(posedge clock) begin
        if (reset) valid_s1 <= 1'b0;
        else valid_s1 <= valid_in;

        product_x <= vector1.x * vector2.x;
        product_y <= vector1.y * vector2.y;
        product_z <= vector1.z * vector2.z;
        product_w <= vector1.w * vector2.w;
    end

    // first adders
    logic [64:0] sum_xy, sum_zw;
    logic valid_s2;

    always_ff @(posedge clock) begin
        if (reset) valid_s2 <= 1'b0;
        else valid_s2 <= valid_s1;

        sum_xy <= product_x + product_y;
        sum_zw <= product_z + product_w;
    end

    // final add
    always_ff @(posedge clock) begin
        if (reset) valid_out <= 1'b0;
        else valid_out <= valid_s2;

        dot <= sum_xy + sum_zw;
    end

endmodule

`default_nettype wire
