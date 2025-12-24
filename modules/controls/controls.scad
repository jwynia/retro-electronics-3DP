// Control Panel Faceplate Generator
// Creates face plates with potentiometer, switch, and LED mounting.
// Designed for audio equipment, amplifiers, and retro electronics.

include <BOSL2/std.scad>

// Default values
_CONTROLS_THICKNESS = 4;
_CONTROLS_CORNER_R = 8;

// Common potentiometer shaft sizes
POT_SHAFT_6MM = 6.2;    // Standard 6mm shaft + clearance
POT_SHAFT_7MM = 7.2;    // Alpha 7mm shaft + clearance

// Common LED sizes
LED_3MM = 3.2;
LED_5MM = 5.2;

// ============================================================
// CONTROL HOLE GENERATORS (Internal)
// ============================================================

/**
 * Potentiometer mounting hole with optional D-shaft flat
 * Standard 9mm mounting hole for panel-mount pots
 */
module _pot_mount_hole(
    shaft_dia = POT_SHAFT_6MM,
    mount_dia = 9.5,        // Standard pot bushing is 9mm
    d_shaft = false,        // Add D-shaft anti-rotation flat
    d_depth = 1.5,          // Depth of D-flat pocket
    thickness
) {
    // Main shaft hole (through)
    cyl(d=shaft_dia, h=thickness + 1, anchor=CENTER, $fn=32);

    // Mounting bushing hole (through, slightly larger)
    cyl(d=mount_dia, h=thickness + 1, anchor=CENTER, $fn=32);

    // D-shaft anti-rotation pocket (on back)
    if (d_shaft) {
        translate([0, 0, -thickness/2])
        difference() {
            cyl(d=shaft_dia + 2, h=d_depth + 0.1, anchor=BOT, $fn=32);
            translate([shaft_dia/2, 0, -0.1])
            cube([shaft_dia, shaft_dia + 2, d_depth + 0.3], center=true);
        }
    }
}

/**
 * Rotary encoder mounting hole
 * Typically has D-shaft and may need additional holes for encoder pins
 */
module _encoder_mount_hole(
    shaft_dia = POT_SHAFT_6MM,
    mount_dia = 7.2,
    pin_spacing = 10,       // Distance between mounting pins
    pin_dia = 2.5,
    has_pins = true,
    thickness
) {
    // Main shaft hole
    cyl(d=shaft_dia, h=thickness + 1, anchor=CENTER, $fn=32);

    // Mounting bushing
    cyl(d=mount_dia, h=thickness + 1, anchor=CENTER, $fn=32);

    // Mounting pin holes (if present)
    if (has_pins) {
        for (x = [-1, 1]) {
            translate([x * pin_spacing/2, 0, 0])
            cyl(d=pin_dia, h=thickness + 1, anchor=CENTER, $fn=16);
        }
    }
}

/**
 * LED mounting hole
 */
module _led_hole(dia = LED_5MM, thickness) {
    cyl(d=dia, h=thickness + 1, anchor=CENTER, $fn=24);
}

/**
 * Toggle switch mounting hole (standard 6mm mini toggle)
 */
module _toggle_switch_hole(mount_dia = 6.5, thickness) {
    cyl(d=mount_dia, h=thickness + 1, anchor=CENTER, $fn=24);
}

/**
 * Rocker switch rectangular cutout
 */
module _rocker_switch_hole(size = [13, 19.5], corner_r = 1, thickness) {
    cuboid([size[0], size[1], thickness + 1],
           rounding=corner_r, edges="Z", anchor=CENTER);
}

/**
 * USB-C port cutout
 */
module _usbc_hole(thickness) {
    // USB-C port: ~9mm wide x 3.2mm tall, rounded ends
    hull() {
        for (x = [-1, 1]) {
            translate([x * 3, 0, 0])
            cyl(d=3.2, h=thickness + 1, anchor=CENTER, $fn=24);
        }
    }
}

/**
 * 3.5mm audio jack hole
 */
module _audio_jack_hole(mount_dia = 6.5, thickness) {
    cyl(d=mount_dia, h=thickness + 1, anchor=CENTER, $fn=24);
}

/**
 * Decorative pointer groove (for knob alignment)
 */
