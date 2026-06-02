OPERATION_OR()  = _Raw.OPERATION_OR()
OPERATION_AND() = _Raw.OPERATION_AND()
OPERATION_XOR() = _Raw.OPERATION_XOR()
OPERATION_NOT() = _Raw.OPERATION_NOT()

JOIN_MITER()    = _Raw.JOIN_MITER()
JOIN_BEVEL()    = _Raw.JOIN_BEVEL()
JOIN_ROUND()    = _Raw.JOIN_ROUND()

function gds_boolean(a::Vector{Polygon}, b::Vector{Polygon}, op::Integer, scaling::Real)
    a_ptrs = _unwrap_polygon_array(a)
    b_ptrs = _unwrap_polygon_array(b)
    raw = _Raw.gds_boolean(a_ptrs, b_ptrs, Int(op), Float64(scaling))
    return _wrap_array(Polygon, raw)
end

function gds_offset(polys::Vector{Polygon}, distance::Real, join_type, tolerance::Real, scaling::Real, use_union::Bool)
    ptrs = _unwrap_polygon_array(polys)
    raw = _Raw.gds_offset(ptrs, Float64(distance), Int(join_type), Float64(tolerance), Float64(scaling), use_union)
    return _wrap_array(Polygon, raw)
end

function gds_merge(polys::Vector{Polygon}, scaling::Real)
    ptrs = _unwrap_polygon_array(polys)
    raw = _Raw.gds_merge(ptrs, Float64(scaling))
    return _wrap_array(Polygon, raw)
end

function gds_slice(p::Polygon, positions::AbstractVector{<:Real}, x_axis::Bool, scaling::Real)
    pos = convert(Vector{Float64}, collect(positions))
    raw = _Raw.gds_slice(_unwrap(p), pos, x_axis, Float64(scaling))
    return _wrap_array(Polygon, raw)
end

gds_slice_counts() = collect(_Raw.gds_slice_counts())
