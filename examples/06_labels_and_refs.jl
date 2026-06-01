using Gdstk

# Example 06: Labels and References.
# Demonstrates: reading labels from a GDS file, inspecting Reference objects,
#               get_labels, get_references, is_cell_ref, get_text, get_layer

println("=== Example 06: Labels and References ===\n")

gds_file = joinpath(@__DIR__, "..", "test_data", "example.gds")

if !isfile(gds_file)
    println("""
This example requires a GDS file at:
  $gds_file

You can point to any GDSII file you have:
  lib = read_gds("/path/to/your/layout.gds")

Below is a code walkthrough that will run once you have a valid file.
""")
    # -------------------------------------------------------------------
    # Code walkthrough (not executed – file not found)
    # -------------------------------------------------------------------
    println(raw"""
--- Walkthrough (run after providing a GDS file) ---

lib = read_gds(gds_file)
println("Library: ", get_name(lib))
println("Unit:     ", get_unit(lib), " m")
println("Precision:", get_precision(lib), " m")
println("Cells:    ", cell_count(lib))

# Iterate all cells
for i in 0:cell_count(lib)-1
    cell = get_cell_by_index(lib, UInt64(i))
    println("\\nCell: ", get_name(cell))

    # --- Labels ---
    labels = get_labels(cell, false)       # false = don't apply repetitions
    println("  Labels: ", length(labels))
    for l in labels
        println("    text = '", get_text(l), "'",
                "  layer=", get_layer(l),
                "  type=",  get_texttype(l),
                "  @ (",    round(get_originx(l); digits=3), ",",
                            round(get_originy(l); digits=3), ")",
                "  rot=",   round(get_rotation(l); digits=3), " rad",
                "  anchor=",get_anchor(l))  # 0=NW … 10=SE
    end

    # --- References ---
    refs = get_references(cell)
    println("  References: ", length(refs))
    for r in refs
        if is_cell_ref(r)
            child = get_cell(r)
            cname = child !== nothing ? get_name(child) : "(null)"
            println("    → cell '", cname, "'",
                    "  origin=(", round(get_originx(r); digits=3), ",",
                                  round(get_originy(r); digits=3), ")",
                    "  rot=",   round(get_rotation(r); digits=3), " rad",
                    "  mag=",   get_magnification(r),
                    "  x_refl=",get_x_reflection(r))
        else
            println("    → name ref '", get_name(r), "'")
        end
    end
end
""")
    println("\n✓ Example 06 walkthrough printed (file not found – no GDS loaded).")
    exit(0)
end

# =============================================================================
# Live run (GDS file found)
# =============================================================================
lib = read_gds(gds_file)
println("Library:   '", get_name(lib), "'")
println("Unit:       ", get_unit(lib), " m")
println("Precision:  ", get_precision(lib), " m")
println("Cell count: ", cell_count(lib))

for i in 0:cell_count(lib)-1
    cell = get_cell_by_index(lib, UInt64(i))
    cname = get_name(cell)
    println("\n─── Cell: '$cname' ───")

    # Labels
    labels = get_labels(cell, true)
    println("  Labels ($(length(labels))):")
    for l in labels
        println("    '", get_text(l), "'",
                "  L", get_layer(l), "/T", get_texttype(l),
                "  @ (", round(get_originx(l); digits=3), ", ", round(get_originy(l); digits=3), ")")
    end

    # References
    refs = get_references(cell)
    println("  References ($(length(refs))):")
    for r in refs
        target = is_cell_ref(r) ? get_name(get_cell(r)) : "'$(get_name(r))' (name)"
        println("    → ", target,
                "  origin=(", round(get_originx(r); digits=3), ", ",
                              round(get_originy(r); digits=3), ")",
                "  rot=", round(get_rotation(r); digits=3))
    end
end

println("\n✓ Example 06 complete.")
