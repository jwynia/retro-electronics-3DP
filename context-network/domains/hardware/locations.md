# Hardware - Code Locations

## Purpose
Index of where hardware-related code lives in the RetroCase codebase.

## Classification
- **Domain:** Hardware
- **Stability:** Dynamic (updates with code changes)
- **Abstraction:** Reference
- **Confidence:** Current as of 2025-12-21

## Module Files

### magnet-pockets.scad
- **File:** `modules/hardware/magnet-pockets.scad`
- **Status:** Referenced but not yet fully implemented
- **Purpose:** Magnet pocket generation utilities

## Inline Hardware Code

Most hardware features are currently inline in shell and faceplate modules:

### Steel Disc Pockets in Faceplate
- **File:** `modules/faces/bezel.scad`
- **Lines:** 92-99
- **What:** Loop creating four corner pockets for steel discs
- **Pattern:**
  ```openscad
  tag("remove")
  position(BOT)
  for (pos = pocket_positions) {
      translate([pos[0], pos[1], 0])
      cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
  }
  ```

### Pocket Position Calculation
- **File:** `modules/faces/bezel.scad`
- **Lines:** 60-65 (bezel) and 133-138 (blank)
- **What:** Four-corner position array
- **Pattern:**
  ```openscad
  pocket_positions = [
      [ width/2 - steel_inset,  height/2 - steel_inset],
      [-width/2 + steel_inset,  height/2 - steel_inset],
      [-width/2 + steel_inset, -height/2 + steel_inset],
      [ width/2 - steel_inset, -height/2 + steel_inset]
  ];
  ```

## Hardware Parameters in Modules

### faceplate_bezel() Hardware Params
- **File:** `modules/faces/bezel.scad`
- **Lines:** 42-46
- **Parameters:**
  ```openscad
  steel_pockets = true,  // Enable/disable pockets
  steel_inset = 12,      // Distance from corner
  steel_dia = 10,        // Disc diameter
  steel_depth = 1        // Pocket depth
  ```

### faceplate_blank() Hardware Params
- **File:** `modules/faces/bezel.scad`
- **Lines:** 121-125
- **Parameters:** Same as bezel

## Planned Module Locations

The following are planned but not yet implemented:

### standoff()
- **Planned file:** `modules/hardware/standoffs.scad`
- **Purpose:** PCB mounting standoffs

### heatset_boss()
- **Planned file:** `modules/hardware/standoffs.scad`
- **Purpose:** Heat-set insert mounting posts

### magnet_pocket()
- **Planned file:** `modules/hardware/magnet-pockets.scad`
- **Purpose:** Reusable magnet pocket shape

### steel_pocket()
- **Planned file:** `modules/hardware/magnet-pockets.scad`
- **Purpose:** Reusable steel disc pocket shape

## Example Usage

### Hardware Example (if exists)
- **File:** `examples/` (none specific to hardware yet)

## Shell-Side Hardware

Currently, magnet pockets in shells are not implemented. The shell_monolithic() module creates a lip rebate where magnet pockets would go, but the actual pocket generation is left for future implementation.

**Planned location:** Inside shell lip generation code in `modules/shells/monolithic.scad`

## Navigation

**Up:** [`index.md`](index.md) - Hardware domain overview

**Related Locations:**
- [`../faceplates/locations.md`](../faceplates/locations.md) - Steel pocket implementation
- [`../shells/locations.md`](../shells/locations.md) - Lip where magnets go

## Implementation Status

| Feature | Status | Location |
|---------|--------|----------|
| Steel disc pockets | Implemented | `modules/faces/bezel.scad:92-99` |
| Magnet pockets | Not yet | Planned for `modules/hardware/` |
| PCB standoffs | Not yet | Planned for `modules/hardware/` |
| Heat-set bosses | Not yet | Planned for `modules/hardware/` |

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Location Index
