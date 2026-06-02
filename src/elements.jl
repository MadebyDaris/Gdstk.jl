# --- Factory ---
make_tag(layer, datatype) = _Raw.make_tag(UInt32(layer), UInt32(datatype))
get_layer(tag::UInt64)    = _Raw.get_layer(tag)
get_type(tag::UInt64)     = _Raw.get_type(tag)

make_vec2(x::Real, y::Real) = Vec2(_Raw.make_vec2(Float64(x), Float64(y)))

rectangle(x0::Real, y0::Real, x1::Real, y1::Real, layer, datatype) =
    Polygon(_Raw.rectangle(Float64(x0), Float64(y0), Float64(x1), Float64(y1), UInt32(layer), UInt32(datatype)))

cross_shape(cx::Real, cy::Real, full_size::Real, arm_width::Real, layer, datatype) =
    Polygon(_Raw.cross_shape(Float64(cx), Float64(cy), Float64(full_size), Float64(arm_width), UInt32(layer), UInt32(datatype)))

regular_polygon(cx::Real, cy::Real, side_length::Real, sides::Integer, rotation::Real, layer, datatype) =
    Polygon(_Raw.regular_polygon(Float64(cx), Float64(cy), Float64(side_length), UInt64(sides), Float64(rotation), UInt32(layer), UInt32(datatype)))

ellipse(cx::Real, cy::Real, rx::Real, ry::Real, irx::Real, iry::Real, a0::Real, a1::Real, tol::Real, layer, datatype) =
    Polygon(_Raw.ellipse(Float64(cx), Float64(cy), Float64(rx), Float64(ry), Float64(irx), Float64(iry), Float64(a0), Float64(a1), Float64(tol), UInt32(layer), UInt32(datatype)))

racetrack(cx::Real, cy::Real, straight_length::Real, radius::Real, inner_radius::Real, vertical::Bool, tol::Real, layer, datatype) =
    Polygon(_Raw.racetrack(Float64(cx), Float64(cy), Float64(straight_length), Float64(radius), Float64(inner_radius), vertical, Float64(tol), UInt32(layer), UInt32(datatype)))

make_flexpath(x::Real, y::Real, width::Real, tolerance::Real, layer, datatype) =
    FlexPath(_Raw.make_flexpath(Float64(x), Float64(y), Float64(width), Float64(tolerance), UInt32(layer), UInt32(datatype)))

make_robustpath(x::Real, y::Real, width::Real, tolerance::Real, max_evals::Integer, layer, datatype) =
    RobustPath(_Raw.make_robustpath(Float64(x), Float64(y), Float64(width), Float64(tolerance), UInt64(max_evals), UInt32(layer), UInt32(datatype)))

# --- Vec2 ---
getx(v::Vec2)    = _Raw.getx(_unwrap(v))
gety(v::Vec2)    = _Raw.gety(_unwrap(v))
setx(v::Vec2, x::Real) = _Raw.setx(_unwrap(v), Float64(x))
sety(v::Vec2, y::Real) = _Raw.sety(_unwrap(v), Float64(y))
vlength(v::Vec2) = _Raw.vlength(_unwrap(v))
vinner(a::Vec2, b::Vec2) = _Raw.vinner(_unwrap(a), _unwrap(b))

# --- Polygon ---
area(p::Polygon)            = _Raw.area(_unwrap(p))
signed_area(p::Polygon)     = _Raw.signed_area(_unwrap(p))
perimeter(p::Polygon)       = _Raw.perimeter(_unwrap(p))
num_points(p::Polygon)      = _Raw.num_points(_unwrap(p))
get_points_flat(p::Polygon) = _Raw.get_points_flat(_unwrap(p))
get_datatype(p::Polygon)    = _Raw.get_datatype(_unwrap(p))
get_layer(p::Polygon)       = _Raw.get_layer(_unwrap(p))
bbox_raw(p::Polygon)        = _Raw.bbox_raw(_unwrap(p))

translate!(p::Polygon, dx::Real, dy::Real) = _Raw.translate!(_unwrap(p), Float64(dx), Float64(dy))
scale!(p::Polygon, sx::Real, sy::Real, cx::Real, cy::Real) = _Raw.scale!(_unwrap(p), Float64(sx), Float64(sy), Float64(cx), Float64(cy))
mirror!(p::Polygon, ax::Real, ay::Real, bx::Real, by::Real) = _Raw.mirror!(_unwrap(p), Float64(ax), Float64(ay), Float64(bx), Float64(by))
rotate!(p::Polygon, angle::Real, cx::Real, cy::Real) = _Raw.rotate!(_unwrap(p), Float64(angle), Float64(cx), Float64(cy))
fillet!(p::Polygon, radius::Real, tolerance::Real) = _Raw.fillet!(_unwrap(p), Float64(radius), Float64(tolerance))
fracture(p::Polygon, max_points::Integer, precision::Real) = _wrap_array(Polygon, _Raw.fracture(_unwrap(p), UInt64(max_points), Float64(precision)))

