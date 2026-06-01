module Gdstk

using CxxWrap
using gdstk_jll

# --- Raw C++ Bindings ---

module _Raw
    using CxxWrap
    using gdstk_jll
    @wrapmodule(() -> gdstk_jll.libgdstk_wrapper)
    function __init__()
        @initcxx
    end
end

function __init__()
    _Raw.__init__()
end

import ._Raw

# --- Opaque Julia Wrapper Structs ---

"""
    Vec2(ptr)

A 2D vector object representing an (x, y) coordinate pair.
"""
struct Vec2
    ptr::Any
end

"""
    Polygon(ptr)

A polygon object defined by a sequence of vertices.
"""
struct Polygon
    ptr::Any
end

"""
    Label(ptr)

A text label object used for annotations in a layout.
"""
struct Label
    ptr::Any
end

"""
    Reference(ptr)

A reference to a `Cell` or a named cell, allowing for hierarchical layouts.
"""
struct Reference
    ptr::Any
end

"""
    FlexPath(ptr)

A path object with variable width and multiple elements, suitable for complex routing.
"""
struct FlexPath
    ptr::Any
end

"""
    RobustPath(ptr)

A path object designed to be robust against self-intersections and other geometric issues.
"""
struct RobustPath
    ptr::Any
end

"""
    Cell(ptr)

A container for geometry (polygons, paths, labels) and references to other cells.
"""
struct Cell
    ptr::Any
end

"""
    Library(ptr)

A top-level container for a collection of cells, including unit and precision metadata.
"""
struct Library
    ptr::Any
end

# --- Internal Helpers ---

# Dereference CxxPtr to base type or return the object itself
_deref(x::CxxPtr) = x[]
_deref(x) = x

# Ensure we have a CxxPtr
_to_ptr(x::CxxPtr) = x
_to_ptr(x) = CxxPtr(x)

# Convert C++ string pointer to Julia String
_cxx_string(p) = unsafe_string(reinterpret(Ptr{UInt8}, p))

# Unwrap Julia wrapper types to their underlying C++ objects for reference dispatch
_unwrap(v::Vec2)       = _deref(v.ptr)
_unwrap(p::Polygon)    = _deref(p.ptr)
_unwrap(l::Label)      = _deref(l.ptr)
_unwrap(r::Reference)  = _deref(r.ptr)
_unwrap(fp::FlexPath)  = _deref(fp.ptr)
_unwrap(rp::RobustPath)= _deref(rp.ptr)
_unwrap(c::Cell)       = _deref(c.ptr)
_unwrap(l::Library)    = _deref(l.ptr)

# Unwrap Julia wrapper types to CxxPtr for pointer arguments
_unwrap_ptr(p::Polygon)    = _to_ptr(p.ptr)
_unwrap_ptr(l::Label)      = _to_ptr(l.ptr)
_unwrap_ptr(r::Reference)  = _to_ptr(r.ptr)
_unwrap_ptr(fp::FlexPath)  = _to_ptr(fp.ptr)
_unwrap_ptr(rp::RobustPath)= _to_ptr(rp.ptr)
_unwrap_ptr(c::Cell)       = _to_ptr(c.ptr)

# Wrap raw C++ pointer arrays into Julia wrapper types
_wrap_array(::Type{Polygon}, raw)     = [Polygon(CxxPtr{_Raw.Polygon}(p)) for p in raw]
_wrap_array(::Type{Cell}, raw)        = [Cell(CxxPtr{_Raw.Cell}(p)) for p in raw]
_wrap_array(::Type{Label}, raw)       = [Label(CxxPtr{_Raw.Label}(p)) for p in raw]
_wrap_array(::Type{Reference}, raw)   = [Reference(CxxPtr{_Raw.Reference}(p)) for p in raw]

# Extract raw pointer arrays for C++ ArrayRef input
_unwrap_polygon_array(arr)   = Ptr{_Raw.Polygon}[p.ptr.cpp_object for p in arr]
_unwrap_cell_array(arr)      = Ptr{_Raw.Cell}[c.ptr.cpp_object for c in arr]

# --- Factory Functions ---

"""
    make_tag(layer, datatype) -> UInt64

Create a GDSII tag by combining a layer number and a datatype.
"""
make_tag(layer, datatype) = _Raw.make_tag(UInt32(layer), UInt32(datatype))

"""
    get_layer(tag::UInt64) -> UInt32

Extract the layer number from a GDSII tag.
"""
get_layer(tag::UInt64) = _Raw.get_layer(tag)

"""
    get_type(tag::UInt64) -> UInt32

Extract the datatype from a GDSII tag.
"""
get_type(tag::UInt64) = _Raw.get_type(tag)

"""
    make_vec2(x::Real, y::Real) -> Vec2

Create a new `Vec2` object from the given `x` and `y` coordinates.
"""
make_vec2(x::Real, y::Real) = Vec2(_Raw.make_vec2(Float64(x), Float64(y)))

