module Gdstk

using CxxWrap
using gdstk_jll

include("raw.jl")
import ._Raw

include("types.jl")
include("elements.jl")
include("containers.jl")
include("io.jl")
include("boolean.jl")
include("helpers.jl")

export Vec2, make_vec2, getx, gety, setx, sety, vlength, vinner
export make_tag, get_layer, get_type
export Polygon, area, signed_area, perimeter, num_points, get_points_flat
export get_datatype, translate!, scale!, mirror!, rotate!, fillet!, fracture
export rectangle, cross_shape, regular_polygon, ellipse, racetrack
export Label, get_text, get_texttype, get_anchor, get_originx, get_originy
export get_rotation, get_magnification, get_x_reflection
export Reference, is_cell_ref, get_name
export FlexPath, make_flexpath, segment!, arc!, turn!, horizontal!, vertical!
export num_elements, to_polygons
export RobustPath, make_robustpath, get_end_pointx, get_end_pointy
export Cell, new_cell, get_name, polygon_count, label_count, reference_count
export get_polygons, get_all_polygons, get_labels, get_references
export flatten!, write_svg, add_polygon!, add_label!, add_reference!
export add_flexpath!, add_robustpath!
export Library, new_library, get_unit, get_precision, cell_count
export get_cell, get_cell_by_index, top_level_cells, add_cell!
export read_gds, read_oas, write_gds, write_oas
export gds_boolean, gds_offset, gds_merge, gds_slice, gds_slice_counts
export OPERATION_OR, OPERATION_AND, OPERATION_XOR, OPERATION_NOT
export JOIN_MITER, JOIN_BEVEL, JOIN_ROUND
export hello_gds
export get_points, bounding_box, gds_units
export union_polygons, intersect_polygons, subtract_polygons, xor_polygons
export slice_polygon

function __init__()
    _Raw.__init__()
end

end # module Gdstk
