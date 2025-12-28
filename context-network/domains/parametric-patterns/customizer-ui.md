# Customizer UI Patterns

## Purpose

Patterns for organizing OpenSCAD Customizer parameters to create intuitive, validated user interfaces. These patterns enable end-users to configure parametric models without editing code.

## Classification
- **Domain:** Parametric Patterns
- **Stability:** Stable
- **Abstraction:** Pattern
- **Confidence:** Established

## Overview

The OpenSCAD Customizer reads specially-formatted comments to generate UI widgets. Well-organized parameters with validation create professional-quality parametric models.

## Section Headers

Use `/* [Section Name] */` comments to group related parameters into collapsible sections.

### Basic Section Headers
```openscad
/* [Container] */
Container_Diameter = 40;
Container_Height = 34;

/* [Thread] */
Thread_Height = 7.8;
Thread_Pitch = 3.8;
```
**Source:** cirkit-pods.scad:33-86

### Emoji Section Headers
Emoji prefixes make sections visually distinct in the Customizer UI.

```openscad
/* [📏 Bracket] */
Type = "angle";
Thickness = 3;

/* [🪛 Holes] */
Hole_Grid = [1, 2];

/* [📐 Support] */
Support_Count = 0;

/* [📷 Render] */
FDM = false;
```
**Source:** bracket-generator.scad:22-95

### Optional Sections
Use double brackets for optional/advanced sections that can be collapsed by default.

```openscad
/* [[Optional] Hole] */
Hole_Diameter = 20;
Hole_Chamfer = 1;

/* [[Optional] Text] */
Text = "CK";
Text_Size = 16;
```
**Source:** cirkit-pods.scad:124-148

### Hidden Section
Use `/* [Hidden] */` to exclude computed values from the Customizer UI.

```openscad
/* [Hidden] */
$fa = 2;
$fs = 0.2;

_Size = [Width, Length, Thickness];
_Hole_Stagger = Hole_Stagger == "none" ? false : true;
```
**Source:** bracket-generator.scad:96-103

---

## Widget Types

### Dropdown Menus
Use `// [value1: Label1, value2: Label2]` syntax for dropdowns.

```openscad
// Basic dropdown with labels
Type = "angle"; // [angle: Angle Bracket, flat: Flat Bracket, T: T-Bracket]

// Thread type with description
Thread = "triangular"; // [triangular: Triangular, trapezoidal: Trapezoidal, acme: ACME]

// Grille type selection
Grille_Type = "vent"; // [vent: Vent, mesh: Mesh, solid: Solid]

// Shape selection
Mesh_Shape = "ellipse"; // [rect: Rectangle, ellipse: Ellipse, octagon: Octagon, hexagon: Hexagon]
```
**Source:** bracket-generator.scad:25, thread-generator.scad:22, grille-generator.scad:27

### Range Sliders
Use `// [min:step:max]` for numeric sliders with step control.

```openscad
// Angle slider 0-135 degrees, step of 1
Angle = 90; // [0:1:135]

// Rounding ratio 0-1, step of 0.05
Rounding = 0; // [0:0.05:1]

// Slat angle with negative range
Slat_Angle = 0; // [-45:1:45]

// Fine-grained clearance control
Nut_Clearance = 0.12; // [0:0.01:0.25]
```
**Source:** bracket-generator.scad:37-40, grille-generator.scad:53, thread-generator.scad:68

### Simple Range Sliders
Use `// [min:max]` for sliders with default step of 1.

```openscad
Jar_Height = 80; // [25:160]
Jar_Diameter = 60; // [25:160]
```
**Source:** jar-generator.scad:34-36

### Boolean Toggles
Boolean variables automatically become checkboxes.

```openscad
// FDM optimization toggle
FDM = false;

// Thread option
Screw_Thread = false;

// Teardrop toggle for overhangs
Container_Teardrop = true;
```
**Source:** bracket-generator.scad:88, cirkit-pods.scad:48

### Array Parameters
Arrays display as multiple input fields.

```openscad
// Grid dimensions [columns, rows]
Hole_Grid = [1, 2];

// Spacing [x, y]
Hole_Spacing = [8, 16];

// Size as [width, length]
Grille_Size = [100, 100];
```
**Source:** bracket-generator.scad:48-51, grille-generator.scad:24

### Color Picker
Use `// color` to enable color picker widget.

```openscad
Color = "#ddd"; // color
Color = "#e2dede"; // color
```
**Source:** bracket-generator.scad:94, thread-generator.scad:82

