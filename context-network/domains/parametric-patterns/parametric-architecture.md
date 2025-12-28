# Parametric Architecture Patterns

## Purpose

Architectural patterns for building flexible, multi-variant parametric OpenSCAD generators. These patterns enable single files to produce multiple configurations while maintaining clean, maintainable code.

## Classification
- **Domain:** Parametric Patterns
- **Stability:** Stable
- **Abstraction:** Pattern
- **Confidence:** Established

## Overview

Well-architected parametric models separate configuration from geometry, use dispatch patterns for variants, and compute derived values from core parameters. These patterns create generators that are both powerful and maintainable.

---

## Type Dispatch Pattern

Use conditional dispatch to generate different variants from a single file.

### Basic Type Dispatch

```openscad
/* [📏 Bracket] */
Type = "angle"; // [angle: Angle Bracket, flat: Flat Bracket, T: T-Bracket]

module generate() {
    if (Type == "angle") {
        angle_bracket(
            size = _Size,
            rounding = Rounding,
            interior_angle = Angle,
            ...
        );
    } else if (Type == "flat") {
        flat_bracket(
            size = _Size,
            rounding = Rounding,
            ...
        );
    } else if (Type == "T") {
        t_bracket(
            size = _Size,
            rounding = Rounding,
            ...
        );
    }
}
```
**Source:** bracket-generator.scad:110-165

**Key Points:**
- Single entry point `generate()` dispatches to type-specific modules
- All types share common parameters where possible
- Type-specific parameters only passed where needed

### Thread Type Dispatch

```openscad
/* [🌀️ Thread] */
Thread = "triangular"; // [triangular: Triangular, trapezoidal: Trapezoidal, acme: ACME, buttress: Buttress, square: Square]

module generate() {
    if (Thread == "triangular") {
        triangular_thread();
    } else if (Thread == "trapezoidal") {
        trapezoidal_thread();
    } else if (Thread == "acme") {
        acme_thread();
    } else if (Thread == "buttress") {
        buttress_thread();
    } else if (Thread == "square") {
        square_thread();
    }
}
```
**Source:** thread-generator.scad:117-135

**Key Points:**
- Each thread type has dedicated module with standard-specific parameters
- Common rendering logic shared (rod, nut positioning)

### Grille Type Dispatch

```openscad
module grille() {
    if (Grille_Type == "mesh") {
        mesh();
    } else if (Grille_Type == "solid") {
        cap();
    } else {
        slats();  // Default to vent/slats
    }

    insert();  // Common to all types

    difference() {
        cover();  // Common to all types
        holes();
    }
}
```
**Source:** grille-generator.scad:167-182

**Key Points:**
- Type dispatch for variable portion
- Common elements (insert, cover, holes) apply to all types

---

## Function-Based Configuration

Use functions to return configuration arrays based on parameters.

### Texture Parameter Lookup

```openscad
function get_texture_params(type) =
    (type == "Ribs") ? [ "trunc_ribs", [4, 1], undef ] :
    (type == "Diamonds") ? [ "diamonds", [6, 6], "convex" ] :
    (type == "Swirl") ? [ "diamonds", [6, 3], "default" ] :
    (type == "Checkers") ? [texture("checkers", border=0.2), [8, 8], undef] :
    (type == "Triangles") ? [ "tri_grid", [6, 10], undef ] :
    (type == "Squares") ? [ "trunc_pyramids_vnf", [6, 6], "default" ] :
    (type == "Bricks") ? [ "bricks_vnf", [10, 10], "default" ] :
    [ undef, undef, undef ];

// Usage
params = get_texture_params(Texture_Type);
texture = params[0];
texture_size = Texture_Size == "" ? params[1] : get_texture_size(Texture_Size);
texture_style = params[2];
```
**Source:** cirkit-pods.scad:283-291, 309-312

**Key Points:**
- Function returns array of related parameters
- Ternary chain for pattern matching
- Default case handles unknown types
- Override mechanism for custom sizes

### Shape Function Dispatch

```openscad
function pattern_shape(name = Pattern, size = Pattern_Size, rounding = Pattern_Rounding, spin = 0, realign = false) =
    let (rounding = (min(size.x, size.y) * rounding) / 2)
    name == "ellipse"
        ? ellipse(d = size)
        : name == "octagon"
        ? round_corners(ellipse(d = size, $fn = 8, circum = true, spin = spin + (realign ? 22.5 : 0)), r = rounding / 2)
        : name == "hexagon"
        ? round_corners(ellipse(d = size, $fn = 6), r = rounding / 2)
        : rect(size, rounding = rounding);  // Default
```
**Source:** grid-generator.scad:118-132

**Key Points:**
- Returns 2D path based on shape name
- Common interface regardless of shape
- Default fallback to rectangle

---

## Position Arrays

