# Interface Contracts

## Purpose
Standardized attachment points and interface specifications between RetroCase modules.

## Classification
- **Domain:** Cross-domain standards
- **Stability:** Stable (changes break compatibility)
- **Abstraction:** Technical specification
- **Confidence:** Established

## Shell ↔ Faceplate Interface

### Dimensional Contract

For a faceplate to fit a shell:

```
faceplate_width  = shell_opening_width + shell_lip_inset * 2
faceplate_height = shell_opening_height + shell_lip_inset * 2
faceplate_depth  ≤ shell_lip_depth
```

### Visual Diagram

```
    ┌─────────────────────────────────────┐
    │           Shell Exterior            │
    │  ┌───────────────────────────────┐  │
    │  │         Lip Rebate            │  │← lip_inset
    │  │  ┌─────────────────────────┐  │  │
    │  │  │                         │  │  │
    │  │  │      Opening Area       │  │  │
    │  │  │                         │  │  │
    │  │  └─────────────────────────┘  │  │
    │  │                               │  │← lip_depth
    │  └───────────────────────────────┘  │
    └─────────────────────────────────────┘
         ↑                           ↑
    opening_width            + lip_inset*2 = faceplate_width
```

### Faceplate Seating

The faceplate sits in the lip rebate:
- Front face of faceplate is flush with shell exterior
- Faceplate back face contacts shell lip
- Gap around faceplate allows insertion/removal

## Magnetic Attachment Interface

### Alignment Contract

Magnets in shell lip must align with steel discs in faceplate:

```
shell_magnet_inset = faceplate_steel_inset = mounting_inset
```

### Position Specification

Four-corner pattern from center of faceplate/lip:

```
positions = [
    [ width/2 - inset,  height/2 - inset],  # Top-right
    [-width/2 + inset,  height/2 - inset],  # Top-left
    [-width/2 + inset, -height/2 + inset],  # Bottom-left
    [ width/2 - inset, -height/2 + inset]   # Bottom-right
]
```

### Pocket Specifications

| Component | Location | Diameter | Depth |
|-----------|----------|----------|-------|
| Magnet | Shell lip | magnet_dia + 0.3 | magnet_depth + 0.1 |
| Steel disc | Faceplate back | steel_dia + 0.3 | steel_depth + 0.1 |

## Attachable Module Contract

### Required Parameters

All attachable modules must accept:

```openscad
module my_module(
    // Module-specific parameters...
    anchor = CENTER,  // or BOT for shells
    spin = 0,
    orient = UP
)
```

### Required Structure

```openscad
module my_module(size, ..., anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor, spin, orient, size=size) {
        // Geometry here

        children();  // REQUIRED
    }
}
```

### Anchor Points

Standard anchor points are automatically created:
- Face centers: `TOP`, `BOT`, `LEFT`, `RIGHT`, `FWD`, `BACK`
- Edge centers: `TOP+LEFT`, `FWD+BOT`, etc.
- Corners: `TOP+LEFT+FWD`, etc.

## Profile Module Contract

### Module Pattern
```openscad
module profile_name(width, height, ...) {
    // Returns 2D shape
    // Origin at center
    // Width along X, height along Y
}
```

### Function Pattern
```openscad
function path_name(width, height, ...) =
    // Returns array of [x, y] points
    // Closed path for use with offset_sweep
```

## Hardware Module Contract

### Pocket Modules

Pocket modules are designed to be subtracted:

```openscad
diff()
parent_shape() {
    tag("remove")
    position(ANCHOR)
    pocket_module(...);
}
```

### Standoff Modules

Standoff modules are designed to be added:

```openscad
parent_shape() {
    position(BOT)
    standoff(height=5);
}
```

## Parameter Passing

### Shell → Faceplate Coordination

When creating matching shell and faceplate:

```openscad
// Shell parameters
shell_opening = [120, 80];
shell_lip_inset = 1.5;
shell_lip_depth = 3;

// Derived faceplate parameters
faceplate_size = [
    shell_opening[0] + shell_lip_inset * 2,
    shell_opening[1] + shell_lip_inset * 2
];
faceplate_thickness = shell_lip_depth - 0.5;  // Small clearance
```

### Magnetic Hardware Coordination

```openscad
// Shared parameters
mounting_inset = 12;
magnet_dia = 8;
steel_dia = 8;

// Use same inset in both shell and faceplate
```

## Breaking Changes

Changes to these interfaces require:
1. Version bump
2. Migration documentation
3. Update all affected modules
4. Update all affected presets

## Navigation

**Up:** [`index.md`](index.md) - Cross-domain overview

**Related:**
- [`parameter-conventions.md`](parameter-conventions.md) - Naming standards
- [`module-dependencies.md`](module-dependencies.md) - Module relationships
- [`../domains/shells/`](../domains/shells/index.md) - Shell specifications
- [`../domains/faceplates/`](../domains/faceplates/index.md) - Faceplate specifications

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Interface Specification
