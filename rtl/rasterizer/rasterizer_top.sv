`timescale 1ns / 1ps
`default_nettype none

// @title rasterizer_top
//! Connects the rasterizer modules. Still boilerplate; does not draw yet.
module rasterizer_top (
    // Clock and reset
    input logic clk,   //! Clock
    input logic rst_n, //! Active-low synchronous reset

    // Frame start
    input  logic             frame_start_valid,  //! Hold request and color until ready.
    output logic             frame_start_ready,  //! Ready to start a frame
    input  gpu_pkg::rgb444_t background_color,   //! RGB444 background color

    // Frame completion
    output logic frame_done_valid,  //! Frame writes are finished. Hold until ready.
    input  logic frame_done_ready,  //! Ready for the frame-done signal
    output logic busy,              //! Still has work pending. Stubbed for now.

    // Data interfaces
    stream_if.consumer        commands,    //! gpu_pkg::raster_command_t input stream
    memory_write_if.requester color_write  //! gpu_pkg::color_write_t writes to external storage
);
    import gpu_pkg::*;
    import rasterizer_pkg::*;

    stream_if #(.DATA_T(raster_command_t)) queue_input ();
    stream_if #(.DATA_T(raster_command_t)) queued_commands ();
    stream_if #(.DATA_T(triangle_setup_t)) setup_stream ();
    stream_if #(.DATA_T(raster_sample_t)) walked_samples ();
    stream_if #(.DATA_T(raster_sample_t)) covered_samples ();
    stream_if #(.DATA_T(fragment_t)) fragments ();

    memory_read_if #(
        .ADDR_T(pixel_addr_t),
        .DATA_T(depth_t)
    ) depth_read ();
    memory_write_if #(.DATA_T(depth_write_t)) commit_depth_write ();
    memory_write_if #(.DATA_T(depth_write_t)) clear_depth_write ();
    memory_write_if #(.DATA_T(depth_write_t)) depth_write ();
    memory_write_if #(.DATA_T(color_write_t)) commit_color_write ();
    memory_write_if #(.DATA_T(color_write_t)) clear_color_write ();

    logic draw_enable, clear_active, controller_busy, clear_busy;
    logic clear_start_valid, clear_start_ready, clear_done_valid, clear_done_ready;
    rgb444_t clear_color;
    logic fence_valid, fence_ready;
    logic q_busy, setup_busy, walk_busy, edge_busy, interp_busy, commit_busy;
    raster_command_t command;

    // Named struct view also lets generic stream ports carry packed bit vectors.
    assign command = commands.data;
    assign queue_input.valid = commands.valid && draw_enable;
    assign queue_input.data = commands.data;
    assign commands.ready = draw_enable && queue_input.ready;
    assign busy = controller_busy || clear_busy || q_busy || setup_busy || walk_busy ||
                  edge_busy || interp_busy || commit_busy;

    frame_controller controller (
        .clk(clk),
        .rst_n(rst_n),
        .start_valid(frame_start_valid),
        .start_ready(frame_start_ready),
        .background_color(background_color),
        .clear_start_valid(clear_start_valid),
        .clear_start_ready(clear_start_ready),
        .clear_color(clear_color),
        .clear_done_valid(clear_done_valid),
        .clear_done_ready(clear_done_ready),
        .clear_active(clear_active),
        .draw_enable(draw_enable),
        .end_frame_accepted(commands.valid && commands.ready && command.end_frame),
        .fence_valid(fence_valid),
        .fence_ready(fence_ready),
        .frame_done_valid(frame_done_valid),
        .frame_done_ready(frame_done_ready),
        .busy(controller_busy)
    );
    triangle_fifo queue (
        .clk(clk),
        .rst_n(rst_n),
        .busy(q_busy),
        .input_stream(queue_input),
        .output_stream(queued_commands)
    );
    triangle_setup setup_stage (
        .clk(clk),
        .rst_n(rst_n),
        .busy(setup_busy),
        .input_stream(queued_commands),
        .output_stream(setup_stream)
    );
    bbox_walker walker (
        .clk(clk),
        .rst_n(rst_n),
        .busy(walk_busy),
        .input_stream(setup_stream),
        .output_stream(walked_samples)
    );
    edge_evaluator coverage (
        .clk(clk),
        .rst_n(rst_n),
        .busy(edge_busy),
        .input_stream(walked_samples),
        .output_stream(covered_samples)
    );
    fragment_interpolator attributes (
        .clk(clk),
        .rst_n(rst_n),
        .busy(interp_busy),
        .input_stream(covered_samples),
        .output_stream(fragments)
    );
    pixel_commit commit_stage (
        .clk(clk),
        .rst_n(rst_n),
        .busy(commit_busy),
        .input_stream(fragments),
        .depth_read(depth_read),
        .depth_write(commit_depth_write),
        .color_write(commit_color_write),
        .fence_valid(fence_valid),
        .fence_ready(fence_ready)
    );
    buffer_clear clearer (
        .clk(clk),
        .rst_n(rst_n),
        .busy(clear_busy),
        .start_valid(clear_start_valid),
        .start_ready(clear_start_ready),
        .clear_color(clear_color),
        .clear_depth(DEPTH_CLEAR),
        .depth_write(clear_depth_write),
        .color_write(clear_color_write),
        .done_valid(clear_done_valid),
        .done_ready(clear_done_ready)
    );

    // Keep the selected owner until all its write responses are back.
    memory_write_mux depth_owner (
        .select_b(clear_active),
        .a(commit_depth_write),
        .b(clear_depth_write),
        .storage(depth_write)
    );
    memory_write_mux color_owner (
        .select_b(clear_active),
        .a(commit_color_write),
        .b(clear_color_write),
        .storage(color_write)
    );
    z_buffer depth_storage (
        .clk(clk),
        .rst_n(rst_n),
        .depth_read(depth_read),
        .depth_write(depth_write)
    );
endmodule

`default_nettype wire
