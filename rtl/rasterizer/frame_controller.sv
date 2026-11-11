`timescale 1ns / 1ps
`default_nettype none

// @title frame_controller
//! Handles clearing, drawing, and finishing a frame.
module frame_controller (
    // Clock and reset
    input logic clk,   //! Clock
    input logic rst_n, //! Active-low synchronous reset. Does not clear RAM.

    // Start request
    input logic start_valid,  //! Start request. Hold request and settings until start_ready.
    output logic start_ready,  //! Ready to start.
    input gpu_pkg::rgb444_t background_color,  //! RGB444 background color. Save on frame start.

    // Buffer clear request
    output logic clear_start_valid,  //! Start clearing the buffers. Hold until clear_start_ready.
    input logic clear_start_ready,  //! Clear module is ready to start.
    output gpu_pkg::rgb444_t clear_color,  //! RGB444 clear color. Save on clear start.

    // Buffer clear completion
    input  logic clear_done_valid,  //! All clear writes are finished. Hold until clear_done_ready.
    output logic clear_done_ready,  //! Ready for the clear-done signal.

    // Frame control
    output logic clear_active,  //! Clear module owns the buffer ports until its last write finishes.
    output logic draw_enable,  //! Allow triangle input after clearing. Stop at the end-of-frame marker.
    input  logic end_frame_accepted,  //! High for one cycle when the end-of-frame command is accepted.

    // End-of-frame marker
    input  logic fence_valid,  //! End-of-frame marker reached the end. All earlier writes are done. Hold until fence_ready.
    output logic fence_ready,  //! Ready to take the end-of-frame marker.

    // Frame completion
    output logic frame_done_valid,  //! Frame writes are finished. Hold until frame_done_ready.
    input  logic frame_done_ready,  //! Ready for the frame-done signal.

    // Status
    output logic busy  //! Still has work pending. Tied low for now.
);
    assign start_ready = 1'b0;
    assign clear_start_valid = 1'b0;
    assign clear_color = '0;
    assign clear_done_ready = 1'b0;
    assign clear_active = 1'b0;
    assign draw_enable = 1'b0;
    assign fence_ready = 1'b0;
    assign frame_done_valid = 1'b0;
    assign busy = 1'b0;
endmodule

`default_nettype wire
