"""
    new_cell(name::AbstractString)

Creates a new GDSII/OASIS `Cell` with the specified `name`.

# Examples
```julia
using Gdstk
cell = new_cell("Main")
```
"""
new_cell(name::AbstractString) = Cell(_Raw.new_cell(String(name)))

"""
    new_library(name::AbstractString, unit::Real, precision::Real)

Creates a new `Library` with the specified `name`, database `unit`, and `precision`.

# Examples
```julia
using Gdstk
lib = new_library("MyLibrary", 1e-6, 1e-9)
```
"""
new_library(name::AbstractString, unit::Real, precision::Real) = Library(_Raw.new_library(String(name), Float64(unit), Float64(precision)))

"""
    get_name(c::Cell)

Returns the name of a `Cell`.
"""
get_name(c::Cell)         = _cxx_string(_Raw.get_name(_unwrap(c)))

"""
    polygon_count(c::Cell)

Returns the number of polygons added directly to the cell.
"""
polygon_count(c::Cell)    = _Raw.polygon_count(_unwrap(c))

"""
    label_count(c::Cell)

Returns the number of labels added directly to the cell.
"""
label_count(c::Cell)      = _Raw.label_count(_unwrap(c))

"""
    reference_count(c::Cell)

Returns the number of cell references added directly to the cell.
"""
reference_count(c::Cell)  = _Raw.reference_count(_unwrap(c))

"""
    bbox_raw(c::Cell)

Returns the raw bounding box of the cell.
"""
bbox_raw(c::Cell)         = _Raw.bbox_raw(_unwrap(c))

"""
    flatten!(c::Cell, apply_repetitions::Bool)

Flattens the cell by essentially removing the hierarchy and replacing references with polygons and labels.
"""
flatten!(c::Cell, apply_repetitions::Bool) = _Raw.flatten!(_unwrap(c), apply_repetitions)

"""
    write_svg(c::Cell, filename::AbstractString, scaling::Real)

Writes the cell layout to an SVG file scaled by a given factor.
"""
write_svg(c::Cell, filename::AbstractString, scaling::Real) = _Raw.write_svg(_unwrap(c), String(filename), Float64(scaling))

"""
    add_polygon!(c::Cell, p::Polygon)

Adds a `Polygon` to the `Cell`.

# Examples
```julia
using Gdstk
rect = rectangle(0, 0, 10, 10, 1, 0)
add_polygon!(cell, rect)
```
"""
add_polygon!(c::Cell, p::Polygon)     = _Raw.add_polygon!(_unwrap(c), _unwrap_ptr(p))

"""
    add_label!(c::Cell, l::Label)

Adds a `Label` to the `Cell`.
"""
add_label!(c::Cell, l::Label)         = _Raw.add_label!(_unwrap(c), _unwrap_ptr(l))

"""
    add_reference!(c::Cell, r::Reference)

Adds a `Reference` (a cell instance) to the `Cell`.
"""
add_reference!(c::Cell, r::Reference) = _Raw.add_reference!(_unwrap(c), _unwrap_ptr(r))

"""
    add_flexpath!(c::Cell, fp::FlexPath)

Adds a `FlexPath` to the `Cell`.
"""
add_flexpath!(c::Cell, fp::FlexPath)   = _Raw.add_flexpath!(_unwrap(c), _unwrap_ptr(fp))

"""
    add_robustpath!(c::Cell, rp::RobustPath)

Adds a `RobustPath` to the `Cell`.
"""
add_robustpath!(c::Cell, rp::RobustPath) = _Raw.add_robustpath!(_unwrap(c), _unwrap_ptr(rp))

"""
    get_polygons(c::Cell, apply_repetitions::Bool, layer::Integer, datatype::Integer)

Returns an array of polygons on a specific `layer` and `datatype`.
"""
get_polygons(c::Cell, apply_repetitions::Bool, layer::Integer, datatype::Integer) =
    _wrap_array(Polygon, _Raw.get_polygons(_unwrap(c), apply_repetitions, UInt32(layer), UInt32(datatype)))

"""
    get_all_polygons(c::Cell, apply_repetitions::Bool)

Returns an array of all polygons within the cell.
"""
get_all_polygons(c::Cell, apply_repetitions::Bool) = _wrap_array(Polygon, _Raw.get_all_polygons(_unwrap(c), apply_repetitions))

"""
    get_labels(c::Cell, apply_repetitions::Bool)

Returns all labels present within the cell.
"""
get_labels(c::Cell, apply_repetitions::Bool)       = _wrap_array(Label, _Raw.get_labels(_unwrap(c), apply_repetitions))

"""
    get_references(c::Cell)

Returns all references (instances) present within the cell.
"""
get_references(c::Cell)                            = _wrap_array(Reference, _Raw.get_references(_unwrap(c)))

"""
    get_name(l::Library)

Returns the name of a given `Library`.
"""
get_name(l::Library)     = _cxx_string(_Raw.get_name(_unwrap(l)))

"""
    get_unit(l::Library)

Returns the database unit of a `Library`.
"""
get_unit(l::Library)     = _Raw.get_unit(_unwrap(l))

"""
    get_precision(l::Library)

Returns the coordinate precision of a `Library`.
"""
get_precision(l::Library)= _Raw.get_precision(_unwrap(l))

"""
    cell_count(l::Library)

Returns the number of cells within a `Library`.
"""
cell_count(l::Library)   = _Raw.cell_count(_unwrap(l))

"""
    get_cell(l::Library, name::AbstractString)

Retrieves a cell from the library by its `name`. Return `nothing` if not found.
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
    get_cell_by_index(l::Library, i::Integer)

Retrieves a cell from the library by its index `i`. Returns `nothing` if not found.
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
    top_level_cells(l::Library)

Returns an array of top-level cells in the library, which are cells not referenced by any other cells in the library.
"""
top_level_cells(l::Library) = _wrap_array(Cell, _Raw.top_level_cells(_unwrap(l)))

"""
    add_cell!(l::Library, c::Cell)

Adds a given `Cell` to a `Library`.

# Examples
```julia
using Gdstk
lib = new_library("MyLibrary", 1e-6, 1e-9)
cell = new_cell("Main")
add_cell!(lib, cell)
```
"""
add_cell!(l::Library, c::Cell) = _Raw.add_cell!(_unwrap(l), _unwrap_ptr(c))

"""
    write_gds(l::Library, filename::AbstractString, max_points::Integer)

Writes the library to a GDSII file. `max_points` provides the limit for fracture points.

# Examples
```julia
using Gdstk
write_gds(lib, "output.gds", 0)
```
"""
write_gds(l::Library, filename::AbstractString, max_points::Integer) =
    _Raw.write_gds(_unwrap(l), String(filename), UInt64(max_points))

"""
    write_oas(l::Library, filename::AbstractString, circle_tolerance::Real, deflate_level::Integer)

Writes the library to an OASIS file with specific tolerance and deflation level.
"""
write_oas(l::Library, filename::AbstractString, circle_tolerance::Real, deflate_level::Integer) =
    _Raw.write_oas(_unwrap(l), String(filename), Float64(circle_tolerance), UInt8(deflate_level))