module _pointer_groove(length = 15, width = 1, depth = 0.5) {
    translate([0, length/2, 0])
    cuboid([width, length, depth + 0.1], anchor=CENTER);
}

// ============================================================
// MAIN MODULE
// ============================================================

/**
 * Creates a face plate with control mounting holes.
 *
 * Arguments:
 *   size          - [width, height] outer dimensions
 *   thickness     - plate thickness (default: 4)
 *   corner_r      - corner radius (default: 8)
 *
 *   controls      - array of control definitions, each is:
 *                   ["pot", [x,y], shaft_dia, d_shaft]
 *                   ["encoder", [x,y], shaft_dia, has_pins]
 *                   ["led", [x,y], diameter]
 *                   ["toggle", [x,y], mount_dia]
 *                   ["rocker", [x,y], [width, height]]
 *                   ["usbc", [x,y]]
 *                   ["audio", [x,y], mount_dia]
 *                   ["hole", [x,y], diameter]  (generic round hole)
 *                   ["slot", [x,y], [width, height], corner_r]
 *
 *   style         - "plain" or "braun" (adds subtle border)
 *   pointer_marks - add pointer grooves above pots (default: false)
 *
 *   steel_pockets - include steel pockets for magnetic mount (default: true)
 *   steel_inset   - distance from corner to pocket center (default: 12)
 *   steel_dia     - steel disc diameter (default: 10)
 *   steel_depth   - pocket depth (default: 1)
 *
 * Example:
 *   faceplate_controls(
 *       size = [150, 60],
 *       controls = [
 *           ["pot", [0, 0], POT_SHAFT_6MM, true],
 *           ["led", [50, 0], LED_5MM],
 *           ["toggle", [-50, 0], 6.5]
 *       ]
 *   );
 */
module faceplate_controls(
    size,
    thickness = _CONTROLS_THICKNESS,
    corner_r = _CONTROLS_CORNER_R,
    controls = [],
    style = "plain",
    pointer_marks = false,
    // Magnetic mounting
    steel_pockets = true,
    steel_inset = 12,
    steel_dia = 10,
    steel_depth = 1,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    width = size[0];
    height = size[1];

    // Steel pocket positions
    pocket_positions = [
        [ width/2 - steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset, -height/2 + steel_inset],
        [ width/2 - steel_inset, -height/2 + steel_inset]
    ];

    attachable(anchor, spin, orient, size=[width, height, thickness]) {
        union() {
            diff()
            cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {

                // Process each control
                for (ctrl = controls) {
                    ctrl_type = ctrl[0];
                    ctrl_pos = ctrl[1];

                    tag("remove")
                    translate([ctrl_pos[0], ctrl_pos[1], 0]) {
                        if (ctrl_type == "pot") {
                            shaft = len(ctrl) > 2 ? ctrl[2] : POT_SHAFT_6MM;
                            d_shaft = len(ctrl) > 3 ? ctrl[3] : false;
                            _pot_mount_hole(shaft_dia=shaft, d_shaft=d_shaft, thickness=thickness);
                        }
                        else if (ctrl_type == "encoder") {
                            shaft = len(ctrl) > 2 ? ctrl[2] : POT_SHAFT_6MM;
                            has_pins = len(ctrl) > 3 ? ctrl[3] : true;
                            _encoder_mount_hole(shaft_dia=shaft, has_pins=has_pins, thickness=thickness);
                        }
                        else if (ctrl_type == "led") {
                            dia = len(ctrl) > 2 ? ctrl[2] : LED_5MM;
                            _led_hole(dia=dia, thickness=thickness);
                        }
                        else if (ctrl_type == "toggle") {
                            dia = len(ctrl) > 2 ? ctrl[2] : 6.5;
                            _toggle_switch_hole(mount_dia=dia, thickness=thickness);
                        }
                        else if (ctrl_type == "rocker") {
                            sz = len(ctrl) > 2 ? ctrl[2] : [13, 19.5];
                            _rocker_switch_hole(size=sz, thickness=thickness);
                        }
                        else if (ctrl_type == "usbc") {
                            _usbc_hole(thickness=thickness);
                        }
                        else if (ctrl_type == "audio") {
                            dia = len(ctrl) > 2 ? ctrl[2] : 6.5;
                            _audio_jack_hole(mount_dia=dia, thickness=thickness);
                        }
                        else if (ctrl_type == "hole") {
                            dia = len(ctrl) > 2 ? ctrl[2] : 5;
                            cyl(d=dia, h=thickness + 1, anchor=CENTER, $fn=24);
                        }
                        else if (ctrl_type == "slot") {
                            sz = len(ctrl) > 2 ? ctrl[2] : [10, 20];
                            r = len(ctrl) > 3 ? ctrl[3] : 2;
                            cuboid([sz[0], sz[1], thickness + 1],
                                   rounding=r, edges="Z", anchor=CENTER);
                        }
                    }
                }

                // Steel disc pockets for magnetic attachment
                if (steel_pockets) {
                    tag("remove")
                    position(BOT)
                    for (pos = pocket_positions) {
                        translate([pos[0], pos[1], 0])
                        cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
                    }
                }
            }

            // Pointer marks (grooves above pot positions)
            if (pointer_marks) {
                for (ctrl = controls) {
                    if (ctrl[0] == "pot" || ctrl[0] == "encoder") {
                        translate([ctrl[1][0], ctrl[1][1] + 12, thickness/2])
                        difference() {
                            translate([0, 4, 0])
                            cube([1.5, 8, 1], center=true);
                            // nothing to subtract, just a visual groove
                        }
                    }
                }
            }

            // Braun-style border
            if (style == "braun") {
                difference() {
                    translate([0, 0, thickness/2])
                    cuboid([width - 1, height - 1, 0.6],
                           chamfer=0.3, edges="Z", anchor=BOT);

                    translate([0, 0, thickness/2 - 0.1])
                    cuboid([width - 4, height - 4, 1],
                           chamfer=0.2, edges="Z", anchor=BOT);
                }
            }
        }

        children();
    }
}

