# Faceplates - Code Locations

## Purpose
Index of where faceplate-related code lives in the RetroCase codebase.

## Classification
- **Domain:** Faceplates
- **Stability:** Dynamic (updates with code changes)
- **Abstraction:** Reference
- **Confidence:** Current as of 2025-12-21

## Module Files

### faceplate_bezel()
- **File:** `modules/faces/bezel.scad`
- **Lines:** 34-104
- **Purpose:** Face plate with screen bezel opening
- **Key features:**
  - Viewing opening (lines 72-79)
  - Screen mounting pocket (lines 82-89)
  - Steel disc pockets (lines 92-99)

### faceplate_blank()
- **File:** `modules/faces/bezel.scad`
- **Lines:** 117-157
- **Purpose:** Simple flat face plate for control panels
- **Key features:**
  - Optional steel disc pockets (lines 145-152)

### Default Constants
- **File:** `modules/faces/bezel.scad`
- **Lines:** 9-14
- **Values:**
  ```openscad
  _FACEPLATE_THICKNESS = 4
  _FACEPLATE_CORNER_R = 8
  _BEZEL_WIDTH = 10
  _SCREEN_LIP = 1.5
  _SCREEN_DEPTH = 8
  ```

## Example Files

### 05-faceplate-bezel.scad
- **File:** `examples/05-faceplate-bezel.scad`
- **Purpose:** Screen bezel demonstration
- **Demonstrates:** Complete bezel faceplate usage

## Key Implementation Details

### Viewing Opening
- **Location:** `modules/faces/bezel.scad:72-79`
- **What:** Through-hole for screen visibility
- **Pattern:**
  ```openscad
  tag("remove")
  position(TOP)
  cuboid([view_w, view_h, thickness + 1], rounding=screen_corner_r, edges="Z", anchor=TOP);
  ```

### Screen Pocket
- **Location:** `modules/faces/bezel.scad:82-89`
- **What:** Recess for screen to sit in
- **Pattern:**
  ```openscad
  tag("remove")
  position(BOT)
  cuboid([screen_w, screen_h, screen_depth], rounding=screen_corner_r + 1, edges="Z", anchor=BOT);
  ```

### Steel Pocket Loop
- **Location:** `modules/faces/bezel.scad:92-99`
- **What:** Four corner pockets for steel discs
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
- **Location:** `modules/faces/bezel.scad:60-65`
- **What:** Calculates four corner positions
- **Pattern:**
  ```openscad
  pocket_positions = [
      [ width/2 - steel_inset,  height/2 - steel_inset],
      [-width/2 + steel_inset,  height/2 - steel_inset],
      [-width/2 + steel_inset, -height/2 + steel_inset],
      [ width/2 - steel_inset, -height/2 + steel_inset]
  ];
  ```

### Attachable Wrapper
- **Location:** `modules/faces/bezel.scad:67`
- **What:** Makes faceplate work with BOSL2 attachment system
- **Note:** Anchored at CENTER (not BOT) for symmetric attachment

## Edge Rounding
- **Location:** `modules/faces/bezel.scad:69`
- **What:** `edges="Z"` for vertical edges only
- **Why:** Thin plates should only round vertical edges

## Test/Demo Code

### Bezel Demo
- **Location:** `modules/faces/bezel.scad:160-170`
- **What:** Preview block showing example bezel

## Navigation

**Up:** [`index.md`](index.md) - Faceplates domain overview

**Related Locations:**
- [`../shells/locations.md`](../shells/locations.md) - Shell code (faceplates fit into shells)
- [`../hardware/locations.md`](../hardware/locations.md) - Hardware mounting code

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Location Index
