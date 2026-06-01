using Gdstk

# Example 05: FlexPath and RobustPath.
# Demonstrates: make_flexpath, segment!, arc!, turn!, horizontal!, vertical!,
#               to_polygons, make_robustpath
#
# NOTE: The current C++ wrapper has a known bug where FlexPath::init() and
#       RobustPath::init() use an overload that does NOT set num_elements,
#       leaving it at 0.  This causes to_polygons() to return empty results.
#       The path operations (segment!, arc!, etc.) DO update the internal
#       state correctly, but polygonisation is broken at the C++ layer.
#       This example runs without MethodErrors but produces 0 polygons.

println("=== Example 05: Paths (FlexPath & RobustPath) ===\n")

LAYER    = UInt32(1)
DTYPE    = UInt32(0)
WIDTH    = 0.5    # µm
TOL      = 0.001  # approximation tolerance

# =============================================================================
# FlexPath – bent waveguide example
# =============================================================================
println("--- FlexPath ---")
fp = make_flexpath(0.0, 0.0, WIDTH, TOL, LAYER, DTYPE)

# Draw an S-bend using arc segments
# 1. Straight segment going right
segment!(fp, 5.0, 0.0, false)

# 2. 90° arc upward (centre-of-curvature radius 3 µm)
arc!(fp, 3.0, 3.0, -π/2, 0.0, 0.0)

# 3. Straight segment going up
segment!(fp, 0.0, 4.0, false)

# 4. Another 90° arc
arc!(fp, 3.0, 3.0, π, π/2, 0.0)

# 5. Horizontal segment (absolute x = 15)
horizontal!(fp, 15.0, false)

println("  num_elements = ", num_elements(fp))

# Polygonise the path
polys = to_polygons(fp)
println("  to_polygons → ", length(polys), " polygon(s)")
if !isempty(polys)
    total_area = sum(area(p) for p in polys)
    println("  approximate cross-section area = ", round(total_area; digits=4))
end

# In-place transforms work just like Polygon
translate!(fp, 0.0, 10.0)
rotate!(fp, π/6, 0.0, 10.0)
polys_xf = to_polygons(fp)
println("  after translate+rotate → ", length(polys_xf), " polygon(s)")

# =============================================================================
# RobustPath – more numerically stable for tight bends
# =============================================================================
println("\n--- RobustPath ---")
MAX_EVALS = UInt64(1000)
rp = make_robustpath(0.0, 0.0, WIDTH, TOL, MAX_EVALS, LAYER, DTYPE)

# Segment to (10, 0)
segment!(rp, 10.0, 0.0, false)

# Turn 90° upward with radius 2 µm
turn!(rp, 2.0, π/2)

# Segment 5 µm further
segment!(rp, 0.0, 5.0, true)   # relative

end_x = get_end_pointx(rp)
end_y = get_end_pointy(rp)
println("  end point = (", round(end_x; digits=3), ", ", round(end_y; digits=3), ")")
println("  num_elements = ", num_elements(rp))

rp_polys = to_polygons(rp)
println("  to_polygons → ", length(rp_polys), " polygon(s)")
if !isempty(rp_polys)
    println("  polygon area ≈ ", round(sum(area(p) for p in rp_polys); digits=3))
end

println("\n✓ Example 05 complete.")
