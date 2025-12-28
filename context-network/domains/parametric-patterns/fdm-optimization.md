# FDM Optimization Patterns

## Purpose

Patterns for optimizing OpenSCAD models for FDM 3D printing. These patterns handle overhangs, print orientation, tolerances, and part splitting for better print quality.

## Classification
- **Domain:** Parametric Patterns
- **Stability:** Stable
- **Abstraction:** Pattern
- **Confidence:** Established

## Overview

FDM printing has specific constraints: 45-degree overhang limits, bridging capabilities, and layer adhesion considerations. These patterns address common FDM challenges in parametric models.

---

## Teardrop Holes

Circular holes become teardrops to eliminate overhangs at the top of the hole.

### BOSL2 screw_hole with Teardrop

```openscad
module holes() {
    move_copies(pts) {
        screw_hole(screw_spec,
            length = size.z + 0.02,
            thread = screw_thread,
            head = screw_head,
            counterbore = screw_counterbore,
            teardrop = hole_teardrop ? true : false,  // Enable teardrop
            spin = hole_teardrop ? -90 : 0,           // Rotate to point up
            $slop = screw_thread ? 0.1 : 0
        );
    }
}
```
**Source:** bracket-generator.scad:588-596

**Key Points:**
- `teardrop = true` converts circular hole to teardrop shape
- `spin = -90` orients point upward (away from build plate)
- Only enable when `FDM = true` or `hole_teardrop = true`

### Teardrop Rounding on Cylinders

```openscad
// Bottom rounding with teardrop for overhang-free printing
cyl(d=Jar_Diameter, h=Jar_Height,
    rounding1=Jar_Diameter / 7,  // Bottom rounding
    anchor=BOTTOM,
    teardrop=true                 // Teardrop shape
);
```
**Source:** jar-generator.scad:83-89, 94

**Key Points:**
- `rounding1` applies to bottom edge only
- `teardrop=true` modifies rounding to avoid overhangs
- Ratio of `diameter/7` creates gentle transition

### Container Teardrop Toggle

```openscad
/* [Container] */
// Toggle teardrop rounding for better overhangs
Container_Teardrop = true;

// Usage
cyl(d=Container_Diameter, h=Container_Height,
    rounding1=Container_Inner_Rounding,
    teardrop=Container_Teardrop
);
```
**Source:** cirkit-pods.scad:47-48

**Key Points:**
- Expose as Customizer toggle for user control
- Default to `true` for FDM-friendly output
- Can be disabled for resin or CNC

---

## Print Orientation

Rotate models for optimal print orientation based on FDM toggle.

### Conditional Rotation for Print Orientation

```openscad
/* [📷 Render] */
// Optimize for 3D printing
FDM = false;

// In generate() module:
if (Type == "angle") {
    up(FDM ? Width / 2 : 0)      // Lift to compensate for rotation
    yrot(FDM ? 90 : 0)           // Rotate 90 degrees for printing
    angle_bracket(...);
}
```
**Source:** bracket-generator.scad:88, 111-113

**Key Points:**
- `FDM = false` for display orientation, `true` for print-ready
- `up()` compensates for rotation to keep on build plate
- Different bracket types may need different orientations

### Preview Rotation Toggle

```openscad
/* [📷 Render] */
// Enable preview mode
Preview = false;

// Rotate for preview vs. print
color(Color) xrot(Preview ? -90 : 0) grille();
```
**Source:** grille-generator.scad:132, 165

**Key Points:**
- Separate preview rotation from FDM optimization
- Allows viewing model as installed vs. as printed

---

## Rod Splitting

Split large cylindrical parts for stronger layer orientation.

### Split Rod with Bridge Geometry

```openscad
/* [🔩 Rod] */
// Split the rod for increased strength when printing
Rod_Split = false;

module render_rod() {
    if (Rod_Visible) {
        color(Color)
        left(Nut_Visible ? Diameter / 2 + Spacing / 2 : 0) {
            if (Rod_Split) {
                $rod_anchor = TOP;
                // Front half - rotate flat
                xrot(-90)
                down(0.1)
                front_half(s = Rod_Length * 2) {
                    children();
                }
                // Back half - rotate flat
                xrot(90)
                down(0.1)
                back_half(s = Rod_Length * 2) {
                    children();
                }
                // Bridge to connect halves during printing
                cube([Diameter * 3 / 4, 0.24, 0.24], anchor = BOTTOM+CENTER);
            } else {
                $rod_anchor = BOTTOM;
                children();
            }
        }
    }
}
```
**Source:** thread-generator.scad:51, 148-174

**Key Points:**
- `front_half()` and `back_half()` slice model in half
- `s = Rod_Length * 2` ensures complete cut
- Bridge cube (0.24mm thick) connects halves for single-piece printing
- Bridge snaps off after printing
- Layers run perpendicular to thread for strength

### Half Helpers

```openscad
// BOSL2 provides half-cutting helpers:
front_half(s = size) children();   // Keep front half
back_half(s = size) children();    // Keep back half
left_half(s = size) children();    // Keep left half
right_half(s = size) children();   // Keep right half
top_half(s = size) children();     // Keep top half
bottom_half(s = size) children();  // Keep bottom half
```

**Key Points:**
- `s` parameter is cutting plane size (should exceed model)
- Combine with rotations to reorient for printing

---

## Tolerances and Clearances

### Slop Parameter for Assembly Fit

```openscad
/* [Render] */
// Clearance for assembly tolerance with 3D Printing
Slop = 0.12;

// Validation
assert(Slop >= 0 && Slop <= 0.4,
    "Slop should be non-negative and no more than 0.4 mm.");

// Apply globally
$slop = Slop;
```
**Source:** cirkit-pods.scad:112-118

