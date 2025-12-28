# Pattern Generation Patterns

## Purpose

Patterns for generating 2D patterns (honeycomb, grids, textures) and applying them to 3D geometry. These patterns create decorative and functional surface treatments.

## Classification
- **Domain:** Parametric Patterns
- **Stability:** Stable
- **Abstraction:** Pattern
- **Confidence:** Established

## Overview

Pattern generation covers two main approaches: 2D polygon-based patterns for difference operations, and BOSL2 texture arrays for cylindrical surfaces. Both enable parametric, scalable surface treatments.

---

## 2D Polygon Patterns

### Honeycomb Pattern

Staggered hexagonal grid for lightweight, strong structures.

```openscad
module honeycombPattern(w, h) {
    col_spacing = sqrt(3) * cell_radius + cell_gap;
    row_spacing = 1.5 * cell_radius + cell_gap;
    // Add margin so partial cells get cut
    rows = ceil(h / row_spacing) + 2;
    cols = ceil(w / col_spacing) + 2;

    for (row = [0 : rows - 1]) {
        for (col = [0 : cols - 1]) {
            // Stagger alternate rows
            x = col * col_spacing + (row % 2) * (col_spacing / 2);
            y = row * row_spacing;
            translate([x, y])
                polygon(points = [
                    [0, cell_radius],
                    [(sqrt(3) * cell_radius) / 2, cell_radius / 2],
                    [(sqrt(3) * cell_radius) / 2, -cell_radius / 2],
                    [0, -cell_radius],
                    [-(sqrt(3) * cell_radius) / 2, -cell_radius / 2],
                    [-(sqrt(3) * cell_radius) / 2, cell_radius / 2]
                ]);
        }
    }
}
```
**Source:** drawer-divider.scad:154-178

**Key Points:**
- `col_spacing = sqrt(3) * radius` for proper hex packing
- `row % 2` creates stagger offset
- Overscan with `+ 2` ensures edge coverage
- Let `difference()` handle clipping to bounds

### Pill Pattern

Vertical capsule shapes with stagger option.

```openscad
module pillPattern(w, h) {
    x_spacing = pill_vertical_gap;
    y_spacing = pill_height + pill_horizontal_gap;

    intersection() {
        square([w, h]);

        for (col = [0:ceil(w/x_spacing)]) {
            y_offset = (col % 2) ? pill_offset : 0;

            for (row = [0:ceil(h/y_spacing)*2]) {
                x = col * x_spacing;
                y = row * y_spacing;

                if (x < w && y < h) {
                    if (y+y_offset+pill_height - pill_horizontal_gap <= h && y+y_offset - pill_height >= 0) {
                        translate([x + pill_vertical_gap/2, y + y_offset])
                            pill_shape(pill_vertical_gap, pill_height, pill_radius);
                    }
                }
            }
        }
    }
}

module pill_shape(width, height, radius) {
    hull() {
        translate([radius, -height/2 + radius])
            circle(r=radius, $fa=5, $fs=0.5);
        translate([radius, height/2 - radius])
            circle(r=radius, $fa=5, $fs=0.5);
    }
}
```
**Source:** drawer-divider.scad:180-218

**Key Points:**
- `hull()` creates pill from two circles
- Boundary check prevents partial pills
- `intersection()` clips to rectangle

### Base Panel with Pattern

Apply pattern to panel with preserved border.

```openscad
module base_panel_2d(len, ht) {
    union() {
        // Create border frame
        difference() {
            rect(len, ht);
            translate([pattern_border_thickness, pattern_border_thickness])
                rect(len - 2*pattern_border_thickness, ht - 2*pattern_border_thickness);
        }

        // Pattern inside border
        difference() {
            rect(len, ht);
            translate([pattern_border_thickness, pattern_border_thickness]) {
                if (pattern == "pill")
                    pillPattern(len - 2*pattern_border_thickness, ht - 2*pattern_border_thickness);
                if (pattern == "honeycomb")
                    honeycombPattern(len - 2*pattern_border_thickness, ht - 2*pattern_border_thickness);
            }
        }
    }
}
```
**Source:** drawer-divider.scad:244-268

**Key Points:**
- Border frame preserves solid edges
- Pattern subtracted from interior
- Union combines frame and patterned interior

---

## BOSL2 Texture Arrays

Binary 2D arrays that define surface height variation.

### Custom Texture Array Format

```openscad
// Binary pattern: 0 = base surface, 1 = raised/lowered
ribPattern = [
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1]
];

// Apply depth scaling
function computeCustomPattern(pattern) = [
    for(row = pattern) [
        for(el = row)
            el * Pattern_Depth
    ]
];
```
**Source:** jar-generator.scad:68-73, 479-488

**Key Points:**
- Binary (0/1) arrays for simple patterns
- `computeCustomPattern()` scales by depth
- Array rows are circumferential, columns are axial

### Applying Texture to Cylinder

