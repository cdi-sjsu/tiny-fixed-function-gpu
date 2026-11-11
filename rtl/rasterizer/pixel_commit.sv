`timescale 1ns / 1ps
`default_nettype none

// @title pixel_commit
//! Checks depth, then writes depth and color if the pixel is closer.
module pixel_commit (
    // Clock and reset
    input logic clk,   //! Clock
    input logic rst_n, //! Active-low synchronous reset. Does not clear RAM.

    // End-of-frame marker
    output logic fence_valid,  //! End-of-frame marker reached the end. All earlier writes are done. Hold until fence_ready.
    input logic fence_ready,  //! Ready to take the end-of-frame marker.

    // Status
    output logic busy,  //! Still has work pending. Tied low for now.

    // Input stream
    stream_if.consumer input_stream,  //! Input data and ready/valid handshake

    // Depth reads
    memory_read_if.requester depth_read,  //! Read stored depth

    // Depth writes
    memory_write_if.requester depth_write,  //! Pixel address, depth, and write completion

    // Color writes
    memory_write_if.requester color_write  //! Pixel address, RGB444 color, and write completion
);
    assign input_stream.ready = 1'b0;
    assign depth_read.request_valid = 1'b0;
    assign depth_read.address = '0;
    assign depth_read.response_ready = 1'b0;
    assign depth_write.request_valid = 1'b0;
    assign depth_write.data = '0;
    assign depth_write.done_ready = 1'b0;
    assign color_write.request_valid = 1'b0;
    assign color_write.data = '0;
    assign color_write.done_ready = 1'b0;
    assign fence_valid = 1'b0;
    assign busy = 1'b0;
endmodule

`default_nettype wire
