`timescale 1ns / 1ps
`default_nettype none

//! @title Button
//! @author Kyle Ringor
//!
//! Customizable button debouncer supporting pulse and sustained outputs.
module button #(
    parameter bit BUTTON_MODE = "PULSE",  //! "PULSE" or "SUSTAINED"
    parameter int unsigned STABLE_COUNT = 1000  //! Clock cycles required for stability
) (
    input  wire  clk,
    input  wire  rst_n,
    input  wire  btn_i,
    output logic btn_o
);

    logic [1:0] sync;  //! 2-stage synchronizer for metastability

    logic debounced_state;  //! Current debounced physical state of the button

    localparam int unsigned COUNT_WIDTH = (STABLE_COUNT > 1) ? $clog2(
        STABLE_COUNT
    ) : 1;  //! Prevent underflow
    logic [COUNT_WIDTH - 1:0] count;

    //! Synchronizer and debounce counter logic
    always_ff @(posedge clk or negedge rst_n) begin : debouncer_proc
        if (!rst_n) begin
            sync            <= 2'b00;
            debounced_state <= 1'b0;
            count           <= '0;
        end else begin
            sync <= {sync[0], btn_i};

            // Counter needs to fill for both debounced_state hi and lo
            if (sync[1] != debounced_state) begin
                if (count == (STABLE_COUNT - 1)) begin
                    debounced_state <= sync[1];
                    count           <= '0;
                end else begin
                    count <= count + 1'b1;
                end
            end else begin
                count <= '0;
            end
        end
    end

    generate
        case (BUTTON_MODE)
            "PULSE": begin : gen_pulse
                // Produces a 1-cycle pulse
                always_ff @(posedge clk or negedge rst_n) begin : pulse_proc
                    if (!rst_n) begin
                        btn_o <= 1'b0;
                    end else begin
                        btn_o <= (sync[1] != debounced_state) && // Necessary for STABLE_COUNT = 1 edge-case
                        (count == STABLE_COUNT - 1) &&  // Only triggers for 1 clk cycle
                        (sync[1] == 1'b1);  // Only triggers on hi
                    end
                end : pulse_proc
            end

            "SUSTAINED": begin : gen_sustained
                // Mirrors the debounced state
                always_comb begin : sustained_proc
                    btn_o = debounced_state;
                end : sustained_proc
            end

            default:
            begin : gen_invalid
`ifndef SYNTHESIS
                initial begin
                    $error("Unsupported BUTTON_MODE parameter specified in module %m.");
                end
`endif
            end
        endcase
    endgenerate

endmodule

`default_nettype wire