```openscad
module createPatternedCyl(tex, texSize, patternDepth)
    cyl(d=Jar_Diameter, h=Jar_Height,
        anchor=BOTTOM,
        texture=tex,
        tex_size=texSize,           // [circumference, height] tiles
        tex_depth=patternDepth,     // Positive = raised, negative = recessed
        tex_taper=Pattern_Taper,    // Fade at top/bottom
        rounding1=Jar_Diameter / 7,
        teardrop=true
    );

// With rotation
module createRotatedPatternedCyl(tex, texSize, patternDepth, rot)
    cyl(d=Jar_Diameter, h=Jar_Height,
        anchor=BOTTOM,
        texture=tex,
        tex_size=texSize,
        tex_depth=patternDepth,
        tex_taper=Pattern_Taper,
        tex_rot=rot,                // Rotate texture pattern
        rounding1=Jar_Diameter / 7,
        teardrop=true
    );

// With style
module createStyledPatternedCyl(tex, texSize, texStyle, patternDepth)
    cyl(d=Jar_Diameter, h=Jar_Height,
        anchor=BOTTOM,
        texture=tex,
        tex_size=texSize,
        tex_depth=patternDepth,
        tex_taper=Pattern_Taper,
        style=texStyle,             // "convex", "concave", "default", "min_edge"
        rounding1=Jar_Diameter / 7,
        teardrop=true
    );
```
**Source:** jar-generator.scad:82-89

**Key Points:**
- `tex_size` controls tile repetitions
- `tex_taper` fades texture at ends
- `tex_rot` rotates pattern in degrees
- `style` affects how texture applies to surface

### Embed vs Relief Control

```openscad
// Negative depth = recessed (embedded)
// Positive depth = raised (relief)
patternDepth = Pattern_Embed == true ? -Pattern_Depth : Pattern_Depth;

if (Pattern == "none") {
    cyl(d=Jar_Diameter, h=Jar_Height, ...);
} else if (Pattern == "ribs") {
    tex = computeCustomPattern(ribPattern);
    createPatternedCyl(tex, [8,8], patternDepth);
}
```
**Source:** jar-generator.scad:92-102

**Key Points:**
- Negate depth for embedded (subtracted) texture
- Positive depth for raised (added) texture
- User toggle controls direction

### Responsive Texture Sizing

```openscad
// Scale texture size based on object size
texSize = Jar_Height + Jar_Diameter > 150 ? [20,20] : [10,10];

cyl(d=Jar_Diameter, h=Jar_Height,
    texture=texture(Pattern, n=24),  // Built-in texture
    tex_size=texSize,
    tex_depth=Pattern_Depth,
    tex_taper=Pattern_Taper
);
```
**Source:** jar-generator.scad:96-97

**Key Points:**
- Larger objects need larger texture tiles
- Threshold-based sizing maintains visual consistency
- `n=24` increases texture resolution for built-ins

---

## Example Texture Patterns

### Ribs (Vertical Stripes)

```openscad
ribPattern = [
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1]
];
```
**Source:** jar-generator.scad:479-488

### Swirl Pattern

```openscad
swirlPattern = [
    [0,0,1,1,1,1,0,0],
    [0,0,0,1,1,1,1,0],
    [0,0,0,0,1,1,1,1],
    [1,0,0,0,0,1,1,1],
    [1,1,0,0,0,0,1,1],
    [1,1,1,0,0,0,0,1],
    [1,1,1,1,0,0,0,0],
    [0,1,1,1,1,0,0,0],
];
```
**Source:** jar-generator.scad:508-517

### Diamond Pattern

```openscad
diamondPattern = [
    [1,1,0,0,1,0,0,1],
    [1,0,0,1,1,1,0,0],
    [0,0,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1],
    [0,0,1,1,1,1,1,0],
    [1,0,0,1,1,1,0,0],
    [1,1,0,0,1,0,0,1],
    [1,1,1,0,0,0,1,1],
    [1,1,1,1,0,1,1,1],
    [1,1,1,0,0,0,1,1]
];
```
**Source:** jar-generator.scad:562-573

### Bricks Pattern

```openscad
bricksPattern = [
    [0,0,0,0,0,0,0,0,0],
    [0,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [1,1,1,1,0,0,1,1,1],  // Offset for staggered bricks
    [1,1,1,1,0,0,1,1,1],
    [1,1,1,1,0,0,1,1,1],
    [0,0,0,0,0,0,0,0,0]
];
```
**Source:** jar-generator.scad:575-586

---

## BOSL2 Built-in Textures

Use `texture()` function for pre-defined patterns.

