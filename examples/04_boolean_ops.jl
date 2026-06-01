using Gdstk

# Example 04: Boolean polygon operations.
# Demonstrates: gds_boolean (OR/AND/NOT/XOR), gds_offset, gds_merge,
#               union_polygons, intersect_polygons, subtract_polygons

println("=== Example 04: Boolean Operations ===\n")

LAYER = UInt32(1)
DTYPE = UInt32(0)
SCALING = 1e4  # integer grid precision

# Two overlapping rectangles
rect_a = rectangle(0.0, 0.0, 6.0, 4.0, LAYER, DTYPE)
rect_b = rectangle(3.0, 1.0, 9.0, 5.0, LAYER, DTYPE)

println("rect_a area = ", area(rect_a))
println("rect_b area = ", area(rect_b))
println("Overlap expected: 3×3 = 9 µm²\n")

# Wrap in vectors for the array-based API
polys_a = [rect_a]
polys_b = [rect_b]

# OR (union)
result_or = union_polygons(polys_a, polys_b; scaling=SCALING)
println("Union (OR):")
println("  num result polygons = ", length(result_or))
if length(result_or) > 0
    println("  total area = ", sum(area(p) for p in result_or))
end

# AND (intersection)
result_and = intersect_polygons(polys_a, polys_b; scaling=SCALING)
println("\nIntersection (AND):")
println("  num result polygons = ", length(result_and))
if length(result_and) > 0
    println("  area = ", area(result_and[1]))
end

# NOT (subtract b from a)
result_not = subtract_polygons(polys_a, polys_b; scaling=SCALING)
println("\nSubtract (NOT: a - b):")
println("  num result polygons = ", length(result_not))
if length(result_not) > 0
    println("  total area = ", sum(area(p) for p in result_not))
end

# XOR
result_xor = xor_polygons(polys_a, polys_b; scaling=SCALING)
println("\nXOR (symmetric difference):")
println("  num result polygons = ", length(result_xor))
if length(result_xor) > 0
    println("  total area = ", sum(area(p) for p in result_xor))
end

# --- Offset (dilation / erosion) ---
println("\n--- Offset (dilation/erosion) ---")
small_rect = [rectangle(0.0, 0.0, 4.0, 2.0, LAYER, DTYPE)]
dilated  = gds_offset(small_rect, 0.5, JOIN_ROUND(), 0.001, SCALING, false)
eroded   = gds_offset(small_rect, -0.5, JOIN_MITER(), 0.001, SCALING, false)
println("Original area  = ", area(small_rect[1]))
if !isempty(dilated); println("Dilated  area  ≈ ", round(area(dilated[1]); digits=2)); end
if !isempty(eroded);  println("Eroded   area  ≈ ", round(area(eroded[1]);  digits=2)); end

# --- Merge (union of many polygons) ---
println("\n--- Merge multiple polygons ---")
many = [rectangle(Float64(i)*2, 0.0, Float64(i)*2+1.5, 1.0, LAYER, DTYPE) for i in 0:4]
println("5 rectangles, areas: ", [area(p) for p in many])
merged = gds_merge(many, SCALING)
println("Merged into ", length(merged), " polygon(s)")
if !isempty(merged)
    println("  total area = ", sum(area(p) for p in merged))
end

println("\n✓ Example 04 complete.")
