# BOSL2 shapes3d.scad Reference

Essential 3D primitives for RetroCase. Source: https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad

## cuboid()

Creates a cube with chamfering and roundovers.

```openscad
cuboid(size, [rounding=], [chamfer=], [edges=], [except=], [anchor=], [spin=], [orient=])
```

### Basic Usage

```openscad
include <BOSL2/std.scad>

// Simple rounded cube
cuboid([100, 80, 60], rounding=10);

// Chamfered cube
cuboid([100, 80, 60], chamfer=5);
```

### Edge Selection

Round/chamfer specific edges using directional constants:

```openscad
// Round only top edges
cuboid([100, 80, 60], rounding=10, edges=TOP);

// Round only right edges
cuboid([100, 80, 60], rounding=10, edges=RIGHT);

// Round edges meeting at a corner
cuboid([100, 80, 60], rounding=10, edges=TOP+RIGHT+FWD);

// Round a single edge
cuboid([100, 80, 60], rounding=10, edges=TOP+FWD);

// Round all edges parallel to Z axis
cuboid([100, 80, 60], rounding=10, edges="Z");

// Round all except bottom edges
cuboid([100, 80, 60], rounding=10, except=BOT);
```

### Anchoring

Default anchor is CENTER. Override with `anchor=`:

```openscad
// Anchor to bottom (sits on XY plane)
cuboid([100, 80, 60], anchor=BOT);

// Anchor to bottom-front-left corner
cuboid([100, 80, 60], anchor=BOT+FWD+LEFT);
```

## prismoid()

Creates a rectangular prismoid (tapered box). **Only rounds/chamfers vertical edges.**

```openscad
prismoid(size1, size2, h, [rounding=], [rounding1=], [rounding2=], [shift=], [anchor=])
```

### Basic Usage

```openscad
include <BOSL2/std.scad>

// Simple taper
prismoid([100, 80], [60, 40], h=50);

// With rounded vertical edges
prismoid([100, 80], [60, 40], h=50, rounding=10);

// Different rounding top vs bottom
prismoid([100, 80], [60, 40], h=50, rounding1=5, rounding2=15);

// Per-corner rounding [X+Y+, X-Y+, X-Y-, X+Y-]
prismoid(100, 80, h=50, rounding1=[0,50,0,50], rounding2=[40,0,40,0]);

// Shifted top
prismoid([100, 80], [60, 40], h=50, shift=[20, 0]);
```

### Key Limitation

prismoid() **cannot round horizontal edges** (top/bottom faces). For that, use:
- `offset_sweep()` from rounding.scad
- `rounded_prism()` from rounding.scad
- Edge masking with `edge_profile()`

## cyl()

Creates an attachable cylinder with roundovers and chamfering.

```openscad
cyl(h, r, [rounding=], [rounding1=], [rounding2=], [chamfer=], [anchor=])
```

### Basic Usage

```openscad
include <BOSL2/std.scad>

// Simple cylinder
cyl(h=50, r=20);

// Rounded ends
cyl(h=50, r=20, rounding=5);

// Different top/bottom
cyl(h=50, r=20, rounding1=5, rounding2=10);

// Tapered cylinder
cyl(h=50, r1=30, r2=20);

// Chamfered
cyl(h=50, r=20, chamfer=3);
```

## rect_tube()

Creates a rectangular tube (hollow prism).

```openscad
rect_tube(h, size, [isize=], [wall=], [rounding=], [irounding=], [anchor=])
```

### Basic Usage

```openscad
include <BOSL2/std.scad>

// By wall thickness
rect_tube(h=50, size=[100, 80], wall=5);

// By inner size
rect_tube(h=50, size=[100, 80], isize=[90, 70]);

// With rounding
rect_tube(h=50, size=[100, 80], wall=5, rounding=10, irounding=5);
```

## wedge()

Creates a 3D triangular wedge.

```openscad
wedge(size, [anchor=], [spin=], [orient=])
```

### Basic Usage

```openscad
include <BOSL2/std.scad>

// Simple wedge - slope faces RIGHT
wedge([100, 80, 60]);

// Anchor to back bottom
wedge([100, 80, 60], anchor=BACK+BOT);
```

## Directional Constants

Use these to specify anchors, edges, and positions:

| Constant | Vector | Description |
|----------|--------|-------------|
| `CENTER` | [0,0,0] | Center point |
| `LEFT` | [-1,0,0] | -X direction |
| `RIGHT` | [1,0,0] | +X direction |
| `FWD`/`FRONT` | [0,-1,0] | -Y direction |
| `BACK` | [0,1,0] | +Y direction |
| `BOT`/`BOTTOM` | [0,0,-1] | -Z direction |
| `TOP`/`UP` | [0,0,1] | +Z direction |

Combine with `+`: `TOP+RIGHT`, `BOT+FWD+LEFT`

## Edge Axis Strings

For rounding all edges parallel to an axis:

| String | Edges affected |
|--------|----------------|
| `"X"` | All edges parallel to X axis |
| `"Y"` | All edges parallel to Y axis |
| `"Z"` | All edges parallel to Z axis (vertical edges) |
