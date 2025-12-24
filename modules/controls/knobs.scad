// Knob Generator
// Creates retro-styled control knobs for potentiometers and encoders.
// Supports Braun, classic, and skirt styles.

include <BOSL2/std.scad>

// Default values
_KNOB_DIA = 25;
_KNOB_HEIGHT = 15;
_SHAFT_DIA = 6;
_SHAFT_DEPTH = 10;

// ============================================================
// SHAFT BORE GENERATORS (Internal)
// ============================================================

/**
 * Round shaft bore (standard potentiometer)
 */
module _shaft_bore_round(dia, depth, tolerance = 0.2) {
    cyl(d=dia + tolerance, h=depth + 1, anchor=TOP, $fn=32);
}

/**
 * D-shaft bore (most common for pots with anti-rotation)
 */
module _shaft_bore_d(dia, depth, flat_depth = 1.2, tolerance = 0.2) {
    difference() {
        cyl(d=dia + tolerance, h=depth + 1, anchor=TOP, $fn=32);
        // D-flat
        translate([dia/2 - flat_depth + tolerance/2, 0, -depth/2])
        cube([dia, dia + 2, depth + 2], center=true);
    }
}

/**
 * Knurled shaft bore (split with compression)
 */
module _shaft_bore_knurled(dia, depth, slots = 4, tolerance = 0.1) {
    difference() {
        cyl(d=dia + tolerance, h=depth + 1, anchor=TOP, $fn=32);
        // Compression slots
        for (a = [0 : 360/slots : 359]) {
            rotate([0, 0, a])
            translate([0, 0, -depth/2 - 0.5])
            cube([0.8, dia * 2, depth + 2], center=true);
        }
    }
}

/**
 * Set screw bore (round with perpendicular screw hole)
 */
module _shaft_bore_setscrew(dia, depth, screw_dia = 3, tolerance = 0.2) {
    // Main bore
    cyl(d=dia + tolerance, h=depth + 1, anchor=TOP, $fn=32);

    // Set screw hole (M3)
    translate([0, 0, -depth/2])
    rotate([0, 90, 0])
    cyl(d=screw_dia, h=dia * 2, anchor=CENTER, $fn=24);
}

// ============================================================
// KNOB STYLE GENERATORS
// ============================================================

/**
 * Braun-style knob
 * Clean cylinder with flat top, minimal chamfer, optional pointer line
 */
module _knob_braun(
    dia, height,
    chamfer = 0.8,
    pointer = true,
    pointer_width = 1.2,
    pointer_depth = 0.8,
    pointer_length = 0
) {
    pl = pointer_length > 0 ? pointer_length : dia/2 - 3;

    difference() {
        // Main body
        cyl(d=dia, h=height, chamfer2=chamfer, anchor=BOT, $fn=64);

        // Pointer groove
        if (pointer) {
            translate([0, dia/4, height])
            cuboid([pointer_width, pl, pointer_depth * 2], anchor=TOP);
        }
    }
}

/**
 * Classic radio knob
 * Slightly domed top, decorative ring
 */
module _knob_classic(
    dia, height,
    dome = 2,
    ring_inset = 2,
    ring_depth = 0.5,
    pointer = true
) {
    difference() {
        union() {
            // Main body with slight dome
            cyl(d=dia, h=height - dome, anchor=BOT, $fn=64);

            // Domed top
            translate([0, 0, height - dome])
            scale([1, 1, dome / (dia/4)])
            sphere(d=dia/2, $fn=48);
        }

        // Ring groove
        translate([0, 0, height - dome - ring_inset])
        difference() {
            cyl(d=dia + 1, h=ring_depth, anchor=CENTER, $fn=64);
            cyl(d=dia - 3, h=ring_depth + 1, anchor=CENTER, $fn=64);
        }

        // Pointer dot
        if (pointer) {
            translate([0, dia/2 - 3, height])
            cyl(d=2, h=2, anchor=TOP, $fn=16);
        }
    }
}

/**
 * Skirt knob (amp/hi-fi style)
 * Larger base with numbered skirt, smaller top grip
 */