Pre-define position arrays for multi-arm/multi-element placement.

### Anchor Position Arrays

```openscad
/* [Hidden] */

// Vertical start positions (TOP first)
_VPositions = [
    [],
    [TOP, FRONT],
    [TOP, FRONT, RIGHT],
    [TOP, FRONT, RIGHT, BACK],
    [TOP, FRONT, RIGHT, BACK, LEFT],
    [TOP, FRONT, RIGHT, BACK, LEFT, DOWN],
];

// Horizontal start positions (BACK/FRONT first)
_HPositions = [
    [],
    [BACK, FRONT],
    [BACK, FRONT, RIGHT],
    [BACK, FRONT, RIGHT, LEFT],
    [BACK, FRONT, RIGHT, LEFT, TOP],
    [BACK, FRONT, RIGHT, LEFT, TOP, DOWN],
];

// Usage
positions = _Arm_VStart ? _VPositions[Arm_Count - 1] : _HPositions[Arm_Count - 1];

attach(positions, UP) {
    // Arm geometry for each position
}
```
**Source:** connector-generator.scad:121-146, 172-175

**Key Points:**
- Array index = arm count - 1
- Empty array for 1 arm (no attachment needed)
- Choose array based on orientation parameter
- BOSL2 `attach()` iterates through positions

### Side Position Arrays for Supports

```openscad
_VSidePositions = [
    [],
    [BACK],
    [BACK, RIGHT],
    [BACK, RIGHT],
    [BACK, RIGHT, LEFT],
    [BACK, RIGHT, LEFT, FRONT],
];

// In support module
positions = _Arm_VStart ? _VSidePositions[$idx] : _HSidePositions[$idx];
attach(positions, RIGHT, align = TOP) {
    // Support geometry
}
```
**Source:** connector-generator.scad:130-137, 267-272

**Key Points:**
- `$idx` gives current arm index within attach loop
- Different support positions for each arm
- Complements main position arrays

---

## String Parsing for Variable Parameters

Parse comma-separated strings for per-element customization.

### Parsing Comma-Separated Angles

```openscad
/* [🔧 Advanced] */
// X Rotation of each arm (comma-separated)
Arm_X_Angles = "0";
// Y Rotation of each arm (comma-separated)
Arm_Y_Angles = "0";

/* [Hidden] */
_Angles_Disabled = (Arm_X_Angles == "0" || Arm_X_Angles == "") && (Arm_Y_Angles == "0" || Arm_Y_Angles == "");
_XAngles = str_split(Arm_X_Angles, ",");
_YAngles = str_split(Arm_Y_Angles, ",");

// Usage in loop
attach(positions, UP) {
    angle = [_XAngles[$idx], _YAngles[$idx]];
    rotate([
        angle.x ? parse_int(str_strip(angle.x, " ")) : 0,
        angle.y ? parse_int(str_strip(angle.y, " ")) : 0
    ]) {
        // Arm geometry
    }
}
```
**Source:** connector-generator.scad:57-61, 114-116, 176-186

**Key Points:**
- `str_split()` creates array from comma-separated string
- `$idx` accesses element for current iteration
- `str_strip()` removes whitespace
- `parse_int()` converts to number
- Fallback to 0 if empty/undefined

### Variable Arm Sizes

```openscad
// Variable size of each arm (comma-separated)
Arm_Sizes = "0";

/* [Hidden] */
_Arm_Sizes_Disabled = (Arm_Sizes == "0" || Arm_Sizes == "");
_Arm_Sizes = str_split(Arm_Sizes, ",");

// Usage
isize = _Arm_Sizes_Disabled
    ? Arm_Size                                          // Use default
    : parse_int(str_strip(select(_Arm_Sizes, $idx), " ")); // Use per-arm value
osize = isize + _Arm_Wall * 2;
```
**Source:** connector-generator.scad:63-64, 108-109, 177-180

**Key Points:**
- `select()` safely indexes array (wraps around)
- Disabled flag for simpler logic
- Fallback to global parameter when disabled

---

## Computed Values

Derive complex values from core parameters in Hidden section.

### Derived Dimensions

```openscad
/* [Hidden] */
Container_Outer_Diameter = Container_Diameter + (Container_Wall * 2);
Thread_Diameter = Container_Diameter + (Thread_Depth * 2) + (Thread_Wall * 2);

_Inner_Size = Arm_Size;
_Outer_Size = Arm_Size + _Arm_Wall * 2;

Nut_WAF = max(Diameter, Nut_Width);  // Width across flats
```
**Source:** connector-generator.scad:111-112, thread-generator.scad:100

**Key Points:**
- Prefix with `_` for internal computed values
- Calculate once, use throughout
- Derived from user-facing parameters

### Bevel Control Mapping

