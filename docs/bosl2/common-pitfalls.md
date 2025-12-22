# Common BOSL2 Pitfalls

Critical mistakes to avoid when writing OpenSCAD with BOSL2.

## 1. Array Access Syntax

**WRONG:**
```openscad
pos = [10, 20, 30];
x = pos.x;  // ERROR: OpenSCAD has no dot notation
```

**RIGHT:**
```openscad
pos = [10, 20, 30];
x = pos[0];
y = pos[1];
z = pos[2];
```

## 2. Edge Specification

**WRONG:**
```openscad
cuboid(50, rounding=5, edges=["top", "front"]);  // Strings don't work like this
cuboid(50, rounding=5, edges=[TOP, FRONT]);      // List of constants doesn't work
```

**RIGHT:**
```openscad
// Use constants directly
cuboid(50, rounding=5, edges=TOP);

// Combine with +
cuboid(50, rounding=5, edges=TOP+FWD);

// Use axis strings for parallel edges
cuboid(50, rounding=5, edges="Z");  // All vertical edges

// Multiple edges: use except instead
cuboid(50, rounding=5, except=BOT);  // All except bottom
```

## 3. diff() vs difference()

**WRONG (for attachables):**
```openscad
difference() {
    cuboid(50);
    translate([0, 0, 20]) cylinder(h=40, d=20, center=true);
}
```
This works but loses attachment benefits and is harder to compose.

**RIGHT:**
```openscad
diff()
cuboid(50)
    tag("remove") position(TOP) cyl(d=20, h=40);
```

## 4. Missing tag() in diff()

**WRONG:**
```openscad
diff()
cuboid(50) {
    position(TOP) cyl(d=20, h=10);  // NOT subtracted! No tag.
}
```

**RIGHT:**
```openscad
diff()
cuboid(50) {
    tag("remove") position(TOP) cyl(d=20, h=10);
}
```

Or with default tags:
```openscad
diff("hole")
cuboid(50) {
    tag("hole") position(TOP) cyl(d=20, h=10);
}
```

## 5. Tag Inheritance Surprises

**PROBLEM:**
```openscad
diff()
cuboid(50) {
    tag("remove") position(TOP) cuboid(10)
        attach(TOP) cyl(d=5, h=5);  // ALSO removed! Tags inherit.
}
```

**SOLUTION: Use tag_this()**
```openscad
diff()
cuboid(50) {
    tag_this("remove") position(TOP) cuboid(10)
        attach(TOP) cyl(d=5, h=5);  // NOT removed, tag doesn't inherit
}
```

## 6. prismoid() Rounding Limits

**WRONG EXPECTATION:**
```openscad
// Trying to round top face edges
prismoid([100, 80], [60, 40], h=50, rounding=10);
// Only rounds vertical edges, not top/bottom faces!
```

**RIGHT:**
```openscad
// For full rounding, use offset_sweep or rounded_prism
offset_sweep(
    rect([100, 80], rounding=10),
    height=50,
    bottom=os_circle(r=5),
    top=os_circle(r=5)
);
```

## 7. Anchor Confusion

**WRONG:**
```openscad
// Trying to place at top center
cuboid(50, anchor=TOP);  // This ANCHORS to top, not positions there
// The cube is now below the XY plane!
```

**RIGHT:**
```openscad
// anchor= sets where origin is ON the object
// The object moves so that anchor point is at origin

cuboid(50, anchor=BOT);   // Bottom at origin, cube sits on XY plane
cuboid(50, anchor=CENTER); // Center at origin (default)
```

## 8. attach() Orientation

**SURPRISE:**
```openscad
cuboid(50)
    attach(RIGHT) cuboid([10, 10, 20]);
// The attached cube is rotated! Its "top" faces right.
```

attach() rotates children so the anchor faces align. Use position() to keep child orientation:
```openscad
cuboid(50)
    position(RIGHT) cuboid([10, 10, 20], anchor=LEFT);
```

## 9. Non-Attachable Objects