"""
    rectangle(x0, y0, x1, y1, layer, datatype) -> Polygon

Create a rectangular `Polygon` with corners at (x0, y0) and (x1, y1) on the specified layer and datatype.
"""
rectangle(x0::Real, y0::Real, x1::Real, y1::Real, layer, datatype) =
    Polygon(_Raw.rectangle(Float64(x0), Float64(y0), Float64(x1), Float64(y1),
                           UInt32(layer), UInt32(datatype)))

"""
    cross_shape(cx, cy, full_size, arm_width, layer, datatype) -> Polygon

Create a cross-shaped `Polygon` centered at (cx, cy) with the given full size and arm width.
"""
cross_shape(cx::Real, cy::Real, full_size::Real, arm_width::Real, layer, datatype) =
    Polygon(_Raw.cross_shape(Float64(cx), Float64(cy), Float64(full_size),
                             Float64(arm_width), UInt32(layer), UInt32(datatype)))

"""
    regular_polygon(cx, cy, side_length, sides, rotation, layer, datatype) -> Polygon

Create a regular `Polygon` with a specified number of sides, centered at (cx, cy).
"""
regular_polygon(cx::Real, cy::Real, side_length::Real, sides::Integer,
                rotation::Real, layer, datatype) =
    Polygon(_Raw.regular_polygon(Float64(cx), Float64(cy), Float64(side_length),
                                 UInt64(sides), Float64(rotation),
                                 UInt32(layer), UInt32(datatype)))

"""
    ellipse(cx, cy, rx, ry, irx, iry, a0, a1, tol, layer, datatype) -> Polygon

Create an elliptical `Polygon` (or annulus/sector) centered at (cx, cy).
`rx`, `ry` are the outer radii; `irx`, `iry` are the inner radii.
`a0` and `a1` are start/end angles in radians.
"""
ellipse(cx::Real, cy::Real, rx::Real, ry::Real, irx::Real, iry::Real,
        a0::Real, a1::Real, tol::Real, layer, datatype) =
    Polygon(_Raw.ellipse(Float64(cx), Float64(cy), Float64(rx), Float64(ry),
                         Float64(irx), Float64(iry), Float64(a0), Float64(a1),
                         Float64(tol), UInt32(layer), UInt32(datatype)))

"""
    racetrack(cx, cy, straight_length, radius, inner_radius, vertical, tol, layer, datatype) -> Polygon

Create a racetrack-shaped `Polygon` centered at (cx, cy).
"""
racetrack(cx::Real, cy::Real, straight_length::Real, radius::Real,
          inner_radius::Real, vertical::Bool, tol::Real, layer, datatype) =
    Polygon(_Raw.racetrack(Float64(cx), Float64(cy), Float64(straight_length),
                           Float64(radius), Float64(inner_radius), vertical,
                           Float64(tol), UInt32(layer), UInt32(datatype)))

"""
    make_flexpath(x, y, width, tolerance, layer, datatype) -> FlexPath

Initialize a new `FlexPath` starting at (x, y) with the given initial width and tolerance.
"""
make_flexpath(x::Real, y::Real, width::Real, tolerance::Real, layer, datatype) =
    FlexPath(_Raw.make_flexpath(Float64(x), Float64(y), Float64(width),
                                Float64(tolerance), UInt32(layer), UInt32(datatype)))

"""
    make_robustpath(x, y, width, tolerance, max_evals, layer, datatype) -> RobustPath

Initialize a new `RobustPath` starting at (x, y).
"""
make_robustpath(x::Real, y::Real, width::Real, tolerance::Real,
                max_evals::Integer, layer, datatype) =
    RobustPath(_Raw.make_robustpath(Float64(x), Float64(y), Float64(width),
                                    Float64(tolerance), UInt64(max_evals),
                                    UInt32(layer), UInt32(datatype)))

"""
    new_cell(name::AbstractString) -> Cell

Create a new, empty `Cell` with the specified name.
"""
new_cell(name::AbstractString) = Cell(_Raw.new_cell(String(name)))

"""
    new_library(name::AbstractString, unit::Real, precision::Real) -> Library

Create a new `Library` with a name, physical unit (in meters), and precision (in meters).
"""
new_library(name::AbstractString, unit::Real, precision::Real) =
    Library(_Raw.new_library(String(name), Float64(unit), Float64(precision)))

# --- I/O Functions ---

"""
    read_gds(filename::AbstractString) -> Library

Read a GDSII file and return a `Library` containing its cells and metadata.
"""
read_gds(filename::AbstractString) = Library(_Raw.read_gds(String(filename)))

"""
    read_oas(filename::AbstractString) -> Library

Read an OASIS file and return a `Library`.
"""
read_oas(filename::AbstractString) = Library(_Raw.read_oas(String(filename)))

