using Gdstk

# Example 03: Creating polygon shapes and querying their geometry.
# Demonstrates: rectangle, ellipse, regular_polygon, racetrack, cross_shape,
#               area, perimeter, bounding_box, get_points, translate!, rotate!

println("=== Example 03: Shape Constructors ===\n")

# Layer / datatype for all shapes (GDSII convention)
LAYER = UInt32(1)
DTYPE = UInt32(0)

# --- Rectangle ---
rect = rectangle(0.0, 0.0, 10.0, 5.0, LAYER, DTYPE)
println("Rectangle")
println("  area      = ", area(rect), " µm²")
println("  perimeter = ", perimeter(rect), " µm")
bb = bounding_box(rect)
println("  bbox min  = ", bb.min)
println("  bbox max  = ", bb.max)

# --- Circle (ellipse with rx == ry, no inner radius, full sweep) ---
circ = ellipse(0.0, 0.0, 5.0, 5.0, 0.0, 0.0, 0.0, 2π, 0.001, LAYER, DTYPE)
println("\nCircle (r=5)")
println("  area      ≈ ", round(area(circ); digits=2), " µm²  (exact: π·25 ≈ 78.54)")
println("  num_points = ", num_points(circ))

# --- Annular ring (ellipse with inner radius) ---
ring = ellipse(0.0, 0.0, 5.0, 5.0, 3.0, 3.0, 0.0, 2π, 0.001, LAYER, DTYPE)
println("\nRing (r_out=5, r_in=3)")
println("  area ≈ ", round(area(ring); digits=2), " µm²  (exact: π·(25-9) ≈ 50.27)")

# --- Regular polygon ---
hex = regular_polygon(0.0, 0.0, 2.0, UInt64(6), 0.0, LAYER, DTYPE)
println("\nHexagon (side=2)")
println("  area ≈ ", round(area(hex); digits=4))
println("  layer    = ", get_layer(hex))
println("  datatype = ", get_datatype(hex))

# --- Racetrack ---
track = racetrack(0.0, 0.0, 10.0, 3.0, 0.0, false, 0.001, LAYER, DTYPE)
println("\nRacetrack (straight=10, r=3)")
println("  area ≈ ", round(area(track); digits=2))

# --- Cross shape ---
plus = cross_shape(0.0, 0.0, 10.0, 2.0, LAYER, DTYPE)
println("\nCross (full_size=10, arm_width=2)")
println("  area = ", area(plus))

# --- In-place transforms ---
println("\n--- In-place transforms on rectangle ---")
r2 = rectangle(0.0, 0.0, 4.0, 2.0, LAYER, DTYPE)
println("  Before translate: bbox = ", bounding_box(r2))
translate!(r2, 5.0, 5.0)
println("  After  translate: bbox = ", bounding_box(r2))

rotate!(r2, π/4, 5.0+2.0, 5.0+1.0)   # rotate 45° around its own center
println("  After  rotate 45°: num_points = ", num_points(r2))

# --- Vertex access ---
pts = get_points(hex)   # (N×2) Matrix{Float64}
println("\nHexagon vertices ($(size(pts,1)) rows × 2 cols):")
for i in 1:size(pts, 1)
    println("  (", round(pts[i,1]; digits=4), ", ", round(pts[i,2]; digits=4), ")")
end

println("\n✓ Example 03 complete.")
