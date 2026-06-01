# Gdstk.jl

A Julia wrapper for the [`gdstk`](https://github.com/heitzmann/gdstk) C++ library — a fast, full-featured GDSII and OASIS layout engine.

## Features

| Category | What's exposed |
|---|---|
| **Geometry types** | `Vec2`, `Polygon`, `Label`, `Reference`, `FlexPath`, `RobustPath` |
| **Shape constructors** | `rectangle`, `ellipse`, `regular_polygon`, `racetrack`, `cross_shape` |
| **Polygon operations** | `area`, `signed_area`, `perimeter`, `bounding_box`, `get_points`, `translate!`, `rotate!`, `scale!`, `mirror!`, `fillet!`, `fracture` |
| **Path operations** | `segment!`, `arc!`, `turn!`, `horizontal!`, `vertical!`, `to_polygons` |
| **Boolean / Clipper** | `gds_boolean`, `union_polygons`, `intersect_polygons`, `subtract_polygons`, `xor_polygons`, `gds_offset`, `gds_merge`, `slice_polygon` |
| **Cell** | `get_polygons`, `get_all_polygons`, `get_labels`, `get_references`, `bounding_box`, `flatten!`, `add_polygon!`, `add_label!`, … |
| **Library** | `top_level_cells`, `write_gds`, `write_oas`, `add_cell!`, `cell_count`, `get_cell_by_index` |
| **I/O** | `read_gds`, `read_oas`, `write_gds`, `write_oas`, `gds_units` |
| **SVG export** | `write_svg` |
| **Tag utilities** | `make_tag`, `get_layer`, `get_type` (for layer/datatype encoding) |

## Quick Start

```julia
using Gdstk

# Verify the wrapper loaded
println(hello_gds())

# Read an existing GDSII file
lib = read_gds("layout.gds")
println("Library: ", get_name(lib), "  cells: ", cell_count(lib))

# Access a specific cell
cell = get_cell(lib, "TOP")

# Get all polygons (all layers, recursing references)
polys = get_all_polygons(cell, true)
println("Total polygons: ", length(polys))
println("Area of first:  ", area(polys[1]))

# Bounding box
bb = bounding_box(cell)
println("BBox: ", bb.min, " → ", bb.max)

# Get vertex matrix for a polygon
pts = get_points(polys[1])   # (N × 2) Matrix{Float64}
```

## Creating Geometry

```julia
# Shape constructors: (x0, y0, x1, y1, layer, datatype)
rect = rectangle(0.0, 0.0, 10.0, 5.0, UInt32(1), UInt32(0))

# Ellipse / circle
circ = ellipse(5.0, 5.0, 3.0, 3.0, 0.0, 0.0, 0.0, 2π, 0.001,
               UInt32(1), UInt32(0))

# Regular n-gon
hex = regular_polygon(0.0, 0.0, 2.0, UInt64(6), 0.0, UInt32(1), UInt32(0))

# Racetrack (straight_length, radius, inner_radius, vertical, tolerance, …)
track = racetrack(0.0, 0.0, 10.0, 3.0, 0.0, false, 0.001, UInt32(1), UInt32(0))

# Cross shape
plus = cross_shape(0.0, 0.0, 10.0, 2.0, UInt32(1), UInt32(0))
```

## Boolean Operations

```julia
polys_a = [rectangle(0.0, 0.0, 6.0, 4.0, UInt32(1), UInt32(0))]
polys_b = [rectangle(3.0, 1.0, 9.0, 5.0, UInt32(1), UInt32(0))]

union   = union_polygons(polys_a, polys_b)
inter   = intersect_polygons(polys_a, polys_b)
diff    = subtract_polygons(polys_a, polys_b)
sym_diff= xor_polygons(polys_a, polys_b)

# Dilation / erosion
dilated = gds_offset(polys_a, 0.5, JOIN_ROUND(), 0.001, 1e4, false)
eroded  = gds_offset(polys_a, -0.3, JOIN_MITER(), 0.001, 1e4, false)
```

## Paths

```julia
# FlexPath (polygon-based, efficient)
fp = make_flexpath(0.0, 0.0, 0.5, 0.001, UInt32(1), UInt32(0))
segment!(fp, 10.0, 0.0, false)
arc!(fp, 3.0, 3.0, -π/2, 0.0, 0.0)
turn!(fp, 2.0, π/4)
polys = to_polygons(fp)

# RobustPath (parametric, numerically stable for tight bends)
rp = make_robustpath(0.0, 0.0, 0.5, 0.001, UInt64(1000), UInt32(1), UInt32(0))
segment!(rp, 5.0, 0.0, false)
turn!(rp, 1.5, π/2)
rp_polys = to_polygons(rp)
```

## Writing Layouts

```julia
lib  = new_library("MyChip", 1e-6, 1e-9)
cell = new_cell("TOP")

add_polygon!(cell, rectangle(0.0, 0.0, 100.0, 50.0, UInt32(1), UInt32(0)))
add_cell!(lib, cell)

write_gds(lib, "output.gds", UInt64(0))    # 0 = no polygon fracture
write_oas(lib, "output.oas", 0.001, UInt8(6))  # circle detection + compression
```

## SVG Export

```julia
write_svg(cell, "output.svg", 10.0)   # 10 px per µm
```

## Important Notes

### `cross` vs `cross_shape`
The function is named **`cross_shape`** (not `cross`) to avoid clashing with `Base.cross` (the vector cross product).

### `get_type` vs `Base.get`
`get_type(tag)` reads the **datatype** from a tag. Unambiguous — no conflict with Base.

### Thread Safety
`bounding_box` and `slice_polygon` use module-level static C++ buffers and are **not** thread-safe. Use them from a single thread.

### Memory
`Polygon`, `Cell`, and `Library` objects created by factory functions (`new_cell`, `rectangle`, etc.) are allocated by gdstk's internal allocator. Julia's GC will not free them automatically. For long-running scripts, add elements to a `Cell` or `Library` immediately after creation to transfer logical ownership.

## Dependencies

- [`CxxWrap.jl`](https://github.com/JuliaInterop/CxxWrap.jl)
- `gdstk_jll` — the precompiled C++ wrapper (built by `GdstkWrapper/build_tarballs.jl`)

## Examples

| File | Demonstrates |
|---|---|
| `examples/01_basic_loading.jl` | `read_gds`, `hello_gds` |
| `examples/02_polygon_area.jl` | `get_polygons`, `area` |
| `examples/03_create_polygon.jl` | Shape constructors, transforms, `bounding_box`, `get_points` |
| `examples/04_boolean_ops.jl` | Boolean ops, `gds_offset`, `gds_merge` |
| `examples/05_flexpath.jl` | `FlexPath`, `RobustPath`, `to_polygons` |
| `examples/06_labels_and_refs.jl` | `get_labels`, `get_references`, `is_cell_ref` |
| `examples/07_cell_hierarchy.jl` | `top_level_cells`, `flatten!`, hierarchy traversal |
| `examples/08_write_gds.jl` | `new_library`, `new_cell`, `write_gds`, round-trip |
| `examples/09_oasis_io.jl` | `read_oas`, `write_oas`, GDSII vs OASIS size |
| `examples/10_svg_export.jl` | `write_svg`, multi-layer rendering |
