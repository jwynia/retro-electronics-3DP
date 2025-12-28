# Advanced BOSL2 Patterns

## Purpose

Advanced BOSL2 library patterns for grid distribution, path operations, sweeps, and regions. These patterns enable complex parametric geometry beyond basic primitives.

## Classification
- **Domain:** Parametric Patterns
- **Stability:** Stable
- **Abstraction:** Pattern
- **Confidence:** Established

## Overview

BOSL2 provides powerful functions for working with paths, distributing geometry, and creating complex shapes. These patterns extract best practices from production generators.

---

## Grid Distribution

### grid_copies with Inside Clipping

Distribute shapes within a boundary using `grid_copies()` with the `inside` parameter.

```openscad
// Define boundary shape
inside = Mesh_Offset == 0
    ? _Grille_Shape
    : offset(_Grille_Shape, delta = -Mesh_Offset, closed = true);

// Distribute pattern shapes within boundary
pattern = grid_copies(
    p = zrot(Mesh_Rotate, pattern_shape()),  // Shape to copy (rotated)
    inside = inside,                          // Clip to this boundary
    spacing = spacing,                        // [x, y] spacing
    stagger = _Mesh_Stagger                   // true, false, or "alt"
);

// Use the pattern
linear_extrude(height = depth) {
    region(pattern);
}
```
**Source:** grille-generator.scad:187-204

**Key Points:**
- `inside` clips grid to arbitrary shape boundary
- `stagger = true` offsets alternating rows by half spacing
- `stagger = "alt"` alternates stagger direction
- Returns path list suitable for `region()`

### grid_copies with Stagger and Overlap Control

```openscad
// Calculate pattern size for spacing
pshape = pattern_shape(realign = true);
pshape_size = pointlist_size(pshape);

// Control overlap at edges
inside = Overlap ? undef : base_shape(inset = pshape_size);

// Create grid of shapes
shapes = grid_copies(
    p = zrot(spin, pshape),
    n = [Columns, Rows],          // Fixed grid size
    spacing = pshape_size + spacing,
    stagger = stagger,
    inside = inside,
);
```
**Source:** grid-generator.scad:149-161

**Key Points:**
- `n = [cols, rows]` for fixed grid dimensions
- `inside = undef` allows shapes to extend past boundary
- `spacing` should include shape size for non-overlapping grids

---

## Path Functions

### Functions Returning 2D Shape Paths

Create reusable shape generators that return path arrays.

```openscad
// Shape function with polymorphic dispatch
function pattern_shape(name = Pattern, size = Pattern_Size, rounding = Pattern_Rounding, spin = 0, realign = false) =
    let (rounding = (min(size.x, size.y) * rounding) / 2)
    name == "ellipse"
        ? ellipse(d = size)
        : name == "octagon"
        ? round_corners(ellipse(d = size, $fn = 8, circum = true, spin = spin + (realign ? 22.5 : 0)), r = rounding / 2)
        : name == "hexagon"
        ? round_corners(ellipse(d = size, $fn = 6), r = rounding / 2)
        : name == "pentagon"
        ? round_corners(ellipse(d = size, $fn = 5, spin = spin + (realign ? -18 : 0)), r = rounding / 2)
        : name == "triangle"
        ? round_corners(ellipse(d = size, $fn = 3), r = rounding / 3)
        : rect(size, rounding = rounding);  // default case
```
**Source:** grid-generator.scad:118-132, grille-generator.scad:392-404

**Key Points:**
- Use `let()` for local calculations within function
- `ellipse()` with low `$fn` creates regular polygons
- `circum = true` makes inscribed polygon fit within diameter
- `realign` rotates shapes to align with grid

### Base Shape with Inset Support

```openscad
function base_shape(name = Base, size = Base_Size, rounding = Base_Rounding, inset = [0, 0]) =
    let (
        w = size.x - inset.x,
        l = size.y - inset.y,
        rounding = (min(w, l) * rounding) / 2,
        shape = name == "ellipse"
            ? ellipse(d = [w, l])
            : name == "hexagon"
            ? round_corners(ellipse(d = [w, l], $fn = 6), r = rounding / 1.5)
            : rect([w, l], rounding = rounding)
    ) shape;
```
**Source:** grid-generator.scad:92-107