"""
    gds_units_unit(filename::AbstractString) -> Float64

Return the physical unit (in meters) from a GDSII file header.
"""
gds_units_unit(filename::AbstractString) = _Raw.gds_units_unit(String(filename))

"""
    gds_units_precision(filename::AbstractString) -> Float64

Return the precision (in meters) from a GDSII file header.
"""
gds_units_precision(filename::AbstractString) = _Raw.gds_units_precision(String(filename))

"""
    hello_gds() -> String

Return a diagnostic string from the underlying gdstk C++ library.
"""
hello_gds() = _cxx_string(_Raw.hello_gds())

# --- Enums and Constants ---

"""
    OPERATION_OR() -> Int

Return the integer constant for a Boolean OR operation.
"""
OPERATION_OR()  = _Raw.OPERATION_OR()

"""
    OPERATION_AND() -> Int

Return the integer constant for a Boolean AND operation.
"""
OPERATION_AND() = _Raw.OPERATION_AND()

"""
    OPERATION_XOR() -> Int

Return the integer constant for a Boolean XOR operation.
"""
OPERATION_XOR() = _Raw.OPERATION_XOR()

"""
    OPERATION_NOT() -> Int

Return the integer constant for a Boolean NOT (subtraction) operation.
"""
OPERATION_NOT() = _Raw.OPERATION_NOT()

"""
    JOIN_MITER() -> Int

Return the integer constant for a miter join type in paths.
"""
JOIN_MITER()    = _Raw.JOIN_MITER()

"""
    JOIN_BEVEL() -> Int

Return the integer constant for a bevel join type in paths.
"""
JOIN_BEVEL()    = _Raw.JOIN_BEVEL()

"""
    JOIN_ROUND() -> Int

Return the integer constant for a round join type in paths.
"""
JOIN_ROUND()    = _Raw.JOIN_ROUND()

# --- Polygon Methods ---

"""
    area(p::Polygon) -> Float64

Calculate the area of the `Polygon`.
"""
area(p::Polygon)            = _Raw.area(_unwrap(p))

"""
    signed_area(p::Polygon) -> Float64

Calculate the signed area of the `Polygon`. Positive indicates counter-clockwise orientation.
"""
signed_area(p::Polygon)     = _Raw.signed_area(_unwrap(p))

"""
    perimeter(p::Polygon) -> Float64

Calculate the total perimeter length of the `Polygon`.
"""
perimeter(p::Polygon)       = _Raw.perimeter(_unwrap(p))

"""
    num_points(p::Polygon) -> UInt64

Return the number of vertices in the `Polygon`.
"""
num_points(p::Polygon)      = _Raw.num_points(_unwrap(p))

"""
    get_points_flat(p::Polygon) -> Vector{Float64}

Return the polygon vertices as a flat vector: `[x1, y1, x2, y2, ...]`.
"""
get_points_flat(p::Polygon) = _Raw.get_points_flat(_unwrap(p))

"""
    get_datatype(p::Polygon) -> UInt32

Return the GDSII datatype of the `Polygon`.
"""
get_datatype(p::Polygon)    = _Raw.get_datatype(_unwrap(p))

"""
    get_layer(p::Polygon) -> UInt32

Return the GDSII layer of the `Polygon`.
"""
get_layer(p::Polygon)       = _Raw.get_layer(_unwrap(p))

"""
    bbox_raw(p::Polygon) -> Vector{Float64}

Return the raw bounding box as `[min_x, min_y, max_x, max_y]`.
"""
bbox_raw(p::Polygon)        = _Raw.bbox_raw(_unwrap(p))

"""
    translate!(p::Polygon, dx, dy)

Translate the `Polygon` by `dx` and `dy` in-place.
"""
translate!(p::Polygon, dx::Real, dy::Real) =
    _Raw.translate!(_unwrap(p), Float64(dx), Float64(dy))

"""
    scale!(p::Polygon, sx, sy, cx, cy)

Scale the `Polygon` by `sx` and `sy` factors relative to the center (cx, cy) in-place.
"""
scale!(p::Polygon, sx::Real, sy::Real, cx::Real, cy::Real) =
    _Raw.scale!(_unwrap(p), Float64(sx), Float64(sy), Float64(cx), Float64(cy))

"""
    mirror!(p::Polygon, ax, ay, bx, by)

Mirror the `Polygon` across the line defined by points (ax, ay) and (bx, by) in-place.
"""
mirror!(p::Polygon, ax::Real, ay::Real, bx::Real, by::Real) =
    _Raw.mirror!(_unwrap(p), Float64(ax), Float64(ay), Float64(bx), Float64(by))

"""
    rotate!(p::Polygon, angle, cx, cy)

Rotate the `Polygon` by `angle` (radians) around the center (cx, cy) in-place.
"""
rotate!(p::Polygon, angle::Real, cx::Real, cy::Real) =
    _Raw.rotate!(_unwrap(p), Float64(angle), Float64(cx), Float64(cy))