### Extended Color Lists
For material-specific colors, use extensive dropdown lists.

```openscad
Jar_Color = "Matte Desert Tan"; // [Bambu Green, Beige, Black, Blue, Blue Gray, Bright Green, Bronze, Brown, Cobalt Blue, Cocoa Brown, Cyan, Dark Gray, Gold, Gray, Jade White, Hot Pink, Indigo Purple, Light Gray, Magenta, Maroon Red, Mistletoe Green, Orange, Pink, Pumpkin Orange, Purple, Red, Silver, Sunflower Yellow, Turquoise, Yellow, Matte Apple Green, Matte Ash Gray, Matte Bone White, Matte Caramel, Matte Charcoal, Matte Dark Blue, Matte Dark Brown, Matte Dark Chocolate, Matte Dark Green, Matte Dark Red, Matte Desert Tan, Matte Grass Green, Matte Ice Blue, Matte Ivory White, Matte Latte Brown, Matte Lemon Yellow, Matte Lilac Purple, Matte Mandarin Orange, Matte Marine Blue, Matte Nardo Gray, Matte Plum, Matte Sakura Pink, Matte Scarlet Red, Matte Sky Blue, Matte Terracotta]
```
**Source:** jar-generator.scad:28-29

---

## Resolution Presets

Provide resolution options that map to `$fa`/`$fs` values for performance vs. quality tradeoff.

### Simple Resolution Dropdown
```openscad
Resolution = 3; // [4: Ultra, 3: High, 2: Medium, 1: Low]

// Map resolution to face settings
Face = (Resolution == 4) ? [1, 0.1]
    : (Resolution == 3) ? [2, 0.15]
    : (Resolution == 2) ? [2, 0.2]
    : [4, 0.4];

$fa = Face[0];
$fs = Face[1];
```
**Source:** thread-generator.scad:79-91

### Direct Face Controls
```openscad
// Minimum angle for a fragment in degrees
Face_Angle = 2; // [1:1:15]
// Minimum size of a fragment in mm
Face_Size = 0.2; // [0.1:0.1:1]

$fa = Face_Angle;
$fs = Face_Size;
```
**Source:** cirkit-pods.scad:107-122

---

## Parameter Validation

Use `assert()` statements after parameters to validate user input with helpful error messages.

### Basic Range Validation
```openscad
Container_Diameter = 40;
assert(Container_Diameter >= 20, "Container_Diameter must be at least 20mm.");

Container_Height = 34;
assert(Container_Height > 5, "Container_Height must be greater than 5mm.");

Container_Wall = 2.2;
assert(Container_Wall >= 1, "Container_Wall must be at least 1mm.");
```
**Source:** cirkit-pods.scad:36-55

### Non-Negative Validation
```openscad
Container_Rounding = 10;
assert(Container_Rounding >= 0, "Container_Rounding cannot be negative.");

Texture_Depth = 1.8;
assert(Texture_Depth >= 0, "Texture_Depth cannot be negative.");
```
**Source:** cirkit-pods.scad:54-66

### Relationship Validation
Validate that parameters make sense together.

```openscad
// Thread depth must be less than half the pitch
assert(Thread_Depth < (Thread_Pitch / 2),
    "Thread_Depth is too large relative to the pitch; it must be less than half the pitch.");

// Thread height must fit within ring
assert(Thread_Height < Ring_Height - Thread_Wall,
    "Thread_Height is larger than the available ring height.");

// Hole must be smaller than container
assert(Hole_Diameter < Container_Diameter,
    "Hole_Diameter must be less than Container_Diameter.");

// Chamfer can't exceed half the base thickness
assert(Hole_Chamfer <= Container_Base / 2,
    "Hole chamfer cannot exceed half of Container_Base.");
```
**Source:** cirkit-pods.scad:100-134

### Range Validation
```openscad
// Angle must be in valid range
assert(Thread_Flank_Angle >= 15 && Thread_Flank_Angle <= 45,
    "Thread_Flank_Angle must be between 15 and 45 degrees.");

// Face angle practical limits
assert(Face_Angle >= 0 && Face_Angle <= 15,
    "Face_Angle must be greater than 0 and not exceed 15.");

// Slop tolerance practical limits
assert(Slop >= 0 && Slop <= 0.4,
    "Slop should be non-negative and no more than 0.4 mm.");
```
**Source:** cirkit-pods.scad:101-118

---

## Computed Values in Hidden Section

