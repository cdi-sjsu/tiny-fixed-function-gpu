`timescale 1ns / 1ps
`default_nettype none

// @title z_buffer
//! Stores the closest depth at each pixel.
module z_buffer (
    // Clock and reset
    input logic clk,   //! Clock
    input logic rst_n, //! Active-low synchronous reset. Does not clear RAM.

    // Depth reads
    memory_read_if.storage depth_read,  //! Depth read requests and responses

    // Depth writes
    memory_write_if.storage depth_write  //! Depth writes and completion
);
    assign depth_read.request_ready = 1'b0;
    assign depth_read.response_valid = 1'b0;
    assign depth_read.data = '0;
    assign depth_write.request_ready = 1'b0;
    assign depth_write.done_valid = 1'b0;
endmodule

`default_nettype wire