"""
    fillet!(p::Polygon, radius, tolerance)

Apply a fillet (rounding) to the corners of the `Polygon` in-place.
"""
fillet!(p::Polygon, radius::Real, tolerance::Real) =
    _Raw.fillet!(_unwrap(p), Float64(radius), Float64(tolerance))

"""
    fracture(p::Polygon, max_points, precision) -> Vector{Polygon}

Fracture the `Polygon` into a set of smaller polygons, each having at most `max_points` vertices.
"""
fracture(p::Polygon, max_points::Integer, precision::Real) =
    _wrap_array(Polygon, _Raw.fracture(_unwrap(p), UInt64(max_points), Float64(precision)))

# --- Vec2 Methods ---

"""
    getx(v::Vec2) -> Float64

Return the x-coordinate of the `Vec2`.
"""
getx(v::Vec2)    = _Raw.getx(_unwrap(v))

"""
    gety(v::Vec2) -> Float64

Return the y-coordinate of the `Vec2`.
"""
gety(v::Vec2)    = _Raw.gety(_unwrap(v))

"""
    setx(v::Vec2, x)

Set the x-coordinate of the `Vec2` in-place.
"""
setx(v::Vec2, x::Real) = _Raw.setx(_unwrap(v), Float64(x))

"""
    sety(v::Vec2, y)

Set the y-coordinate of the `Vec2` in-place.
"""
sety(v::Vec2, y::Real) = _Raw.sety(_unwrap(v), Float64(y))

"""
    vlength(v::Vec2) -> Float64

Return the Euclidean length (magnitude) of the `Vec2`.
"""
vlength(v::Vec2) = _Raw.vlength(_unwrap(v))

"""
    vinner(a::Vec2, b::Vec2) -> Float64

Return the inner (dot) product of two `Vec2` objects.
"""
vinner(a::Vec2, b::Vec2) = _Raw.vinner(_unwrap(a), _unwrap(b))

# --- Label Methods ---

"""
    get_text(l::Label) -> String

Return the text content of the `Label`.
"""
get_text(l::Label)         = _cxx_string(_Raw.get_text(_unwrap(l)))

"""
    get_layer(l::Label) -> UInt32

Return the GDSII layer of the `Label`.
"""
get_layer(l::Label)        = _Raw.get_layer(_unwrap(l))

"""
    get_texttype(l::Label) -> UInt32

Return the GDSII texttype (datatype) of the `Label`.
"""
get_texttype(l::Label)     = _Raw.get_texttype(_unwrap(l))

"""
    get_originx(l::Label) -> Float64

Return the x-coordinate of the `Label`'s origin.
"""
get_originx(l::Label)      = _Raw.get_originx(_unwrap(l))

"""
    get_originy(l::Label) -> Float64

Return the y-coordinate of the `Label`'s origin.
"""
get_originy(l::Label)      = _Raw.get_originy(_unwrap(l))

"""
    get_rotation(l::Label) -> Float64

Return the rotation of the `Label` in radians.
"""
get_rotation(l::Label)     = _Raw.get_rotation(_unwrap(l))

"""
    get_magnification(l::Label) -> Float64

Return the magnification factor of the `Label`.
"""
get_magnification(l::Label)= _Raw.get_magnification(_unwrap(l))

"""
    get_x_reflection(l::Label) -> Bool

Return `true` if the `Label` is reflected across the x-axis.
"""
get_x_reflection(l::Label) = _Raw.get_x_reflection(_unwrap(l))

"""
    get_anchor(l::Label) -> UInt8

Return the anchor position code of the `Label` (e.g., North-West, Center, etc.).
"""
get_anchor(l::Label)       = _Raw.get_anchor(_unwrap(l))

# --- Reference Methods ---

"""
    is_cell_ref(r::Reference) -> Bool

Return `true` if the `Reference` points to a `Cell` object, `false` if it is a name-only reference.
"""
is_cell_ref(r::Reference)      = _Raw.is_cell_ref(_unwrap(r))

"""
    get_name(r::Reference) -> String

Return the name of the cell being referenced.
"""
get_name(r::Reference)         = _cxx_string(_Raw.get_name(_unwrap(r)))

"""
    get_originx(r::Reference) -> Float64

Return the x-coordinate of the `Reference`'s origin.
"""
get_originx(r::Reference)      = _Raw.get_originx(_unwrap(r))

"""
    get_originy(r::Reference) -> Float64

Return the y-coordinate of the `Reference`'s origin.
"""
get_originy(r::Reference)      = _Raw.get_originy(_unwrap(r))

"""
    get_rotation(r::Reference) -> Float64

Return the rotation of the `Reference` in radians.
"""
get_rotation(r::Reference)     = _Raw.get_rotation(_unwrap(r))

"""
    get_magnification(r::Reference) -> Float64

Return the magnification factor of the `Reference`.
"""
get_magnification(r::Reference)= _Raw.get_magnification(_unwrap(r))

