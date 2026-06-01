using Gdstk

# Example 10: SVG export.
# Demonstrates: write_svg on a Cell, building a layout suitable for SVG render.

println("=== Example 10: SVG Export ===\n")

OUTPUT_SVG = joinpath(@__DIR__, "output_10.svg")

# =============================================================================
# Build a colourful test layout
# =============================================================================
cell = new_cell("SVG_DEMO")

# Ground plane (layer 0)
add_polygon!(cell, rectangle(-5.0, -5.0, 55.0, 35.0, UInt32(0), UInt32(0)))

# Active regions (layer 1)
for (x, y) in [(0.0, 0.0), (20.0, 0.0), (40.0, 0.0)]
    add_polygon!(cell, rectangle(x, y, x+15.0, y+10.0, UInt32(1), UInt32(0)))
end

# Gate (layer 2) – a narrow strip through each active region
for (x, y) in [(0.0, 0.0), (20.0, 0.0), (40.0, 0.0)]
    add_polygon!(cell, rectangle(x+6.0, y-1.0, x+9.0, y+11.0, UInt32(2), UInt32(0)))
end

# Metal routing (layer 4) via FlexPath
bus = make_flexpath(-2.0, 5.0, 2.0, 0.001, UInt32(4), UInt32(0))
segment!(bus, 52.0, 5.0, false)     # horizontal bus
metal_polys = to_polygons(bus)
for p in metal_polys
    add_polygon!(cell, p)
end

# Contacts (layer 3) – circles at each device midpoint
for cx in [7.5, 27.5, 47.5]
    add_polygon!(cell, ellipse(cx, 5.0, 1.2, 1.2, 0.0, 0.0, 0.0, 2π, 0.005,
                               UInt32(3), UInt32(0)))
end

# Decorative hexagonal via (layer 5)
add_polygon!(cell, regular_polygon(7.5, 20.0, 3.0, UInt64(6), 0.0, UInt32(5), UInt32(0)))
add_polygon!(cell, regular_polygon(27.5, 20.0, 3.0, UInt64(6), 0.0, UInt32(5), UInt32(0)))

# Racetrack pad (layer 6)
add_polygon!(cell, racetrack(47.5, 20.0, 4.0, 2.0, 0.0, false, 0.005, UInt32(6), UInt32(0)))

println("Built 'SVG_DEMO' cell:")
println("  polygon_count = ", polygon_count(cell))
bb = bounding_box(cell)
println("  bounding box  = ", bb)

# =============================================================================
# Export to SVG
# write_svg(cell, filename, scaling)
#   scaling = pixels per µm (e.g., 10 → 1 µm = 10 px)
# =============================================================================
println("\nExporting to SVG: $OUTPUT_SVG")
rc = write_svg(cell, OUTPUT_SVG, 10.0)
println("  write_svg returned: $rc  (0 = success)")

if isfile(OUTPUT_SVG)
    file_size = filesize(OUTPUT_SVG)
    println("  File size: $file_size bytes")

    # Peek at the first few lines of the SVG
    open(OUTPUT_SVG) do f
        lines = readlines(f)
        println("\n  First 5 lines of SVG:")
        for l in first(lines, 5)
            println("    ", l)
        end
    end
end

# =============================================================================
# SVG export from a GDS file (if available)
# =============================================================================
gds_file = joinpath(@__DIR__, "..", "test_data", "example.gds")
if isfile(gds_file)
    println("\nExporting first top-level cell from $(basename(gds_file)) …")
    lib = read_gds(gds_file)
    tops = top_level_cells(lib)
    if !isempty(tops)
        top = tops[1]
        out = joinpath(@__DIR__, "output_10_gds.svg")
        rc2 = write_svg(top, out, 5.0)
        println("  '", get_name(top), "' → $out  (rc=$rc2)")
    end
end

println("\n✓ Example 10 complete.  Open $OUTPUT_SVG in a browser to view.")