**Key Points:**
- `inset` parameter shrinks shape for clipping boundaries
- Rounding ratio normalized to minimum dimension
- Returns path array for use with `polygon()` or `region()`

### Flower Shape with Polar Coordinates

```openscad
function flower(size, rounding, petals=6, phase_deg=15) =
    let (
        // Amplitude B for radial variation
        df = 0.2 + (rounding * 0.2),
        B  = df * (size / 4)
    )
    zrot(-phase_deg,
        [for (theta = lerpn(phase_deg, 360 + phase_deg, 180 + phase_deg, endpoint=false))
            (size/2 + B * (1 + sin(petals * theta))) * [cos(theta), sin(theta)]]
    );
```
**Source:** grille-generator.scad:378-387

**Key Points:**
- Polar to Cartesian: `r * [cos(theta), sin(theta)]`
- `lerpn()` generates evenly spaced angles
- Sinusoidal variation creates petal effect
- `zrot()` works on path arrays

---

## Path Operations

### pointlist_bounds for Size Calculation

```openscad
function pointlist_size(points) =
    let (
        bounds = pointlist_bounds(points),
        size = bounds[1] - bounds[0]
    ) [
        round_number(size.x),
        round_number(size.y)
    ];

function round_number(num, decimals = 1) =
    round(num * pow(10, decimals)) / pow(10, decimals);
```
**Source:** grid-generator.scad:109-116

**Key Points:**
- `pointlist_bounds()` returns `[[min_x, min_y], [max_x, max_y]]`
- Subtraction gives bounding box dimensions
- Useful for calculating spacing based on actual shape size

### offset for Path Expansion/Contraction

```openscad
// Expand path outward
_Cover_Shape = Cover_Shape == "auto"
    ? offset(_Grille_Shape, delta=Cover_Width, closed=true)
    : cover_shape();

// Contract path inward
inside = offset(_Grille_Shape, delta = -Mesh_Offset, closed = true);

// For boolean difference
offset(grille_shape, delta = -0.1, closed=true)  // Slight inset
```
**Source:** grille-generator.scad:149-151, 189, 292

**Key Points:**
- `delta` positive = expand, negative = contract
- `closed = true` required for closed paths
- Small offsets (-0.1) prevent z-fighting in differences

### resample_path for Even Distribution

```openscad
// Evenly space points along a path
pts = resample_path(path, n=Hole_Count);

// With corner preservation for rectangles
pts_seed = resample_path(bbox_path, n=n, keep_corners=n>2 ? 90 : undef);
```
**Source:** grille-generator.scad:310, 336

**Key Points:**
- `n` specifies number of output points
- `keep_corners` angle threshold preserves sharp corners
- Returns evenly distributed point array

### path_closest_point for Projection

```openscad
// Project points from one path to another
function project_rect_path(path, n) =
    let (
        path_bounds = pointlist_bounds(path),
        bbox_path = rect(path_bounds[1] - path_bounds[0], anchor=CENTER),
        pts_seed = resample_path(bbox_path, n=n, keep_corners=n>2 ? 90 : undef)
    )
    [ for (p = pts_seed) path_closest_point(path, p)[1] ];
```
**Source:** grille-generator.scad:331-339

**Key Points:**
- Projects corner-locked rectangle points to rounded shape
- `path_closest_point()` returns `[distance, closest_point]`
- Ensures screw holes at corners even with rounding

### path_merge_collinear for Simplification

```openscad
// Remove redundant points from path
shape = path_merge_collinear(shape);
```
**Source:** grille-generator.scad:369

**Key Points:**
- Removes points on straight segments
- Reduces polygon complexity
- Useful after path operations that add intermediate points

---

## Sweep Operations

### path_sweep2d for Rectangular Profiles

Efficient sweep for 4-point rectangular paths.

```openscad
module insert(wall = Insert_Wall, depth = Insert_Depth, chamfer = min(Insert_Chamfer, Insert_Wall/2)) {
    if (wall > 0 && depth > 0) {
        path = _Grille_Shape;
        profile = rect(
            [wall, depth],
            chamfer = [chamfer, chamfer, 0, 0],
            anchor = BOTTOM+RIGHT
        );

        if (len(path) == 4) {
            path_sweep2d(profile, path, closed = true);
        } else {
            path_sweep(profile, path, closed = true);
        }
    }
}
```
**Source:** grille-generator.scad:259-277