"""
    get_x_reflection(r::Reference) -> Bool

Return `true` if the `Reference` is reflected across the x-axis.
"""
get_x_reflection(r::Reference) = _Raw.get_x_reflection(_unwrap(r))

"""
    get_cell(r::Reference) -> Union{Cell, Nothing}

Return the `Cell` object referenced, or `nothing` if it's a name-only reference or the cell is unavailable.
"""
function get_cell(r::Reference)
    try
        raw = _Raw.get_cell(_unwrap(r))
        return Cell(raw)
    catch
        return nothing
    end
end

"""
    get_polygons(r::Reference, apply_repetitions, layer, datatype) -> Vector{Polygon}

Return a list of polygons from the referenced cell, filtered by layer and datatype.
"""
get_polygons(r::Reference, apply_repetitions::Bool, layer::Integer, datatype::Integer) =
    _wrap_array(Polygon, _Raw.get_polygons(_unwrap(r), apply_repetitions,
                                           UInt32(layer), UInt32(datatype)))

# --- FlexPath Methods ---

"""
    translate!(fp::FlexPath, dx, dy)

Translate the `FlexPath` by `dx` and `dy` in-place.
"""
translate!(fp::FlexPath, dx::Real, dy::Real) =
    _Raw.translate!(_unwrap(fp), Float64(dx), Float64(dy))

"""
    rotate!(fp::FlexPath, angle, cx, cy)

Rotate the `FlexPath` by `angle` around (cx, cy) in-place.
"""
rotate!(fp::FlexPath, angle::Real, cx::Real, cy::Real) =
    _Raw.rotate!(_unwrap(fp), Float64(angle), Float64(cx), Float64(cy))

"""
    scale!(fp::FlexPath, s, cx, cy)

Scale the `FlexPath` by factor `s` relative to (cx, cy) in-place.
"""
scale!(fp::FlexPath, s::Real, cx::Real, cy::Real) =
    _Raw.scale!(_unwrap(fp), Float64(s), Float64(cx), Float64(cy))

"""
    mirror!(fp::FlexPath, ax, ay, bx, by)

Mirror the `FlexPath` across the line (ax, ay)-(bx, by) in-place.
"""
mirror!(fp::FlexPath, ax::Real, ay::Real, bx::Real, by::Real) =
    _Raw.mirror!(_unwrap(fp), Float64(ax), Float64(ay), Float64(bx), Float64(by))

"""
    segment!(fp::FlexPath, ex, ey, relative)

Add a straight segment to the `FlexPath` ending at (ex, ey) in-place.
"""
segment!(fp::FlexPath, ex::Real, ey::Real, relative::Bool) =
    _Raw.segment!(_unwrap(fp), Float64(ex), Float64(ey), relative)

"""
    arc!(fp::FlexPath, rx, ry, a0, a1, rotation)

Add an elliptical arc to the `FlexPath` in-place.
"""
arc!(fp::FlexPath, rx::Real, ry::Real, a0::Real, a1::Real, rotation::Real) =
    _Raw.arc!(_unwrap(fp), Float64(rx), Float64(ry), Float64(a0), Float64(a1), Float64(rotation))

"""
    turn!(fp::FlexPath, radius, angle)

Add a turn (circular arc segment) to the `FlexPath` in-place.
"""
turn!(fp::FlexPath, radius::Real, angle::Real) =
    _Raw.turn!(_unwrap(fp), Float64(radius), Float64(angle))

"""
    horizontal!(fp::FlexPath, x, relative)

Add a horizontal segment to the `FlexPath` in-place.
"""
horizontal!(fp::FlexPath, x::Real, relative::Bool) =
    _Raw.horizontal!(_unwrap(fp), Float64(x), relative)

"""
    vertical!(fp::FlexPath, y, relative)

Add a vertical segment to the `FlexPath` in-place.
"""
vertical!(fp::FlexPath, y::Real, relative::Bool) =
    _Raw.vertical!(_unwrap(fp), Float64(y), relative)

"""
    num_elements(fp::FlexPath) -> UInt64

Return the number of path segments (elements) in the `FlexPath`.
"""
num_elements(fp::FlexPath) = _Raw.num_elements(_unwrap(fp))

"""
    to_polygons(fp::FlexPath) -> Vector{Polygon}

Generate and return a list of `Polygon` objects representing the `FlexPath`.
"""
to_polygons(fp::FlexPath)  = _wrap_array(Polygon, _Raw.to_polygons(_unwrap(fp)))

# --- RobustPath Methods ---

"""
    translate!(rp::RobustPath, dx, dy)

Translate the `RobustPath` by `dx` and `dy` in-place.
"""
translate!(rp::RobustPath, dx::Real, dy::Real) =
    _Raw.translate!(_unwrap(rp), Float64(dx), Float64(dy))

