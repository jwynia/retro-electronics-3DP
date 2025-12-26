# Gridfinity Integration

## Overview

Gridfinity is a modular storage system with standardized dimensions that allows bins and baseplates to interlock. This project integrates with the [gridfinity-rebuilt-openscad](https://github.com/kennetek/gridfinity-rebuilt-openscad) library for generating compatible parts.

## Standard Dimensions

| Constant | Value | Description |
|----------|-------|-------------|
| Grid pitch | 42mm x 42mm | Single unit footprint |
| Base top | 41.5mm x 41.5mm | Actual base size (0.5mm gap) |
| Base height | 7mm | Height unit (z-step) |
| Base profile height | 5.45mm | Height of the interlocking profile |
| Base top radius | 3.75mm | Corner radius at top of base |
| Base bottom radius | 0.8mm | Corner radius at bottom |

## Key Features

### Baseplates
- Screw hole support (M3 / 4-40 compatible)
- Magnet holes (6mm dia x 2mm deep)
- Multiple styles: thin, weighted, skeletonized, screw-together

### Bins
- Adjustable X/Y/Z grid units
- Compartment dividers
- Scoops and tabs
- Stacking lips
- Support-free hole printing

## Library Location

```
lib/gridfinity-rebuilt-openscad/
├── gridfinity-rebuilt-baseplate.scad  # Baseplate generator
├── gridfinity-rebuilt-bins.scad       # Bin generator
├── gridfinity-rebuilt-lite.scad       # Simplified variant
├── gridfinity-spiral-vase.scad        # Vase mode bins
└── src/
    └── core/
        └── standard.scad              # All standard constants
```

## Use with Plywood Cases

The primary integration point is using Gridfinity baseplates as the bottom of plywood equipment cases built with corner brackets. This allows:

1. Interior organization with standard Gridfinity bins
2. Easy reconfiguration of storage layout
3. Compatible with existing Gridfinity ecosystem

### Sizing Calculations

For a plywood case with interior dimensions W x D:
- Grid units X = floor(W / 42)
- Grid units Y = floor(D / 42)
- Actual baseplate size = (units * 42) mm
- Remaining margin = interior - (units * 42)

### Height Considerations

Case height should account for:
- Baseplate height: ~5mm (thin) or ~7mm (standard)
- Bin height: (z_units * 7) + 7mm base
- Clearance above bins for removal

## Related Files

- [Calculator Script](../../../scripts/case-calculator.ts) - Plywood cut list + Gridfinity sizing
- [Corner Brackets](../../../modules/hardware/corner-bracket.scad) - Case frame hardware
- [Example Assembly](../../../examples/gridfinity-case.scad) - Combined case + Gridfinity
