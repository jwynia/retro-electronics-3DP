# NopSCADlib Integration

## Purpose
NopSCADlib provides hardware component definitions (PCBs, connectors, fasteners) so RetroCase doesn't need to model these from scratch.

## Classification
- **Domain:** External Libraries
- **Stability:** Stable
- **Abstraction:** Integration reference
- **Confidence:** Established

## Location
`lib/NopSCADlib/`

## Basic Usage

```openscad
include <BOSL2/std.scad>
include <NopSCADlib/lib.scad>
use <NopSCADlib/vitamins/pcb.scad>

// Render a Raspberry Pi 4
pcb(RPI4);

// Get PCB dimensions
dims = pcb_size(RPI4);  // [85, 56, 1.4]

// Get hole positions
holes = pcb_holes(RPI4);  // [[3.5, 3.5], [61.5, 3.5], ...]
```

## Available PCB Definitions

### Raspberry Pi
| Constant | Board | Size (mm) |
|----------|-------|-----------|
| `RPI0` | Pi Zero | 65 x 30 |
| `RPI3A` | Pi 3 A+ | 65 x 56 |
| `RPI3` | Pi 3 B/B+ | 85 x 56 |
| `RPI4` | Pi 4 | 85 x 56 |
| `RPI_Pico` | Pico | 51 x 21 |

### Arduino
| Constant | Board |
|----------|-------|
| `ArduinoUno3` | Arduino Uno R3 |
| `ArduinoNano` | Arduino Nano |
| `ArduinoLeonardo` | Arduino Leonardo |

### ESP/Other
| Constant | Board |
|----------|-------|
| `ESP32_DOIT_V1` | ESP32 DevKit |
| `BlackPill` | STM32 Black Pill |
| `Feather405` | Adafruit Feather |

## Key Functions

### PCB Information
```openscad
pcb_size(type)      // [length, width, thickness]
pcb_holes(type)     // [[x,y], [x,y], ...] hole positions
pcb_hole_d(type)    // hole diameter
pcb_land_d(type)    // landing pad diameter
pcb_name(type)      // human-readable name
```

### Rendering
```openscad
pcb(type)           // Full PCB with components
pcb_assembly(type)  // PCB + screws/standoffs
```

## Vitamins (Components)

NopSCADlib organizes components as "vitamins" - parts you buy, not print.

### Commonly Used
| File | Components |
|------|------------|
| `pcb.scad` | PCB boards |
| `screw.scad` | Screws (M2-M8) |
| `insert.scad` | Heat-set inserts |
| `standoff.scad` | PCB standoffs |
| `jack.scad` | Audio/barrel jacks |
| `usb.scad` | USB connectors |
| `hdmi.scad` | HDMI connectors |
| `display.scad` | LCD/OLED displays |

### Example: Standoffs
```openscad
use <NopSCADlib/vitamins/standoff.scad>

// M2.5 standoff, 10mm height
standoff(M2p5_standoff, 10);
```

### Example: Screws
```openscad
use <NopSCADlib/vitamins/screw.scad>

// M2.5 x 6mm pan head screw
screw(M2p5_pan_screw, 6);
```

## RetroCase Integration Patterns

### Pattern 1: Get Dimensions for Shell Sizing
```openscad
include <NopSCADlib/lib.scad>

// Size shell based on PCB
pcb_dims = pcb_size(RPI4);
shell_width = pcb_dims[0] + 20;   // PCB + margins
shell_height = pcb_dims[1] + 20;
shell_depth = 40;                  // Based on tallest component

shell_monolithic(size=[shell_width, shell_height, shell_depth], ...);
```

### Pattern 2: Generate Mounting Holes
```openscad
include <NopSCADlib/lib.scad>

module pi_mount_holes(pcb_type, depth=10) {
    for (pos = pcb_holes(pcb_type)) {
        translate([pos[0], pos[1], 0])
            cylinder(d=pcb_hole_d(pcb_type), h=depth);
    }
}
```

### Pattern 3: Connector Cutouts
```openscad
// Use NopSCADlib data to position cutouts
// Check vitamins/usb.scad, hdmi.scad for connector dimensions
```

## File Structure

```
lib/NopSCADlib/
├── lib.scad           # Main include file
├── core.scad          # Core utilities
├── global_defs.scad   # Global definitions
├── vitamins/          # Component definitions
│   ├── pcb.scad       # PCB module
│   ├── pcbs.scad      # PCB definitions
│   ├── screw.scad     # Screws
│   └── ...
├── printed/           # Printable part generators
├── utils/             # Utility functions
└── docs/              # Documentation
```

## Caveats

1. **Large library** - Include only what you need with `use` instead of `include`
2. **Render time** - Full PCB models are detailed; use for preview, simplify for final
3. **Coordinate system** - NopSCADlib PCBs are typically origin at corner, not center
4. **Updates** - Pin to specific commits for reproducibility

## Navigation

**Up:** [`index.md`](index.md) - External Libraries overview

**Related:**
- [`piholes.md`](piholes.md) - Simpler Pi-only alternative
- [`../hardware/`](../hardware/index.md) - RetroCase mounting patterns
- [`../../planning/hardware-targets.md`](../../planning/hardware-targets.md) - Target boards

## Metadata
- **Created:** 2025-12-22
- **Last Updated:** 2025-12-22
- **Document Type:** Integration Reference
