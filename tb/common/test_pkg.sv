// Should be deleted later
package test_pkg;
    import geometry_pkg::*;

    localparam xyzw_vector_t test_vector_1 = '{
        x : 32'sh0003A8C4,
        y : 32'shFFFE2B70,
        z : 32'sh00127F3A,
        w : 0
    };
    localparam xyzw_vector_t test_vector_2 = '{
        x : 32'shFFF1C3A8,
        y : 32'sh0009F1D2,
        z : 32'sh00008B4E,
        w : GEOMETRY_ONE
    };
    localparam xyzw_vector_t test_vector_3 = '{
        x : 32'sh00520A97,
        y : 32'shFFC4D5E1,
        z : 32'sh00067C09,
        w : 0
    };

    localparam transformation_matrix_t test_translation = '{
        '{32'sh00010000, 32'sh00000000, 32'sh00000000, 32'sh00179022},
        '{32'sh00000000, 32'sh00010000, 32'sh00000000, 32'sh0003649C},
        '{32'sh00000000, 32'sh00000000, 32'sh00010000, 32'shFFFF9D71},
        '{32'sh00000000, 32'sh00000000, 32'sh00000000, 32'sh00010000}
    };

endpackage
