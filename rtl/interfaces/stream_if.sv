`timescale 1ns / 1ps
`default_nettype none

//! @title stream_if
//! One ready/valid channel. Transfers happen on valid && ready.
interface stream_if #(
    parameter type DATA_T = logic [31:0]  //! Data carried by this channel
);
    logic  valid;  //! Data is valid. Hold valid and data until ready.
    logic  ready;  //! Receiver can take the data.
    DATA_T data;  //! Channel payload

    modport producer(output valid, data, input ready);
    modport consumer(input valid, data, output ready);
endinterface

`default_nettype wire