Derive complex values from user parameters in the Hidden section.

### String to Boolean Mapping
```openscad
/* [Hidden] */
_Hole_Stagger = Hole_Stagger == "none" ? false
    : Hole_Stagger == "stagger" ? true
    : Hole_Stagger;
```
**Source:** bracket-generator.scad:102

### Counterbore Logic
```openscad
/* [Hidden] */
_Screw_Counterbore = Screw_Counterbore == 0 ? false
    : Screw_Counterbore < 0 ? true
    : Screw_Counterbore;
```
**Source:** bracket-generator.scad:103

### Bevel Control Mapping
```openscad
/* [Hidden] */
Nut_Inner_Bevel = Nut_Bevel == "auto" ? undef
    : Nut_Bevel == "none" || Nut_Bevel == "outside" ? false
    : true;
Nut_Outer_Bevel = Nut_Bevel == "auto" ? undef
    : Nut_Bevel == "none" || Nut_Bevel == "inside" ? false
    : true;
```
**Source:** thread-generator.scad:101-106

### Display Visibility Flags
```openscad
/* [Hidden] */
All_Visible = Display == "all";
Rod_Visible = All_Visible || Display == "rod";
Nut_Visible = All_Visible || Display == "nut";
```
**Source:** thread-generator.scad:95-97

### Derived Dimensions
```openscad
/* [Hidden] */
Container_Outer_Diameter = Container_Diameter + (Container_Wall * 2);
Thread_Diameter = Container_Diameter + (Thread_Depth * 2) + (Thread_Wall * 2);
Nut_WAF = max(Diameter, Nut_Width);  // Width across flats
```
**Source:** cirkit-pods.scad (computed), thread-generator.scad:100

---

## Common Patterns

### Screw Specification Dropdown
Standard ISO and UTS screw sizes for hole generation.

```openscad
Screw_Spec = "M5"; // [M2, M2.5, M3, M4, M5, M6, M8, M10, M12, M14, M16, M18, M20, #4, #6, #8, #10, #12, 1/4, 5/16, 3/8, 7/16, 1/2, 9/16, 3/4]
```
**Source:** bracket-generator.scad:63

### Head Type Selection
```openscad
Screw_Head = "none"; // [none: None, flat: Flat, button: Button, socket: Socket, hex: Hex, pan: Pan, cheese: Cheese]
```
**Source:** bracket-generator.scad:66

### Both-Ends Control
Single parameter that controls behavior at both ends.

```openscad
Blunt_Start = "both"; // [none: None, top: Top, bottom: Bottom, both: Both ends]
Rod_Bevel = "none"; // [none: None, top: Top, bottom: Bottom, both: Both ends]

/* [Hidden] */
Blunt_Start_Top = Blunt_Start == "none" || Blunt_Start == "bottom" ? false : true;
Blunt_Start_Bottom = Blunt_Start == "none" || Blunt_Start == "top" ? false : true;
```
**Source:** thread-generator.scad:34-48, 111-112

### Stagger Options
Common pattern for grid arrangement.

```openscad
Hole_Stagger = "none"; // [none: None, stagger: Stagger, alt: Alternate]
Mesh_Stagger = "stagger"; // [none: None, stagger: Staggered, alt: Alternate]
```
**Source:** bracket-generator.scad:54, grille-generator.scad:67

---

## Best Practices

### Naming Conventions
- Use `Title_Case` with underscores for Customizer visibility
- Group related parameters with common prefixes: `Thread_Height`, `Thread_Pitch`, `Thread_Depth`
- Use descriptive suffixes: `_Size`, `_Depth`, `_Count`, `_Offset`

### Comment Descriptions
Add a comment line before the parameter for tooltip descriptions.

```openscad
// Inner diameter of the container
Container_Diameter = 40;
// Height of the container body excluding the ring
Container_Height = 34;
```

### Parameter Order
1. Primary dimensions (size, width, height, depth)
2. Secondary options (rounding, chamfers)
3. Feature toggles (FDM, teardrop)
4. Render settings (resolution, color)

---

## Navigation

**Up:** [`index.md`](index.md) - Parametric Patterns overview

**Related:**
- [`parametric-architecture.md`](parametric-architecture.md) - Type dispatch patterns
- [`../../cross-domain/parameter-conventions.md`](../../cross-domain/parameter-conventions.md) - Naming standards

## Metadata
- **Created:** 2025-12-28
- **Last Updated:** 2025-12-28
- **Document Type:** Pattern
