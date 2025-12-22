# Bezel Faceplate Patterns

## Purpose
Face plates designed for screen/display mounting with proper bezels and mounting features.

## Classification
- **Domain:** Faceplates
- **Stability:** Established
- **Abstraction:** Pattern documentation
- **Confidence:** High

## What is a Bezel Faceplate?

A bezel faceplate is a front panel designed to:
- Frame a screen or display
- Hold the screen in place with a lip/edge
- Attach to a shell via magnetic connection
- Provide clean finished appearance

## Basic Structure

A bezel faceplate has three main features:

1. **Viewing Opening** - Through-hole for screen visibility
2. **Screen Pocket** - Recess on back for screen to sit in
3. **Steel Pockets** - For magnetic attachment to shell

## Viewing Opening Pattern

Creates the visible window through the faceplate:

```openscad
tag("remove")
position(TOP)
cuboid(
    [view_width, view_height, thickness + 1],
    rounding = corner_r,
    edges = "Z",
    anchor = TOP
);
```

**Key points:**
- Goes completely through (`thickness + 1` depth)
- Smaller than screen size (screen lip holds screen)
- Round vertical edges only (`edges = "Z"`)

## Screen Pocket Pattern

Creates recess on back for screen to sit in:

```openscad
tag("remove")
position(BOT)
cuboid(
    [screen_width, screen_height, screen_depth],
    rounding = corner_r + 1,
    edges = "Z",
    anchor = BOT
);
```

**Key points:**
- On back face (`position(BOT)`)
- Larger than viewing opening (creates holding lip)
- Depth accommodates screen + clearance
- Slightly larger rounding for easier screen insertion

## Steel Pocket Pattern

Creates pockets for steel discs (magnetic attachment):

```openscad
pocket_positions = [
    [ width/2 - inset,  height/2 - inset],
    [-width/2 + inset,  height/2 - inset],
    [-width/2 + inset, -height/2 + inset],
    [ width/2 - inset, -height/2 + inset]
];

tag("remove")
position(BOT)
for (pos = pocket_positions) {
    translate([pos[0], pos[1], 0])
    cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
}
```

**Key points:**
- Four corners, inset from edges
- On back face (same side as screen pocket)
- Slightly oversized for press-fit insertion
- Shallow depth (typically 1mm for steel discs)

## Dimension Calculations

### Viewing vs Screen Size
```
view_width  = screen_width - screen_lip * 2
view_height = screen_height - screen_lip * 2
```
Screen lip is typically 1.5-2mm - enough to hold screen but not obscure content.

### Faceplate vs Shell Opening
```
faceplate_width  = shell_opening_width + lip_width * 2
faceplate_height = shell_opening_height + lip_width * 2
```
Faceplate must be larger than shell opening to sit in the lip rebate.

### Pocket Positions
```
inset = 12  // Typical value
corner_x = width/2 - inset
corner_y = height/2 - inset
```
Inset should be enough to avoid edge weakness but visible for alignment.

## Complete Example

From `modules/faces/bezel.scad`:

```openscad
module faceplate_bezel(
    size,
    thickness = 4,
    corner_r = 8,
    screen_size,
    screen_corner_r = 3,
    screen_depth = 8,
    screen_lip = 1.5,
    steel_pockets = true,
    steel_inset = 12,
    steel_dia = 10,
    steel_depth = 1,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    width = size[0];
    height = size[1];
    screen_w = screen_size[0];
    screen_h = screen_size[1];

    view_w = screen_w - screen_lip * 2;
    view_h = screen_h - screen_lip * 2;

    // ... pocket position calculation ...

    attachable(anchor, spin, orient, size=[width, height, thickness]) {
        diff()
        cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {
            // Viewing opening
            tag("remove")
            position(TOP)
            cuboid([view_w, view_h, thickness + 1], rounding=screen_corner_r, edges="Z", anchor=TOP);

            // Screen pocket
            tag("remove")
            position(BOT)
            cuboid([screen_w, screen_h, screen_depth], rounding=screen_corner_r + 1, edges="Z", anchor=BOT);

            // Steel pockets
            if (steel_pockets) {
                tag("remove")
                position(BOT)
                for (pos = pocket_positions) {
                    translate([pos[0], pos[1], 0])
                    cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
                }
            }
        }
        children();
    }
}
```

## Navigation

**Up:** [`index.md`](index.md) - Faceplates domain overview

**Related:**
- [`blank-faceplates.md`](blank-faceplates.md) - Control panel faceplates
- [`../hardware/magnetic-attachment.md`](../hardware/magnetic-attachment.md) - Magnet system
- [`../shells/`](../shells/index.md) - Shells that accept faceplates

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain - Pattern Documentation
