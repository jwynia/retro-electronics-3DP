# Blank Faceplate Patterns

## Purpose
Solid face plates for control panel builds - a base for adding knobs, switches, buttons, and other controls.

## Classification
- **Domain:** Faceplates
- **Stability:** Established
- **Abstraction:** Pattern documentation
- **Confidence:** High

## What is a Blank Faceplate?

A blank faceplate is a simple flat panel that:
- Fits into a shell's lip rebate
- Attaches via magnetic connection
- Serves as a base for custom cutouts
- Can be used as-is for a closed cover

## Basic Structure

A blank faceplate has minimal features:

1. **Solid body** - Flat plate matching shell opening + lip
2. **Steel pockets** - For magnetic attachment
3. **No screen opening** - User adds custom cutouts

## Basic Pattern

```openscad
diff()
cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {
    // Steel disc pockets
    if (steel_pockets) {
        tag("remove")
        position(BOT)
        for (pos = pocket_positions) {
            translate([pos[0], pos[1], 0])
            cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
        }
    }
}
```

**Key points:**
- Simple cuboid with only vertical edge rounding
- Optional steel pockets on back
- No through-holes by default

## Adding Control Cutouts

Blank faceplates are designed to be extended with custom cutouts:

### Button Hole
```openscad
faceplate_blank(size, thickness) {
    // Add button hole
    tag("remove")
    position(CENTER)
    cyl(d=button_dia, h=thickness + 1, anchor=CENTER);
}
```

### Toggle Switch Slot
```openscad
faceplate_blank(size, thickness) {
    tag("remove")
    position(CENTER)
    cuboid([switch_width, switch_height, thickness + 1], anchor=CENTER);
}
```

### Knob Hole with Shaft Clearance
```openscad
faceplate_blank(size, thickness) {
    tag("remove")
    position(CENTER)
    cyl(d=knob_shaft_dia + 0.5, h=thickness + 1, anchor=CENTER);
}
```

## Grid Layout Pattern

For control panels with multiple controls:

```openscad
control_positions = [
    [-30, 20, "button"],
    [0, 20, "knob"],
    [30, 20, "button"],
    [-30, -20, "toggle"],
    [30, -20, "toggle"]
];

faceplate_blank(size, thickness) {
    for (ctrl = control_positions) {
        if (ctrl[2] == "button") {
            tag("remove")
            translate([ctrl[0], ctrl[1], 0])
            cyl(d=12, h=thickness + 1);
        }
        if (ctrl[2] == "knob") {
            tag("remove")
            translate([ctrl[0], ctrl[1], 0])
            cyl(d=7, h=thickness + 1);
        }
        if (ctrl[2] == "toggle") {
            tag("remove")
            translate([ctrl[0], ctrl[1], 0])
            cuboid([6, 12, thickness + 1]);
        }
    }
}
```

## Complete Example

From `modules/faces/bezel.scad`:

```openscad
module faceplate_blank(
    size,
    thickness = 4,
    corner_r = 8,
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

    pocket_positions = [
        [ width/2 - steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset, -height/2 + steel_inset],
        [ width/2 - steel_inset, -height/2 + steel_inset]
    ];

    attachable(anchor, spin, orient, size=[width, height, thickness]) {
        diff()
        cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {
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

## Usage as Base

The blank faceplate is designed to be used as a starting point:

```openscad
// Method 1: Use diff() around the module call
diff()
faceplate_blank([140, 95], 4) {
    // Your custom cutouts here
    tag("remove") position(CENTER) cyl(d=20, h=10);
}

// Method 2: Create a derived module
module my_control_panel() {
    diff()
    faceplate_blank([140, 95], 4) {
        tag("remove")
        position(LEFT+CENTER)
        translate([20, 0, 0])
        cyl(d=15, h=10);
    }
}
```

## Navigation

**Up:** [`index.md`](index.md) - Faceplates domain overview

**Related:**
- [`bezel-faceplates.md`](bezel-faceplates.md) - Screen bezel faceplates
- [`../hardware/magnetic-attachment.md`](../hardware/magnetic-attachment.md) - Magnet system
- [`../../planning/preset-catalog.md`](../../planning/preset-catalog.md) - Preset control panel designs

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain - Pattern Documentation
