`timescale 1ns / 1ps
`default_nettype none

// @title buffer_clear
//! Clears color and depth, then waits for the writes to finish.
module buffer_clear (
    // Clock and reset
    input logic clk,   //! Clock
    input logic rst_n, //! Active-low synchronous reset. Does not clear RAM.

    // Start request
    input logic start_valid,  //! Start request. Hold request and settings until start_ready.
    output logic start_ready,  //! Ready to start.
    input gpu_pkg::rgb444_t clear_color,  //! RGB444 clear color. Save on clear start.
    input  gpu_pkg::depth_t  clear_depth,  //! Depth clear value. Save on clear start; normally all ones.

    // Operation completion
    output logic done_valid,  //! All color and depth clear writes are finished. Hold until done_ready.
    input logic done_ready,  //! Ready for the done signal.

    // Status
    output logic busy,  //! Still has work pending. Tied low for now.

    // Depth writes
    memory_write_if.requester depth_write,  //! Pixel address, depth, and write completion

    // Color writes
    memory_write_if.requester color_write  //! Pixel address, RGB444 color, and write completion
);
    assign start_ready = 1'b0;
    assign depth_write.request_valid = 1'b0;
    assign depth_write.data = '0;
    assign depth_write.done_ready = 1'b0;
    assign color_write.request_valid = 1'b0;
    assign color_write.data = '0;
    assign color_write.done_ready = 1'b0;
    assign done_valid = 1'b0;
    assign busy = 1'b0;
endmodule

`default_nettype wire