"""
    rotate!(rp::RobustPath, angle, cx, cy)

Rotate the `RobustPath` by `angle` around (cx, cy) in-place.
"""
rotate!(rp::RobustPath, angle::Real, cx::Real, cy::Real) =
    _Raw.rotate!(_unwrap(rp), Float64(angle), Float64(cx), Float64(cy))

"""
    segment!(rp::RobustPath, ex, ey, relative)

Add a straight segment to the `RobustPath` in-place.
"""
segment!(rp::RobustPath, ex::Real, ey::Real, relative::Bool) =
    _Raw.segment!(_unwrap(rp), Float64(ex), Float64(ey), relative)

"""
    arc!(rp::RobustPath, rx, ry, a0, a1, rotation)

Add an arc to the `RobustPath` in-place.
"""
arc!(rp::RobustPath, rx::Real, ry::Real, a0::Real, a1::Real, rotation::Real) =
    _Raw.arc!(_unwrap(rp), Float64(rx), Float64(ry), Float64(a0), Float64(a1), Float64(rotation))

"""
    turn!(rp::RobustPath, radius, angle)

Add a turn to the `RobustPath` in-place.
"""
turn!(rp::RobustPath, radius::Real, angle::Real) =
    _Raw.turn!(_unwrap(rp), Float64(radius), Float64(angle))

"""
    get_end_pointx(rp::RobustPath) -> Float64

Return the x-coordinate of the `RobustPath`'s current end point.
"""
get_end_pointx(rp::RobustPath) = _Raw.get_end_pointx(_unwrap(rp))

"""
    get_end_pointy(rp::RobustPath) -> Float64

Return the y-coordinate of the `RobustPath`'s current end point.
"""
get_end_pointy(rp::RobustPath) = _Raw.get_end_pointy(_unwrap(rp))

"""
    num_elements(rp::RobustPath) -> UInt64

Return the number of path segments in the `RobustPath`.
"""
num_elements(rp::RobustPath) = _Raw.num_elements(_unwrap(rp))

"""
    to_polygons(rp::RobustPath) -> Vector{Polygon}

Generate and return a list of `Polygon` objects representing the `RobustPath`.
"""
to_polygons(rp::RobustPath)  = _wrap_array(Polygon, _Raw.to_polygons(_unwrap(rp)))

# --- Cell Methods ---

"""
    get_name(c::Cell) -> String

Return the name of the `Cell`.
"""
get_name(c::Cell)         = _cxx_string(_Raw.get_name(_unwrap(c)))

"""
    polygon_count(c::Cell) -> UInt64

Return the number of top-level polygons in the `Cell`.
"""
polygon_count(c::Cell)    = _Raw.polygon_count(_unwrap(c))

"""
    label_count(c::Cell) -> UInt64

Return the number of top-level labels in the `Cell`.
"""
label_count(c::Cell)      = _Raw.label_count(_unwrap(c))

"""
    reference_count(c::Cell) -> UInt64

Return the number of references in the `Cell`.
"""
reference_count(c::Cell)  = _Raw.reference_count(_unwrap(c))

"""
    bbox_raw(c::Cell) -> Vector{Float64}

Return the raw bounding box of the `Cell` as `[min_x, min_y, max_x, max_y]`.
"""
bbox_raw(c::Cell)         = _Raw.bbox_raw(_unwrap(c))

"""
    flatten!(c::Cell, apply_repetitions)

Flatten the hierarchy of the `Cell` in-place.
"""
flatten!(c::Cell, apply_repetitions::Bool) =
    _Raw.flatten!(_unwrap(c), apply_repetitions)

"""
    write_svg(c::Cell, filename, scaling)

Export the `Cell` geometry to an SVG file.
"""
write_svg(c::Cell, filename::AbstractString, scaling::Real) =
    _Raw.write_svg(_unwrap(c), String(filename), Float64(scaling))

"""
    add_polygon!(c::Cell, p::Polygon)

Add a `Polygon` to the `Cell` in-place.
"""
add_polygon!(c::Cell, p::Polygon) =
    _Raw.add_polygon!(_unwrap(c), _unwrap_ptr(p))

"""
    add_label!(c::Cell, l::Label)

Add a `Label` to the `Cell` in-place.
"""
add_label!(c::Cell, l::Label) =
    _Raw.add_label!(_unwrap(c), _unwrap_ptr(l))

"""
    add_reference!(c::Cell, r::Reference)

Add a `Reference` to the `Cell` in-place.
"""
add_reference!(c::Cell, r::Reference) =
    _Raw.add_reference!(_unwrap(c), _unwrap_ptr(r))

"""
    add_flexpath!(c::Cell, fp::FlexPath)

Add a `FlexPath` to the `Cell` in-place.
"""
add_flexpath!(c::Cell, fp::FlexPath) =
    _Raw.add_flexpath!(_unwrap(c), _unwrap_ptr(fp))

"""
    add_robustpath!(c::Cell, rp::RobustPath)

Add a `RobustPath` to the `Cell` in-place.
"""
add_robustpath!(c::Cell, rp::RobustPath) =
    _Raw.add_robustpath!(_unwrap(c), _unwrap_ptr(rp))

