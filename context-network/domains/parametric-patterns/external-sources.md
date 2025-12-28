# External Pattern Sources

## Purpose

Reference documentation for valuable patterns from external OpenSCAD projects that complement the inbox file analysis. These sources provide additional techniques for enclosure design, modular systems, and mechanical joints.

## Classification
- **Domain:** Parametric Patterns
- **Stability:** Semi-stable
- **Abstraction:** Reference
- **Confidence:** Established

## Overview

External projects offer proven patterns for specific use cases. This document summarizes key techniques from major OpenSCAD libraries and generators without requiring full file downloads.

---

## YAPP Box Generator

**Source:** [github.com/mrWheel/YAPP_Box](https://github.com/mrWheel/YAPP_Box)
**Documentation:** [mrwheel-docs.gitbook.io/yappgenerator_en](https://mrwheel-docs.gitbook.io/yappgenerator_en)

### PCB-Centric Design Philosophy

YAPP inverts typical enclosure design by building the box around the PCB rather than fitting PCBs into pre-made boxes.

**Key Concept:**
- PCB dimensions and component placement are primary references
- Box adapts to PCB, not vice versa
- Connector positions relative to PCB origin

### Plane-Based Cutout Organization

Cutouts organized by plane (base, lid, front, back, left, right).

**Pattern:**
```
cutout_definition = [
    position_x,
    position_y,
    depth,
    shape_type,
    dimensions,
    options
];
```

**Each cutout receives:**
- Position coordinates relative to PCB placement
- Depth parameters (internal/external visibility)
- Shape definitions (circular, rectangular, polygonal)
- Optional masks for complex geometries
- PCB selection flags for multi-board assemblies

### Hierarchical Parameter Naming

Parameters use prefix-based naming for logical grouping:
- Structural parameters grouped by function
- Manufacturing details (tolerances) separate from design
- Consistent naming enables parameter discovery

**Applicable to RetroCase:**
- Faceplate cutout system could use plane-based organization
- PCB-relative positioning for screen and control mounting
- Separation of design from manufacturing parameters

---

## Gridfinity Extended

**Source:** [github.com/ostat/gridfinity_extended_openscad](https://github.com/ostat/gridfinity_extended_openscad)

### Grid Unit System

Base dimensions use consistent pitch:
- **X/Y pitch:** 42mm per grid unit
- **Z pitch:** 7mm per height unit

**Dual-Input Pattern:**
```openscad
// [grid_units, mm_override]
width = [2, 0];  // 2 grid units = 84mm
width = [0, 50]; // Direct 50mm specification
```

When second value is non-zero, it overrides grid calculation.

### Base Profile Options

Multiple floor configurations:
- **Gridfinity stackable:** Standard interlocking base
- **Rounded:** Simplified non-stacking base
- **Efficient floor:** Offset internal floor reduces material
- **Half-pitch:** Enables half-cell offsets

### Wall Pattern Library

Six pattern styles for walls and dividers:
1. Hexgrid
2. Standard grid
3. Voronoi variants
4. Brick
5. Offset brick
6. Custom

**Pattern Parameters:**
- Cell sizing
- Hole geometry (4/6/8 sides or circular)
- Depth and border configuration
- Fill modes (crop, space, hybrid)

### Height Calculation

```openscad
// Height as multiple of 7mm
total_height = units * 7;

// With lip adjustment
effective_height = total_height + (include_lip ? lip_height : 0);
```

**Applicable to RetroCase:**
- Grid-based sizing for modular compatibility
- Wall pattern library for ventilation
- Height unit system for stackable components

---

## BOSL2 Hinges

**Source:** [BOSL2 hinges.scad](https://github.com/BelfrySCAD/BOSL2/wiki/hinges.scad)

### Knuckle Hinge Parameters

```openscad
knuckle_hinge(
    length,                    // Total hinge length
    segs,                      // Number of interlocking segments
    offset,                    // Distance from mount to pin center
    inner = true,              // Inner or outer hinge part
    arm_height = 0,            // Vertical support height
    arm_angle = 45,            // Support angle from vertical
    knuckle_diam = 4,          // Barrel diameter
    pin_diam = 3,              // Hole diameter (or "M3" for screw spec)
    fill = false,              // Connect arm to mount surface
    clear_top = false,         // Remove excess above mount
    round_top = 0,             // Top transition radius
    round_bot = 0              // Bottom transition radius
);
```

**Key Points:**
- `offset` minimum = knuckle diameter
- Odd `segs` counts produce symmetric configurations
- `pin_diam` accepts screw specifications like "M3"

### Living Hinge Mask

For thin-walled flexure hinges:

```openscad
living_hinge_mask(
    foldangle = 90,           // Interior joint angle
    hingegap,                 // Bottom clearance for folding
    // Preserves 2*layerheight at fold line
);
```

**Usage:**
- Difference mask from plate material
- Designed for FDM layer orientation
- Creates flexible fold line in solid print

### Snap-Lock System

Two complementary modules:

```openscad
snap_lock(
    snaplen,
    snapdiam,
    foldangle = 90
);

snap_socket(
    snaplen,
    snapdiam,
    foldangle = 90
);
```

**Integration:**
```openscad
apply_folding_hinges_and_snaps() {
    // Your geometry
}
```

**Applicable to RetroCase:**
- Knuckle hinges for lid mechanisms
- Living hinges for integrated closures
- Snap-locks for tool-free assembly

---

## Gridfinity Rebuilt

**Source:** [github.com/kennetek/gridfinity-rebuilt-openscad](https://github.com/kennetek/gridfinity-rebuilt-openscad)

Already in inbox as `gridfinity-bins.scad`. Key patterns documented in other sections:
- Profile sweep for walls ([bosl2-advanced.md](bosl2-advanced.md))
- Height calculations ([parametric-architecture.md](parametric-architecture.md))
- Tab management for customizer

---

## Pattern Library Summary

### Enclosure Design
| Pattern | Source | Use Case |
|---------|--------|----------|
| PCB-centric design | YAPP | Electronics enclosures |
| Plane-based cutouts | YAPP | Connector placement |
| Hierarchical parameters | YAPP | Complex configurations |

### Modular Systems
| Pattern | Source | Use Case |
|---------|--------|----------|
| Grid unit system | Gridfinity | Standardized sizing |
| Dual-input dimensions | Gridfinity Extended | Flexible specification |
| Height units | Gridfinity | Stackable components |

### Mechanical Features
| Pattern | Source | Use Case |
|---------|--------|----------|
| Knuckle hinges | BOSL2 | Lid mechanisms |
| Living hinges | BOSL2 | Integrated flexures |
| Snap-locks | BOSL2 | Tool-free assembly |

### Surface Patterns
| Pattern | Source | Use Case |
|---------|--------|----------|
| Wall patterns | Gridfinity Extended | Ventilation, aesthetics |
| Pattern library | Gridfinity Extended | Reusable decorations |

---

## Integration Recommendations

### For RetroCase Shells
1. Consider YAPP-style plane-based cutout organization for faceplates
2. Use Gridfinity height unit concept for stackable enclosures
3. Integrate BOSL2 hinges for lid mechanisms

### For Faceplates
1. Adapt Gridfinity wall patterns for speaker grilles
2. Use YAPP cutout system for connector placement
3. Consider snap-lock features for removable panels

### For Hardware
1. BOSL2 knuckle hinges for access panels
2. Snap-socket system for tool-free assembly
3. Living hinges for cable management covers

---

## Navigation

**Up:** [`index.md`](index.md) - Parametric Patterns overview

**Related:**
- [`mechanical-joints.md`](mechanical-joints.md) - Threading patterns
- [`bosl2-advanced.md`](bosl2-advanced.md) - BOSL2 techniques
- [`pattern-generation.md`](pattern-generation.md) - Surface patterns

## Metadata
- **Created:** 2025-12-28
- **Last Updated:** 2025-12-28
- **Document Type:** Reference
