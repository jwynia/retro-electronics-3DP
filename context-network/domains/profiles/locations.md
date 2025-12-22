# Profiles - Code Locations

## Purpose
Index of where profile-related code lives in the RetroCase codebase.

## Classification
- **Domain:** Profiles
- **Stability:** Dynamic (updates with code changes)
- **Abstraction:** Reference
- **Confidence:** Current as of 2025-12-21

## Module Files

### basic.scad
- **File:** `modules/profiles/basic.scad`
- **Lines:** 1-61
- **Purpose:** Basic 2D profile generators
- **Contains:**
  - `profile_rounded_rect()` (lines 10-12)
  - `profile_wedge()` (lines 24-37)
  - `path_rounded_rect()` (lines 47-48)

## Individual Modules

### profile_rounded_rect()
- **File:** `modules/profiles/basic.scad`
- **Lines:** 10-12
- **Purpose:** Simple rounded rectangle wrapper
- **Implementation:**
  ```openscad
  module profile_rounded_rect(size, corner_r) {
      rect(size, rounding=corner_r);
  }
  ```

### profile_wedge()
- **File:** `modules/profiles/basic.scad`
- **Lines:** 24-37
- **Purpose:** Trapezoidal profile for tapered shapes
- **Key features:**
  - Accepts different top and bottom widths
  - Optional corner rounding using `round_corners()`
  - Uses raw `polygon()` for base shape

### path_rounded_rect()
- **File:** `modules/profiles/basic.scad`
- **Lines:** 47-48
- **Purpose:** Returns path for use with `offset_sweep()`
- **Implementation:**
  ```openscad
  function path_rounded_rect(size, corner_r) =
      rect(size, rounding=corner_r, $fn=32);
  ```

## Example Files

### Profile demo in basic.scad
- **File:** `modules/profiles/basic.scad`
- **Lines:** 50-60
- **Purpose:** Preview showing both profile types
- **Shows:**
  - Rounded rectangle extruded
  - Wedge extruded
  - Side-by-side comparison

### 06-offset-sweep-shell.scad
- **File:** `examples/06-offset-sweep-shell.scad`
- **Purpose:** Shell using offset_sweep with profiles
- **Demonstrates:** Using path functions with offset_sweep()

## BOSL2 Functions Used

The profile modules use these BOSL2 functions:

### rect()
- **BOSL2 location:** `std.scad`
- **Used at:** `modules/profiles/basic.scad:11, 48`
- **Purpose:** Create rounded rectangle shape/path

### round_corners()
- **BOSL2 location:** `rounding.scad`
- **Used at:** `modules/profiles/basic.scad:33`
- **Purpose:** Apply corner rounding to polygon points

### polygon()
- **OpenSCAD built-in**
- **Used at:** `modules/profiles/basic.scad:33, 35`
- **Purpose:** Create 2D shape from points

## Profile Usage Locations

Profiles are used in:

### examples/06-offset-sweep-shell.scad
- Uses `path_rounded_rect()` with `offset_sweep()`

### examples/02-wedge-shell.scad
- May use `profile_wedge()` pattern (verify implementation)

## Navigation

**Up:** [`index.md`](index.md) - Profiles domain overview

**Related Locations:**
- [`../shells/locations.md`](../shells/locations.md) - Shells may use profiles
- [`../bosl2-integration/locations.md`](../bosl2-integration/locations.md) - BOSL2 usage

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Location Index
