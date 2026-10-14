// Test-only signal keeps a VPI root visible for the otherwise empty RTL shell.
module top_smoke (
    output logic shell_loaded
);
    top dut ();
    assign shell_loaded = 1'b1;
endmodule
