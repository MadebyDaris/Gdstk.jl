using Gdstk

# Example 08: Build a layout from scratch and write it to a GDSII file.
# Demonstrates: new_library, new_cell, rectangle, ellipse, make_flexpath,
#               add_polygon!, add_flexpath!, add_cell!, write_gds, read_gds round-trip.

println("=== Example 08: Build & Write GDSII ===\n")

OUTPUT_FILE = joinpath(@__DIR__, "output_08.gds")

# =============================================================================
# 1. Create library
# =============================================================================
lib = new_library("MyLayout", 1e-6, 1e-9)
println("Created library '", get_name(lib), "'")
println("  unit      = ", get_unit(lib), " m")
println("  precision = ", get_precision(lib), " m")

# =============================================================================
# 2. Build a sub-cell: "DEVICE"
# =============================================================================
device = new_cell("DEVICE")

# Active region (rectangle on layer 1)
active = rectangle(0.0, 0.0, 20.0, 10.0, UInt32(1), UInt32(0))
add_polygon!(device, active)

# Gate oxide (rectangle on layer 2)
gate = rectangle(8.0, 0.0, 12.0, 10.0, UInt32(2), UInt32(0))
add_polygon!(device, gate)

# Contact hole (circle, layer 3)
contact = ellipse(10.0, 5.0, 1.0, 1.0, 0.0, 0.0, 0.0, 2π, 0.005,
                  UInt32(3), UInt32(0))
add_polygon!(device, contact)

# Metal routing (FlexPath, layer 4)
metal = make_flexpath(10.0, 5.0, 1.5, 0.001, UInt32(4), UInt32(0))
segment!(metal, 10.0, 15.0, false)   # up to y=15
arc!(metal, 3.0, 3.0, -π/2, π/2, 0.0)   # 180° bend
segment!(metal, 10.0, 5.0, false)    # back down
add_flexpath!(device, metal)

println("\nBuilt 'DEVICE' cell:")
println("  polygon_count = ", polygon_count(device))

# =============================================================================
# 3. Build top-level cell: "TOP" (references DEVICE 3 times)
# =============================================================================
top = new_cell("TOP")

# Add the DEVICE cell itself to the library first
add_cell!(lib, device)

# Create references to DEVICE at three positions
# (References are complex to build from scratch without a full Reference
#  constructor – here we embed polygons directly for simplicity)
for (i, (x, y)) in enumerate([(0.0, 0.0), (30.0, 0.0), (60.0, 0.0)])
    # Copy device polygons with offset (manual placement)
    r = rectangle(x, y, x+20.0, y+10.0, UInt32(1), UInt32(0))
    add_polygon!(top, r)
    g = rectangle(x+8.0, y, x+12.0, y+10.0, UInt32(2), UInt32(0))
    add_polygon!(top, g)
    c = ellipse(x+10.0, y+5.0, 1.0, 1.0, 0.0, 0.0, 0.0, 2π, 0.005, UInt32(3), UInt32(0))
    add_polygon!(top, c)
    println("  instance $i placed at ($x, $y)")
end

add_cell!(lib, top)
println("\nBuilt 'TOP' cell:")
println("  polygon_count = ", polygon_count(top))
println("  cell_count in lib = ", cell_count(lib))

# =============================================================================
# 4. Write to GDSII
# =============================================================================
println("\nWriting to: $OUTPUT_FILE")
rc = write_gds(lib, OUTPUT_FILE, UInt64(0))   # 0 = no fracture
println("  write_gds returned: $rc  (0 = success)")

# =============================================================================
# 5. Round-trip: read back and verify
# =============================================================================
if isfile(OUTPUT_FILE)
    println("\nReading back …")
    lib2 = read_gds(OUTPUT_FILE)
    println("  library name:  '", get_name(lib2), "'")
    println("  cell_count:     ", cell_count(lib2))
    for i in 0:cell_count(lib2)-1
        c = get_cell_by_index(lib2, UInt64(i))
        println("  cell '", get_name(c), "'  polygon_count=", polygon_count(c))
    end
    println("\n  File size: ", filesize(OUTPUT_FILE), " bytes")
end

println("\n✓ Example 08 complete.  Output: $OUTPUT_FILE")