"""
    get_polygons(c::Cell, apply_repetitions, layer, datatype) -> Vector{Polygon}

Return a list of polygons from the `Cell`, optionally including those from references (if flattened) and filtered by layer/datatype.
"""
get_polygons(c::Cell, apply_repetitions::Bool, layer::Integer, datatype::Integer) =
    _wrap_array(Polygon, _Raw.get_polygons(_unwrap(c), apply_repetitions,
                                           UInt32(layer), UInt32(datatype)))

"""
    get_all_polygons(c::Cell, apply_repetitions) -> Vector{Polygon}

Return all polygons in the `Cell` including those from all layers and datatypes.
"""
get_all_polygons(c::Cell, apply_repetitions::Bool) =
    _wrap_array(Polygon, _Raw.get_all_polygons(_unwrap(c), apply_repetitions))

"""
    get_labels(c::Cell, apply_repetitions) -> Vector{Label}

Return a list of all labels in the `Cell`.
"""
get_labels(c::Cell, apply_repetitions::Bool) =
    _wrap_array(Label, _Raw.get_labels(_unwrap(c), apply_repetitions))

"""
    get_references(c::Cell) -> Vector{Reference}

Return a list of all references in the `Cell`.
"""
get_references(c::Cell) =
    _wrap_array(Reference, _Raw.get_references(_unwrap(c)))

# --- Library Methods ---

"""
    get_name(l::Library) -> String

Return the name of the `Library`.
"""
get_name(l::Library)     = _cxx_string(_Raw.get_name(_unwrap(l)))

"""
    get_unit(l::Library) -> Float64

Return the physical unit (in meters) defined in the `Library`.
"""
get_unit(l::Library)     = _Raw.get_unit(_unwrap(l))

"""
    get_precision(l::Library) -> Float64

Return the precision (in meters) defined in the `Library`.
"""
get_precision(l::Library)= _Raw.get_precision(_unwrap(l))

"""
    cell_count(l::Library) -> UInt64

Return the number of cells contained in the `Library`.
"""
cell_count(l::Library)   = _Raw.cell_count(_unwrap(l))

"""
    get_cell(l::Library, name::AbstractString) -> Union{Cell, Nothing}

Find and return a `Cell` by its name from the `Library`, or `nothing` if not found.
"""
function get_cell(l::Library, name::AbstractString)
    try
        raw = _Raw.get_cell(_unwrap(l), String(name))
        return Cell(raw)
    catch
        return nothing
    end
end

"""
    get_cell_by_index(l::Library, i::Integer) -> Union{Cell, Nothing}

Return a `Cell` from the `Library` at the specified index.
"""
function get_cell_by_index(l::Library, i::Integer)
    try
        raw = _Raw.get_cell_by_index(_unwrap(l), UInt64(i))
        return Cell(raw)
    catch
        return nothing
    end
end

"""
    top_level_cells(l::Library) -> Vector{Cell}

Return a list of cells in the `Library` that are not referenced by any other cell.
"""
top_level_cells(l::Library) =
    _wrap_array(Cell, _Raw.top_level_cells(_unwrap(l)))

"""
    add_cell!(l::Library, c::Cell)

Add a `Cell` to the `Library` in-place.
"""
add_cell!(l::Library, c::Cell) =
    _Raw.add_cell!(_unwrap(l), _unwrap_ptr(c))

"""
    write_gds(l::Library, filename, max_points)

Write the `Library` content to a GDSII file. `max_points` specifies the limit for polygon vertices.
"""
write_gds(l::Library, filename::AbstractString, max_points::Integer) =
    _Raw.write_gds(_unwrap(l), String(filename), UInt64(max_points))

"""
    write_oas(l::Library, filename, circle_tolerance, deflate_level)

Write the `Library` content to an OASIS file.
"""
write_oas(l::Library, filename::AbstractString, circle_tolerance::Real, deflate_level::Integer) =
    _Raw.write_oas(_unwrap(l), String(filename), Float64(circle_tolerance), UInt8(deflate_level))

# --- Boolean and Clipper Operations ---

"""
    gds_boolean(a::Vector{Polygon}, b::Vector{Polygon}, op::Integer, scaling::Real) -> Vector{Polygon}

Perform a Boolean operation (AND, OR, XOR, NOT) between two sets of polygons. `scaling` defines integer grid coordinate precision.
"""
function gds_boolean(a::Vector{Polygon}, b::Vector{Polygon}, op::Integer, scaling::Real)
    a_ptrs = _unwrap_polygon_array(a)
    b_ptrs = _unwrap_polygon_array(b)
    raw = _Raw.gds_boolean(a_ptrs, b_ptrs, Int(op), Float64(scaling))
    return _wrap_array(Polygon, raw)
end

