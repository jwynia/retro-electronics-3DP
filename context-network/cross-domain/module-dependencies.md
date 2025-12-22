# Module Dependencies

## Purpose
Map of dependencies and relationships between RetroCase modules.

## Classification
- **Domain:** Cross-domain standards
- **Stability:** Dynamic (updates with new modules)
- **Abstraction:** Structural
- **Confidence:** Current as of 2025-12-21

## Dependency Overview

```
BOSL2/std.scad
    │
    ├── modules/profiles/basic.scad
    │       └── profile_rounded_rect()
    │       └── profile_wedge()
    │       └── path_rounded_rect()
    │
    ├── modules/shells/monolithic.scad
    │       └── shell_monolithic()
    │
    └── modules/faces/bezel.scad
            └── faceplate_bezel()
            └── faceplate_blank()
```

## Core Dependencies

### All Modules
Every module depends on:
```openscad
include <BOSL2/std.scad>
```

This provides:
- `cuboid()`, `cyl()`, `prismoid()`
- `diff()`, `tag()`
- `position()`, `attach()`
- `attachable()`
- Anchor constants

## Module-Specific Dependencies

### shell_monolithic()
- **File:** `modules/shells/monolithic.scad`
- **Depends on:** BOSL2 only
- **Used by:** Examples, presets

### faceplate_bezel()
- **File:** `modules/faces/bezel.scad`
- **Depends on:** BOSL2 only
- **Used by:** Examples, presets
- **Notes:** Contains inline steel pocket code

### faceplate_blank()
- **File:** `modules/faces/bezel.scad`
- **Depends on:** BOSL2 only
- **Used by:** Examples, presets
- **Notes:** Same file as faceplate_bezel()

### profile_rounded_rect()
- **File:** `modules/profiles/basic.scad`
- **Depends on:** BOSL2 `rect()`
- **Used by:** Examples using offset_sweep

### profile_wedge()
- **File:** `modules/profiles/basic.scad`
- **Depends on:** BOSL2 `round_corners()`
- **Used by:** Wedge shell examples

## Planned Dependencies

### Future: Standalone Hardware Modules
```
modules/hardware/magnet-pockets.scad
    └── magnet_pocket()
    └── steel_pocket()

modules/faces/bezel.scad
    └── faceplate_bezel()
        └── uses magnet_pocket()  # Future refactor
```

### Future: Board Mounting
```
modules/hardware/standoffs.scad
    └── standoff()
    └── heatset_boss()

modules/hardware/pi-mount.scad
    └── pi_mounting_holes()
        └── uses standoff()  # Depends on hardware
```

## External Library Dependencies

### Required
- **BOSL2** - All modules

### Optional (Future)
- **NopSCADlib** - PCB definitions
- **PiHoles** - Raspberry Pi mounting

These are not currently used but may be integrated for board-specific mounting.

## Circular Dependencies

**None currently.** Module design avoids circular dependencies.

**Rule:** Lower-level modules (profiles, hardware) should not depend on higher-level modules (shells, faceplates).

Hierarchy:
```
Level 0: BOSL2 (external)
Level 1: profiles/, hardware/ (basic building blocks)
Level 2: shells/, faces/ (composite modules)
Level 3: presets/ (complete designs)
```

## Import Patterns

### Standard Include
```openscad
include <BOSL2/std.scad>
```

### Module Use
```openscad
use <../shells/monolithic.scad>
```

### Preset Pattern
```openscad
include <BOSL2/std.scad>
use <../modules/shells/monolithic.scad>
use <../modules/faces/bezel.scad>
```

## Shared Code

Currently, no shared utility code exists between modules. Each module is self-contained.

**Future consideration:** Common utilities (like pocket position calculation) could be extracted to a shared file.

## Navigation

**Up:** [`index.md`](index.md) - Cross-domain overview

**Related:**
- [`interface-contracts.md`](interface-contracts.md) - How modules connect
- [`../planning/module-roadmap.md`](../planning/module-roadmap.md) - Planned modules

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Dependency Map
