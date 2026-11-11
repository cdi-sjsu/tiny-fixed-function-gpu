# Meeting 2 behavioral prototype (Y-up coordinates, integer vertices, float weights).
# Note: Hardware RTL (gpu_pkg) uses top-left origin (Y-down) and Q16.4 fixed-point coordinates.


def edge_function(x: tuple[int, int], y: tuple[int, int], p: tuple[int, int]):
    """Used ONLY for the initial starting pixel"""
    return (y[0] - x[0]) * (p[1] - x[1]) - (y[1] - x[1]) * (p[0] - x[0])


# returns "area"


def is_top_left(x, y):
    dx = y[0] - x[0]
    dy = y[1] - x[1]
    return (dy < 0) or (dy == 0 and dx < 0)


def accepts_edge(value, top_left):
    return value > 0 or (value == 0 and top_left)


def rasterize_triangle_pineda(A, B, C):
    print(f"Rasterizing Triangle: A={A}, B={B}, C={C}\n")

    min_x, max_x = min(A[0], B[0], C[0]), max(A[0], B[0], C[0])
    min_y, max_y = min(A[1], B[1], C[1]), max(A[1], B[1], C[1])

    # 1. Check for degenerate triangle
    # Pineda's algorithm relies on CCW winding. If the area is <= 0, it's degenerate or CW.
    area = edge_function(A, B, C)
    if area == 0:
        print("This is a Degenerate triangle.\n")
        return

    # 2. Hoist constant top-left rules
    tl0 = is_top_left(A, B)
    tl1 = is_top_left(B, C)
    tl2 = is_top_left(C, A)

    # 3. Calculate Pineda step constants
    # Moving right subtracts dy. Moving up adds dx.
    dy0, dx0 = B[1] - A[1], B[0] - A[0]
    dy1, dx1 = C[1] - B[1], C[0] - B[0]
    dy2, dx2 = A[1] - C[1], A[0] - C[0]

    # 4. Evaluate edge functions ONLY for the starting bottom-left pixel
    p_start = (min_x + 0.5, min_y + 0.5)
    w0_row_start = edge_function(A, B, p_start)
    w1_row_start = edge_function(B, C, p_start)
    w2_row_start = edge_function(C, A, p_start)

    print("Covered Pixels (x, y):")

    # 5. Incremental traversal
    for pixel_y in range(min_y, max_y + 1):
        # Set our pixel edge values to the start of this specific row
        w0 = w0_row_start
        w1 = w1_row_start
        w2 = w2_row_start

        for pixel_x in range(min_x, max_x + 1):
            # Evaluate using the current weights
            if accepts_edge(w0, tl0) and accepts_edge(w1, tl1) and accepts_edge(w2, tl2):
                print(f"Pixel ({pixel_x}, {pixel_y}) - Weights: w0={w0}, w1={w1}, w2={w2}")

            # PINEDA X-STEP: Move 1 pixel right (subtract dy from current weights)
            w0 -= dy0
            w1 -= dy1
            w2 -= dy2

        # PINEDA Y-STEP: Move 1 pixel up for the NEXT row (add dx to the row starting weights)
        w0_row_start += dx0
        w1_row_start += dx1
        w2_row_start += dx2


if __name__ == "__main__":
    print("Meeting 2 Triangle (Pineda Incremental)")
    rasterize_triangle_pineda(A=(0, 0), B=(4, 0), C=(0, 4))
