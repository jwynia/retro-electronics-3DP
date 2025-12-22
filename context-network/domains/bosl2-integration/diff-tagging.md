# Geometric Operations with diff() and tag()

## Purpose
How RetroCase uses BOSL2's tag-based boolean operations instead of raw `difference()`.

## Classification
- **Domain:** BOSL2 Integration
- **Stability:** Stable (core pattern)
- **Abstraction:** Conceptual and practical
- **Confidence:** Established

## Why Not Use difference()?

Traditional OpenSCAD:
```openscad
difference() {
    cuboid([100, 80, 60]);
    translate([0, 0, 3])
    cuboid([94, 74, 60]);
}
```

Problems:
1. Manual positioning with `translate()` is fragile
2. Doesn't work well with attachment system
3. Children can't be conditionally included/excluded easily

## The Tag-Based Approach

BOSL2 solution:
```openscad
diff()
cuboid([100, 80, 60], anchor=BOT) {
    tag("remove")
    position(TOP)
    cuboid([94, 74, 60], anchor=TOP);
}
```

Benefits:
1. Positioning uses attachment system
2. All geometry maintains proper relationships
3. Tags can be conditionally applied

## How diff() Works

### Basic Pattern
```openscad
diff()
parent_shape() {
    tag("remove") child_to_subtract();
    tag("keep") child_to_keep();
    untagged_children();  // Also kept
}
```

### Tag Types
| Tag | Effect |
|-----|--------|
| `"remove"` | Subtracted from parent |
| `"keep"` | Kept regardless of nesting |
| (none) | Kept by default |

### What Gets Subtracted

Only immediate children with `tag("remove")` are subtracted:

```openscad
diff()
cuboid(100) {
    // This is subtracted
    tag("remove") cyl(d=20, h=50);

    // This is kept (no tag)
    cyl(d=10, h=50);

    // This is explicitly kept
    tag("keep") cyl(d=5, h=50);
}
```

## Multiple Subtractions

All `tag("remove")` children are subtracted together:

```openscad
diff()
cuboid([100, 80, 60], rounding=8, anchor=BOT) {
    // Main cavity
    tag("remove")
    position(TOP)
    cuboid([94, 74, 55], anchor=TOP);

    // Lip rebate
    tag("remove")
    position(TOP)
    cuboid([97, 77, 3], anchor=TOP);

    // Front opening
    tag("remove")
    position(FWD)
    cuboid([80, 10, 50], anchor=FWD);
}
```

All three shapes are subtracted from the main cuboid.

## Conditional Subtractions

Tags work with conditionals:

```openscad
diff()
cuboid(size) {
    // Always subtracted: main cavity
    tag("remove")
    position(TOP)
    cuboid(inner_size, anchor=TOP);

    // Conditionally subtracted: opening
    if (has_opening) {
        tag("remove")
        position(FWD)
        cuboid(opening_size, anchor=FWD);
    }

    // Conditionally subtracted: lip
    if (has_lip) {
        tag("remove")
        position(TOP)
        cuboid(lip_size, anchor=TOP);
    }
}
```

## Loops and Tags

Tags work in loops for repetitive subtractions:

```openscad
pocket_positions = [
    [ 50,  50],
    [-50,  50],
    [-50, -50],
    [ 50, -50]
];

diff()
cuboid([150, 150, 10]) {
    tag("remove")
    for (pos = pocket_positions) {
        translate([pos[0], pos[1], 0])
        cyl(d=10, h=15, anchor=BOT);
    }
}
```

Note: The `tag("remove")` is outside the `for` loop but still applies to all iterations.

## Nested Operations

For complex shapes requiring multiple boolean operations:

```openscad
diff()
main_shape() {
    tag("remove")
    diff()  // Nested diff for complex subtraction shape
    outer_cut() {
        tag("keep")  // This part stays in the cut
        inner_feature();
    }
}
```

This is advanced - prefer simple patterns when possible.

## Common Mistakes

### Missing diff() Wrapper
```openscad
// WRONG: Tags are ignored
cuboid(50) {
    tag("remove") cyl(d=20, h=50);
}

// RIGHT: Tags are processed
diff()
cuboid(50) {
    tag("remove") cyl(d=20, h=50);
}
```

### Tag Outside Parent
```openscad
// WRONG: Tag must be inside diff() children
tag("remove") cyl(d=20, h=50);
diff()
cuboid(50);

// RIGHT: Tag is child of parent shape
diff()
cuboid(50) {
    tag("remove") cyl(d=20, h=50);
}
```

## Known Limitation: Preview Artifacts with Overlapping Removes

**Important:** When multiple `tag("remove")` volumes overlap or share faces, OpenSCAD's preview rendering can produce severe z-fighting artifacts (flickering, scattered fragments).

**Example that causes problems:**
```openscad
diff()
shell_body() {
    tag("remove") interior_cavity();   // Large internal void
    tag("remove") front_opening();      // Cuts through front into cavity
}
// Preview may show glitchy rendering where opening meets cavity
```

**The STL output may still be correct**, but the preview is unreliable.

**Solutions:**
1. Use `difference()` instead of `diff()` for complex booleans
2. Use F6 (full CGAL render) in OpenSCAD to verify geometry
3. Export STL and check in another viewer

**When to prefer `difference()` over `diff()`:**
- Multiple overlapping remove volumes
- Remove volumes that intersect with rounded surfaces
- Complex shells with openings that cut into hollowed interiors

See [`common-mistakes.md`](common-mistakes.md) for detailed examples.

## Navigation

**Up:** [`index.md`](index.md) - BOSL2 Integration overview

**Related:**
- [`attachment-system.md`](attachment-system.md) - Positioning for subtractions
- [`idioms.md`](idioms.md) - Common patterns
- [`common-mistakes.md`](common-mistakes.md) - What to avoid

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain - Conceptual
