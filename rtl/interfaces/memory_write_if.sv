`timescale 1ns / 1ps
`default_nettype none

//! @title memory_write_if
//! Writes with a separate completion handshake.
interface memory_write_if #(
    parameter type DATA_T = logic [31:0]  //! Write packet with address and value
);
    logic  request_valid;  //! Write request. Hold data until request_ready.
    logic  request_ready;  //! Storage can take a write request.
    DATA_T data;  //! Pixel address and new value

    logic  done_valid;  //! Write is finished and readable. Hold until done_ready.
    logic  done_ready;  //! Requester can take the write-done signal.

    modport requester(output request_valid, data, done_ready, input request_ready, done_valid);
    modport storage(input request_valid, data, done_ready, output request_ready, done_valid);
endinterface

`default_nettype wire
