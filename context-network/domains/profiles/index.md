# Profiles Domain

## Purpose
This domain covers 2D profile generation - the cross-sectional shapes used with `offset_sweep()` and other path-based operations to create complex 3D forms.

## Classification
- **Domain:** 2D Profile Generation
- **Stability:** Semi-stable
- **Abstraction:** Foundational patterns
- **Confidence:** Established

## Documents

### [`2d-profiles.md`](2d-profiles.md)
**Profile Generation Patterns**

Techniques for creating 2D profiles for sweep operations.

**Key topics:**
- Rounded rectangle profiles
- Wedge/trapezoid profiles
- Path generation for sweeps
- Profile parameter conventions

### [`locations.md`](locations.md)
**Code Location Index**

Maps profile concepts to actual implementation files.

## Profile Types

### Implemented
- **Rounded Rectangle** - Basic rectangular profile with corner rounding
- **Wedge** - Trapezoid profile for tapered forms

### Planned
- **Organic Curves** - Bezier-based profiles
- **Stepped Profiles** - Multi-level cross-sections

## Key Patterns

### Rounded Rectangle Profile
```openscad
module profile_rounded_rect(width, height, radius) {
    rect([width, height], rounding=radius);
}
```

### Wedge Profile
```openscad
module profile_wedge(bottom_width, top_width, height, radius=0) {
    trapezoid(w1=bottom_width, w2=top_width, h=height, rounding=radius);
}
```

### Path for Sweep
```openscad
function path_rounded_rect(width, depth, radius) =
    rect(size=[width, depth], rounding=radius, $fn=32);
```

### Using Profiles with offset_sweep
```openscad
offset_sweep(
    path_rounded_rect(width, depth, corner_radius),
    height = height,
    top = os_rounded(r=top_radius),
    bottom = os_rounded(r=bottom_radius)
);
```

## Profile Conventions

### Naming
- `profile_<shape>()` - Returns 2D shape for use with `linear_extrude()` or as child
- `path_<shape>()` - Returns path (array of points) for use with `offset_sweep()`

### Orientation
- Profiles are created in XY plane
- Height dimension is Y
- Width dimension is X
- Sweep direction is typically Z

### Parameter Order
1. Width (X dimension)
2. Height (Y dimension)
3. Rounding/radius
4. Additional shape-specific parameters

## Navigation

**Up:** [`../index.md`](../index.md) - Domains overview

**Related Domains:**
- [`../shells/`](../shells/index.md) - Shells may use swept profiles
- [`../bosl2-integration/`](../bosl2-integration/index.md) - BOSL2 sweep functions

**Related Documents:**
- [`../../cross-domain/parameter-conventions.md`](../../cross-domain/parameter-conventions.md) - Parameter naming standards

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Domain Type:** Foundational domain
