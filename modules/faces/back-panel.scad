// Back Panel Generator
// Creates back panels with port cutouts for electronics enclosures.
// Supports USB-C, barrel jacks, switches, and ventilation.

include <BOSL2/std.scad>

// Default values
_BACKPANEL_THICKNESS = 3;
_BACKPANEL_CORNER_R = 8;

// ============================================================
// PORT CUTOUT GENERATORS (Internal)
// ============================================================

/**
 * USB-C port cutout
 * Standard: 9mm wide x 3.2mm tall, rounded ends
 */
module _port_usbc(thickness, tolerance = 0.3) {
    hull() {
        for (x = [-1, 1]) {
            translate([x * 2.9, 0, 0])
            cyl(d=3.2 + tolerance, h=thickness + 1, anchor=CENTER, $fn=24);
        }
    }
}

/**
 * USB Micro-B port cutout
 * ~8mm wide x 2.8mm tall
 */
module _port_usb_micro(thickness, tolerance = 0.3) {
    cuboid([8 + tolerance, 2.8 + tolerance, thickness + 1],
           rounding=0.5, edges="Z", anchor=CENTER);
}

/**
 * Barrel jack / DC power port
 * Common sizes: 5.5mm, 5.1mm outer
 */
module _port_barrel(thickness, dia = 8, tolerance = 0.3) {
    cyl(d=dia + tolerance, h=thickness + 1, anchor=CENTER, $fn=32);
}

/**
 * 3.5mm audio jack
 */
module _port_audio_35(thickness, tolerance = 0.3) {
    cyl(d=6.5 + tolerance, h=thickness + 1, anchor=CENTER, $fn=32);
}

/**
 * Toggle switch hole (mini toggle)
 */
module _port_toggle(thickness, dia = 6.5, tolerance = 0.2) {
    cyl(d=dia + tolerance, h=thickness + 1, anchor=CENTER, $fn=24);
}

/**
 * Rocker switch cutout
 */
module _port_rocker(thickness, size = [13, 19.5], tolerance = 0.3) {
    cuboid([size[0] + tolerance, size[1] + tolerance, thickness + 1],
           rounding=1, edges="Z", anchor=CENTER);
}

/**
 * Slide switch slot
 */
module _port_slide(thickness, size = [8, 4], tolerance = 0.3) {
    cuboid([size[0] + tolerance, size[1] + tolerance, thickness + 1],
           rounding=0.5, edges="Z", anchor=CENTER);
}

/**
 * Ventilation slots
 */
module _vent_slots(width, height, thickness, slot_width = 3, slot_count = 0, slot_spacing = 6) {
    sc = slot_count > 0 ? slot_count : floor(height / slot_spacing);
    offset_y = (height - (sc - 1) * slot_spacing) / 2;

    translate([0, -height/2 + offset_y, 0])
    for (i = [0 : sc - 1]) {
        translate([0, i * slot_spacing, 0])
        cuboid([width, slot_width, thickness + 1], rounding=slot_width/2, edges="Z", anchor=CENTER);
    }
}

/**
 * Ventilation grid (circular holes)
 */
module _vent_grid(width, height, thickness, hole_dia = 4, spacing = 6) {
    cols = floor(width / spacing);
    rows = floor(height / spacing);
    offset_x = (width - (cols - 1) * spacing) / 2;
    offset_y = (height - (rows - 1) * spacing) / 2;

    translate([-width/2 + offset_x, -height/2 + offset_y, 0])
    for (x = [0 : cols - 1], y = [0 : rows - 1]) {
        translate([x * spacing, y * spacing, 0])
        cyl(d=hole_dia, h=thickness + 1, anchor=CENTER, $fn=16);
    }
}

/**
 * Cable pass-through hole
 */
module _port_cable(thickness, dia = 10, tolerance = 0.5) {
    cyl(d=dia + tolerance, h=thickness + 1, anchor=CENTER, $fn=32);
}

/**
 * SD card slot
 */
module _port_sdcard(thickness, tolerance = 0.5) {
    // SD card: 24mm x 2.1mm
    cuboid([24 + tolerance, 2.5 + tolerance, thickness + 1],
           rounding=0.5, edges="Z", anchor=CENTER);
}

/**
 * HDMI port (standard)
 */
