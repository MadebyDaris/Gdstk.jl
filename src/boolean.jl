"""
    OPERATION_OR()

Returns the code for the OR boolean operation (Union).
"""
OPERATION_OR()  = C.OPERATION_OR()

"""
    OPERATION_AND()

Returns the code for the AND boolean operation (Intersection).
"""
OPERATION_AND() = C.OPERATION_AND()

"""
    OPERATION_XOR()

Returns the code for the XOR boolean operation (Symmetric Difference).
"""
OPERATION_XOR() = C.OPERATION_XOR()

"""
    OPERATION_NOT()

Returns the code for the NOT boolean operation (Difference).
"""
OPERATION_NOT() = C.OPERATION_NOT()

"""
    JOIN_MITER()

Returns the code for mitered joint types (used in offset operations).
"""
JOIN_MITER()    = C.JOIN_MITER()

"""
    JOIN_BEVEL()

Returns the code for beveled joint types (used in offset operations).
"""
JOIN_BEVEL()    = C.JOIN_BEVEL()

"""
    JOIN_ROUND()

Returns the code for rounded joint types (used in offset operations).
"""
JOIN_ROUND()    = C.JOIN_ROUND()

"""
    gds_boolean(a::Vector{Polygon}, b::Vector{Polygon}, op::Integer, scaling::Real)

Performs a boolean operation (`op`) between two sets of polygons (`a` and `b`).
The operation code can be one of `OPERATION_OR()`, `OPERATION_AND()`, `OPERATION_XOR()`, or `OPERATION_NOT()`.

# Examples
```julia
using Gdstk
rect_a = [rectangle(0.0, 0.0, 6.0, 4.0, 1, 0)]
rect_b = [rectangle(3.0, 1.0, 9.0, 5.0, 1, 0)]
result = gds_boolean(rect_a, rect_b, OPERATION_OR(), 1e4)
```
"""
function gds_boolean(a::Vector{Polygon}, b::Vector{Polygon}, op::Integer, scaling::Real)
    a_ptrs = _unwrap_polygon_array(a)
    b_ptrs = _unwrap_polygon_array(b)
    raw = C.gds_boolean(a_ptrs, b_ptrs, Int(op), Float64(scaling))
    return _wrap_array(Polygon, raw)
end

"""
    gds_offset(polys::Vector{Polygon}, distance::Real, join_type, tolerance::Real, scaling::Real, use_union::Bool)

Dilates or erodes a set of polygons by a specific `distance`. A positive distance dilates the polygons, while a negative distance erodes them.

# Examples
```julia
using Gdstk
small_rect = [rectangle(0.0, 0.0, 4.0, 2.0, 1, 0)]
dilated = gds_offset(small_rect, 0.5, JOIN_ROUND(), 0.001, 1e4, false)
eroded = gds_offset(small_rect, -0.5, JOIN_MITER(), 0.001, 1e4, false)
```
"""
function gds_offset(polys::Vector{Polygon}, distance::Real, join_type, tolerance::Real, scaling::Real, use_union::Bool)
    ptrs = _unwrap_polygon_array(polys)
    raw = C.gds_offset(ptrs, Float64(distance), Int(join_type), Float64(tolerance), Float64(scaling), use_union)
    return _wrap_array(Polygon, raw)
end

"""
    gds_merge(polys::Vector{Polygon}, scaling::Real)

Merges multiple polygons into a minimal set of non-overlapping polygons.

# Examples
```julia
using Gdstk
many = [rectangle(Float64(i)*2, 0.0, Float64(i)*2+1.5, 1.0, 1, 0) for i in 0:4]
merged = gds_merge(many, 1e4)
```
"""
function gds_merge(polys::Vector{Polygon}, scaling::Real)
    ptrs = _unwrap_polygon_array(polys)
    raw = C.gds_merge(ptrs, Float64(scaling))
    return _wrap_array(Polygon, raw)
end

"""
    gds_slice(p::Polygon, positions::AbstractVector{<:Real}, x_axis::Bool, scaling::Real)

Slices a polygon along the specified positions on either the x-axis or y-axis.
Returns an array of resulting polygons.
"""
function gds_slice(p::Polygon, positions::AbstractVector{<:Real}, x_axis::Bool, scaling::Real)
    pos = convert(Vector{Float64}, collect(positions))
    raw = C.gds_slice(_unwrap(p), pos, x_axis, Float64(scaling))
    return _wrap_array(Polygon, raw)
end

"""
    gds_slice_counts()

Returns the counts of polygons resulting from the last slice operation.
"""
gds_slice_counts() = collect(C.gds_slice_counts())
