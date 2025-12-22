# Shell Parameter Reference

## Purpose
Complete reference for shell generation parameters used across RetroCase.

## Classification
- **Domain:** Shells
- **Stability:** Stable
- **Abstraction:** Reference
- **Confidence:** Established

## Dimensional Parameters

### size
- **Type:** `[width, height, depth]` array
- **Units:** mm
- **Description:** Overall outer dimensions of the shell
- **Note:** Order is [X, Y, Z] in OpenSCAD coordinates

### wall
- **Type:** number
- **Units:** mm
- **Default:** 3
- **Description:** Wall thickness for all sides
- **Constraints:** Should be ≥ 2mm for printability

### corner_r (corner_radius)
- **Type:** number
- **Units:** mm
- **Default:** 10
- **Description:** Rounding radius for outer edges
- **Constraints:** Should be ≤ smallest dimension / 2

## Opening Parameters

### opening
- **Type:** `[width, height]` array or `undef`
- **Units:** mm
- **Description:** Size of front opening for face plate
- **Note:** `undef` means no opening (closed shell)

### opening_r (opening_radius)
- **Type:** number
- **Units:** mm
- **Default:** 5
- **Description:** Corner radius for opening edges
- **Constraints:** Should be ≤ opening dimensions / 2

### opening_inset
- **Type:** number
- **Units:** mm
- **Description:** Distance from outer edge to opening edge
- **Note:** Not used in current implementation; opening is centered

## Lip Parameters

### lip_depth
- **Type:** number
- **Units:** mm
- **Default:** 3
- **Description:** Depth of rebate for face plate to sit in
- **Constraints:** Should be ≥ face plate thickness

### lip_inset
- **Type:** number
- **Units:** mm
- **Default:** 1.5
- **Description:** Distance from outer edge to lip edge
- **Note:** Creates the visible lip edge around face plate

### lip_width
- **Type:** calculated
- **Formula:** `opening_width + lip_edge * 2`
- **Description:** Total width of lip rebate area

## BOSL2 Attachment Parameters

### anchor
- **Type:** BOSL2 anchor constant
- **Default:** `BOT`
- **Description:** Where the shell's origin is located
- **Common values:** `BOT` (for sitting on surface), `CENTER`

### spin
- **Type:** number (degrees)
- **Default:** 0
- **Description:** Rotation around Z axis

### orient
- **Type:** BOSL2 orientation constant
- **Default:** `UP`
- **Description:** Which direction is "up" for the shell

## Parameter Relationships

### Wall vs Corner Radius
```
inner_corner_r = max(1, corner_r - wall)
```
Inner corner radius must be positive. If wall thickness approaches corner radius, inner corners become sharp.

### Opening vs Shell Size
```
max_opening_width  = width - wall * 2 - 10  // Leave edge material
max_opening_height = height - wall - 10
```

### Lip vs Opening
```
lip_width  = opening_width + (wall - lip_inset) * 2
lip_height = opening_height + (wall - lip_inset) * 2
```
Lip must be larger than opening to create the seating edge.

## Recommended Values

### Standard Shell
```openscad
shell_monolithic(
    size = [150, 100, 80],
    wall = 3,
    corner_r = 10,
    opening = [120, 70],
    opening_r = 5,
    lip_depth = 3,
    lip_inset = 1.5
);
```

### Small Enclosure
```openscad
shell_monolithic(
    size = [80, 60, 40],
    wall = 2.5,
    corner_r = 6,
    opening = [60, 40],
    opening_r = 3,
    lip_depth = 2.5,
    lip_inset = 1
);
```

### Large Enclosure
```openscad
shell_monolithic(
    size = [250, 180, 100],
    wall = 4,
    corner_r = 15,
    opening = [200, 140],
    opening_r = 8,
    lip_depth = 4,
    lip_inset = 2
);
```

## Parameter Validation

When implementing shells, validate:

1. **wall > 0** - Must have positive wall thickness
2. **corner_r > wall** - Otherwise inner corners are impossible
3. **opening dimensions < interior dimensions** - Opening must fit
4. **lip_depth ≥ faceplate thickness** - Faceplate must seat fully
5. **lip_inset < wall** - Lip must be inside wall boundary

## Navigation

**Up:** [`index.md`](index.md) - Shells domain overview

**Related:**
- [`monolithic-shells.md`](monolithic-shells.md) - Shell patterns
- [`../../cross-domain/parameter-conventions.md`](../../cross-domain/parameter-conventions.md) - Naming standards
- [`../faceplates/`](../faceplates/index.md) - Face plates that fit shells

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Domain - Reference
