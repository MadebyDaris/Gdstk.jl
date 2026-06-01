# Gdstk.jl

`Gdstk.jl` is a high-performance Julia wrapper for the [gdstk](https://github.com/heitzmann/gdstk) C++ library. It provides a fast and efficient way to create, read, and manipulate GDSII and OASIS layout files.

## Features

- **Fast Layout Generation:** Create complex geometries using optimized C++ primitives.
- **Hierarchical Design:** Support for Cells and References to build modular layouts.
- **Boolean Operations:** High-performance polygon clipping and merging via the Clipper library.
- **Flexible Paths:** `FlexPath` and `RobustPath` for advanced routing.
- **GDSII/OASIS Support:** Robust I/O for industry-standard formats.

## Installation

```julia
using Pkg
Pkg.add("Gdstk")
```

## Quick Start

```julia
using Gdstk

# Create a library
lib = new_library("MyLibrary", 1e-6, 1e-9)

# Create a cell
cell = new_cell("Main")
add_cell!(lib, cell)

# Create a rectangle
rect = rectangle(0, 0, 10, 10, 1, 0)
add_polygon!(cell, rect)

# Write to GDS
write_gds(lib, "output.gds", 0)
```

## Table of Contents

```@contents
Pages = ["api.md"]
```
