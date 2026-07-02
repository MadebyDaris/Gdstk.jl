"""
    read_gds(filename::AbstractString)

Reads a GDSII file and returns a `Library` object.
"""
read_gds(filename::AbstractString) = Library(C.read_gds(String(filename)))

"""
    read_oas(filename::AbstractString)

Reads an OASIS file and returns a `Library` object.
"""
read_oas(filename::AbstractString) = Library(C.read_oas(String(filename)))

"""
    gds_units_unit(filename::AbstractString)

Returns the database unit from a GDSII file.
"""
gds_units_unit(filename::AbstractString)      = C.gds_units_unit(String(filename))

"""
    gds_units_precision(filename::AbstractString)

Returns the coordinate precision from a GDSII file.
"""
gds_units_precision(filename::AbstractString) = C.gds_units_precision(String(filename))

"""
    hello_gds()

Returns a simple testing string from the underlying C++ library.
"""
hello_gds() = _cxx_string(C.hello_gds())
