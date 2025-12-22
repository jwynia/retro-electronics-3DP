# BOSL2 Rounding Reference

Advanced rounding techniques beyond basic cuboid/prismoid rounding. Source: https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad

## When to Use What

| Shape | Built-in rounding? | For full rounding use |
|-------|-------------------|----------------------|
| cuboid() | Yes, all edges | Built-in is sufficient |
| prismoid() | Vertical edges only | offset_sweep() or edge_profile() |
| rounded_prism() | Yes, continuous curvature | Built-in is sufficient |
| Custom shapes | No | offset_sweep() or skin() |

## offset_sweep()

Sweeps a 2D shape vertically with offset that changes along height. Perfect for rounded top/bottom edges.

```openscad
include <BOSL2/std.scad>

// Basic rounded rectangle with rounded top and bottom
offset_sweep(
    rect([100, 80], rounding=10),  // 2D shape
    height=50,
    bottom=os_circle(r=5),         // Bottom edge treatment
    top=os_circle(r=5)             // Top edge treatment
);
```

### Edge Treatment Profiles

```openscad
// Circular roundover (most common)
os_circle(r=5)

// Teardrop for 3D printing (no overhangs)
os_teardrop(r=5)

// Chamfer
os_chamfer(height=5)
os_chamfer(width=5)
os_chamfer(height=5, angle=45)

// Smooth continuous curvature
os_smooth(cut=5)
os_smooth(joint=5)

// Pointed (no rounding)
os_pointed()

// Flat (just the edge, no rounding)
os_flat()
```

### Negative Radius = Fillet (inside corner)

```openscad
// Fillet at bottom, round at top
offset_sweep(
    rect([100, 80]),
    height=50,
    bottom=os_circle(r=-5),  // Negative = fillet/cove
    top=os_circle(r=5)       // Positive = roundover
);
```

### Steps Parameter

More steps = smoother curves:

```openscad
offset_sweep(
    rect([100, 80]),
    height=50,
    bottom=os_circle(r=10),
    top=os_circle(r=10),
    steps=20  // Default varies by $fn
);
```

## rounded_prism()

Creates a rounded 3D shape by connecting two polygons. Uses **continuous curvature** rounding (smoother than circular).

```openscad
include <BOSL2/std.scad>

// Simple rounded box
rounded_prism(
    rect([100, 80]),  // Bottom shape
    rect([100, 80]),  // Top shape (same = straight sides)
    height=50,
    joint_top=5,      // Top edge rounding
    joint_bot=5,      // Bottom edge rounding
    joint_sides=10    // Side edge rounding
);
```

### Tapered with rounding

```openscad
rounded_prism(
    rect([100, 80]),      // Bottom
    rect([60, 50]),       // Top (smaller = taper)
    height=50,
    joint_top=3,
    joint_bot=5,
    joint_sides=8
);
```

### k Parameter (curvature smoothness)

```openscad
// k=0.5 is gentler, k=0.9 is closer to circular
rounded_prism(
    rect([100, 80]),
    rect([100, 80]),
    height=50,
    joint_top=5,
    joint_bot=5,
    joint_sides=10,
    k=0.8  // 0.5-0.9 range, default ~0.5
);
```

## round_corners() (2D)

Rounds corners of a 2D path before extruding.

```openscad
include <BOSL2/std.scad>

// Round all corners of a rectangle
rounded = round_corners(square(50), r=10);
linear_extrude(20) polygon(rounded);

// Different radius per corner
rounded = round_corners(square(50), r=[5, 10, 15, 5]);
```

### With offset_sweep

```openscad
shape = round_corners(square([100, 80], center=true), r=15, $fn=32);

offset_sweep(
    shape,
    height=50,
    bottom=os_circle(r=5),
    top=os_circle(r=5)
);
```

## Hollowing with Rounding

### Method 1: Two offset_sweeps with difference

```openscad
include <BOSL2/std.scad>

wall = 3;
outer = rect([100, 80], rounding=10);
inner = rect([100-wall*2, 80-wall*2], rounding=10-wall);

difference() {
    offset_sweep(outer, height=50, bottom=os_circle(r=5), top=os_circle(r=5));
    up(wall) offset_sweep(inner, height=50, bottom=os_circle(r=-3), top=os_circle(r=3));
}
```

### Method 2: Two rounded_prisms with diff

```openscad
include <BOSL2/std.scad>

wall = 3;

diff() {
    rounded_prism(rect([100, 80]), height=50, joint_top=5, joint_bot=5, joint_sides=10);
    
    tag("remove")
    up(wall) rounded_prism(
        rect([100-wall*2, 80-wall*2]),
        height=50,
        joint_top=-3,  // Negative = fillet inside
        joint_bot=0,
        joint_sides=10-wall
    );
}
```

## path_sweep()

Sweeps a 2D shape along a 3D path.

```openscad
include <BOSL2/std.scad>

// Create a curved tube
path = arc(r=50, angle=[0, 180]);
path_sweep(circle(d=10), path3d(path));
```

### With caps

```openscad
path_sweep(
    circle(d=10),
    path3d(arc(r=50, angle=[0, 180])),
    caps=true
);
```

## skin()

Connects multiple 2D profiles into a 3D shape. For complex lofted shapes.

```openscad
include <BOSL2/std.scad>

// Morph from square to circle
profiles = [
    path3d(square(50, center=true), 0),
    path3d(circle(d=50, $fn=32), 30)
];

skin(profiles, slices=20);
```

## Common Patterns for RetroCase

### Rounded shell with rebated lip

```openscad
include <BOSL2/std.scad>

module retro_shell(w, h, d, wall=3, corner_r=10, lip_depth=3) {
    outer = rect([w, h], rounding=corner_r);
    inner = rect([w-wall*2, h-wall*2], rounding=max(1, corner_r-wall));
    lip = rect([w-wall, h-wall], rounding=corner_r-wall/2);
    
    difference() {
        offset_sweep(outer, height=d, bottom=os_circle(r=5), top=os_flat());
        
        // Main cavity
        up(wall) offset_sweep(inner, height=d, bottom=os_circle(r=-2), top=os_flat());
        
        // Lip rebate
        up(d - lip_depth) linear_extrude(lip_depth + 1) offset(0.2) polygon(lip);
    }
}

retro_shell(120, 80, 60);
```

### Tapered wedge shell

```openscad
include <BOSL2/std.scad>

module wedge_shell(w, h, d, taper=0.7, wall=3, corner_r=8) {
    difference() {
        rounded_prism(
            rect([w, h]),
            rect([w * taper, h * taper]),
            height=d,
            joint_top=corner_r/2,
            joint_bot=corner_r,
            joint_sides=corner_r
        );
        
        up(wall)
        rounded_prism(
            rect([w - wall*2, h - wall*2]),
            rect([w * taper - wall*2, h * taper - wall*2]),
            height=d,
            joint_top=0,
            joint_bot=max(1, corner_r - wall),
            joint_sides=max(1, corner_r - wall)
        );
    }
}

wedge_shell(150, 100, 80);
```
