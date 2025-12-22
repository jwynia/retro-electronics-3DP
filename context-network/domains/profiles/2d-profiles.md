# 2D Profile Patterns

## Purpose
Techniques for creating 2D profiles used with `offset_sweep()` and other path-based operations.

## Classification
- **Domain:** Profiles
- **Stability:** Established
- **Abstraction:** Pattern documentation
- **Confidence:** High

## What Are Profiles?

Profiles are 2D shapes that define cross-sections. They're used with:
- `linear_extrude()` - Simple extrusion along Z
- `offset_sweep()` - Extrusion along a path with edge treatment
- `skin()` - Lofting between profiles
- `sweep()` - Following arbitrary paths

## Profile vs Path

**Profile (module):** Creates a 2D shape for use as a child
```openscad
module profile_rounded_rect(size, corner_r) {
    rect(size, rounding=corner_r);
}
```

**Path (function):** Returns a point array for use as an argument
```openscad
function path_rounded_rect(size, corner_r) =
    rect(size, rounding=corner_r, $fn=32);
```

## Implemented Profiles

### profile_rounded_rect()

Simple rounded rectangle:

```openscad
module profile_rounded_rect(size, corner_r) {
    rect(size, rounding=corner_r);
}
```

**Parameters:**
- `size` - [width, height]
- `corner_r` - Corner radius

**Usage:**
```openscad
linear_extrude(50)
profile_rounded_rect([80, 60], 10);
```

### profile_wedge()

Trapezoidal profile for tapered shapes:

```openscad
module profile_wedge(height, base_width, top_width, corner_r=0) {
    points = [
        [-base_width/2, 0],
        [ base_width/2, 0],
        [ top_width/2, height],
        [-top_width/2, height]
    ];

    if (corner_r > 0) {
        polygon(round_corners(points, r=corner_r, $fn=16));
    } else {
        polygon(points);
    }
}
```

**Parameters:**
- `height` - Profile height
- `base_width` - Width at base (Y=0)
- `top_width` - Width at top (Y=height)
- `corner_r` - Optional corner rounding

**Usage:**
```openscad
rotate([90, 0, 0])
linear_extrude(100)
profile_wedge(60, 80, 50, corner_r=5);
```

### path_rounded_rect()

Returns path for offset_sweep:

```openscad
function path_rounded_rect(size, corner_r) =
    rect(size, rounding=corner_r, $fn=32);
```

**Usage:**
```openscad
offset_sweep(
    path_rounded_rect([100, 80], 10),
    height = 50,
    top = os_rounded(r=3)
);
```

## Using Profiles with offset_sweep()

`offset_sweep()` creates 3D shapes with nice edge treatments:

```openscad
offset_sweep(
    path,                    // 2D path (point array)
    height = 50,             // Extrusion height
    top = os_rounded(r=3),   // Top edge treatment
    bottom = os_rounded(r=2) // Bottom edge treatment
);
```

### Edge Treatments

| Treatment | Effect |
|-----------|--------|
| `os_rounded(r)` | Rounded edge with radius r |
| `os_chamfer(w)` | 45-degree chamfer with width w |
| `os_teardrop(r)` | Teardrop for 3D printing |
| `os_flat()` | No treatment (sharp edge) |

## Creating Custom Profiles

### Polygon-Based

For arbitrary shapes:

```openscad
module profile_custom() {
    points = [
        [0, 0],
        [50, 0],
        [60, 30],
        [50, 60],
        [0, 60],
        [-10, 30]
    ];
    polygon(round_corners(points, r=5, $fn=16));
}
```

### Boolean-Based

Combining simple shapes:

```openscad
module profile_notched_rect(size, notch_size) {
    difference() {
        rect(size);
        translate([size[0]/2 - notch_size[0]/2, size[1]/2])
        rect(notch_size, anchor=TOP);
    }
}
```

## Orientation Conventions

### Standard Orientation
- Profiles are created in XY plane
- Width is X dimension
- Height is Y dimension
- Extrusion direction is typically Z (up)

### For Swept Shells
When creating shell profiles:
```openscad
// Profile defines side view (Y = forward, not up)
rotate([90, 0, 0])
linear_extrude(depth)
profile_wedge(...);
```

## Navigation

**Up:** [`index.md`](index.md) - Profiles domain overview

**Related:**
- [`locations.md`](locations.md) - Code locations
- [`../bosl2-integration/`](../bosl2-integration/index.md) - BOSL2 sweep functions
- [`../shells/`](../shells/index.md) - Shells may use swept profiles

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain - Pattern Documentation
