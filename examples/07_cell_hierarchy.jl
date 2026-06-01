using Gdstk

# Example 07: Cell hierarchy – top-level cells, flatten, polygon count.
# Demonstrates: top_level_cells, reference_count, flatten!, get_all_polygons,
#               bounding_box on cells

println("=== Example 07: Cell Hierarchy ===\n")

gds_file = joinpath(@__DIR__, "..", "test_data", "example.gds")

if !isfile(gds_file)
    println("""
This example requires a GDS file at:
  $gds_file

Showing walkthrough code instead.
""")
    println(raw"""
--- Walkthrough ---

lib = read_gds("/path/to/layout.gds")
tops = top_level_cells(lib)
println("Top-level cells ($(length(tops))):")
for cell in tops
    println("  '", get_name(cell), "'")
end

# Recursive dependency traversal
function print_hierarchy(cell, lib; indent=0)
    prefix = "  " ^ indent
    refs   = get_references(cell)
    polys  = polygon_count(cell)   # direct polygons only
    println(prefix, "'", get_name(cell), "'  refs=", length(refs), "  direct_polys=", polys)
    for r in refs
        if is_cell_ref(r)
            child = get_cell(r)
            child !== nothing && print_hierarchy(child, lib; indent=indent+1)
        end
    end
end

for top in tops
    print_hierarchy(top, lib)
end

# Bounding box of entire top-level cell (includes hierarchy)
top = tops[1]
bb = bounding_box(top)
println("BBox of '", get_name(top), "': ", bb)

# Flatten in-place (removes all references, inserts polygons directly)
flatten!(top, true)
println("After flatten: polygon_count = ", polygon_count(top))
println("               reference_count = ", reference_count(top))

# All polygons after flatten
all_polys = get_all_polygons(top, false)
println("get_all_polygons → ", length(all_polys), " polygons")
""")
    println("\n✓ Example 07 walkthrough printed.")
    exit(0)
end

# =============================================================================
# Live run
# =============================================================================
lib = read_gds(gds_file)
println("Library: '", get_name(lib), "'  (", cell_count(lib), " cells)\n")

tops = top_level_cells(lib)
println("Top-level cells: ", length(tops))
for cell in tops
    println("  '", get_name(cell), "'")
end

println()

# Recursive hierarchy printer
function print_hierarchy(cell; indent=0)
    prefix = "  " ^ indent
    refs  = get_references(cell)
    polys = polygon_count(cell)
    labels = label_count(cell)
    bb = bounding_box(cell)
    bbox_str = "($(round(bb.min[1];digits=2)), $(round(bb.min[2];digits=2))) → " *
               "($(round(bb.max[1];digits=2)), $(round(bb.max[2];digits=2)))"
    println(prefix, "◆ '", get_name(cell), "'")
    println(prefix, "  polygons=", polys, "  labels=", labels, "  refs=", length(refs))
    println(prefix, "  bbox: ", bbox_str)
    seen = Set{String}()
    for r in refs
        if is_cell_ref(r)
            child = get_cell(r)
            if child !== nothing
                n = get_name(child)
                if !(n in seen)
                    push!(seen, n)
                    print_hierarchy(child; indent=indent+1)
                end
            end
        end
    end
end

for top in tops
    print_hierarchy(top)
    println()
end

# Flatten first top-level cell and count polygons
if !isempty(tops)
    top = tops[1]
    name = get_name(top)
    println("Flattening '", name, "' …")
    flatten!(top, true)
    all_polys = get_all_polygons(top, false)
    println("  polygon_count after flatten: ", polygon_count(top))
    println("  get_all_polygons result:     ", length(all_polys))
end

println("\n✓ Example 07 complete.")
