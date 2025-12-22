# Hardware Domain

## Purpose
This domain covers hardware mounting solutions - magnetic attachment systems, standoffs, screw pockets, and internal mounting for electronics like Raspberry Pi, ESP32, and audio amplifiers.

## Classification
- **Domain:** Hardware and Mounting
- **Stability:** Core (fundamental to project)
- **Abstraction:** Detailed patterns
- **Confidence:** Established

## Documents

### [`magnetic-attachment.md`](magnetic-attachment.md)
**Magnet/Steel Disc System**

The primary closure mechanism for RetroCase - disc magnets paired with steel discs.

**Key topics:**
- Magnet pocket generation
- Steel disc pocket generation
- Alignment strategies
- Recommended magnet sizes

### [`mounting-hardware.md`](mounting-hardware.md)
**Standoffs and Mounting Features**

Internal mounting solutions for electronics.

**Key topics:**
- PCB standoff generation
- Screw pocket patterns
- Heat-set insert support
- Board-specific mounting (Pi, ESP32)

### [`locations.md`](locations.md)
**Code Location Index**

Maps hardware concepts to actual implementation files.

## Hardware Types

### Implemented
- **Magnet Pockets** - Cylindrical pockets for disc magnets
- **Steel Disc Pockets** - Shallow pockets for steel discs

### Planned
- **Standoffs** - PCB mounting posts
- **Screw Pockets** - Self-tapping screw receivers
- **Heat-Set Bosses** - Posts for M2/M3 heat-set inserts

## Key Patterns

### Magnet Pocket (in faceplate)
```openscad
tag("remove") position(corner)
    cyl(d=magnet_dia, h=magnet_depth, anchor=TOP);
```

### Steel Disc Pocket (in shell lip)
```openscad
tag("remove") position(corner)
    cyl(d=steel_dia, h=steel_depth, anchor=BOT);
```

### Standoff Pattern
```openscad
position(mount_point)
    diff()
    cyl(d=standoff_dia, h=standoff_height, anchor=BOT) {
        tag("remove") cyl(d=screw_dia, h=standoff_height, anchor=BOT);
    }
```

## Standard Specifications

### Magnets
| Type | Diameter | Depth | Pull Force |
|------|----------|-------|------------|
| Small | 6mm | 2mm | ~0.5kg |
| Medium | 8mm | 3mm | ~1kg |
| Large | 10mm | 3mm | ~1.5kg |

### Steel Discs
Match magnet diameter, 1mm depth typical.

## Navigation

**Up:** [`../index.md`](../index.md) - Domains overview

**Related Domains:**
- [`../shells/`](../shells/index.md) - Hardware mounts in shells
- [`../faceplates/`](../faceplates/index.md) - Hardware mounts in faceplates

**Related Documents:**
- [`../../decisions/002-magnetic-closure-design.md`](../../decisions/002-magnetic-closure-design.md) - Why magnetic attachment
- [`../../planning/hardware-targets.md`](../../planning/hardware-targets.md) - Target hardware platforms

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Domain Type:** Core structural domain
