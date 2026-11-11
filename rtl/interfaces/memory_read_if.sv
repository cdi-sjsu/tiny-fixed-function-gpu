`timescale 1ns / 1ps
`default_nettype none

//! @title memory_read_if
//! Read requests and responses. Each channel has its own handshake.
interface memory_read_if #(
    parameter type ADDR_T = logic [31:0],  //! Pixel address type
    parameter type DATA_T = logic [31:0]   //! Read data type
);
    logic  request_valid;  //! Read request. Hold address until request_ready.
    logic  request_ready;  //! Storage can take a read request.
    ADDR_T address;  //! Pixel index, not a byte address

    logic  response_valid;  //! Read data is back. Hold until response_ready.
    logic  response_ready;  //! Requester can take the read data.
    DATA_T data;  //! Data for the accepted read

    modport requester(
        output request_valid, address, response_ready,
        input request_ready, response_valid, data
    );
    modport storage(
        input request_valid, address, response_ready,
        output request_ready, response_valid, data
    );
endinterface

`default_nettype wire
