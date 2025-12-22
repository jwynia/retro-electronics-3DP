# Common BOSL2 Mistakes and Solutions

## Purpose
A catalog of common mistakes when using BOSL2 in RetroCase, with corrections and explanations.

## Classification
- **Domain:** BOSL2 Integration
- **Stability:** Stable (known patterns)
- **Abstraction:** Practical examples
- **Confidence:** Established

## Quick Reference Table

| Wrong | Right | Why |
|-------|-------|-----|
| `pos.x, pos.y` | `pos[0], pos[1]` | OpenSCAD has no dot notation |
| `edges=["front"]` | `edges=FWD` or `edges="Y"` | Edge specs use constants or axis strings |
| `difference() { ... }` | `diff() { tag("remove") ... }` | Use tag-based ops with attachables |
| `translate([x,y,z]) child()` | `position(RIGHT) child()` | Use attachment system |
| `rounding=5, edges=[...]` together | Check cuboid vs prismoid rules | prismoid only rounds vertical edges |

## Detailed Explanations

### 1. Array Access (No Dot Notation)

**Wrong:**
```openscad
pos = [10, 20, 30];
echo(pos.x);  // ERROR - dot notation doesn't exist
```

**Right:**
```openscad
pos = [10, 20, 30];
echo(pos[0]);  // x = 10
echo(pos[1]);  // y = 20
echo(pos[2]);  // z = 30
```

**Why:** OpenSCAD uses index-based array access, not object property notation.

### 2. Edge Specifications

**Wrong:**
```openscad
cuboid(50, rounding=5, edges=["front", "back"]);  // Strings don't work
cuboid(50, rounding=5, edges=[FRONT, BACK]);      // These aren't faces
```

**Right:**
```openscad
// Using axis strings
cuboid(50, rounding=5, edges="Y");     // All edges parallel to Y axis

// Using directional constants
cuboid(50, rounding=5, edges=FWD);     // All edges on front face
cuboid(50, rounding=5, edges=TOP+FWD); // Single edge

// Combining multiple
cuboid(50, rounding=5, edges=[TOP, BOT]); // All top and bottom edges
```

**Why:** BOSL2 uses specific edge specification syntax:
- `"X"`, `"Y"`, `"Z"` for axis-parallel edges
- Face constants (`TOP`, `FWD`, etc.) for edges on that face
- Combined constants (`TOP+FWD`) for specific edges

### 3. Boolean Operations with Attachables

**Wrong:**
```openscad
difference() {
    cuboid([100, 80, 60], rounding=8, anchor=BOT);
    translate([0, 0, 60])
    cuboid([94, 74, 60], anchor=TOP);
}
```

**Right:**
```openscad
diff()
cuboid([100, 80, 60], rounding=8, anchor=BOT) {
    tag("remove")
    position(TOP)
    cuboid([94, 74, 60], rounding=5, anchor=TOP);
}
```

**Why:** BOSL2's `diff()` works with the attachment system. Children tagged with `"remove"` are subtracted from the parent. This keeps geometry in proper relation.

### 4. Positioning Children

**Wrong:**
```openscad
cuboid([50, 40, 30]) {
    translate([25, 0, 15])
    cyl(d=10, h=5);
}
```

**Right:**
```openscad
cuboid([50, 40, 30]) {
    position(TOP+RIGHT)
    cyl(d=10, h=5, anchor=BOT);
}
```

**Why:** The attachment system handles positioning based on parent geometry. Using `translate()` bypasses this and creates fragile positioning.

### 5. Rounding with prismoid vs cuboid

**Wrong (for vertical edges):**
```openscad
prismoid([100, 80], [80, 60], h=50, rounding=10);
// Rounding applies to vertical edges only - not what you might expect
```

**Understanding:**
```openscad
// cuboid rounds edges you specify
cuboid([100, 80, 60], rounding=10);  // Rounds ALL edges by default
cuboid([100, 80, 60], rounding=10, edges="Z");  // Only vertical edges

// prismoid only rounds vertical edges
prismoid([100, 80], [80, 60], h=50, rounding=10);  // Vertical edges only
```

**Why:** `cuboid` and `prismoid` have different rounding behaviors. Check documentation for each.

### 6. Missing diff() Wrapper

**Wrong:**
```openscad
cuboid(50) {
    tag("remove") attach(TOP) cyl(d=20, h=10, anchor=BOT);
}
// Tags are ignored without diff()!
```

**Right:**
```openscad
diff()
cuboid(50) {
    tag("remove") attach(TOP) cyl(d=20, h=10, anchor=BOT);
}
```

**Why:** The `tag()` system only works inside a `diff()` (or `intersect()`, `conv_hull()`) wrapper.

### 7. Anchor vs Attach

**Wrong:**
```openscad
cuboid(50) {
    attach(TOP)  // Attaches to TOP face, oriented away from parent
    cuboid([20, 20, 10], anchor=BOT);  // Anchor is ignored here
}
```

**Right (for surface attachment):**
```openscad
cuboid(50) {
    attach(TOP)
    cuboid([20, 20, 10], anchor=BOT);  // Child sits on top, pointing up
}
```

**Right (for relative positioning):**
```openscad
cuboid(50) {
    position(TOP)
    cuboid([20, 20, 10], anchor=BOT);  // Child at top, not reoriented
}
```

**Why:**
- `attach()` positions AND reorients the child
- `position()` only positions, child keeps its orientation

## Navigation

**Up:** [`index.md`](index.md) - BOSL2 Integration overview

**Related:**
- [`idioms.md`](idioms.md) - Correct patterns to use
- [`attachment-system.md`](attachment-system.md) - How attachments work
- [`../../docs/bosl2/attachments.md`](../../docs/bosl2/attachments.md) - BOSL2 docs

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain - Reference