**Key Points:**
- `path_sweep2d()` is faster for simple rectangular paths
- Fall back to `path_sweep()` for complex paths
- Profile `anchor` controls positioning relative to path
- `chamfer` array: `[top-left, top-right, bottom-right, bottom-left]`

### move_copies for Point Distribution

```openscad
// Place children at each point
move_copies(pts) {
    screw_hole(Screw_Spec,
        length = Cover_Depth + 0.02,
        anchor = TOP,
        orient = DOWN
    );
}
```
**Source:** grille-generator.scad:313-323

**Key Points:**
- Places children at each point in array
- Combines with `resample_path()` for even distribution
- Alternative to `for` loop with `translate()`

---

## Region Operations

### region() for Complex 2D Shapes

```openscad
// Extrude complex shape
linear_extrude(height = bshape_height)
    region(bshape);

// Extrude grid of shapes
linear_extrude(height = pshape_height)
    region(shapes);
```
**Source:** grid-generator.scad:164-171

**Key Points:**
- `region()` handles nested paths and holes
- Required for paths from `grid_copies()`
- Works with path arrays containing multiple shapes

### region difference for Boolean 2D

```openscad
// Create frame by subtracting inner from outer
linear_extrude(height = depth) {
    region(
        difference([cover_shape, offset(grille_shape, delta = -0.1, closed=true)])
    );
}
```
**Source:** grille-generator.scad:290-294

**Key Points:**
- `difference()` takes array of paths: `[outer, inner1, inner2, ...]`
- First path is positive, rest are negative
- Wrapping in `region()` handles complex results

### shell2d for Frame Generation

```openscad
// Create frame around shape
if (Frame > 0) {
    linear_extrude(Frame_Thickness) {
        shell2d(Frame) region(bshape);
    }
}
```
**Source:** grid-generator.scad:193-196

**Key Points:**
- `shell2d(thickness)` creates hollow version of child
- Thickness expands outward
- Useful for bezels and borders

---

## Slat Calculation Function

Mathematical slat distribution for vent patterns.

```openscad
function slat_centers(len, cells, mode, w, s=0) =
    (cells <= 0) ? [] :
    (mode == "around") ?
        let(
            pitch0 = len/cells,            // default center-to-center
            g0     = pitch0 - w,           // default clear gap
            g      = max(0, g0 + s),       // adjusted gap (>=0)
            pitch  = w + g                 // new center-to-center
        )
        [ for (k=[0:cells-1]) -((cells-1)*pitch)/2 + k*pitch ] :
    // mode == "between"
        (cells <= 1) ? [] :
        let(
            S   = cells - 1,               // number of slats
            g0  = (len - S*w)/cells,       // default clear gap
            g   = max(0, g0 + s),          // adjusted clear gap
            P   = w + g,                   // center-to-center
            T   = S*w + cells*g,           // total span
            x0  = -T/2 + g + w/2           // first slat center
        )
        [ for (i=[0:S-1]) x0 + i*P ];
```
**Source:** grille-generator.scad:409-430

**Key Points:**
- `mode = "around"`: gaps at both edges and between
- `mode = "between"`: gaps only between slats
- `s` parameter adjusts spacing from default
- Returns array of center positions (symmetric about 0)

---

## Common Patterns

### Z-Fighting Prevention

Always extend cutting shapes slightly past surfaces.

```openscad
// Extend past top and bottom
down(0.01) linear_extrude(height = _Grille_Depth + 0.02) {
    region(pattern);
}

// In screw holes
screw_hole(Screw_Spec,
    length = Cover_Depth + 0.02,  // Extend past surface
    anchor = TOP,
    orient = DOWN
);
```

### Conditional Path Selection

```openscad
// Use efficient path when possible
if (len(path) == 4) {
    path_sweep2d(profile, path, closed = true);
} else {
    path_sweep(profile, path, closed = true);
}
```

---

## Navigation

**Up:** [`index.md`](index.md) - Parametric Patterns overview

**Related:**
- [`../bosl2-integration/idioms.md`](../bosl2-integration/idioms.md) - Core BOSL2 patterns
- [`pattern-generation.md`](pattern-generation.md) - 2D pattern creation
- [`customizer-ui.md`](customizer-ui.md) - Parameter patterns

## Metadata
- **Created:** 2025-12-28
- **Last Updated:** 2025-12-28
- **Document Type:** Pattern
