# BOSL2 Attachment System in RetroCase

## Purpose
How RetroCase uses BOSL2's attachment system for positioning and orienting shapes.

## Classification
- **Domain:** BOSL2 Integration
- **Stability:** Stable (core pattern)
- **Abstraction:** Conceptual and practical
- **Confidence:** Established

## Core Concepts

### Anchors
Every BOSL2 shape has anchor points - named positions where things can be placed or aligned.

**Face anchors:**
```
TOP    - Center of top face
BOT    - Center of bottom face
LEFT   - Center of left face
RIGHT  - Center of right face
FWD    - Center of front face
BACK   - Center of back face
CENTER - Center of shape (default)
```

**Edge anchors (combine two):**
```
TOP+RIGHT   - Center of right edge on top
FWD+LEFT    - Center of left edge on front
TOP+FWD     - Center of front edge on top
```

**Corner anchors (combine three):**
```
TOP+RIGHT+FWD  - Front-right corner on top
BOT+LEFT+BACK  - Back-left corner on bottom
```

### position() vs attach()

**`position(anchor)`**
- Moves child so its anchor point is at parent's specified anchor
- Child keeps its original orientation
- Use when you want to place something at a location

```openscad
cuboid(50)
    position(TOP) cyl(d=10, h=20, anchor=BOT);
// Cylinder stands on top of cube, pointing up
```

**`attach(anchor)`**
- Moves AND rotates child to face outward from parent's anchor
- Child's BOT faces the parent surface
- Use when you want something to stick out from a surface

```openscad
cuboid(50)
    attach(TOP) cyl(d=10, h=20, anchor=BOT);
// Same result as position() for TOP
// But attach(RIGHT) would rotate cylinder to point right
```

### When to Use Which

| Situation | Use | Why |
|-----------|-----|-----|
| Child should stand on surface | `position()` | Keeps original orientation |
| Child should point out from surface | `attach()` | Rotates to face outward |
| Cutting holes through faces | Either works | `attach()` is more intuitive |
| Internal mounting | `position()` | Usually want original orientation |

## Creating Attachable Modules

Every major module in RetroCase uses `attachable()` to support the attachment system.

### Template
```openscad
module my_module(
    // Your parameters...
    size,
    // Attachment parameters (standard)
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    // Calculate dimensions for attachable()
    width = size[0];
    height = size[1];
    depth = size[2];

    attachable(anchor, spin, orient, size=size) {
        // Your geometry here
        diff()
        cuboid(size) {
            // Children with tags...
        }

        // REQUIRED: Pass through children
        children();
    }
}
```

### Key Requirements

1. **Accept standard attachment parameters:**
   - `anchor` - Where the shape is anchored (default: CENTER or BOT)
   - `spin` - Rotation around Z axis
   - `orient` - Which direction is "up"

2. **Wrap geometry in `attachable()`:**
   - Pass anchor, spin, orient
   - Specify size for automatic anchor calculation

3. **Call `children()` after geometry:**
   - This allows children to attach to your module

## Edge Specifications for Rounding

When using `rounding` with `edges`, you specify which edges to round:

### By Axis
```openscad
edges = "X"  // All edges parallel to X axis
edges = "Y"  // All edges parallel to Y axis
edges = "Z"  // All vertical edges (parallel to Z)
```

### By Face
```openscad
edges = TOP    // All 4 edges on top face
edges = FWD    // All 4 edges on front face
edges = TOP+FWD  // Single edge where top and front meet
```

### Combined
```openscad
edges = [TOP, BOT]  // All edges on top and bottom faces
edges = "Z"         // Same as [TOP, BOT] for vertical edges
```

### Excluding Edges
```openscad
except = BOT  // Round everything except bottom edges
```

## RetroCase Usage Patterns

### Shell Hollowing
```openscad
diff()
cuboid(size, rounding=corner_r, anchor=BOT) {
    tag("remove")
    position(TOP)
    cuboid(inner_size, rounding=inner_r, anchor=TOP);
}
```
- Outer shape anchored at BOT (sits on build plate)
- Inner subtraction positioned at TOP, anchored TOP (removes from above)

### Faceplate Edges
```openscad
cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER)
```
- Only round vertical edges (for thin plates)
- Anchor at CENTER for symmetric attachment

### Opening Cutouts
```openscad
tag("remove")
position(FWD)
cuboid([opening_w, wall*2, opening_h], rounding=r, edges="Y", anchor=FWD);
```
- Position at FWD (front face)
- Round only edges parallel to Y (perpendicular to cut direction)
- Anchor at FWD so cutout extends into shell

## Navigation

**Up:** [`index.md`](index.md) - BOSL2 Integration overview

**Related:**
- [`diff-tagging.md`](diff-tagging.md) - Boolean operations
- [`idioms.md`](idioms.md) - Common patterns
- [`../../docs/bosl2/attachments.md`](../../docs/bosl2/attachments.md) - Full BOSL2 docs

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain - Conceptual
