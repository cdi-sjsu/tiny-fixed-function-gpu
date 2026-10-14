`timescale 1ns / 1ps
`default_nettype none

// Check the shared type layout and the interpretation of fixture assignment patterns.
module type_contract;
    gpu_pkg::xyzw_vector_t vertex;
    gpu_pkg::transformation_matrix_t matrix;

    initial begin
        vertex   = '0;
        vertex.z = 32'hffffffff;
        if (vertex.z <= 0) $fatal(1, "z must compare as unsigned");
        if ($bits(vertex) != 97) $fatal(1, "Unexpected vector width");
        if ($bits(matrix) != 512) $fatal(1, "Unexpected matrix width");
        if ($left(matrix, 1) != 3) $fatal(1, "Matrix rows must start at 3");
        if ($right(matrix, 1) != 0) $fatal(1, "Matrix rows must end at 0");
        if ($left(matrix, 2) != 3) $fatal(1, "Matrix columns must start at 3");
        if ($right(matrix, 2) != 0) $fatal(1, "Matrix columns must end at 0");
        matrix = test_pkg::test_translation;
        if (matrix[3][0] != 32'h00179022 || matrix[2][0] != 32'h0003649c ||
            matrix[1][0] != 32'hffff9d71 || matrix[0][0] != 32'h00010000)
            $fatal(1, "Translation fixture index interpretation changed");
    end
endmodule

`default_nettype wire