/**
 * Creates a simple control strip for inline mounting.
 * Thinner and narrower than full faceplate, for mounting below/above grilles.
 *
 * Arguments:
 *   length     - strip length
 *   height     - strip height (default: 25)
 *   thickness  - plate thickness (default: 3)
 *   controls   - array of control definitions (same as faceplate_controls)
 *   end_style  - "square", "rounded", or "tapered"
 */
module control_strip(
    length,
    height = 25,
    thickness = 3,
    corner_r = 4,
    controls = [],
    end_style = "rounded",
    steel_pockets = false,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    end_r = end_style == "rounded" ? height/2 :
            end_style == "tapered" ? height/3 : corner_r;

    attachable(anchor, spin, orient, size=[length, height, thickness]) {
        diff()
        cuboid([length, height, thickness], rounding=end_r, edges="Z", anchor=CENTER) {

            // Process controls
            for (ctrl = controls) {
                ctrl_type = ctrl[0];
                ctrl_pos = ctrl[1];

                tag("remove")
                translate([ctrl_pos[0], ctrl_pos[1], 0]) {
                    if (ctrl_type == "pot") {
                        shaft = len(ctrl) > 2 ? ctrl[2] : POT_SHAFT_6MM;
                        _pot_mount_hole(shaft_dia=shaft, thickness=thickness);
                    }
                    else if (ctrl_type == "led") {
                        dia = len(ctrl) > 2 ? ctrl[2] : LED_5MM;
                        _led_hole(dia=dia, thickness=thickness);
                    }
                    else if (ctrl_type == "toggle") {
                        dia = len(ctrl) > 2 ? ctrl[2] : 6.5;
                        _toggle_switch_hole(mount_dia=dia, thickness=thickness);
                    }
                }
            }
        }

        children();
    }
}

// ============================================================
// TEST / DEMO
// ============================================================

if ($preview) {
    // Demo: Control panel with volume pot, power LED, aux input
    faceplate_controls(
        size = [150, 50],
        thickness = 4,
        corner_r = 6,
        style = "braun",
        controls = [
            ["pot", [0, 0], POT_SHAFT_6MM, true],      // Volume pot with D-shaft
            ["led", [50, 0], LED_3MM],                  // Power LED
            ["audio", [-50, 0], 6.5]                    // Aux input
        ]
    );
}
