# Mechanical Joint Patterns

## Purpose

Patterns for creating threaded connections, dovetail joints, and other mechanical joining methods in parametric OpenSCAD models.

## Classification
- **Domain:** Parametric Patterns
- **Stability:** Stable
- **Abstraction:** Pattern
- **Confidence:** Established

## Overview

Mechanical joints enable assemblies of printed parts. Threading provides secure closures, dovetails create interlocking connections, and various joint types serve different structural needs.

---

## Threading Patterns

### BOSL2 Threaded Rod

Standard triangular (ISO/UTS) threaded rod using BOSL2.

```openscad
include <BOSL2/std.scad>;
include <BOSL2/threading.scad>;

threaded_rod(
    d = Diameter,              // Major diameter
    l = Rod_Length,            // Length
    pitch = Pitch,             // Thread pitch (distance per turn)
    left_handed = Left_Handed, // Reverse thread direction
    starts = Starts,           // Number of thread starts (1 = standard)
    bevel1 = Rod_Bevel_Bottom, // Bevel bottom end
    bevel2 = Rod_Bevel_Top,    // Bevel top end
    blunt_start1 = Blunt_Start_Bottom,  // Truncated start bottom
    blunt_start2 = Blunt_Start_Top,     // Truncated start top
    end_len = End_Length,      // Unthreaded length after blunt start
    anchor = BOTTOM
);
```
**Source:** thread-generator.scad:196-208

**Key Points:**
- `pitch` is distance per revolution (not threads per inch)
- `blunt_start` creates truncated thread entry for easier assembly
- `bevel` chamfers the thread ends
- `starts > 1` creates multi-start threads (faster engagement)

### BOSL2 Threaded Nut

```openscad
threaded_nut(
    nutwidth = Nut_WAF,        // Width across flats
    id = Diameter,             // Inner diameter (matches rod)
    h = Nut_Thickness,         // Nut thickness
    pitch = Pitch,             // Must match rod pitch
    left_handed = Left_Handed,
    shape = Nut_Shape,         // "hex" or "square"
    starts = Starts,
    bevel = Nut_Outer_Bevel,   // Bevel outer edges
    bevel1 = Nut_Flush ? false : undef,  // Bottom bevel control
    ibevel = Nut_Inner_Bevel,  // Bevel inner thread
    blunt_start1 = Blunt_Start_Bottom,
    blunt_start2 = Blunt_Start_Top,
    end_len = End_Length,
    anchor = BOTTOM
);
```
**Source:** thread-generator.scad:210-226

**Key Points:**
- `nutwidth` is across flats (not across corners)
- `shape = "hex"` or `"square"` for nut shape
- `ibevel` chamfers internal thread entry

### Trapezoidal Threading (ISO 2904)

For load-bearing applications like leadscrews.

```openscad
trapezoidal_threaded_rod(
    d = Diameter,
    l = Rod_Length,
    pitch = Pitch,
    left_handed = Left_Handed,
    starts = Starts,
    bevel1 = Rod_Bevel_Bottom,
    bevel2 = Rod_Bevel_Top,
    blunt_start1 = Blunt_Start_Bottom,
    blunt_start2 = Blunt_Start_Top,
    end_len = End_Length,
    thread_angle = 30,         // ISO standard: 30 degrees
    anchor = $rod_anchor
);

trapezoidal_threaded_nut(
    nutwidth = Nut_WAF,
    id = Diameter,
    h = Nut_Thickness,
    pitch = Pitch,
    thread_angle = 30,
    // ... other parameters same as triangular
);
```
**Source:** thread-generator.scad:234-268

**Key Points:**
- 30-degree flank angle (ISO standard)
- Better load distribution than triangular
- Lower friction for linear motion

### ACME Threading (ANSI B1.5)

North American leadscrew standard.

```openscad
acme_threaded_rod(
    d = Diameter,
    l = Rod_Length,
    pitch = Pitch,
    // Thread angle is built-in: 29 degrees
    // ... other parameters same as triangular
);

acme_threaded_nut(
    nutwidth = Nut_WAF,
    id = Diameter,
    h = Nut_Thickness,
    pitch = Pitch,
    // ... other parameters
);
```
**Source:** thread-generator.scad:275-307

**Key Points:**
- 29-degree flank angle (ANSI standard)
- Common for US machinery
- Slightly different profile than ISO trapezoidal

### Buttress Threading

For high axial load in one direction.

```openscad
buttress_threaded_rod(
    d = Diameter,
    l = Rod_Length,
    pitch = Pitch,
    // 45-degree flank angle on one side
    // ... other parameters
);
```
**Source:** thread-generator.scad:314-346

