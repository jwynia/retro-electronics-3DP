# BOSL2 Attachments Reference

The attachment system positions objects relative to each other. Source: https://github.com/BelfrySCAD/BOSL2/wiki/Tutorial-Attachments

## Core Concepts

1. **Anchor** - A point on an object's surface where things attach
2. **Position** - Place a child at a parent's anchor point
3. **Attach** - Connect child's anchor to parent's anchor
4. **Tags** - Names for Boolean operations (diff, intersect)

## position()

Places children at an anchor point on the parent. Child keeps its own orientation.

```openscad
include <BOSL2/std.scad>

cuboid(50)
    position(TOP) cyl(d=20, h=10);  // Cylinder centered at top of cube

cuboid(50)
    position(TOP+RIGHT) cyl(d=20, h=10);  // At top-right edge
```

## attach()

Connects a child's anchor to a parent's anchor. Child is rotated so anchors face each other.

```openscad
include <BOSL2/std.scad>

// Attach cylinder's BOT to cube's TOP
cuboid(50)
    attach(TOP, BOT) cyl(d=20, h=10);

// Equivalent to position(TOP) but cylinder oriented correctly
```

### Two-anchor form

```openscad
attach(parent_anchor, child_anchor) child();
```

### Single-anchor form

```openscad
attach(parent_anchor) child();  // Uses child's default anchor (usually BOT)
```

## align()

Like position() but automatically picks the right child anchor for flush alignment.

```openscad
include <BOSL2/std.scad>

// Flush to top-right edge
cuboid([50, 40, 15])
    align(TOP, RIGHT) color("blue") cuboid(8);

// Multiple positions
cuboid([50, 40, 15])
    align(TOP, [RIGHT, LEFT]) color("blue") cuboid(8);

// With inset from edge
cuboid([50, 40, 15])
    align(TOP, [FWD, RIGHT, LEFT, BACK], inset=3) prismoid([10,5], [7,4], h=4);
```

## Tags and diff()

Tags mark objects for Boolean operations.

### Basic diff() pattern

```openscad
include <BOSL2/std.scad>

// Subtract tagged shapes from parent
diff()
cuboid(50) {
    tag("remove") attach(TOP) cyl(d=20, h=30, anchor=BOT);
}
```

### Default tags

- `"remove"` - Shapes to subtract (default for diff)
- `"keep"` - Shapes to preserve through intersection

### Explicit tag specification

```openscad
diff("hole")
cuboid(50)
    tag("hole") position(TOP) cyl(d=20, h=60);
```

### Multiple tags

```openscad
diff("hole", keep="antenna")
cuboid(50) {
    tag("hole") attach(TOP) cyl(d=20, h=30);
    tag("antenna") attach(TOP) cyl(d=5, h=40);
}
```

### tag() vs tag_this()

- `tag("name")` - Applies to object and ALL its children
- `tag_this("name")` - Applies to object only, children revert to previous tag

```openscad
diff()
cuboid(50)
    tag_this("remove") position(TOP) cuboid(10)  // This is removed
        attach(TOP) cuboid(5);  // This is NOT removed (tag reverts)
```

## tag_scope()

Isolates tags within a scope. Essential for reusable modules.

```openscad
include <BOSL2/std.scad>

module my_part(anchor=CENTER, spin=0, orient=UP) {
    tag_scope() {
        diff()
        cuboid(30, anchor=anchor, spin=spin, orient=orient) {
            tag("remove") attach(TOP) cyl(d=10, h=15);
            children();
        }
    }
}

// Can now use this module in another diff() without tag conflicts
diff()
cuboid(100)
    attach(TOP) my_part()
        tag("remove") attach(TOP) cyl(d=5, h=10);  // Additional cut
```

## force_tag()

For non-attachable objects (linear_extrude, polygon, etc.):

```openscad
diff()
cuboid(50)
    attach(TOP) force_tag("remove")
        linear_extrude(30) circle(d=20);
```

## intersect()

Keep only the intersection of tagged shapes:

```openscad
intersect()
cube(100, center=true) {
    tag("intersect") cylinder(h=100, d1=120, d2=95, center=true);
    tag("keep") xcyl(h=140, d=20);  // Preserved, not intersected
}
```

## Edge and Corner Masking

### edge_mask()

Difference a mask from specific edges:

```openscad
diff()
cuboid(50)
    edge_mask([TOP, "Z"], except=BACK)
        rounding_edge_mask(r=5, l=$edge_length+1);
```

### corner_mask()

Difference a mask from corners:

```openscad
diff()
cuboid(50)
    corner_mask(TOP)
        rounding_corner_mask(r=5);
```

### edge_profile()

Apply a 2D profile to edges:

```openscad
diff()
cuboid(50)
    edge_profile(TOP)
        mask2d_roundover(r=5);
```

## Inside Attachment

For subtracting shapes from inside:

```openscad
diff()
cuboid(50)
    attach(TOP, BOT, inside=true) tag("remove")
        cyl(d=30, h=40);  // Attached inside, pointing inward
```

## Creating Attachable Modules

Basic pattern for modules that participate in attachment system:

```openscad
module my_shape(size=50, anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor, spin, orient, size=[size, size, size]) {
        // Your geometry here
        cube(size, center=true);
        
        // MUST call children() for attachments to work
        children();
    }
}
```

For prismoid shapes:

```openscad
module my_prism(size=[50,50,50], scale=0.5, anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor, spin, orient, size=size, size2=[size.x, size.y]*scale) {
        hull() {
            up(size.z/2-0.01) cube([size.x*scale, size.y*scale, 0.01], center=true);
            down(size.z/2-0.01) cube([size.x, size.y, 0.01], center=true);
        }
        children();
    }
}
```