**Key Points:**
- `$slop` is BOSL2's special variable for clearance
- 0.1-0.15mm typical for well-calibrated printers
- Up to 0.3-0.4mm for looser fits or less precise printers

### Nut Clearance for Threading

```openscad
/* [⭕ Nut] */
// Additional spacing for 3D printing fit
Nut_Clearance = 0.12; // [0:0.01:0.25]

module render_nut() {
    if (Nut_Visible) {
        $slop = Nut_Clearance;  // Apply to nut specifically
        color(Color)
        right(Rod_Visible ? Nut_WAF / 2 + Spacing / 2 : 0) {
            children();
        }
    }
}
```
**Source:** thread-generator.scad:68, 179-186

**Key Points:**
- Per-component clearance allows tuning
- Slider with 0.01 step for fine control
- Applied via `$slop` special variable

### Screw Hole Slop

```openscad
screw_hole(screw_spec,
    length = size.z + 0.02,
    thread = screw_thread,
    $slop = screw_thread ? 0.1 : 0  // Only apply if threaded
);
```
**Source:** bracket-generator.scad:595

**Key Points:**
- Threaded holes need clearance, plain holes may not
- Conditional slop based on feature type

---

## Z-Fighting Prevention

### Extending Cut Geometry

```openscad
// Extend holes past surfaces
screw_hole(screw_spec,
    length = size.z + 0.02,  // Extend 0.02mm past thickness
    anchor = TOP,
    orient = DOWN
);

// Extend pattern cuts
down(0.01) linear_extrude(height = _Grille_Depth + 0.02) {
    region(pattern);
}
```
**Source:** bracket-generator.scad:589, grille-generator.scad:202-203

**Key Points:**
- Add 0.01-0.02mm to cut depth
- `down(0.01)` starts cut slightly below surface
- Prevents rendering artifacts and ensures clean boolean

---

## Support Structures

### Support Flange Generation

```openscad
// Add support flange(s)
if (interior_angle > 0 && support_taper > 0 && support_thickness > 0) {
    xcopies(
        l = size.x - support_thickness,
        sp = -size.x / 2 + support_thickness/2,
        n = support_count
    ) {
        support_flange(
            support_thickness,
            size - [0, arm_rounding, 0],
            interior_angle,
            support_taper
        );
    }
}
```
**Source:** bracket-generator.scad:286-300

**Key Points:**
- Support flanges strengthen angled brackets
- `xcopies()` distributes multiple supports evenly
- Taper ratio controls support coverage area

### Customizer Support Parameters

```openscad
/* [📐 Support] */
// Number of supports
Support_Count = 0;

// Taper ratio (coverage area)
Support_Taper = 0.5; // [0:0.05:1]

// Support thickness
Support_Thickness = 2;
```
**Source:** bracket-generator.scad:74-83

**Key Points:**
- User-controllable support generation
- Default to 0 supports (user adds as needed)
- Taper and thickness allow fine-tuning

---

## Resolution Optimization

### Resolution Presets for Performance

```openscad
/* [📷 Render] */
// Render resolution to control detail level
Resolution = 3; // [4: Ultra, 3: High, 2: Medium, 1: Low]

// Map resolution to face angle/size
Face = (Resolution == 4) ? [1, 0.1]
    : (Resolution == 3) ? [2, 0.15]
    : (Resolution == 2) ? [2, 0.2]
    : [4, 0.4];

$fa = Face[0];
$fs = Face[1];
```
**Source:** thread-generator.scad:79-91

**Key Points:**
- Higher resolution = more faces = slower preview
- Low resolution for design iteration
- High/Ultra for final export
- `$fa` = fragment angle, `$fs` = fragment size

### Validation for Resolution

```openscad
assert(Face_Angle >= 0 && Face_Angle <= 15,
    "Face_Angle must be greater than 0 and not exceed 15.");
assert(Face_Size > 0 && Face_Size <= 1,
    "Face_Size must be greater than 0 and no more than 1 mm.");
```
**Source:** cirkit-pods.scad:116-117

---

## Common Patterns

### FDM-Aware Module Wrapper

```openscad
module render_part() {
    if (Part_Visible) {
        color(Color)
        if (FDM) {
            // Print-optimized orientation
            xrot(90) children();
        } else {
            // Display orientation
            children();
        }
    }
}
```

### Conditional Counterbore

```openscad
// Auto counterbore when head specified
_Screw_Counterbore = Screw_Head == "none" || Screw_Counterbore == 0
    ? false
    : Screw_Counterbore < 0
    ? true : Screw_Counterbore;
```
**Source:** grille-generator.scad:159-162

**Key Points:**
- `-1` = auto (BOSL2 calculates depth)
- `0` = disabled
- Positive value = explicit depth

---

## Best Practices

### Overhang Guidelines
- Maximum 45-degree overhang angle without supports
- Use teardrops for horizontal holes
- Add fillets to internal corners (not external)

### Layer Orientation
- Threads stronger when layers perpendicular to axis
- Thin walls stronger when layers parallel to surface
- Consider splitting and reorienting critical features

### Tolerance Guidelines
| Application | Recommended Slop |
|-------------|-----------------|
| Press fit | 0.0 - 0.05mm |
| Snug fit | 0.1 - 0.15mm |
| Easy fit | 0.2 - 0.25mm |
| Loose fit | 0.3 - 0.4mm |

---

## Navigation

**Up:** [`index.md`](index.md) - Parametric Patterns overview

**Related:**
- [`mechanical-joints.md`](mechanical-joints.md) - Threading with tolerances
- [`customizer-ui.md`](customizer-ui.md) - FDM toggle parameters

## Metadata
- **Created:** 2025-12-28
- **Last Updated:** 2025-12-28
- **Document Type:** Pattern