**Key Points:**
- Asymmetric thread profile
- Maximum strength in one direction
- Used for vises, presses

### Square Threading

Maximum power transmission efficiency.

```openscad
square_threaded_rod(
    d = Diameter,
    l = Rod_Length,
    pitch = Pitch,
    // 0-degree flank angle (perfectly square)
    // ... other parameters
);

// Note: Use trapezoidal_threaded_nut with thread_angle = 0
trapezoidal_threaded_nut(
    thread_angle = 0,          // Makes it square
    nutwidth = Nut_WAF,
    id = Diameter,
    h = Nut_Thickness,
    pitch = Pitch,
    // ... other parameters
);
```
**Source:** thread-generator.scad:351-378

**Key Points:**
- Most efficient power transmission
- No radial force component
- Hardest to manufacture

---

## Container Threading

For screw-on lids and modular containers.

### External Thread for Male Connector

```openscad
module model_external_thread(hollow = true) {
    difference() {
        create_threaded_rod(
            internal = false,
            orient = DOWN,
            spin = 180,
            anchor = TOP
        );

        // Hollow interior
        if (hollow) {
            cyl(
                h = Thread_Height + 0.1,
                d = Container_Diameter,
                chamfer2 = Thread_Wall_Chamfer,
                anchor = TOP
            );
        }
    }
}
```
**Source:** cirkit-pods.scad:358-379

**Key Points:**
- `internal = false` creates external (male) threads
- Hollow center for container function
- Chamfer on interior for assembly ease

### Internal Thread for Female Connector

```openscad
module model_internal_thread(orient = DOWN, anchor) {
    difference() {
        cyl(
            h = Thread_Height,
            d = Thread_Diameter + Shift_Out,
            anchor = anchor,
            orient = orient
        );

        // Cut out internal thread
        create_threaded_rod(
            internal = true,
            orient = orient,
            anchor = anchor
        );
    }
}
```
**Source:** cirkit-pods.scad:380-397

**Key Points:**
- `internal = true` creates internal (female) threads
- Outer cylinder minus threaded rod = female thread
- `Shift_Out` provides assembly clearance

### Threaded Ring Module

Combines ring with threading for modular containers.

```openscad
module model_internal_threaded_ring() {
    model_ring(hollow = false) {
        // Internal thread cavity with beveled chamfer
        tag(REMOVE) attach(TOP, TOP, inside = true)
            cyl(
                h = Thread_Height + Thread_Bridge,
                d = Thread_Diameter,
                chamfer1 = Thread_Bridge,
                chamfang1 = 50
            );

        tag(KEEP) position(TOP)
            model_internal_thread(orient = UP, anchor = TOP);
    }
}
```
**Source:** cirkit-pods.scad:421-436

**Key Points:**
- Uses BOSL2 diff/tag pattern for boolean operations
- `Thread_Bridge` creates chamfered entry
- `chamfang1 = 50` sets chamfer angle

---

## Dovetail Joints

Interlocking joints for drawer dividers and panel connections.

### Dovetail Tooth Module

```openscad
module dovetail_teeth(width, height, thickness) {
    offset = width / 3;  // Taper ratio
    translate([-width/2, -height/2, 1]) {
        linear_extrude(height = thickness) {
            polygon([
                [0, 0],
                [width, 0],
                [width - offset, height],
                [offset, height]
            ]);
        }
    }
}
```
**Source:** drawer-divider.scad:71-83

**Key Points:**
- Trapezoidal profile with 1/3 taper
- `offset = width / 3` is traditional dovetail ratio
- Thickness controls tooth depth

### Dovetail Male/Female Generator

```openscad
module dovetail(width, teeth_count, teeth_height, teeth_thickness, clear = dovetail_clearence, male = true, debug = false) {
    y = ((width - 1 * 2 * clear) / 1) / 4;
    teeth_width = y * 3;
    offset = teeth_width / 3;
    start_at = clear * 2 + teeth_width/2 - width/2 - clear;

    translate([0, 0, -teeth_thickness/2]) {
        for (i = [-1 : 1 * 2 - 1]) {
            x = start_at + y/2 + (teeth_width - offset + clear) * i;
            if (i % 2) {
                // Odd positions: male teeth
                x = x + 0.1;
                translate([x + compensation, -clear, 0]) {
                    rotate([0, 0, 180]) {
                        if (male == true) {
                            dovetail_teeth(teeth_width - clear, teeth_height - clear, teeth_thickness);
                        }
                    }
                }
            } else {
                // Even positions: female teeth
                translate([x, clear, 0]) {
                    if (male == false) {
                        dovetail_teeth(teeth_width - clear, teeth_height - clear, teeth_thickness);
                    }
                }
            }
        }
    }
}
```
**Source:** drawer-divider.scad:85-120