```openscad
// Built-in textures via get_texture_params()
function get_texture_params(type) =
    (type == "Ribs") ? [ "trunc_ribs", [4, 1], undef ] :
    (type == "Diamonds") ? [ "diamonds", [6, 6], "convex" ] :
    (type == "Swirl") ? [ "diamonds", [6, 3], "default" ] :
    (type == "Checkers") ? [texture("checkers", border=0.2), [8, 8], undef] :
    (type == "Triangles") ? [ "tri_grid", [6, 10], undef ] :
    (type == "Squares") ? [ "trunc_pyramids_vnf", [6, 6], "convex" ] :
    (type == "Bricks") ? [ "bricks_vnf", [10, 10], "default" ] :
    [ undef, undef, undef ];

// Usage
params = get_texture_params(Texture_Type);
cyl(d=diameter, h=height,
    texture = params[0],
    tex_size = params[1],
    tex_style = params[2]
);
```
**Source:** cirkit-pods.scad:283-291

**Available Built-in Textures:**
- `"trunc_ribs"` - Truncated ribs
- `"diamonds"` - Diamond grid
- `"tri_grid"` - Triangular grid
- `"trunc_pyramids_vnf"` - Truncated pyramids
- `"bricks_vnf"` - Brick pattern
- `texture("checkers", border=0.2)` - Checkerboard

---

## Slat/Vent Patterns

### Slat Center Calculation

```openscad
function slat_centers(len, cells, mode, w, s=0) =
    (cells <= 0) ? [] :
    (mode == "around") ?
        let(
            pitch0 = len/cells,
            g0 = pitch0 - w,           // Default gap
            g = max(0, g0 + s),        // Adjusted gap
            pitch = w + g
        )
        [ for (k=[0:cells-1]) -((cells-1)*pitch)/2 + k*pitch ] :
    // mode == "between"
        (cells <= 1) ? [] :
        let(
            S = cells - 1,
            g0 = (len - S*w)/cells,
            g = max(0, g0 + s),
            P = w + g,
            T = S*w + cells*g,
            x0 = -T/2 + g + w/2
        )
        [ for (i=[0:S-1]) x0 + i*P ];
```
**Source:** grille-generator.scad:409-430

**Key Points:**
- `mode = "around"`: gaps at edges and between
- `mode = "between"`: gaps only between slats
- `s` parameter adjusts spacing from default
- Returns centered positions (symmetric about 0)

### Applying Slats

```openscad
module slats() {
    intersection() {
        union() {
            up(_Grille_Depth/2) {
                // Vertical slats (columns)
                for (x = slat_centers(width, Slat_Columns, Slat_Distribution, wy, sy))
                    right(x)
                        cube([wy, length, _Grille_Depth*3], anchor=CENTER);

                // Horizontal slats (rows) with angle
                for (y = slat_centers(length, Slat_Rows, Slat_Distribution, wx, sx)) {
                    back(y) xrot(Slat_Angle)
                        cube([width, wx, _Grille_Depth*3], anchor=CENTER);
                }
            }
        }

        // Clip to grille shape
        linear_extrude(height=_Grille_Depth) {
            polygon(_Grille_Shape);
        }
    }
}
```
**Source:** grille-generator.scad:221-252

**Key Points:**
- Oversized cubes clipped by intersection
- `Slat_Angle` tilts horizontal slats for louver effect
- Combined vertical and horizontal for grid

---

## Mesh Pattern Generation

Using BOSL2 `grid_copies()` for mesh patterns.

```openscad
module mesh() {
    spacing = Mesh_Size + Mesh_Spacing + (_Mesh_Stagger == false ? [0,0] : [0, -Mesh_Size.y/2]);
    inside = Mesh_Offset == 0 ? _Grille_Shape : offset(_Grille_Shape, delta = -Mesh_Offset, closed = true);

    pattern = grid_copies(
        p = zrot(Mesh_Rotate, pattern_shape()),
        inside = inside,
        spacing = spacing,
        stagger = _Mesh_Stagger
    );

    difference() {
        linear_extrude(height = _Grille_Depth) {
            polygon(_Grille_Shape);
        }
        down(0.01) linear_extrude(height = _Grille_Depth + 0.02) {
            region(pattern);
        }
    }
}
```
**Source:** grille-generator.scad:187-207

**Key Points:**
- `grid_copies()` returns path array of shapes
- `inside` clips to grille boundary
- `zrot()` rotates pattern shapes
- `region()` handles complex path array

---

## Best Practices

### Pattern Sizing
- Larger patterns for larger objects
- Consider print layer height for minimum feature size
- Test pattern at print scale before final render

### Performance
- Use lower $fn for pattern preview
- Increase $fn only for final render
- Cache computed patterns in variables

### FDM Considerations
- Avoid overhangs > 45 degrees in patterns
- Consider layer-aligned horizontal features
- Pattern depth limited by wall thickness

---

## Navigation

**Up:** [`index.md`](index.md) - Parametric Patterns overview

**Related:**
- [`bosl2-advanced.md`](bosl2-advanced.md) - grid_copies and paths
- [`customizer-ui.md`](customizer-ui.md) - Pattern parameters

## Metadata
- **Created:** 2025-12-28
- **Last Updated:** 2025-12-28
- **Document Type:** Pattern
