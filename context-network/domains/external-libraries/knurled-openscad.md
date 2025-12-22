# Knurled OpenSCAD Library

## Purpose
Provides knurled cylinder generation for creating textured knobs, grips, and control surfaces.

## Classification
- **Domain:** External Libraries
- **Stability:** Stable
- **Abstraction:** Direct usage
- **Confidence:** Established

## Library Location
`lib/knurled-openscad/` (git submodule)

**Source:** [github.com/smkent/knurled-openscad](https://github.com/smkent/knurled-openscad)

## Usage

```openscad
use <knurled-openscad/knurled.scad>

// Basic knurled cylinder
knurled_cylinder(
    height = 12,        // cylinder height
    diameter = 25,      // outer diameter
    knurl_width = 3,    // diamond width
    knurl_height = 4,   // diamond height
    knurl_depth = 1.5,  // texture depth
    bevel = 2,          // edge bevel height
    smooth = 0          // smoothing percentage (0-100)
);
```

## Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `height` | 12 | Total cylinder height |
| `diameter` | 25 | Outer diameter of knurled surface |
| `knurl_width` | 3 | Width of each knurl diamond |
| `knurl_height` | 4 | Height of each knurl diamond |
| `knurl_depth` | 1.5 | Depth of knurl texture |
| `bevel` | 2 | Bevel height at top/bottom (0=none, negative=inverted) |
| `smooth` | 0 | Smoothing percentage (0-100, higher = smoother) |

## Bevel Modes

- `bevel > 0`: Standard beveled edges (chamfered)
- `bevel = 0`: No bevel, sharp edges
- `bevel < 0`: Inverted bevel (lips at edges)

## RetroCase Integration

### Knurled Knob Module Pattern
```openscad
include <BOSL2/std.scad>
use <knurled-openscad/knurled.scad>

module retro_knob(
    diameter = 20,
    height = 15,
    shaft_d = 6,        // potentiometer shaft diameter
    shaft_flat = 4.5,   // D-shaft flat width (0 for round)
    knurl_depth = 1
) {
    difference() {
        // Knurled exterior
        knurled_cylinder(
            height = height,
            diameter = diameter,
            knurl_width = 2,
            knurl_height = 3,
            knurl_depth = knurl_depth,
            bevel = 1.5
        );

        // Shaft hole (D-shaft)
        translate([0, 0, -0.1])
        linear_extrude(height + 0.2)
        difference() {
            circle(d = shaft_d, $fn = 32);
            if (shaft_flat > 0) {
                translate([shaft_d/2, 0])
                square([shaft_d, shaft_d], center = true);
            }
        }
    }
}
```

### Braun-Style Knob (Minimal Knurling)
```openscad
// Subtle texture for Braun aesthetic
knurled_cylinder(
    height = 12,
    diameter = 18,
    knurl_width = 1.5,
    knurl_height = 2,
    knurl_depth = 0.5,   // Very shallow
    bevel = 1,
    smooth = 50          // Smoother finish
);
```

### Retro Radio Tuning Knob (Deep Grip)
```openscad
// Aggressive texture for easy grip
knurled_cylinder(
    height = 20,
    diameter = 30,
    knurl_width = 3,
    knurl_height = 4,
    knurl_depth = 2,     // Deep texture
    bevel = 3
);
```

## Print Considerations

- Knurling prints well without supports when vertical
- Depth of 1-1.5mm works best for FDM
- Deeper knurling (2mm+) may need slower print speeds
- Consider `smooth` parameter for better layer adhesion

## Navigation

**Up:** [`index.md`](index.md) - External Libraries overview

**Related:**
- [`nopscadlib.md`](nopscadlib.md) - Potentiometer shaft definitions
- [`../../planning/preset-catalog.md`](../../planning/preset-catalog.md) - Knob presets

## Metadata
- **Created:** 2025-12-22
- **Last Updated:** 2025-12-22
- **Document Type:** Integration Guide
