struct Vec2 ptr::Any end
struct Polygon ptr::Any end
struct Label ptr::Any end
struct Reference ptr::Any end
struct FlexPath ptr::Any end
struct RobustPath ptr::Any end
struct Cell ptr::Any end
struct Library ptr::Any end

_deref(x::CxxPtr) = x[]
_deref(x) = x
_to_ptr(x::CxxPtr) = x
_to_ptr(x) = CxxPtr(x)
_cxx_string(p) = unsafe_string(reinterpret(Ptr{UInt8}, p))

_unwrap(v::Vec2)        = _deref(v.ptr)
_unwrap(p::Polygon)     = _deref(p.ptr)
_unwrap(l::Label)       = _deref(l.ptr)
_unwrap(r::Reference)   = _deref(r.ptr)
_unwrap(fp::FlexPath)   = _deref(fp.ptr)
_unwrap(rp::RobustPath) = _deref(rp.ptr)
_unwrap(c::Cell)        = _deref(c.ptr)
_unwrap(l::Library)     = _deref(l.ptr)

_unwrap_ptr(p::Polygon)     = _to_ptr(p.ptr)
_unwrap_ptr(l::Label)       = _to_ptr(l.ptr)
_unwrap_ptr(r::Reference)   = _to_ptr(r.ptr)
_unwrap_ptr(fp::FlexPath)   = _to_ptr(fp.ptr)
_unwrap_ptr(rp::RobustPath) = _to_ptr(rp.ptr)
_unwrap_ptr(c::Cell)        = _to_ptr(c.ptr)

_wrap_array(::Type{Polygon}, raw)   = [Polygon(CxxPtr{_Raw.Polygon}(p)) for p in raw]
_wrap_array(::Type{Cell}, raw)      = [Cell(CxxPtr{_Raw.Cell}(p)) for p in raw]
_wrap_array(::Type{Label}, raw)     = [Label(CxxPtr{_Raw.Label}(p)) for p in raw]
_wrap_array(::Type{Reference}, raw) = [Reference(CxxPtr{_Raw.Reference}(p)) for p in raw]

_unwrap_polygon_array(arr) = Ptr{_Raw.Polygon}[p.ptr.cpp_object for p in arr]
_unwrap_cell_array(arr)    = Ptr{_Raw.Cell}[c.ptr.cpp_object for c in arr]
