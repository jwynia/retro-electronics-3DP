# Mounting Hardware

## Purpose
Documentation of standoffs, screw pockets, and internal mounting solutions for electronics.

## Classification
- **Domain:** Hardware
- **Stability:** Evolving (adding more patterns)
- **Abstraction:** Specification and pattern
- **Confidence:** Moderate (partial implementation)

## Overview

RetroCase supports internal mounting for common electronics:
- Raspberry Pi (Zero, 3, 4, 5)
- ESP32 development boards
- Arduino Uno/Nano
- Audio amplifier modules
- Custom PCBs

## Standoff Pattern

Basic standoff for PCB mounting:

```openscad
module standoff(
    height,
    outer_dia = 6,
    inner_dia = 2.5,  // For M2.5 self-tapping
    anchor = BOT
) {
    diff()
    cyl(d=outer_dia, h=height, anchor=anchor) {
        tag("remove")
        cyl(d=inner_dia, h=height + 1, anchor=anchor);
    }
}
```

**Parameters:**
- `height` - Distance from shell floor to PCB
- `outer_dia` - Standoff outer diameter (6mm typical)
- `inner_dia` - Hole for self-tapping screw

## Screw Hole Sizes

| Screw Type | Hole Diameter | Standoff Diameter |
|------------|---------------|-------------------|
| M2 self-tap | 1.8-2.0mm | 5mm |
| M2.5 self-tap | 2.2-2.5mm | 6mm |
| M3 self-tap | 2.7-3.0mm | 7mm |
| M2 heat-set | 3.0-3.2mm | 6mm |
| M3 heat-set | 4.0-4.2mm | 7mm |

## Heat-Set Insert Pattern

For stronger threads:

```openscad
module heatset_boss(
    height,
    insert_dia = 3.0,  // For M2 heat-set
    insert_depth = 4,
    outer_dia = 6,
    anchor = BOT
) {
    diff()
    cyl(d=outer_dia, h=height, anchor=anchor) {
        tag("remove")
        position(TOP)
        cyl(d=insert_dia, h=insert_depth + 0.5, anchor=TOP);
    }
}
```

## Board Mounting Patterns

### Raspberry Pi Mounting Holes

| Model | Hole Spacing | Hole Diameter |
|-------|--------------|---------------|
| Pi Zero | 58mm × 23mm | 2.75mm |
| Pi 3/4 | 58mm × 49mm | 2.75mm |
| Pi 5 | 58mm × 49mm | 2.75mm |

```openscad
pi_holes = [
    [0, 0],
    [58, 0],
    [58, 49],
    [0, 49]
];

for (pos = pi_holes) {
    translate([pos[0], pos[1], 0])
    standoff(height=5, outer_dia=6, inner_dia=2.5);
}
```

### ESP32 DevKit Mounting

Many ESP32 dev boards don't have mounting holes. Use clips instead:

```openscad
module pcb_clip(pcb_thickness = 1.6, height = 3) {
    // L-shaped clip that grips PCB edge
    diff()
    cuboid([4, 3, height + pcb_thickness + 1], anchor=BOT) {
        tag("remove")
        position(TOP+BACK)
        cuboid([5, 2, pcb_thickness + 0.5], anchor=TOP+BACK);
    }
}
```

### Arduino Uno Mounting

| Hole Position | X | Y |
|--------------|---|---|
| Bottom-left | 0 | 0 |
| Bottom-right | 50.8 | 0 |
| Top-left | 0 | 27.9 |
| Top-right | 50.8 | 27.9 |

Hole diameter: 3.2mm (for M3)

## Placement in Shell

Standoffs are positioned relative to shell interior:

```openscad
shell_monolithic(size, wall, ...) {
    // Position standoffs inside shell
    position(BOT)
    translate([board_offset_x, board_offset_y, wall])
    for (pos = board_holes) {
        translate([pos[0], pos[1], 0])
        standoff(height=standoff_height);
    }
}
```

## Clearance Considerations

### Component Clearance
Leave space below PCB for:
- Through-hole component leads (2-3mm)
- Solder joints (1-2mm)
- Airflow (optional)

**Minimum standoff height:** 5mm

### Cable Clearance
Consider cable routing:
- USB ports need 10-15mm clearance
- GPIO headers need 8-10mm for cables
- Power connectors vary by type

## External Libraries

For more precise mounting patterns:

- **NopSCADlib** - Comprehensive PCB definitions
- **PiHoles** - Raspberry Pi specific
- **SBC_Case_Builder** - Various SBC patterns

These are optional dependencies.

## Navigation

**Up:** [`index.md`](index.md) - Hardware domain overview

**Related:**
- [`magnetic-attachment.md`](magnetic-attachment.md) - Shell/faceplate connection
- [`../../planning/hardware-targets.md`](../../planning/hardware-targets.md) - Target platforms
- [`../shells/`](../shells/index.md) - Where hardware mounts

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain - Specification