```openscad
/* [⭕ Nut] */
Nut_Bevel = "auto"; // [auto: Auto, none: None, inside: Inside, outside: Outside, both: Inside & Outside]

/* [Hidden] */
Nut_Inner_Bevel = Nut_Bevel == "auto" ? undef
    : Nut_Bevel == "none" || Nut_Bevel == "outside" ? false
    : true;
Nut_Outer_Bevel = Nut_Bevel == "auto" ? undef
    : Nut_Bevel == "none" || Nut_Bevel == "inside" ? false
    : true;
```
**Source:** thread-generator.scad:65, 101-106

**Key Points:**
- Single user parameter controls multiple internal flags
- `undef` enables library defaults
- Explicit `false` disables feature

### Visibility Flags

```openscad
/* [📷 Render] */
Display = "all"; // [all: Rod & Nut, rod: Rod, nut: Nut]

/* [Hidden] */
All_Visible = Display == "all";
Rod_Visible = All_Visible || Display == "rod";
Nut_Visible = All_Visible || Display == "nut";
```
**Source:** thread-generator.scad:76, 95-97

**Key Points:**
- Single dropdown controls multiple visibility flags
- Boolean logic for OR conditions
- Clean module conditions: `if (Rod_Visible) { ... }`

---

## Multi-Part Rendering

Render multiple components from single file with toggle controls.

### Conditional Render Module

```openscad
module render_model(condition, color_val) {
    if (condition) {
        color(color_val) children();
    }
}

// Usage
render_model(Render_Bottom, Color_Bottom) render_bottom();
render_model(Render_Top, Color_Top) render_top();
render_model(Render_Center, Color_Center) render_center();
```
**Source:** cirkit-pods.scad:298-303

**Key Points:**
- Wrapper module handles visibility check
- `children()` passes through geometry
- Per-component colors for visualization

### Conditional Rod Rendering

```openscad
module render_rod() {
    if (Rod_Visible) {
        color(Color)
        left(Nut_Visible ? Diameter / 2 + Spacing / 2 : 0) {
            // Rod geometry with split handling
            children();
        }
    }
}

module render_nut() {
    if (Nut_Visible) {
        $slop = Nut_Clearance;
        color(Color)
        right(Rod_Visible ? Nut_WAF / 2 + Spacing / 2 : 0) {
            children();
        }
    }
}
```
**Source:** thread-generator.scad:148-187

**Key Points:**
- Each part checks own visibility
- Positioning adjusts based on what else is visible
- `$slop` set per-component for tolerances

---

## Auto Shape Selection

Automatically choose shape based on context.

### Hub Shape Auto-Selection

```openscad
/* [🔧 Advanced] */
Hub_Shape = "auto"; // [auto: Auto, square: Square]
Hole_Shape = "auto"; // [auto: Auto, round: Round, square: Square]

/* [Hidden] */
_Hub_Shape = Hub_Shape == "auto" ? Arm_Shape : Hub_Shape;
_Hole_Shape = Hole_Shape == "auto" ? Arm_Shape : Hole_Shape;
```
**Source:** connector-generator.scad:46-49, 101-103

**Key Points:**
- "auto" matches related parameter (Arm_Shape)
- Explicit values override auto behavior
- Computed in Hidden section for clean modules

### Cover Shape Auto-Selection

```openscad
/* [🔲 Cover] */
Cover_Shape = "auto"; // [auto: Auto, rect: Rectangle, hexagon: Hexagon, flower: Flower]

/* [Hidden] */
_Cover_Shape = Cover_Shape == "auto"
    ? offset(_Grille_Shape, delta=Cover_Width, closed=true)
    : cover_shape();
```
**Source:** grille-generator.scad:95, 149-151

**Key Points:**
- "auto" computes from geometry (offset of grille shape)
- Explicit values call shape function
- Different computation methods for auto vs. explicit

---

## Best Practices

### Parameter Organization
1. User-facing parameters at top with Customizer annotations
2. Hidden section for computed values
3. Prefix computed values with `_` for clarity
4. Single `generate()` or main module entry point

### Dispatch Pattern Guidelines
1. Use `if/else if` chains for type dispatch
2. Provide default fallback case
3. Keep dispatch logic in one location
4. Share common parameters across types

### Computed Value Guidelines
1. Calculate derived values once in Hidden section
2. Use meaningful names that describe the value
3. Validate computed values where constraints apply
4. Consider `max()` and `min()` for clamping

---

## Navigation

**Up:** [`index.md`](index.md) - Parametric Patterns overview

**Related:**
- [`customizer-ui.md`](customizer-ui.md) - Parameter UI patterns
- [`bosl2-advanced.md`](bosl2-advanced.md) - BOSL2 shape functions

## Metadata
- **Created:** 2025-12-28
- **Last Updated:** 2025-12-28
- **Document Type:** Pattern
