// nice little package here to format vectors and transformations into nice datatypes and store the test ones for now
package test_vectors;

    typedef struct {
        reg signed [31:0] x;
        reg signed [31:0] y;
        reg signed [31:0] z;
        bit w;
    }   xyzw_vector;

    localparam xyzw_vector test_vector_1 = '{x : 32'h0003A8C4, y : 32'hFFFE2B70, z : 32'h00127F3A, w : 0};
    localparam xyzw_vector test_vector_2 = '{x : 32'hFFF1C3A8, y : 32'h0009F1D2, z : 32'h00008B4E, w : 1};
    localparam xyzw_vector test_vector_3 = '{x : 32'h00520A97, y : 32'hFFC4D5E1, z : 32'h00067C09, w : 0};


    typedef reg signed [31:0] transformation_matrix[0:3][0:3];
    
    localparam transformation_matrix test_translation = '{
        '{32'h00010000, 32'h00000000, 32'h00000000, 32'h00179022},
        '{32'h00000000, 32'h00010000, 32'h00000000, 32'h0003649C},
        '{32'h00000000, 32'h00000000, 32'h00010000, 32'hFFFF9D71},
        '{32'h00000000, 32'h00000000, 32'h00000000, 32'h00010000}
    };


endpackage

// dot product module that does this: mx + my + mz + mw
module dot_product 
    import test_vectors::*; 
(
    input xyzw_vector v_0,
    input transformation_matrix m,
    output xyzw_vector v
);

    // all the main math stuff goes here
    // sequential vs. combinatoiral implementation? I'd say preferrably combinatorial or we'll have to change it later for efficiency
    
endmodule