module _knob_skirt(
    dia, height,
    skirt_height = 5,
    skirt_extra = 8,
    grip_dia = 0,
    pointer = true
) {
    gd = grip_dia > 0 ? grip_dia : dia - 6;

    // Skirt base
    cyl(d=dia + skirt_extra, h=skirt_height, chamfer1=1, anchor=BOT, $fn=64);

    // Main grip
    translate([0, 0, skirt_height - 0.5])
    difference() {
        cyl(d=gd, h=height - skirt_height + 0.5, chamfer2=1, anchor=BOT, $fn=64);

        // Pointer line
        if (pointer) {
            translate([0, gd/4, height - skirt_height])
            cuboid([1.5, gd/2 - 2, 1], anchor=TOP);
        }
    }
}

/**
 * Knurled knob
 * Vertical ridges around circumference for grip
 */
module _knob_knurled(
    dia, height,
    ridges = 24,
    ridge_depth = 1,
    chamfer = 1,
    pointer = true
) {
    difference() {
        // Main body
        cyl(d=dia, h=height, chamfer=chamfer, anchor=BOT, $fn=64);

        // Knurl ridges (V-grooves)
        for (a = [0 : 360/ridges : 359]) {
            rotate([0, 0, a])
            translate([dia/2, 0, height/2])
            rotate([0, 0, 45])
            cube([ridge_depth * 1.5, ridge_depth * 1.5, height + 1], center=true);
        }

        // Pointer groove
        if (pointer) {
            translate([0, dia/4, height])
            cuboid([1.2, dia/2 - 2, 1], anchor=TOP);
        }
    }
}

/**
 * Stepped knob (detent-style, like vintage Tektronix)
 */
module _knob_stepped(
    dia, height,
    steps = 3,
    step_height = 0,
    step_inset = 2,
    pointer = true
) {
    sh = step_height > 0 ? step_height : height / steps;

    difference() {
        union() {
            for (i = [0 : steps - 1]) {
                translate([0, 0, i * sh])
                cyl(d=dia - i * step_inset, h=sh + 0.1, anchor=BOT, $fn=64);
            }
        }

        // Pointer line on top step
        if (pointer) {
            step_dia = dia - (steps - 1) * step_inset;
            translate([0, step_dia/4, height])
            cuboid([1.2, step_dia/2 - 2, 1], anchor=TOP);
        }
    }
}

// ============================================================
// MAIN MODULE
// ============================================================

/**
 * Creates a control knob with configurable style and shaft bore.
 *
 * Arguments:
 *   dia           - outer diameter (default: 25)
 *   height        - total height (default: 15)
 *   style         - "braun", "classic", "skirt", "knurled", "stepped"
 *   shaft_dia     - potentiometer shaft diameter (default: 6)
 *   shaft_depth   - depth of shaft bore (default: 10)
 *   shaft_type    - "round", "d", "knurled", "setscrew"
 *   pointer       - include pointer indicator (default: true)
 *   color_cap     - optional color insert on top (for multi-function sets)
 *
 * Style-specific options (pass via style_options array):
 *   braun:    [chamfer, pointer_width, pointer_depth]
 *   classic:  [dome_height, ring_inset, ring_depth]
 *   skirt:    [skirt_height, skirt_extra, grip_dia]
 *   knurled:  [ridge_count, ridge_depth, chamfer]
 *   stepped:  [step_count, step_height, step_inset]
 *
 * Example:
 *   knob(dia=30, height=18, style="braun", shaft_type="d");
 */