# --- Label ---
get_text(l::Label)         = _cxx_string(_Raw.get_text(_unwrap(l)))
get_layer(l::Label)        = _Raw.get_layer(_unwrap(l))
get_texttype(l::Label)     = _Raw.get_texttype(_unwrap(l))
get_originx(l::Label)      = _Raw.get_originx(_unwrap(l))
get_originy(l::Label)      = _Raw.get_originy(_unwrap(l))
get_rotation(l::Label)     = _Raw.get_rotation(_unwrap(l))
get_magnification(l::Label)= _Raw.get_magnification(_unwrap(l))
get_x_reflection(l::Label) = _Raw.get_x_reflection(_unwrap(l))
get_anchor(l::Label)       = _Raw.get_anchor(_unwrap(l))

# --- Reference ---
is_cell_ref(r::Reference)      = _Raw.is_cell_ref(_unwrap(r))
get_name(r::Reference)         = _cxx_string(_Raw.get_name(_unwrap(r)))
get_originx(r::Reference)      = _Raw.get_originx(_unwrap(r))
get_originy(r::Reference)      = _Raw.get_originy(_unwrap(r))
get_rotation(r::Reference)     = _Raw.get_rotation(_unwrap(r))
get_magnification(r::Reference)= _Raw.get_magnification(_unwrap(r))
get_x_reflection(r::Reference) = _Raw.get_x_reflection(_unwrap(r))

function get_cell(r::Reference)
    try
        raw = _Raw.get_cell(_unwrap(r))
        return Cell(raw)
    catch
        return nothing
    end
end

get_polygons(r::Reference, apply_repetitions::Bool, layer::Integer, datatype::Integer) =
    _wrap_array(Polygon, _Raw.get_polygons(_unwrap(r), apply_repetitions, UInt32(layer), UInt32(datatype)))

# --- FlexPath ---
translate!(fp::FlexPath, dx::Real, dy::Real) = _Raw.translate!(_unwrap(fp), Float64(dx), Float64(dy))
rotate!(fp::FlexPath, angle::Real, cx::Real, cy::Real) = _Raw.rotate!(_unwrap(fp), Float64(angle), Float64(cx), Float64(cy))
scale!(fp::FlexPath, s::Real, cx::Real, cy::Real) = _Raw.scale!(_unwrap(fp), Float64(s), Float64(cx), Float64(cy))
mirror!(fp::FlexPath, ax::Real, ay::Real, bx::Real, by::Real) = _Raw.mirror!(_unwrap(fp), Float64(ax), Float64(ay), Float64(bx), Float64(by))
segment!(fp::FlexPath, ex::Real, ey::Real, relative::Bool) = _Raw.segment!(_unwrap(fp), Float64(ex), Float64(ey), relative)
arc!(fp::FlexPath, rx::Real, ry::Real, a0::Real, a1::Real, rotation::Real) = _Raw.arc!(_unwrap(fp), Float64(rx), Float64(ry), Float64(a0), Float64(a1), Float64(rotation))
turn!(fp::FlexPath, radius::Real, angle::Real) = _Raw.turn!(_unwrap(fp), Float64(radius), Float64(angle))
horizontal!(fp::FlexPath, x::Real, relative::Bool) = _Raw.horizontal!(_unwrap(fp), Float64(x), relative)
vertical!(fp::FlexPath, y::Real, relative::Bool) = _Raw.vertical!(_unwrap(fp), Float64(y), relative)
num_elements(fp::FlexPath) = _Raw.num_elements(_unwrap(fp))
to_polygons(fp::FlexPath)  = _wrap_array(Polygon, _Raw.to_polygons(_unwrap(fp)))

# --- RobustPath ---
translate!(rp::RobustPath, dx::Real, dy::Real) = _Raw.translate!(_unwrap(rp), Float64(dx), Float64(dy))
rotate!(rp::RobustPath, angle::Real, cx::Real, cy::Real) = _Raw.rotate!(_unwrap(rp), Float64(angle), Float64(cx), Float64(cy))
segment!(rp::RobustPath, ex::Real, ey::Real, relative::Bool) = _Raw.segment!(_unwrap(rp), Float64(ex), Float64(ey), relative)
arc!(rp::RobustPath, rx::Real, ry::Real, a0::Real, a1::Real, rotation::Real) = _Raw.arc!(_unwrap(rp), Float64(rx), Float64(ry), Float64(a0), Float64(a1), Float64(rotation))
turn!(rp::RobustPath, radius::Real, angle::Real) = _Raw.turn!(_unwrap(rp), Float64(radius), Float64(angle))
get_end_pointx(rp::RobustPath) = _Raw.get_end_pointx(_unwrap(rp))
get_end_pointy(rp::RobustPath) = _Raw.get_end_pointy(_unwrap(rp))
num_elements(rp::RobustPath) = _Raw.num_elements(_unwrap(rp))
to_polygons(rp::RobustPath)  = _wrap_array(Polygon, _Raw.to_polygons(_unwrap(rp)))
