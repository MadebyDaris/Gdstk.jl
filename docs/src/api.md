# API Reference

## Types

```@docs
Gdstk.Polygon
Gdstk.Cell
Gdstk.Library
Gdstk.Reference
Gdstk.Label
Gdstk.FlexPath
Gdstk.RobustPath
Gdstk.Vec2
```

## Factory Functions

### Geometry
```@docs
Gdstk.rectangle
Gdstk.cross_shape
Gdstk.regular_polygon
Gdstk.ellipse
Gdstk.racetrack
```

### Layout
```@docs
Gdstk.new_cell
Gdstk.new_library
Gdstk.make_vec2
Gdstk.make_tag
```

### Paths
```@docs
Gdstk.make_flexpath
Gdstk.make_robustpath
```

## Transformation Methods

```@docs
Gdstk.translate!
Gdstk.scale!
Gdstk.rotate!
Gdstk.mirror!
Gdstk.fillet!
Gdstk.flatten!
```

## Geometry Analysis

```@docs
Gdstk.area
Gdstk.signed_area
Gdstk.perimeter
Gdstk.num_points
Gdstk.get_points
Gdstk.bounding_box
```

## Boolean & Clipper Operations

```@docs
Gdstk.union_polygons
Gdstk.intersect_polygons
Gdstk.subtract_polygons
Gdstk.xor_polygons
Gdstk.gds_offset
Gdstk.gds_merge
Gdstk.slice_polygon
```

## I/O Functions

```@docs
Gdstk.read_gds
Gdstk.read_oas
Gdstk.write_gds
Gdstk.write_oas
Gdstk.write_svg
Gdstk.gds_units
```

## Other Functions

```@autodocs
Modules = [Gdstk]
```