**Key Points:**
- `male = true` for protruding teeth
- `male = false` for receiving slots
- `clear` parameter for print tolerance
- Alternating pattern for interlocking

### Dovetail Cutter with Base

```openscad
module cutter(position, dimension, teeths, male = true, debug = false) {
    translate(position) {
        dovetail(dimension[0], teeths[0], teeths[1], dimension[2], teeths[2], male, debug);
        if (male) {
            // Male: add base below teeth
            translate([
                -dimension[0]/2,
                -(teeths[1]/2 - 0.1) - dimension[1],
                -dimension[2]/2
            ]) {
                cube(size = dimension, center = false);
            }
        } else {
            // Female: add base above teeth (for subtraction)
            translate([
                -dimension[0]/2,
                teeths[1]/2 - 0.1,
                -dimension[2]/2
            ]) {
                cube(size = dimension, center = false);
            }
        }
    }
}
```
**Source:** drawer-divider.scad:122-143

**Key Points:**
- Combines dovetail teeth with solid base
- Male: base behind teeth
- Female: base in front (for difference operation)

---

## Junction Block Calculation

Calculate positions for evenly-spaced junction blocks.

### Equal Junction Positions

```openscad
function equal_junction_positions(num_junctions, jwidth, total_length) =
    let(
        // Calculate space available for segments
        available_space = total_length - (num_junctions * jwidth),
        // Calculate segment length (all equal)
        segment_length = available_space / (num_junctions + 1),
        // Generate junction positions
        positions = [for (i = [1 : num_junctions])
                     i * segment_length + (i-1) * jwidth]
    )
    positions;
```
**Source:** drawer-divider.scad:222-232

**Key Points:**
- Returns array of X positions for junctions
- Equal spacing between junctions
- Accounts for junction width in calculation

### Junction Positions Including Ends

```openscad
function junction_positions(num_internal, jwidth, total_length) =
    let(
        total_junctions = num_internal + 2,  // Add end junctions
        gap = (total_length - total_junctions * jwidth) / (total_junctions - 1)
    )
    [ for (i = [0 : total_junctions - 1])
        i * (jwidth + gap)
    ];
```
**Source:** drawer-divider.scad:235-242

**Key Points:**
- Includes junctions at both ends
- `num_internal` is junctions between ends
- Uniform gap calculation

---

## Thread Parameter Validation

```openscad
assert(Thread_Height >= 4, "Thread_Height must be at least 4mm.");
assert(Thread_Pitch > 0.2, "Thread_Pitch is too small; must be greater than 0.2.");
assert(Thread_Depth < (Thread_Pitch / 2),
    "Thread_Depth is too large; must be less than half the pitch.");
assert(Thread_Flank_Angle >= 15 && Thread_Flank_Angle <= 45,
    "Thread_Flank_Angle must be between 15 and 45 degrees.");
assert(Thread_Height < Ring_Height - Thread_Wall,
    "Thread_Height is larger than available ring height.");
```
**Source:** cirkit-pods.scad:98-103

**Key Points:**
- Minimum thread height for engagement
- Pitch > 0.2mm for printability
- Depth < pitch/2 to avoid interference
- Flank angle in practical range (15-45 degrees)

---

## Thread Types Comparison

| Type | Flank Angle | Use Case | BOSL2 Module |
|------|-------------|----------|--------------|
| Triangular (ISO/UTS) | 60 deg | General fasteners | `threaded_rod()` |
| Trapezoidal (ISO 2904) | 30 deg | Leadscrews, containers | `trapezoidal_threaded_rod()` |
| ACME (ANSI B1.5) | 29 deg | US machinery | `acme_threaded_rod()` |
| Buttress | 45 deg/0 deg | High unidirectional load | `buttress_threaded_rod()` |
| Square | 0 deg | Max efficiency | `square_threaded_rod()` |

---

## Clearance Guidelines

| Joint Type | Recommended Clearance |
|------------|----------------------|
| Thread fit | 0.1 - 0.15mm |
| Dovetail loose | 0.1 - 0.2mm |
| Dovetail tight | 0.05 - 0.1mm |
| Snap fit | 0.0 - 0.05mm |

---

## Navigation

**Up:** [`index.md`](index.md) - Parametric Patterns overview

**Related:**
- [`fdm-optimization.md`](fdm-optimization.md) - Tolerances and clearances
- [`customizer-ui.md`](customizer-ui.md) - Thread parameter UI

## Metadata
- **Created:** 2025-12-28
- **Last Updated:** 2025-12-28
- **Document Type:** Pattern
