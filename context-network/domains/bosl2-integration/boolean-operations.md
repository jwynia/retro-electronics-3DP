# Boolean Operations Best Practices

## The Z-Fighting Problem

When using `difference()` or BOSL2's `diff()/tag("remove")` pattern, coincident surfaces cause rendering artifacts called "z-fighting." This appears as:
- Flickering surfaces when rotating models
- Ambiguous hatching in preview mode
- Microscopic "membrane" surfaces that aren't real geometry

## The Solution: Epsilon Extensions

**Always extend cutting shapes 0.01mm past the surfaces they cut through.**

### Standard Epsilon Value

```openscad
eps = 0.01;  // Standard extension for boolean cuts
```

## Patterns

### Pattern 1: Cavity from Top (Most Common)

When hollowing a shell from the top:

```openscad
// BAD - coincident surfaces
diff()
cuboid([100, 80, 60], anchor=BOT) {
    tag("remove")
    position(TOP)
    cuboid([90, 70, 50], anchor=TOP);  // Top aligns exactly
}

// GOOD - extended past surface
diff()
cuboid([100, 80, 60], anchor=BOT) {
    tag("remove")
    position(TOP)
    up(0.01)  // Shift up slightly
    cuboid([90, 70, 50 + 0.01], anchor=TOP);  // And extend height
}
```

### Pattern 2: Through Holes

When cutting completely through material:

```openscad
// BAD - exactly matches thickness
cylinder(d=10, h=wall);

// GOOD - extends past both surfaces
cylinder(d=10, h=wall + 1);  // Or wall + 0.02 for minimal extension
```

### Pattern 3: Positioned Cavities with translate()

```openscad
// BAD
translate([0, 0, depth - wall/2])
cuboid([w, h, depth], anchor=TOP);

// GOOD
translate([0, 0, depth - wall/2 + 0.01])
cuboid([w, h, depth + 0.01], anchor=TOP);
```

### Pattern 4: Pockets (Non-Through Cuts)

Pockets that don't cut through typically don't need epsilon:

```openscad
// OK - pocket doesn't reach other surface
position(BOT)
cyl(d=10, h=3, anchor=BOT);  // Pocket in bottom face
```

But if the pocket depth equals the wall thickness, add epsilon:

```openscad
// Pocket equals wall - add epsilon
position(BOT)
cyl(d=10, h=wall + 0.01, anchor=BOT);
```

## BOSL2-Specific Notes

### With diff() and tag()

```openscad
diff()
parent_shape() {
    tag("remove")
    position(TOP)
    up(0.01)  // Epsilon shift
    cutting_shape();
}
```

### With attachable()

When using `attachable()`, the cutting geometry still needs epsilon:

```openscad
attachable(anchor, spin, orient, size=size) {
    diff()
    outer_shape() {
        tag("remove")
        position(TOP)
        up(0.01)
        inner_cavity();
    }
    children();
}
```

## Quick Reference

| Situation | Fix |
|-----------|-----|
| Cavity aligned with top | `up(0.01)` + add 0.01 to height |
| Through hole | Add 1mm (or 0.02 minimum) to height |
| hull() cavity | Add 0.01 to inner shape heights |
| Pocket at exact wall depth | Add 0.01 to pocket depth |

## Verification

After applying fixes:
1. Render with `./scripts/render.sh file.scad` (preview mode)
2. Check for orange hatching on surfaces that should be open
3. If hatching persists on open surfaces, epsilon not applied correctly
4. Full render (`--render=full`) should show clean geometry

## Related

- [Development Principles](../../foundation/development-principles.md) - Core rules including epsilon requirement
- [Shell Parameters](../shells/shell-parameters.md) - Shell-specific patterns
