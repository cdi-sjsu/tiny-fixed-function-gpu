def edge_function(x, y, p):
    """
    vertex x to y, p is the point being tested against the edge
    """
    return (y[0] - x[0]) * (p[1] - x[1]) - (y[1] - x[1]) * (p[0] - x[0])


def is_top_left(x, y):
    """
    (0,0) is bottom left
    Determines if an edge is a 'top' or 'left' edge for shared-edge fill conventions.
    Top edge: perfectly horizontal and goes from right to left (dx < 0, dy == 0).
    Left edge: goes downwards (dy < 0).
    """
    dx = y[0] - x[0]
    dy = y[1] - x[1]
    return (dy < 0) or (dy == 0 and dx < 0)


def accepts_edge(value, top_left):
    return value > 0 or (value == 0 and top_left)


def rasterize_triangle(A, B, C):
    """
    A, B, C are vertices of the triangle. input as A=(0,0), etc. Assuming CCW
    """
    print(f"Rasterizing Triangle: A={A}, B={B}, C={C}\n")

    min_x = min(A[0], B[0], C[0])
    max_x = max(A[0], B[0], C[0])
    min_y = min(A[1], B[1], C[1])
    max_y = max(A[1], B[1], C[1])

    # Check for degenerate triangle (zero area)
    area = edge_function(A, B, C)
    if area == 0:
        print("This is a Degenerate triangle.\n")
        return

    print("Covered Pixels (x, y):")
    for pixel_y in range(min_y, max_y + 1):
        for pixel_x in range(min_x, max_x + 1):
            # Pixel position is the center of the pixel
            p = (pixel_x + 0.5, pixel_y + 0.5)

            w0 = edge_function(A, B, p)
            w1 = edge_function(B, C, p)
            w2 = edge_function(C, A, p)

            # If all edge functions pass the top-left rule, the pixel is covered
            if (
                accepts_edge(w0, is_top_left(A, B))
                and accepts_edge(w1, is_top_left(B, C))
                and accepts_edge(w2, is_top_left(C, A))
            ):
                print(f"Pixel ({pixel_x}, {pixel_y}) - Weights: w0={w0}, w1={w1}, w2={w2}")


if __name__ == "__main__":
    # Demonstrate the triangle pictured in Meeting 2
    print("Meeting 2 Triangle")
    rasterize_triangle(A=(0, 0), B=(4, 0), C=(0, 4))

    # Degenerate triangle check
    print("\n Degenerate Triangle")
    rasterize_triangle(A=(1, 1), B=(2, 2), C=(3, 3))