module knob(
    dia = _KNOB_DIA,
    height = _KNOB_HEIGHT,
    style = "braun",
    shaft_dia = _SHAFT_DIA,
    shaft_depth = _SHAFT_DEPTH,
    shaft_type = "d",
    pointer = true,
    style_options = [],
    color_cap = undef,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    attachable(anchor, spin, orient, size=[dia, dia, height]) {
        union() {
            difference() {
                // Knob body based on style
                if (style == "braun") {
                    chamfer = len(style_options) > 0 ? style_options[0] : 0.8;
                    pw = len(style_options) > 1 ? style_options[1] : 1.2;
                    pd = len(style_options) > 2 ? style_options[2] : 0.8;
                    _knob_braun(dia, height, chamfer, pointer, pw, pd);
                }
                else if (style == "classic") {
                    dome = len(style_options) > 0 ? style_options[0] : 2;
                    ri = len(style_options) > 1 ? style_options[1] : 2;
                    rd = len(style_options) > 2 ? style_options[2] : 0.5;
                    _knob_classic(dia, height, dome, ri, rd, pointer);
                }
                else if (style == "skirt") {
                    sh = len(style_options) > 0 ? style_options[0] : 5;
                    se = len(style_options) > 1 ? style_options[1] : 8;
                    gd = len(style_options) > 2 ? style_options[2] : 0;
                    _knob_skirt(dia, height, sh, se, gd, pointer);
                }
                else if (style == "knurled") {
                    ridges = len(style_options) > 0 ? style_options[0] : 24;
                    rd = len(style_options) > 1 ? style_options[1] : 1;
                    ch = len(style_options) > 2 ? style_options[2] : 1;
                    _knob_knurled(dia, height, ridges, rd, ch, pointer);
                }
                else if (style == "stepped") {
                    steps = len(style_options) > 0 ? style_options[0] : 3;
                    sh = len(style_options) > 1 ? style_options[1] : 0;
                    si = len(style_options) > 2 ? style_options[2] : 2;
                    _knob_stepped(dia, height, steps, sh, si, pointer);
                }

                // Shaft bore
                if (shaft_type == "round") {
                    _shaft_bore_round(shaft_dia, shaft_depth);
                }
                else if (shaft_type == "d") {
                    _shaft_bore_d(shaft_dia, shaft_depth);
                }
                else if (shaft_type == "knurled") {
                    _shaft_bore_knurled(shaft_dia, shaft_depth);
                }
                else if (shaft_type == "setscrew") {
                    _shaft_bore_setscrew(shaft_dia, shaft_depth);
                }
            }

            // Color cap insert (optional)
            if (!is_undef(color_cap)) {
                color(color_cap)
                translate([0, 0, height - 0.5])
                cyl(d=dia/3, h=0.6, anchor=BOT, $fn=32);
            }
        }

        children();
    }
}

/**
 * Volume knob preset - larger, prominent
 */
module knob_volume(
    dia = 35,
    height = 20,
    shaft_dia = 6,
    style = "braun",
    shaft_type = "d"
) {
    knob(
        dia = dia,
        height = height,
        style = style,
        shaft_dia = shaft_dia,
        shaft_type = shaft_type,
        pointer = true
    );
}

/**
 * Small control knob preset - for secondary controls
 */
module knob_small(
    dia = 18,
    height = 12,
    shaft_dia = 6,
    style = "braun",
    shaft_type = "d"
) {
    knob(
        dia = dia,
        height = height,
        style = style,
        shaft_dia = shaft_dia,
        shaft_type = shaft_type,
        pointer = true
    );
}

/**
 * Encoder knob preset - typically used for digital controls
 * Often has detents, so no pointer needed
 */
module knob_encoder(
    dia = 20,
    height = 15,
    shaft_dia = 6,
    shaft_type = "d"
) {
    knob(
        dia = dia,
        height = height,
        style = "knurled",
        shaft_dia = shaft_dia,
        shaft_type = shaft_type,
        pointer = false,
        style_options = [20, 0.8, 0.8]  // Finer knurl
    );
}

// ============================================================
// TEST / DEMO
// ============================================================

if ($preview) {
    // Show different knob styles

    // Braun style (default)
    translate([-50, 0, 0])
    knob(dia=30, height=18, style="braun");

    // Classic radio style
    translate([0, 0, 0])
    knob(dia=30, height=18, style="classic");

    // Skirt style
    translate([50, 0, 0])
    knob(dia=25, height=20, style="skirt");

    // Knurled
    translate([-25, 50, 0])
    knob(dia=25, height=15, style="knurled");

    // Stepped
    translate([25, 50, 0])
    knob(dia=28, height=18, style="stepped");
}