module _port_hdmi(thickness, tolerance = 0.3) {
    // HDMI: 14mm x 4.5mm with chamfered corners
    cuboid([14 + tolerance, 4.5 + tolerance, thickness + 1],
           chamfer=1, edges="Z", anchor=CENTER);
}

/**
 * Ethernet / RJ45 port
 */
module _port_ethernet(thickness, tolerance = 0.3) {
    // RJ45: 16mm x 13.5mm
    cuboid([16 + tolerance, 13.5 + tolerance, thickness + 1],
           rounding=1, edges="Z", anchor=CENTER);
}

// ============================================================
// MAIN MODULE
// ============================================================

/**
 * Creates a back panel with port cutouts.
 *
 * Arguments:
 *   size          - [width, height] outer dimensions
 *   thickness     - panel thickness (default: 3)
 *   corner_r      - corner radius (default: 8)
 *
 *   ports         - array of port definitions, each is:
 *                   ["usbc", [x, y]]
 *                   ["usb_micro", [x, y]]
 *                   ["barrel", [x, y], diameter]
 *                   ["audio", [x, y]]
 *                   ["toggle", [x, y], diameter]
 *                   ["rocker", [x, y], [width, height]]
 *                   ["slide", [x, y], [width, height]]
 *                   ["cable", [x, y], diameter]
 *                   ["sdcard", [x, y]]
 *                   ["hdmi", [x, y]]
 *                   ["ethernet", [x, y]]
 *                   ["hole", [x, y], diameter]
 *                   ["slot", [x, y], [width, height]]
 *                   ["vent_slots", [x, y], [width, height], slot_width, slot_count]
 *                   ["vent_grid", [x, y], [width, height], hole_dia, spacing]
 *
 *   mounting      - "magnetic", "screw", or "clip" (default: "magnetic")
 *
 *   Mounting options (same as other faceplates):
 *   steel_pockets, steel_inset, steel_dia, steel_depth
 *   screw_inset, screw_dia, countersink, cs_dia, cs_depth
 *
 * Example:
 *   back_panel(
 *       size = [120, 60],
 *       ports = [
 *           ["usbc", [0, 10]],
 *           ["toggle", [40, 10], 6.5],
 *           ["vent_slots", [0, -15], [60, 20]]
 *       ]
 *   );
 */
