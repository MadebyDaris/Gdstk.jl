using Gdstk

# Example 09: OASIS I/O (Open Artwork System Interchange Standard).
# Demonstrates: read_oas, write_oas, gds_units (for GDSII comparison)

println("=== Example 09: OASIS I/O ===\n")

# =============================================================================
# Build a small library to test with
# =============================================================================
lib = new_library("OasisTest", 1e-6, 1e-9)
cell = new_cell("SHAPES")

# Various shapes
add_polygon!(cell, rectangle(0.0,  0.0,  10.0, 5.0,  UInt32(1), UInt32(0)))
add_polygon!(cell, rectangle(15.0, 0.0,  25.0, 5.0,  UInt32(1), UInt32(0)))
add_polygon!(cell, ellipse(5.0, 5.0, 2.5, 2.5, 0.0, 0.0, 0.0, 2π, 0.005,
                            UInt32(2), UInt32(0)))
add_polygon!(cell, regular_polygon(20.0, 5.0, 2.0, UInt64(6), 0.0,
                                   UInt32(3), UInt32(0)))
add_cell!(lib, cell)

println("Built library '", get_name(lib), "' with cell '", get_name(cell), "'")
println("  polygons in cell: ", polygon_count(cell))

GDS_FILE = joinpath(@__DIR__, "output_09.gds")
OAS_FILE = joinpath(@__DIR__, "output_09.oas")

# =============================================================================
# Write GDSII for comparison
# =============================================================================
rc_gds = write_gds(lib, GDS_FILE, UInt64(0))
println("\nWrote GDSII: $GDS_FILE  (rc=$rc_gds)")
println("  File size: ", filesize(GDS_FILE), " bytes")

units = gds_units(GDS_FILE)
println("  Unit:      ", units.unit,      " m")
println("  Precision: ", units.precision, " m")

# =============================================================================
# Write OASIS
# Arguments: write_oas(lib, filename, circle_tolerance, deflate_level)
#   circle_tolerance = 0.001 → detect circles within 1 nm tolerance
#   deflate_level    = 6     → zlib compression level (0=none, 9=max)
# =============================================================================
rc_oas = write_oas(lib, OAS_FILE, 0.001, UInt8(6))
println("\nWrote OASIS: $OAS_FILE  (rc=$rc_oas)")
if isfile(OAS_FILE)
    println("  File size: ", filesize(OAS_FILE), " bytes  (often smaller than GDSII)")
end

# =============================================================================
# Round-trip: read OASIS back
# =============================================================================
oas_file = joinpath(@__DIR__, "..", "test_data", "example.oas")

if isfile(OAS_FILE)
    println("\nReading back OASIS …")
    lib2 = read_oas(OAS_FILE)
    println("  Library name: '", get_name(lib2), "'")
    println("  Cell count:    ", cell_count(lib2))
    for i in 0:cell_count(lib2)-1
        c2 = get_cell_by_index(lib2, UInt64(i))
        all_polys = get_all_polygons(c2, false)
        println("  Cell '", get_name(c2), "': ", length(all_polys), " polygons")
    end
end

# =============================================================================
# Reading an external OASIS file (if available)
# =============================================================================
if isfile(oas_file)
    println("\nReading external OASIS: $oas_file")
    ext = read_oas(oas_file)
    println("  library: '", get_name(ext), "'  cells: ", cell_count(ext))
else
    println("\n(No external OASIS file found at $(oas_file) – skipping external read)")
end

println("\n✓ Example 09 complete.")
