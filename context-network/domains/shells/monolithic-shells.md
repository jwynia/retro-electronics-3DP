# Monolithic Shell Patterns

## Purpose
Techniques for generating single-piece hollow shells - the primary enclosure type in RetroCase.

## Classification
- **Domain:** Shells
- **Stability:** Established
- **Abstraction:** Pattern documentation
- **Confidence:** High

## What is a Monolithic Shell?

A monolithic shell is a single-piece hollow enclosure with:
- Solid walls on all sides
- Hollow interior cavity
- Optional front opening for face plate
- Optional lip/rebate for face plate seating

This is the simplest shell type and the foundation for most RetroCase designs.

## Basic Hollow Shell

The fundamental pattern for creating a hollow box:

```openscad
diff()
cuboid([width, depth, height], rounding=corner_r, anchor=BOT) {
    tag("remove")
    position(TOP)
    cuboid([width-wall*2, depth-wall*2, height-wall], rounding=corner_r-wall, anchor=TOP);
}
```

**Key concepts:**
- Outer shape defines exterior dimensions
- Inner shape is smaller by wall thickness × 2 on each axis
- Inner shape positioned at TOP, anchored TOP (hollows from above)
- Inner rounding is smaller to maintain wall thickness at corners

## Shell with Front Opening

Adding a face plate opening:

```openscad
diff()
cuboid([width, depth, height], rounding=corner_r, anchor=BOT) {
    // Main cavity
    tag("remove")
    position(TOP)
    cuboid([width-wall*2, depth-wall*2, height-wall], anchor=TOP);

    // Front opening
    tag("remove")
    position(FWD)
    cuboid([opening_w, wall*2, opening_h], rounding=opening_r, edges="Y", anchor=FWD);
}
```

**Key concepts:**
- Opening cutout goes through front wall (`wall*2` depth ensures full cut)
- Round only Y-parallel edges (horizontal edges of opening)
- Anchor at FWD so cutout extends into shell

## Shell with Lip Rebate

Adding a step/rebate for face plate to sit in:

```openscad
diff()
cuboid([width, depth, height], rounding=corner_r, anchor=BOT) {
    // Main cavity
    tag("remove")
    position(TOP)
    cuboid([inner_w, inner_d, height-wall], anchor=TOP);

    // Lip rebate (shallow, wider than opening)
    tag("remove")
    position(TOP)
    cuboid([lip_w, lip_d, lip_depth], rounding=lip_r, anchor=TOP);

    // Front opening (through the lip)
    tag("remove")
    position(FWD)
    cuboid([opening_w, wall*2, opening_h], anchor=FWD);
}
```

**Key concepts:**
- Lip rebate is wider than opening (creates the lip edge)
- Lip is shallow (just enough for face plate thickness)
- Opening cuts through the lip area

## Dimension Calculations

### Interior Dimensions
```
inner_width  = width - wall * 2
inner_depth  = depth - wall * 2
inner_height = height - wall
```

### Opening Dimensions
```
max_opening_width  = width - wall * 2 - min_edge * 2
max_opening_height = height - wall - min_edge * 2
```

### Lip Dimensions
```
lip_width  = opening_width + lip_edge * 2
lip_depth  = faceplate_thickness + clearance
```

### Rounding Preservation
```
inner_corner_r = max(1, corner_r - wall)
lip_corner_r   = max(1, corner_r - lip_inset)
```

## Complete Example

From `modules/shells/monolithic.scad`:

```openscad
module shell_monolithic(
    size,
    wall = 3,
    corner_r = 10,
    opening = undef,
    opening_r = 5,
    lip_depth = 3,
    lip_inset = 1.5,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    width = size[0];
    height = size[1];
    depth = size[2];

    inner_w = width - wall * 2;
    inner_h = height - wall * 2;
    inner_r = max(1, corner_r - wall);

    lip_w = width - lip_inset * 2;
    lip_h = height - lip_inset * 2;
    lip_r = max(1, corner_r - lip_inset);

    has_opening = !is_undef(opening);

    attachable(anchor, spin, orient, size=size) {
        diff()
        cuboid(size, rounding=corner_r, anchor=CENTER) {
            // Main cavity
            tag("remove")
            position(TOP)
            cuboid([inner_w, inner_h, depth - wall], rounding=inner_r, anchor=TOP);

            // Lip rebate
            if (has_opening) {
                tag("remove")
                position(TOP)
                cuboid([lip_w, lip_h, lip_depth + 0.01], rounding=lip_r, anchor=TOP);
            }

            // Front opening
            if (has_opening) {
                tag("remove")
                position(FWD)
                cuboid([opening[0], wall + 1, opening[1]], rounding=opening_r, edges="Y", anchor=FWD);
            }
        }

        children();
    }
}
```

## Navigation

**Up:** [`index.md`](index.md) - Shells domain overview

**Related:**
- [`shell-parameters.md`](shell-parameters.md) - Parameter reference
- [`locations.md`](locations.md) - Code locations
- [`../bosl2-integration/idioms.md`](../bosl2-integration/idioms.md) - BOSL2 patterns used

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain - Pattern Documentation
