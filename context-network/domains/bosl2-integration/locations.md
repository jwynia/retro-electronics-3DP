# BOSL2 Integration - Code Locations

## Purpose
Index of where BOSL2 patterns are used in the RetroCase codebase.

## Classification
- **Domain:** BOSL2 Integration
- **Stability:** Dynamic (updates with code changes)
- **Abstraction:** Reference
- **Confidence:** Current as of 2025-12-21

## Attachable Module Pattern

### shell_monolithic()
- **Where:** `modules/shells/monolithic.scad:55-93`
- **What:** Full attachable module with diff() and multiple tag("remove")
- **Shows:** Attachable wrapper, hollowing, conditional geometry

### faceplate_bezel()
- **Where:** `modules/faces/bezel.scad:67-104`
- **What:** Attachable faceplate with screen opening and steel pockets
- **Shows:** Attachable wrapper, edges="Z" rounding, loop-based pockets

### faceplate_blank()
- **Where:** `modules/faces/bezel.scad:140-157`
- **What:** Simple attachable plate
- **Shows:** Minimal attachable pattern

## diff() and tag("remove") Usage

### Main Cavity Hollowing
- **Where:** `modules/shells/monolithic.scad:59-66`
- **Pattern:**
  ```openscad
  tag("remove")
  position(TOP)
  cuboid([inner_w, inner_h, depth - wall], rounding=inner_r, anchor=TOP);
  ```

### Lip Rebate
- **Where:** `modules/shells/monolithic.scad:69-77`
- **Pattern:** Conditional subtraction for face plate seating

### Screen Opening
- **Where:** `modules/faces/bezel.scad:72-79`
- **Pattern:** Through-hole for screen visibility

### Screen Pocket
- **Where:** `modules/faces/bezel.scad:82-89`
- **Pattern:** Partial-depth pocket for screen mounting

### Steel Disc Pockets
- **Where:** `modules/faces/bezel.scad:92-99`
- **Pattern:** Loop-based pocket creation at corners

## Edge Specification Examples

### Vertical Edges Only (edges="Z")
- **Where:** `modules/faces/bezel.scad:69`
- **What:** `cuboid([w, h, t], rounding=r, edges="Z")`
- **Why:** Thin plates should only round vertical edges

### Y-Parallel Edges (edges="Y")
- **Where:** `modules/shells/monolithic.scad:86`
- **What:** Opening cutout rounds edges perpendicular to cut direction

## Anchor Usage

### anchor=BOT for Shells
- **Where:** `modules/shells/monolithic.scad:55`
- **Why:** Shell sits on build plate, anchor at bottom

### anchor=CENTER for Faceplates
- **Where:** `modules/faces/bezel.scad:67`
- **Why:** Symmetric attachment from either side

### anchor=TOP for Inner Cavities
- **Where:** `modules/shells/monolithic.scad:65`
- **Why:** Cavity extends down from top, matching position(TOP)

## position() Usage

### position(TOP) for Cavities
- **Where:** `modules/shells/monolithic.scad:61`
- **What:** Places inner shape at top of parent for hollowing

### position(FWD) for Front Opening
- **Where:** `modules/shells/monolithic.scad:82`
- **What:** Places cutout at front face

### position(BOT) for Pockets
- **Where:** `modules/faces/bezel.scad:94`
- **What:** Places pockets at bottom (back) of faceplate

## Loop Patterns with Tags

### Corner Pocket Loop
- **Where:** `modules/faces/bezel.scad:92-99`
- **Pattern:**
  ```openscad
  tag("remove")
  position(BOT)
  for (pos = pocket_positions) {
      translate([pos[0], pos[1], 0])
      cyl(d=steel_dia, h=steel_depth, anchor=BOT);
  }
  ```
- **Note:** Tag is outside loop, applies to all iterations

## Conditional Geometry

### Optional Opening
- **Where:** `modules/shells/monolithic.scad:69-89`
- **Pattern:**
  ```openscad
  if (has_opening) {
      tag("remove") ...
  }
  ```

### Optional Steel Pockets
- **Where:** `modules/faces/bezel.scad:92`
- **Pattern:** `if (steel_pockets) { ... }`

## Navigation

**Up:** [`index.md`](index.md) - BOSL2 Integration overview

**Related Locations:**
- [`../shells/locations.md`](../shells/locations.md) - Shell module locations
- [`../faceplates/locations.md`](../faceplates/locations.md) - Faceplate module locations

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Location Index
