# Gdstk.jl — Examples

All examples use the `Gdstk` package.  
Run any of them from the repo root with `julia --project examples/NN_name.jl`.

| # | File | Demonstrates |
|---|---|---|
| 01 | `01_basic_loading.jl` | `read_gds`, `hello_gds` |
| 02 | `02_polygon_area.jl` | `get_polygons`, `area` per layer |
| 03 | `03_create_polygon.jl` | `rectangle`, `ellipse`, `regular_polygon`, `racetrack`, `cross_shape`, `bounding_box`, `get_points`, `translate!`, `rotate!` |
| 04 | `04_boolean_ops.jl` | `union_polygons`, `intersect_polygons`, `subtract_polygons`, `xor_polygons`, `gds_offset`, `gds_merge` |
| 05 | `05_flexpath.jl` | `make_flexpath`, `make_robustpath`, `segment!`, `arc!`, `turn!`, `to_polygons` |
| 06 | `06_labels_and_refs.jl` | `get_labels`, `get_references`, `is_cell_ref`, label fields |
| 07 | `07_cell_hierarchy.jl` | `top_level_cells`, recursive traversal, `flatten!`, `polygon_count` |
| 08 | `08_write_gds.jl` | `new_library`, `new_cell`, `add_polygon!`, `add_flexpath!`, `write_gds`, round-trip verification |
| 09 | `09_oasis_io.jl` | `write_oas`, `read_oas`, `gds_units`, GDSII vs OASIS size comparison |
| 10 | `10_svg_export.jl` | `write_svg` with multi-layer layout |

## Notes

- Examples 06 and 07 look for test GDS files in `../test_data/example.gds`.  
  They gracefully fall back to printing a walkthrough if no file is found.
- Example 08 and 09 write output files (`output_08.gds`, `output_09.*`)  
  into the `examples/` directory.
- Example 10 writes `output_10.svg` — open it in any modern browser.