module back_panel(
    size,
    thickness = _BACKPANEL_THICKNESS,
    corner_r = _BACKPANEL_CORNER_R,
    ports = [],
    // Mounting type
    mounting = "magnetic",
    // Magnetic mounting
    steel_pockets = true,
    steel_inset = 12,
    steel_dia = 10,
    steel_depth = 1,
    // Screw mounting
    screw_inset = 10,
    screw_dia = 3.2,
    countersink = true,
    cs_dia = 6,
    cs_depth = 1.5,
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

    // Screw hole positions
    screw_positions = [
        [ width/2 - screw_inset,  height/2 - screw_inset],
        [-width/2 + screw_inset,  height/2 - screw_inset],
        [-width/2 + screw_inset, -height/2 + screw_inset],
        [ width/2 - screw_inset, -height/2 + screw_inset]
    ];

    attachable(anchor, spin, orient, size=[width, height, thickness]) {
        diff()
        cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {

            // Process each port
            for (port = ports) {
                port_type = port[0];
                port_pos = port[1];

                tag("remove")
                translate([port_pos[0], port_pos[1], 0]) {
                    if (port_type == "usbc") {
                        _port_usbc(thickness);
                    }
                    else if (port_type == "usb_micro") {
                        _port_usb_micro(thickness);
                    }
                    else if (port_type == "barrel") {
                        dia = len(port) > 2 ? port[2] : 8;
                        _port_barrel(thickness, dia);
                    }
                    else if (port_type == "audio") {
                        _port_audio_35(thickness);
                    }
                    else if (port_type == "toggle") {
                        dia = len(port) > 2 ? port[2] : 6.5;
                        _port_toggle(thickness, dia);
                    }
                    else if (port_type == "rocker") {
                        sz = len(port) > 2 ? port[2] : [13, 19.5];
                        _port_rocker(thickness, sz);
                    }
                    else if (port_type == "slide") {
                        sz = len(port) > 2 ? port[2] : [8, 4];
                        _port_slide(thickness, sz);
                    }
                    else if (port_type == "cable") {
                        dia = len(port) > 2 ? port[2] : 10;
                        _port_cable(thickness, dia);
                    }
                    else if (port_type == "sdcard") {
                        _port_sdcard(thickness);
                    }
                    else if (port_type == "hdmi") {
                        _port_hdmi(thickness);
                    }
                    else if (port_type == "ethernet") {
                        _port_ethernet(thickness);
                    }
                    else if (port_type == "hole") {
                        dia = len(port) > 2 ? port[2] : 5;
                        cyl(d=dia, h=thickness + 1, anchor=CENTER, $fn=24);
                    }
                    else if (port_type == "slot") {
                        sz = len(port) > 2 ? port[2] : [10, 5];
                        r = len(port) > 3 ? port[3] : 1;
                        cuboid([sz[0], sz[1], thickness + 1], rounding=r, edges="Z", anchor=CENTER);
                    }
                    else if (port_type == "vent_slots") {
                        sz = len(port) > 2 ? port[2] : [40, 20];
                        sw = len(port) > 3 ? port[3] : 3;
                        sc = len(port) > 4 ? port[4] : 0;
                        _vent_slots(sz[0], sz[1], thickness, sw, sc);
                    }
                    else if (port_type == "vent_grid") {
                        sz = len(port) > 2 ? port[2] : [40, 20];
                        hd = len(port) > 3 ? port[3] : 4;
                        sp = len(port) > 4 ? port[4] : 6;
                        _vent_grid(sz[0], sz[1], thickness, hd, sp);
                    }
                }
            }

            // Steel disc pockets (magnetic mounting)
            if (mounting == "magnetic" && steel_pockets) {
                tag("remove")
                position(BOT)
                for (pos = pocket_positions) {
                    translate([pos[0], pos[1], 0])
                    cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
                }
            }

            // Screw holes (screw mounting)
            if (mounting == "screw") {
                tag("remove")
                for (pos = screw_positions) {
                    translate([pos[0], pos[1], 0]) {
                        cyl(d=screw_dia, h=thickness + 1, anchor=CENTER, $fn=24);
                        if (countersink) {
                            up(thickness/2 - cs_depth + 0.01)
                            cyl(d1=screw_dia, d2=cs_dia, h=cs_depth + 0.01, anchor=BOT, $fn=24);
                        }
                    }
                }
            }
        }

        children();
    }
}

/**
 * Simplified back panel for bluetooth speaker.
 * Pre-configured with common bluetooth amp board ports.
 */
module back_panel_bluetooth(
    size,
    thickness = _BACKPANEL_THICKNESS,
    corner_r = _BACKPANEL_CORNER_R,
    usbc_pos = [0, 0],
    aux_pos = undef,
    switch_pos = undef,
    switch_type = "slide",
    vent = true,
    vent_pos = undef,
    vent_size = [40, 15],
    mounting = "magnetic",
    anchor = BOT
) {
    width = size[0];
    height = size[1];

    // Build ports array
    ports = concat(
        // USB-C (always)
        [["usbc", usbc_pos]],
        // Aux input (optional)
        !is_undef(aux_pos) ? [["audio", aux_pos]] : [],
        // Power switch (optional)
        !is_undef(switch_pos) ?
            (switch_type == "slide" ? [["slide", switch_pos]] :
             switch_type == "toggle" ? [["toggle", switch_pos]] :
             [["rocker", switch_pos]]) : [],
        // Ventilation (optional)
        vent ? [["vent_slots",
                 is_undef(vent_pos) ? [0, -height/4] : vent_pos,
                 vent_size]] : []
    );

    back_panel(
        size = size,
        thickness = thickness,
        corner_r = corner_r,
        ports = ports,
        mounting = mounting,
        anchor = anchor
    );
}

// ============================================================
// TEST / DEMO
// ============================================================

if ($preview) {
    // Demo: Back panel for bluetooth speaker
    back_panel(
        size = [120, 60],
        thickness = 3,
        corner_r = 6,
        ports = [
            ["usbc", [0, 15]],
            ["toggle", [40, 15], 6.5],
            ["audio", [-40, 15]],
            ["vent_slots", [0, -12], [80, 25], 3, 4]
        ]
    );
}
