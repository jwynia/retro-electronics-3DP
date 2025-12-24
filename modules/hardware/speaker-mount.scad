// Speaker Driver Mounting Hardware
// Creates mounting rings, baffles, and port tubes for speaker enclosures.

include <BOSL2/std.scad>

// Common speaker driver sizes (outer frame diameter)
SPEAKER_2IN = 57;      // 2" driver
SPEAKER_2_5IN = 66;    // 2.5" driver
SPEAKER_3IN = 77;      // 3" driver
SPEAKER_4IN = 102;     // 4" driver

// ============================================================
// SPEAKER MOUNTING RING
// ============================================================

/**
 * Creates a speaker driver mounting ring.
 * Mounts speaker from behind (typical for flush mounting).
 *
 * Arguments:
 *   driver_dia     - speaker frame outer diameter
 *   cone_dia       - speaker cone diameter (sound opening)
 *   screw_circle   - diameter of screw hole circle
 *   screw_count    - number of mounting screws (typically 4)
 *   screw_dia      - screw hole diameter (default: 3.2 for M3)
 *   ring_width     - width of mounting ring (default: 8)
 *   thickness      - ring thickness (default: 4)
 *   countersink    - add countersink for screw heads (default: true)
 *   cs_dia         - countersink diameter (default: 6)
 *   cs_depth       - countersink depth (default: 2)
 *   anchor         - BOSL2 anchor
 */
module speaker_mount_ring(
    driver_dia,
    cone_dia = 0,
    screw_circle = 0,
    screw_count = 4,
    screw_dia = 3.2,
    ring_width = 8,
    thickness = 4,
    countersink = true,
    cs_dia = 6,
    cs_depth = 2,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    // Calculate derived dimensions
    cd = cone_dia > 0 ? cone_dia : driver_dia - 12;
    sc = screw_circle > 0 ? screw_circle : driver_dia - 6;
    outer_dia = driver_dia + ring_width;

    attachable(anchor, spin, orient, size=[outer_dia, outer_dia, thickness]) {
        diff()
        cyl(d=outer_dia, h=thickness, anchor=CENTER, $fn=64) {
            // Center opening for cone
            tag("remove")
            cyl(d=cd, h=thickness + 1, anchor=CENTER, $fn=64);

            // Screw holes
            tag("remove")
            for (a = [0 : 360/screw_count : 359]) {
                rotate([0, 0, a])
                translate([sc/2, 0, 0]) {
                    // Through hole
                    cyl(d=screw_dia, h=thickness + 1, anchor=CENTER, $fn=24);
                    // Countersink
                    if (countersink) {
                        up(thickness/2 - cs_depth + 0.01)
                        cyl(d1=screw_dia, d2=cs_dia, h=cs_depth + 0.01, anchor=BOT, $fn=24);
                    }
                }
            }
        }

        children();
    }
}

/**
 * Creates a recessed speaker mounting pocket.
 * Use with diff() to cut into a baffle or shell.
 *
 * Arguments:
 *   driver_dia     - speaker frame outer diameter
 *   recess_depth   - how deep the speaker sits (frame thickness)
 *   cone_dia       - speaker cone diameter (through hole)
 *   tolerance      - extra clearance (default: 0.5)
 */
module speaker_pocket(
    driver_dia,
    recess_depth = 5,
    cone_dia = 0,
    tolerance = 0.5
) {
    cd = cone_dia > 0 ? cone_dia : driver_dia - 12;

    // Recess for speaker frame
    cyl(d=driver_dia + tolerance, h=recess_depth, anchor=TOP, $fn=64);

    // Through hole for cone
    translate([0, 0, -0.1])
    cyl(d=cd, h=recess_depth + 10, anchor=TOP, $fn=64);
}

// ============================================================
// BASS REFLEX PORT
// ============================================================

/**
 * Creates a bass reflex port tube.
 * Tuned port for improving low frequency response.
 *
 * Arguments:
 *   inner_dia    - port inner diameter
 *   length       - port tube length (affects tuning frequency)
 *   wall         - tube wall thickness (default: 2)
 *   flare        - flare at ends to reduce turbulence (default: true)
 *   flare_length - length of flare section (default: 5)
 *   flare_angle  - flare angle in degrees (default: 15)
 */
module bass_port(
    inner_dia,
    length,
    wall = 2,
    flare = true,
    flare_length = 5,
    flare_angle = 15,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    outer_dia = inner_dia + wall * 2;
    flare_extra = tan(flare_angle) * flare_length;

    attachable(anchor, spin, orient, size=[outer_dia + flare_extra*2, outer_dia + flare_extra*2, length]) {
        difference() {
            union() {
                // Main tube
                if (flare) {
                    // Flared ends
                    translate([0, 0, -length/2])
                    cyl(d1=outer_dia + flare_extra*2, d2=outer_dia,
                        h=flare_length, anchor=BOT, $fn=48);

                    translate([0, 0, -length/2 + flare_length - 0.1])
                    cyl(d=outer_dia, h=length - flare_length*2 + 0.2, anchor=BOT, $fn=48);

                    translate([0, 0, length/2 - flare_length])
                    cyl(d1=outer_dia, d2=outer_dia + flare_extra*2,
                        h=flare_length, anchor=BOT, $fn=48);
                } else {
                    cyl(d=outer_dia, h=length, anchor=CENTER, $fn=48);
                }
            }

            // Inner bore
            if (flare) {
                translate([0, 0, -length/2 - 0.1])
                cyl(d1=inner_dia + flare_extra*2, d2=inner_dia,
                    h=flare_length + 0.1, anchor=BOT, $fn=48);

                translate([0, 0, -length/2 + flare_length - 0.2])
                cyl(d=inner_dia, h=length - flare_length*2 + 0.4, anchor=BOT, $fn=48);

                translate([0, 0, length/2 - flare_length - 0.1])
                cyl(d1=inner_dia, d2=inner_dia + flare_extra*2,
                    h=flare_length + 0.2, anchor=BOT, $fn=48);
            } else {
                cyl(d=inner_dia, h=length + 1, anchor=CENTER, $fn=48);
            }
        }

        children();
    }
}

