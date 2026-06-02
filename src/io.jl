read_gds(filename::AbstractString) = Library(_Raw.read_gds(String(filename)))
read_oas(filename::AbstractString) = Library(_Raw.read_oas(String(filename)))

gds_units_unit(filename::AbstractString)      = _Raw.gds_units_unit(String(filename))
gds_units_precision(filename::AbstractString) = _Raw.gds_units_precision(String(filename))

hello_gds() = _cxx_string(_Raw.hello_gds())
