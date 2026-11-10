module pineda_rasterizer;

    // Define a struct for our 2D coordinates
    typedef struct {
        int x;
        int y;
    } point_t;

    // Evaluates the cross product edge function. 
    // p_x and p_y are reals to accommodate the +0.5 pixel center offset.
    function automatic real edge_function(point_t v1, point_t v2, real p_x, real p_y);
        return (v2.x - v1.x) * (p_y - v1.y) - (v2.y - v1.y) * (p_x - v1.x);
    endfunction

    // Top-left edge rule checker
    function automatic logic is_top_left(point_t v1, point_t v2);
        int dx = v2.x - v1.x;
        int dy = v2.y - v1.y;
        return (dy < 0) || (dy == 0 && dx < 0);
    endfunction

    // Validates if the edge weight passes the rasterization rule
    function automatic logic accepts_edge(real val, logic top_left);
        return (val > 0) || (val == 0 && top_left);
    endfunction

    // Helper to find min of 3 integers
    function automatic int min3(int a, int b, int c);
        int m = a;
        if (b < m) m = b;
        if (c < m) m = c;
        return m;
    endfunction

    // Helper to find max of 3 integers
    function automatic int max3(int a, int b, int c);
        int m = a;
        if (b > m) m = b;
        if (c > m) m = c;
        return m;
    endfunction

    // Main rasterization task
    task automatic rasterize_triangle_pineda(point_t A, point_t B, point_t C);
        int min_x, max_x, min_y, max_y;
        real area;
        logic tl0, tl1, tl2;
        int dy0, dx0, dy1, dx1, dy2, dx2;
        real p_start_x, p_start_y;
        real w0_row_start, w1_row_start, w2_row_start;
        real w0, w1, w2;

        $display("Rasterizing Triangle: A=(%0d,%0d), B=(%0d,%0d), C=(%0d,%0d)\n", A.x, A.y, B.x, B.y, C.x, C.y);

        min_x = min3(A.x, B.x, C.x);
        max_x = max3(A.x, B.x, C.x);
        min_y = min3(A.y, B.y, C.y);
        max_y = max3(A.y, B.y, C.y);

        // 1. Check for degenerate triangle
        area = edge_function(A, B, real'(C.x), real'(C.y));
        if (area == 0) begin
            $display("This is a Degenerate triangle.\n");
            return;
        end

        // 2. Hoist constant top-left rules
        tl0 = is_top_left(A, B);
        tl1 = is_top_left(B, C);
        tl2 = is_top_left(C, A);

        // 3. Calculate Pineda step constants
        dy0 = B.y - A.y; dx0 = B.x - A.x;
        dy1 = C.y - B.y; dx1 = C.x - B.x;
        dy2 = A.y - C.y; dx2 = A.x - C.x;

        // 4. Evaluate edge functions ONLY for the starting bottom-left pixel
        p_start_x = real'(min_x) + 0.5;
        p_start_y = real'(min_y) + 0.5;

        w0_row_start = edge_function(A, B, p_start_x, p_start_y);
        w1_row_start = edge_function(B, C, p_start_x, p_start_y);
        w2_row_start = edge_function(C, A, p_start_x, p_start_y);

        $display("Covered Pixels (x, y):");

        // 5. Incremental traversal
        for (int pixel_y = min_y; pixel_y <= max_y; pixel_y++) begin
            w0 = w0_row_start;
            w1 = w1_row_start;
            w2 = w2_row_start;

            for (int pixel_x = min_x; pixel_x <= max_x; pixel_x++) begin
                if (accepts_edge(w0, tl0) && accepts_edge(w1, tl1) && accepts_edge(w2, tl2)) begin
                    $display("Pixel (%0d, %0d) - Weights: w0=%0.1f, w1=%0.1f, w2=%0.1f", pixel_x, pixel_y, w0, w1, w2);
                end

                // PINEDA X-STEP
                w0 -= dy0;
                w1 -= dy1;
                w2 -= dy2;
            end

            // PINEDA Y-STEP
            w0_row_start += dx0;
            w1_row_start += dx1;
            w2_row_start += dx2;
        end
    endtask

    // Execution entry point
    initial begin
        point_t A, B, C;
        $display("Meeting 2 Triangle (Pineda Incremental)");
        A = '{x:0, y:0};
        B = '{x:4, y:0};
        C = '{x:0, y:4};
        rasterize_triangle_pineda(A, B, C);
    end

endmodule