/**
 * Creates a mounting flange for bass port.
 * Glues/screws to inside of enclosure.
 */
module port_flange(
    port_inner_dia,
    flange_dia = 0,
    thickness = 3,
    screw_count = 0,
    screw_dia = 3.2,
    anchor = BOT
) {
    fd = flange_dia > 0 ? flange_dia : port_inner_dia + 20;

    attachable(anchor, 0, UP, size=[fd, fd, thickness]) {
        diff()
        cyl(d=fd, h=thickness, anchor=CENTER, $fn=48) {
            // Port hole
            tag("remove")
            cyl(d=port_inner_dia, h=thickness + 1, anchor=CENTER, $fn=48);

            // Optional screw holes
            if (screw_count > 0) {
                screw_circle = (fd + port_inner_dia) / 2;
                tag("remove")
                for (a = [0 : 360/screw_count : 359]) {
                    rotate([0, 0, a])
                    translate([screw_circle/2, 0, 0])
                    cyl(d=screw_dia, h=thickness + 1, anchor=CENTER, $fn=24);
                }
            }
        }

        children();
    }
}

// ============================================================
// INTERNAL BAFFLE / DIVIDER
// ============================================================

/**
 * Creates an internal baffle panel.
 * Used to separate speaker from electronics or create acoustic chambers.
 *
 * Arguments:
 *   size         - [width, height] of baffle
 *   thickness    - baffle thickness (default: 3)
 *   corner_r     - corner radius (default: 5)
 *   speaker_hole - diameter of speaker opening, or 0 for solid
 *   vent_holes   - array of [x, y, dia] for ventilation holes
 *   mounting_tabs - add mounting tabs on edges
 *   tab_width    - width of mounting tabs
 *   tab_holes    - add screw holes in tabs
 */
module baffle_panel(
    size,
    thickness = 3,
    corner_r = 5,
    speaker_hole = 0,
    vent_holes = [],
    mounting_tabs = false,
    tab_width = 10,
    tab_hole_dia = 3.2,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    width = size[0];
    height = size[1];

    attachable(anchor, spin, orient, size=[width, height, thickness]) {
        union() {
            diff()
            cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {
                // Speaker hole
                if (speaker_hole > 0) {
                    tag("remove")
                    cyl(d=speaker_hole, h=thickness + 1, anchor=CENTER, $fn=64);
                }

                // Vent holes
                for (vh = vent_holes) {
                    tag("remove")
                    translate([vh[0], vh[1], 0])
                    cyl(d=vh[2], h=thickness + 1, anchor=CENTER, $fn=32);
                }
            }

            // Mounting tabs
            if (mounting_tabs) {
                // Left and right tabs
                for (x = [-1, 1]) {
                    translate([x * (width/2 + tab_width/2 - 1), 0, 0])
                    diff()
                    cuboid([tab_width, height * 0.6, thickness], rounding=2, edges="Z", anchor=CENTER) {
                        // Tab holes
                        tag("remove")
                        for (y = [-1, 1]) {
                            translate([0, y * height * 0.2, 0])
                            cyl(d=tab_hole_dia, h=thickness + 1, anchor=CENTER, $fn=24);
                        }
                    }
                }
            }
        }

        children();
    }
}

// ============================================================
// PASSIVE RADIATOR MOUNT
// ============================================================

/**
 * Creates a passive radiator mounting ring.
 * Similar to speaker mount but typically no screws (adhesive mount).
 */
module passive_radiator_mount(
    radiator_dia,
    cone_dia = 0,
    ring_width = 6,
    thickness = 3,
    lip_depth = 2,
    anchor = BOT
) {
    cd = cone_dia > 0 ? cone_dia : radiator_dia - 10;
    outer_dia = radiator_dia + ring_width;

    attachable(anchor, 0, UP, size=[outer_dia, outer_dia, thickness]) {
        diff()
        cyl(d=outer_dia, h=thickness, anchor=CENTER, $fn=64) {
            // Cone opening
            tag("remove")
            cyl(d=cd, h=thickness + 1, anchor=CENTER, $fn=64);

            // Mounting lip recess (for radiator frame)
            tag("remove")
            position(TOP)
            tube(id=cd, od=radiator_dia + 0.5, h=lip_depth, anchor=TOP, $fn=64);
        }

        children();
    }
}

// ============================================================
// TEST / DEMO
// ============================================================

if ($preview) {
    // Speaker mounting ring for 3" driver
    translate([0, 0, 0])
    speaker_mount_ring(
        driver_dia = SPEAKER_3IN,
        cone_dia = 60,
        screw_circle = 68,
        screw_count = 4
    );

    // Bass reflex port
    translate([80, 0, 0])
    bass_port(
        inner_dia = 20,
        length = 50,
        flare = true
    );

    // Internal baffle
    translate([0, -80, 0])
    baffle_panel(
        size = [100, 60],
        speaker_hole = 50,
        vent_holes = [
            [35, 15, 8],
            [35, -15, 8]
        ],
        mounting_tabs = true
    );
}
