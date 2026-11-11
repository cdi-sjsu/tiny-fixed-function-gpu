`timescale 1ns / 1ps
`default_nettype none

// @title bbox_walker
//! @author Rasterizer Team
//!
//! Steps through the bounding box and updates edges, depth, and color.
module bbox_walker (
    // Clock and reset
    input logic clk,   //! Clock
    input logic rst_n, //! Active-low synchronous reset.

    // Status
    output logic busy,  //! Still has work pending. Tied low for now.

    // Input stream
    stream_if.consumer input_stream,  //! Input data and ready/valid handshake

    // Output stream
    stream_if.producer output_stream  //! Output data and ready/valid handshake
);
    assign input_stream.ready = 1'b0;
    assign output_stream.valid = 1'b0;
    assign output_stream.data = '0;
    assign busy = 1'b0;
endmodule

`default_nettype wire
