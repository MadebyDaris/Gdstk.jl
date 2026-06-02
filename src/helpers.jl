function get_points(poly::Polygon)
    flat = get_points_flat(poly)
    n = length(flat) ÷ 2
    return reshape(collect(flat), 2, n)'
end

function bounding_box(obj)
    raw = bbox_raw(obj)
    return (min = (raw[1], raw[2]), max = (raw[3], raw[4]))
end

function gds_units(filename::AbstractString)
    u = gds_units_unit(filename)
    p = gds_units_precision(filename)
    return (unit = u, precision = p)
end

union_polygons(a, b; scaling::Real=1e4)     = gds_boolean(a, b, OPERATION_OR(), Float64(scaling))
intersect_polygons(a, b; scaling::Real=1e4) = gds_boolean(a, b, OPERATION_AND(), Float64(scaling))
subtract_polygons(a, b; scaling::Real=1e4)  = gds_boolean(a, b, OPERATION_NOT(), Float64(scaling))
xor_polygons(a, b; scaling::Real=1e4)       = gds_boolean(a, b, OPERATION_XOR(), Float64(scaling))

function slice_polygon(poly::Polygon, positions::AbstractVector{<:Real}; x_axis::Bool=true, scaling::Real=1e4)
    pos = convert(Vector{Float64}, collect(positions))
    flat  = gds_slice(poly, pos, x_axis, Float64(scaling))
    counts = collect(gds_slice_counts())
    n = length(counts)
    result = Vector{Vector{Polygon}}(undef, n)
    idx = 1
    for i in 1:n
        cnt = Int(counts[i])
        result[i] = collect(flat[idx:idx+cnt-1])
        idx += cnt
    end
    return result
end