**WRONG:**
```openscad
diff()
cuboid(50)
    tag("remove") position(TOP)
        linear_extrude(20) circle(d=30);  // linear_extrude not attachable!
```

**RIGHT:**
```openscad
diff()
cuboid(50)
    position(TOP) force_tag("remove")
        linear_extrude(20) circle(d=30);
```

Non-attachable built-ins requiring force_tag():
- `linear_extrude()`
- `rotate_extrude()`
- `polygon()`
- `polyhedron()`
- `text()`
- `import()`
- `surface()`

## 10. Module Scope and Tags

**WRONG:**
```openscad
module my_part() {
    diff()
    cuboid(30)
        tag("remove") attach(TOP) cyl(d=10, h=15);
}

// Using it causes tag pollution
diff()
cuboid(100)
    attach(TOP) my_part()
        tag("remove") cyl(d=5, h=10);  // May interact badly
```

**RIGHT:**
```openscad
module my_part(anchor=CENTER, spin=0, orient=UP) {
    tag_scope() {  // Isolates tags
        diff()
        cuboid(30, anchor=anchor, spin=spin, orient=orient)
            tag("remove") attach(TOP) cyl(d=10, h=15);
    }
}
```

## 11. Forgetting children() in Custom Modules

**WRONG:**
```openscad
module my_cube(size, anchor=CENTER) {
    cuboid(size, anchor=anchor);
    // Forgot children()!
}

my_cube(50)
    position(TOP) cyl(d=10, h=5);  // Nothing attaches!
```

**RIGHT:**
```openscad
module my_cube(size, anchor=CENTER, spin=0, orient=UP) {
    cuboid(size, anchor=anchor, spin=spin, orient=orient)
        children();  // Pass through children
}
```

## 12. Rounding Radius Too Large

**ERROR:**
```openscad
cuboid([50, 50, 20], rounding=15);
// Error: rounding too large for Z dimension (15 > 20/2)
```

**RULE:** Rounding radius must be ≤ half the smallest dimension.

```openscad
// For a 50x50x20 box, max rounding is 10
cuboid([50, 50, 20], rounding=10);
```

## 13. $fn in Wrong Place

**WRONG:**
```openscad
cuboid(50, rounding=10, $fn=64);  // $fn doesn't help cuboid rounding much
```

**RIGHT:**
```openscad
$fn = 32;  // Set globally or in scope
cuboid(50, rounding=10);

// Or for specific operations
cyl(d=20, h=10, $fn=64);
```

## 14. Negative Values in offset_sweep

**CONFUSION:**
```openscad
// Negative r = fillet (concave), not an error
offset_sweep(rect([50, 50]), h=30, bottom=os_circle(r=-5));
// Creates an inward fillet at bottom
```

This is intentional! Negative radius creates fillets/coves.

## 15. Position vs Offset

**NOT THE SAME:**
```openscad
// position() uses parent's anchor system
cuboid(50) position(TOP) cyl(d=10, h=5);  // At top face center

// translate() uses absolute coordinates
cuboid(50, anchor=BOT);
translate([0, 0, 50]) cyl(d=10, h=5);  // Same visual result but no attachment

// up/down/left/right are shorthand translates
cuboid(50) up(25) cyl(d=10, h=5);  // Works but not attached
```

Prefer position()/attach()/align() for composition. Use translate/up/down only when necessary.

## Quick Reference: What Works Where

| Want to... | Use... |
|------------|--------|
| Round all edges of a box | `cuboid(rounding=)` |
| Round vertical edges only | `prismoid(rounding=)` |
| Round horizontal edges too | `offset_sweep()` or `rounded_prism()` |
| Subtract attached shape | `diff()` + `tag("remove")` |
| Position without rotation | `position()` or `align()` |
| Position with rotation | `attach()` |
| Make non-attachable work with tags | `force_tag()` |
| Isolate tags in module | `tag_scope()` |
| Tag only this object | `tag_this()` |
