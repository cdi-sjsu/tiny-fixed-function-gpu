`timescale 1ns / 1ps
`default_nettype none

//! @title memory_write_mux
//! Routes writes and completions for one selected owner.
module memory_write_mux (
    input logic select_b,  //! 0 selects a, 1 selects b.
    memory_write_if.storage a,  //! Requester a
    memory_write_if.storage b,  //! requester b
    memory_write_if.requester storage  //! Selected request and completion path
);
    assign storage.request_valid = select_b ? b.request_valid : a.request_valid;
    assign storage.data = select_b ? b.data : a.data;

    assign a.request_ready = !select_b && storage.request_ready;
    assign b.request_ready = select_b && storage.request_ready;

    assign a.done_valid = !select_b && storage.done_valid;
    assign b.done_valid = select_b && storage.done_valid;

    assign storage.done_ready = select_b ? b.done_ready : a.done_ready;
endmodule

`default_nettype wire
