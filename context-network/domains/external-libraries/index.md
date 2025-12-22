# External Libraries Domain

## Purpose
Documentation for external OpenSCAD libraries used by RetroCase to avoid reinventing common components like PCB definitions, hardware specifications, and mounting patterns.

## Classification
- **Domain:** External Libraries
- **Stability:** Stable (external dependencies)
- **Abstraction:** Integration reference
- **Confidence:** Established

## Installed Libraries

### Location
All external libraries are git submodules in `lib/`:

```
lib/
├── BOSL2/            # Core geometry library (already documented)
├── NopSCADlib/       # Hardware components, PCBs, connectors
├── PiHoles/          # Raspberry Pi mounting positions
├── knurled-openscad/ # Knurled surface textures for knobs
└── battery_lib/      # Battery dimensions and models
```

## Library Overview

### 1. NopSCADlib
**Repository:** `nophead/NopSCADlib`

Comprehensive hardware library with 100+ component types:
- **PCB definitions** - Raspberry Pi (0, 3, 3A+, 4, Pico), Arduino, ESP32, etc.
- **Connectors** - USB, HDMI, barrel jacks, headers
- **Hardware** - Screws, nuts, standoffs, inserts
- **Displays** - LCDs, OLEDs, 7-segment
- **Motors** - Steppers, servos, blowers, fans

→ [`nopscadlib.md`](nopscadlib.md)

### 2. PiHoles
**Repository:** `daprice/PiHoles`

Lightweight Raspberry Pi mounting library:
- Board dimensions for all Pi models
- Mounting hole positions
- Simple snap-fit post generation
- Board preview for alignment

→ [`piholes.md`](piholes.md)

### 3. knurled-openscad
**Repository:** `smkent/knurled-openscad`

Knurled surface library for creating textured knobs and grips:
- Diamond knurl patterns
- Configurable depth, width, height
- Bevel options for edges
- Smoothing control

→ [`knurled-openscad.md`](knurled-openscad.md)

### 4. battery_lib
**Repository:** `kartchnb/battery_lib`

Battery dimensions library for compartment design:
- Tube batteries (AA, AAA, C, D, 18650, 21700)
- Rectangle batteries (9V)
- Button/coin cells (CR2032, LR44, etc.)
- Dimension functions for holder design

→ [`battery-lib.md`](battery-lib.md)

### 5. BOSL2
**Repository:** `BelfrySCAD/BOSL2`

Already documented in [`../bosl2-integration/`](../bosl2-integration/index.md)

## Integration Strategy

### Philosophy
RetroCase provides the **aesthetic layer** (shells, faceplates, design language). External libraries provide **technical data** (dimensions, hole positions, connector specs).

```
┌─────────────────────────────────────┐
│     RetroCase Aesthetic Layer       │
│  (shells, faceplates, profiles)     │
├─────────────────────────────────────┤
│        Integration Layer            │
│  (adapters, mounting modules)       │
├─────────────────────────────────────┤
│      External Libraries             │
│  (NopSCADlib, PiHoles, BOSL2)       │
└─────────────────────────────────────┘
```

### When to Use Each

| Need | Library | Example |
|------|---------|---------|
| Pi mounting holes | PiHoles | `piHoleLocations("3B")` |
| Full PCB model | NopSCADlib | `pcb(RPI4)` |
| Connector cutouts | NopSCADlib | USB, HDMI dimensions |
| Standoffs/screws | NopSCADlib | `screw()`, `standoff()` |
| Knurled knobs | knurled-openscad | `knurled_cylinder()` |
| Battery compartments | battery_lib | `BatteryLib_BodyDiameter("AA")` |
| Geometry operations | BOSL2 | `diff()`, `attach()`, `cuboid()` |

### Include Patterns

```openscad
// BOSL2 (always first)
include <BOSL2/std.scad>

// NopSCADlib (when needed)
include <NopSCADlib/lib.scad>
use <NopSCADlib/vitamins/pcb.scad>

// PiHoles (for simple Pi mounting)
use <PiHoles/PiHoles.scad>

// Knurled surfaces (for knobs)
use <knurled-openscad/knurled.scad>

// Battery dimensions (for compartments)
include <battery_lib/battery_lib.scad>
```

## Documents in This Domain

| Document | Purpose |
|----------|---------|
| [`nopscadlib.md`](nopscadlib.md) | NopSCADlib usage, PCB list, components |
| [`piholes.md`](piholes.md) | PiHoles usage, supported boards |
| [`knurled-openscad.md`](knurled-openscad.md) | Knurled cylinder generation for knobs |
| [`battery-lib.md`](battery-lib.md) | Battery dimensions for compartment design |

## Navigation

**Up:** [`../index.md`](../index.md) - All domains

**Related:**
- [`../bosl2-integration/`](../bosl2-integration/index.md) - BOSL2 library usage
- [`../hardware/`](../hardware/index.md) - RetroCase mounting patterns
- [`../../planning/hardware-targets.md`](../../planning/hardware-targets.md) - Target boards

## Metadata
- **Created:** 2025-12-22
- **Last Updated:** 2025-12-22
- **Document Type:** Domain Index
