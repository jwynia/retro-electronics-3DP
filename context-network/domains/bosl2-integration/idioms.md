# BOSL2 Idioms This Project Uses

## Purpose
Standard patterns used throughout RetroCase. Copy these patterns for consistent, working code.

## Classification
- **Domain:** BOSL2 Integration
- **Stability:** Stable (established patterns)
- **Abstraction:** Practical examples
- **Confidence:** Established

## Core Idioms

### 1. Hollowing a Shape

Create a hollow shell by subtracting a smaller inner shape from a larger outer shape.

```openscad
diff()
cuboid([100, 80, 60], rounding=8, anchor=BOT) {
    tag("remove")
    position(TOP)
    cuboid([100-6, 80-6, 60], rounding=5, anchor=TOP);
}
```

**Key points:**
- Inner shape is slightly smaller (wall thickness × 2)
- Inner rounding is smaller (corner_radius - wall)
- Inner shape anchored at TOP, positioned at TOP
- This hollows from above, leaving bottom solid

**Used in:** `shell_monolithic()` at `modules/shells/monolithic.scad:56-66`

### 2. Positioning Children

Place a child shape relative to a parent using anchor positions.

```openscad
cuboid([50, 40, 30])
    position(TOP+RIGHT) cyl(d=10, h=5, anchor=BOT);
```

**Key points:**
- `position(X)` places child at parent's X anchor
- Child keeps its own orientation
- Child's anchor determines which point touches the position

**Variations:**
```openscad
position(TOP)           // Center of top face
position(TOP+RIGHT)     // Center of right edge on top
position(TOP+RIGHT+FWD) // Front-right corner on top
```

### 3. Subtracting Attached Shapes

Cut a hole that follows the parent's surface.

```openscad
diff()
cuboid(50) {
    tag("remove") attach(TOP) cyl(d=20, h=10, anchor=BOT);
}
```

**Key points:**
- `attach()` positions AND orients to face outward
- Cylinder points away from surface
- Anchor=BOT means cylinder base is at surface

**Used in:** Screen opening in `faceplate_bezel()` at `modules/faces/bezel.scad:72-79`

### 4. Creating Attachable Modules

Make your module work with the attachment system.

```openscad
module my_shape(size, anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor, spin, orient, size=size) {
        // Your geometry here
        cuboid(size);

        children();  // Required for attachment to work
    }
}
```

**Key points:**
- Accept `anchor`, `spin`, `orient` parameters
- Wrap geometry in `attachable()`
- Call `children()` after geometry

**Used in:** All shell and faceplate modules

### 5. Nested diff() Operations

Handle multiple levels of boolean operations.

```openscad
diff()
cuboid([100, 80, 60], rounding=8, anchor=BOT) {
    // First subtraction: main cavity
    tag("remove")
    position(TOP)
    cuboid([94, 74, 55], rounding=5, anchor=TOP);

    // Second subtraction: lip rebate
    tag("remove")
    position(TOP)
    cuboid([97, 77, 3], rounding=7, anchor=TOP);

    // Third subtraction: front opening
    tag("remove")
    position(FWD)
    cuboid([80, 10, 50], anchor=FWD);
}
```

**Key points:**
- All `tag("remove")` shapes are subtracted from parent
- Order of subtraction doesn't matter for most cases
- All subtractions happen in a single `diff()` block

**Used in:** `shell_monolithic()` with opening and lip

### 6. Steel/Magnet Pocket Pattern

Create pockets for magnets or steel discs at corners.

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
    cyl(d=pocket_dia + 0.3, h=pocket_depth + 0.1, anchor=BOT, $fn=32);
}
```

**Key points:**
- Calculate positions as offsets from center
- Add small clearance (0.3mm) for press fit
- Use `$fn=32` for smooth circles
- All pockets in single `tag("remove")` block

**Used in:** `faceplate_bezel()` at `modules/faces/bezel.scad:91-99`

### 7. Conditional Geometry

Include or exclude geometry based on parameters.

```openscad
diff()
cuboid(size) {
    if (has_opening) {
        tag("remove")
        position(FWD)
        cuboid([opening_w, wall*2, opening_h], anchor=FWD);
    }
}
```

**Key points:**
- Conditionals work inside `diff()` blocks
- Tagged shapes only exist when condition is true

**Used in:** `shell_monolithic()` for optional opening

## Navigation

**Up:** [`index.md`](index.md) - BOSL2 Integration overview

**Related:**
- [`common-mistakes.md`](common-mistakes.md) - What not to do
- [`attachment-system.md`](attachment-system.md) - How attachments work
- [`diff-tagging.md`](diff-tagging.md) - Boolean operations
- [`../parametric-patterns/bosl2-advanced.md`](../parametric-patterns/bosl2-advanced.md) - Advanced BOSL2 patterns (grid_copies, paths, sweep)

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain - Patterns
