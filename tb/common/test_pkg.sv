// Should be deleted later
package test_pkg;
    import gpu_pkg::*;

    localparam xyzw_vector_t test_vector_1 = '{
        x : 32'h0003A8C4,
        y : 32'hFFFE2B70,
        z : 32'h00127F3A,
        w : 0
    };
    localparam xyzw_vector_t test_vector_2 = '{
        x : 32'hFFF1C3A8,
        y : 32'h0009F1D2,
        z : 32'h00008B4E,
        w : 1
    };
    localparam xyzw_vector_t test_vector_3 = '{
        x : 32'h00520A97,
        y : 32'hFFC4D5E1,
        z : 32'h00067C09,
        w : 0
    };

    localparam transformation_matrix_t test_translation = '{
        '{32'h00010000, 32'h00000000, 32'h00000000, 32'h00179022},
        '{32'h00000000, 32'h00010000, 32'h00000000, 32'h0003649C},
        '{32'h00000000, 32'h00000000, 32'h00010000, 32'hFFFF9D71},
        '{32'h00000000, 32'h00000000, 32'h00000000, 32'h00010000}
    };

endpackage