"""
    gds_offset(polys::Vector{Polygon}, distance, join_type, tolerance, scaling, use_union) -> Vector{Polygon}

Inflate or deflate a set of polygons by a specified distance.
"""
function gds_offset(polys::Vector{Polygon}, distance::Real, join_type,
                    tolerance::Real, scaling::Real, use_union::Bool)
    ptrs = _unwrap_polygon_array(polys)
    raw = _Raw.gds_offset(ptrs, Float64(distance), Int(join_type),
                          Float64(tolerance), Float64(scaling), use_union)
    return _wrap_array(Polygon, raw)
end

"""
    gds_merge(polys::Vector{Polygon}, scaling) -> Vector{Polygon}

Merge (union) all overlapping polygons in the input list.
"""
function gds_merge(polys::Vector{Polygon}, scaling::Real)
    ptrs = _unwrap_polygon_array(polys)
    raw = _Raw.gds_merge(ptrs, Float64(scaling))
    return _wrap_array(Polygon, raw)
end

"""
    gds_slice(p::Polygon, positions, x_axis, scaling) -> Vector{Polygon}

Slice a `Polygon` into multiple parts along the specified positions on either the x or y axis.
"""
function gds_slice(p::Polygon, positions::AbstractVector{<:Real},
                   x_axis::Bool, scaling::Real)
    pos = convert(Vector{Float64}, collect(positions))
    raw = _Raw.gds_slice(_unwrap(p), pos, x_axis, Float64(scaling))
    return _wrap_array(Polygon, raw)
end

"""
    gds_slice_counts() -> Vector{UInt64}

Return the count of polygons generated in each slice bin from the last `gds_slice` call.
"""
gds_slice_counts() = collect(_Raw.gds_slice_counts())

# --- Re-exports ---

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

# --- Julia-side Helper Wrappers ---

"""
    get_points(poly::Polygon) -> Matrix{Float64}

Return the polygon vertices as an `(N × 2)` matrix where each row is `[x, y]`.
"""
function get_points(poly::Polygon)
    flat = get_points_flat(poly)
    n = length(flat) ÷ 2
    return reshape(collect(flat), 2, n)'
end
export get_points

"""
    bounding_box(obj) -> (min = (minx, miny), max = (maxx, maxy))

Compute the axis-aligned bounding box of a `Polygon` or `Cell`.
Returns a `NamedTuple` with fields `min` and `max`, each a `(x, y)` tuple.

> **Note**: Uses a module-level static buffer internally. Do not call from
> multiple threads simultaneously.
"""
function bounding_box(obj)
    raw = bbox_raw(obj)
    return (min = (raw[1], raw[2]), max = (raw[3], raw[4]))
end
export bounding_box

"""
    gds_units(filename) -> (unit, precision)

Read the unit and precision from a GDSII file header.
Returns a `NamedTuple` `(unit = ..., precision = ...)`.
"""
function gds_units(filename::AbstractString)
    u = gds_units_unit(filename)
    p = gds_units_precision(filename)
    return (unit = u, precision = p)
end
export gds_units

"""
    union_polygons(a, b; scaling=1e4) -> Array{Polygon}

Perform a Boolean OR (union) of two polygon arrays. `scaling` controls the integer grid precision.
"""
union_polygons(a, b; scaling::Real=1e4) =
    gds_boolean(a, b, OPERATION_OR(), Float64(scaling))

"""
    intersect_polygons(a, b; scaling=1e4) -> Array{Polygon}

Perform a Boolean AND (intersection) of two polygon arrays.
"""
intersect_polygons(a, b; scaling::Real=1e4) =
    gds_boolean(a, b, OPERATION_AND(), Float64(scaling))

"""
    subtract_polygons(a, b; scaling=1e4) -> Array{Polygon}

Perform a Boolean subtraction (a - b) of two polygon arrays.
"""
subtract_polygons(a, b; scaling::Real=1e4) =
    gds_boolean(a, b, OPERATION_NOT(), Float64(scaling))

"""
    xor_polygons(a, b; scaling=1e4) -> Array{Polygon}

Perform a Boolean XOR of two polygon arrays.
"""
xor_polygons(a, b; scaling::Real=1e4) =
    gds_boolean(a, b, OPERATION_XOR(), Float64(scaling))

export union_polygons, intersect_polygons, subtract_polygons, xor_polygons

"""
    slice_polygon(poly, positions; x_axis=true, scaling=1e4) -> Vector{Vector{Polygon}}

Slice `poly` at each coordinate in `positions` (must be sorted).
Returns a vector of `N+1` polygon arrays, one per bin.
Bin `1` is below the first cut; bin `N+1` is above the last cut.

> **Note**: Uses a static buffer internally. Do not call from multiple threads simultaneously.
"""
function slice_polygon(poly::Polygon, positions::AbstractVector{<:Real};
                       x_axis::Bool=true, scaling::Real=1e4)
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
export slice_polygon

end # module Gdstk
