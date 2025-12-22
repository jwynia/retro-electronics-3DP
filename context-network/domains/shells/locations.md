# Shells - Code Locations

## Purpose
Index of where shell-related code lives in the RetroCase codebase.

## Classification
- **Domain:** Shells
- **Stability:** Dynamic (updates with code changes)
- **Abstraction:** Reference
- **Confidence:** Current as of 2025-12-21

## Module Files

### shell_monolithic()
- **File:** `modules/shells/monolithic.scad`
- **Lines:** 28-94
- **Purpose:** Single-piece hollow shell with optional opening and lip
- **Key features:**
  - Attachable module (lines 55-93)
  - Hollow interior (lines 59-66)
  - Optional lip rebate (lines 69-77)
  - Optional front opening (lines 80-89)

### shell_wedge()
- **File:** `modules/shells/wedge.scad`
- **Lines:** 32-81
- **Purpose:** Tapered shell with configurable taper direction
- **Key features:**
  - Two taper styles: "top" (vertical taper) and "front" (raked face)
  - Attachable module with full BOSL2 support
  - Hollow interior with consistent wall thickness
  - Optional opening and lip rebate
- **Taper styles:**
  - `taper_style="top"` - narrower at top, wider at bottom
  - `taper_style="front"` - raked front face (Braun RT 20 style)

### Default Constants
- **File:** `modules/shells/monolithic.scad`
- **Lines:** 6-10
- **Values:**
  ```openscad
  _SHELL_WALL = 3
  _SHELL_CORNER_RADIUS = 10
  _SHELL_LIP_DEPTH = 3
  _SHELL_LIP_INSET = 1.5
  ```

- **File:** `modules/shells/wedge.scad`
- **Lines:** 7-12
- **Values:**
  ```openscad
  _SHELL_WALL = 3
  _SHELL_CORNER_RADIUS = 10
  _SHELL_LIP_DEPTH = 3
  _SHELL_LIP_INSET = 1.5
  _SHELL_TAPER = 0.75
  ```

## Example Files

### 01-basic-rounded-box.scad
- **File:** `examples/01-basic-rounded-box.scad`
- **Purpose:** Simplest cuboid with rounding
- **Demonstrates:** Basic BOSL2 cuboid usage

### 02-wedge-shell.scad
- **File:** `examples/02-wedge-shell.scad`
- **Purpose:** Prismoid-based tapered shell
- **Demonstrates:** Using prismoid() for wedge shapes

### 03-hollow-shell-with-lip.scad
- **File:** `examples/03-hollow-shell-with-lip.scad`
- **Purpose:** Complete hollow shell ready for face plate
- **Demonstrates:** Full hollowing pattern with lip

### 04-shell-with-cutout.scad
- **File:** `examples/04-shell-with-cutout.scad`
- **Purpose:** Shell with front opening
- **Demonstrates:** Opening cutout pattern

### 08-wedge-shell-module.scad
- **File:** `examples/08-wedge-shell-module.scad`
- **Purpose:** Comprehensive wedge shell demonstrations
- **Demonstrates:**
  - shell_wedge() with both taper styles
  - Various taper ratios
  - With and without openings

## Key Implementation Details

### Hollowing Pattern
- **Location:** `modules/shells/monolithic.scad:59-66`
- **What:** Creates hollow interior by subtracting inner cuboid
- **Pattern:**
  ```openscad
  tag("remove")
  position(TOP)
  cuboid([inner_w, inner_h, depth - wall], rounding=inner_r, anchor=TOP);
  ```

### Lip Rebate Pattern
- **Location:** `modules/shells/monolithic.scad:69-77`
- **What:** Creates shallow step for face plate seating
- **Pattern:**
  ```openscad
  tag("remove")
  position(TOP)
  cuboid([lip_w, lip_h, lip_depth + 0.01], rounding=lip_r, anchor=TOP);
  ```

### Front Opening Pattern
- **Location:** `modules/shells/monolithic.scad:80-89`
- **What:** Cuts through front wall
- **Pattern:**
  ```openscad
  tag("remove")
  position(FWD)
  cuboid([opening[0], wall + 1, opening[1]], rounding=opening_r, edges="Y", anchor=FWD);
  ```

### Attachable Wrapper
- **Location:** `modules/shells/monolithic.scad:55`
- **What:** Makes shell work with BOSL2 attachment system
- **Pattern:**
  ```openscad
  attachable(anchor, spin, orient, size=size) { ... children(); }
  ```

## Test/Demo Code

### Shell Demo
- **Location:** `modules/shells/monolithic.scad:96-106`
- **What:** Preview block showing example shell
- **Usage:** Visible in OpenSCAD preview mode

## Navigation

**Up:** [`index.md`](index.md) - Shells domain overview

**Related Locations:**
- [`../bosl2-integration/locations.md`](../bosl2-integration/locations.md) - BOSL2 pattern usage
- [`../faceplates/locations.md`](../faceplates/locations.md) - Face plate code

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Location Index
