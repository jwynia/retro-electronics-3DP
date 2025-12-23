// Face Plate Bezel Generator
// Creates face plates for screen/display mounting with magnetic attachment.

include <BOSL2/std.scad>

// Include hardware module (adjust path as needed)
// use <../hardware/magnet-pockets.scad>

// Default values
_FACEPLATE_THICKNESS = 4;
_FACEPLATE_CORNER_R = 8;
_BEZEL_WIDTH = 10;
_SCREEN_LIP = 1.5;
_SCREEN_DEPTH = 8;

// ============================================================
// STYLE FRAME GENERATORS (Internal)
// ============================================================

/**
 * Industrial-style frame decoration
 * Adds chamfered edges and decorative bolt heads
 */
module _bezel_frame_industrial(
    width, height, thickness,
    corner_r,
    intensity = 0.5,
    bolt_dia = 6,
    bolt_inset = 10,
    step_width = 3,
    step_height = 1.5
) {
    // Bolt head positions (decorative circles near corners, inside the steel pocket positions)
    bolt_positions = [
        [ width/2 - bolt_inset,  height/2 - bolt_inset],
        [-width/2 + bolt_inset,  height/2 - bolt_inset],
        [-width/2 + bolt_inset, -height/2 + bolt_inset],
        [ width/2 - bolt_inset, -height/2 + bolt_inset]
    ];

    // Raised bolt heads (additive)
    color("silver")
    for (pos = bolt_positions) {
        translate([pos[0], pos[1], thickness/2])
        cyl(d=bolt_dia, h=1, anchor=BOT, chamfer2=0.5, $fn=24);
    }

    // Stepped border (raised frame edge)
    color("dimgray")
    difference() {
        translate([0, 0, thickness/2])
        cuboid([width - 2, height - 2, step_height],
               chamfer=1.5, edges="Z", anchor=BOT);

        translate([0, 0, thickness/2 - 0.1])
        cuboid([width - step_width*2 - 2, height - step_width*2 - 2, step_height + 1],
               chamfer=max(0.5, 1.5 - step_width/2), edges="Z", anchor=BOT);
    }
}

/**
 * Art Deco style frame decoration
 * Stepped terraced borders with geometric details
 */
module _bezel_frame_deco(
    width, height, thickness,
    corner_r,
    intensity = 0.5,
    steps = 3,
    step_height = 0.6,
    step_inset = 2
) {
    // Concentric stepped borders
    for (i = [0:steps-1]) {
        inset = step_inset * i;
        z_offset = step_height * i;

        difference() {
            translate([0, 0, thickness/2 + z_offset])
            cuboid([width - inset*2 - 2, height - inset*2 - 2, step_height],
                   rounding=max(1, corner_r - inset), edges="Z", anchor=BOT);

            translate([0, 0, thickness/2 + z_offset - 0.1])
            cuboid([width - inset*2 - step_inset*2 - 2, height - inset*2 - step_inset*2 - 2, step_height + 1],
                   rounding=max(0.5, corner_r - inset - step_inset), edges="Z", anchor=BOT);
        }
    }
}

/**
 * Mid-Century Modern style frame decoration
 * Clean raised border with gentle curves
 */
module _bezel_frame_midcentury(
    width, height, thickness,
    corner_r,
    intensity = 0.5,
    border_width = 4,
    border_height = 1.2
) {
    // Simple raised border with rounded top edge
    difference() {
        translate([0, 0, thickness/2])
        cuboid([width - 2, height - 2, border_height],
               rounding=corner_r, edges="Z",
               anchor=BOT);

        translate([0, 0, thickness/2 - 0.1])
        cuboid([width - border_width*2, height - border_width*2, border_height + 1],
               rounding=max(1, corner_r - border_width + 1), edges="Z",
               anchor=BOT);
    }
}

/**
 * Braun/Dieter Rams style frame decoration
 * Ultra-minimal precise border
 */
module _bezel_frame_braun(
    width, height, thickness,
    corner_r,
    intensity = 0.5,
    border_width = 2,
    border_height = 0.6
) {
    // Thin precise border
    difference() {
        translate([0, 0, thickness/2])
        cuboid([width - 1, height - 1, border_height],
               chamfer=0.3, edges="Z", anchor=BOT);

        translate([0, 0, thickness/2 - 0.1])
        cuboid([width - border_width*2 - 1, height - border_width*2 - 1, border_height + 1],
               chamfer=0.2, edges="Z", anchor=BOT);
    }
}

/**
 * CRT-style bezel with sloped frame toward screen
 * Classic tube TV/monitor look with scooped corners
 *
 * convex=false (default): True CRT style - raised outer edge, slopes DOWN to screen (recessed)
 * convex=true: Inverted - slopes UP toward screen (raised frame around opening)
 */
module _bezel_frame_crt(
    width, height, thickness,
    corner_r,
    view_w, view_h,
    intensity = 0.5,
    slope_width = 12,      // Not used directly, kept for API
    slope_angle = 45,      // Not used directly
    slope_height = 8,      // How tall the raised edge is above base
    scoop_radius = 15,     // Corner radius for inner opening
    convex = false         // false=true CRT (recessed), true=raised frame
) {
    // Outer frame dimensions
    outer_w = width - 2;
    outer_h = height - 2;
    outer_r = corner_r;

    // Inner opening dimensions
    inner_w = view_w + 4;
    inner_h = view_h + 4;
    inner_r = max(3, scoop_radius);

    // Start below the top surface to ensure merge with base plate
    z_base = thickness/2 - 1;

    translate([0, 0, z_base])
    difference() {
        // Solid sloped block - extends down to merge with base
        hull() {
            if (convex) {
                // CONVEX: outer at base, inner raised
                linear_extrude(0.01)
                offset(r=outer_r) offset(r=-outer_r)
                square([outer_w, outer_h], center=true);

                translate([0, 0, slope_height + 1])
                linear_extrude(0.01)
                offset(r=inner_r) offset(r=-inner_r)
                square([inner_w, inner_h], center=true);
            } else {
                // CONCAVE: True CRT - outer raised, slopes down to inner
                // Outer perimeter raised
                translate([0, 0, slope_height + 1])
                linear_extrude(0.01)
                offset(r=outer_r) offset(r=-outer_r)
                square([outer_w, outer_h], center=true);

                // Inner perimeter at base level
                linear_extrude(0.01)
                offset(r=inner_r) offset(r=-inner_r)
                square([inner_w, inner_h], center=true);
            }
        }

        // Cut out the center opening
        translate([0, 0, -2])
        linear_extrude(slope_height + 6)
        offset(r=inner_r) offset(r=-inner_r)
        square([inner_w, inner_h], center=true);
    }
}

/**
 * Creates a face plate with screen bezel opening.
 * Designed to fit into a shell's lip and hold a screen/display.
 *
 * Arguments:
 *   size           - [width, height] outer dimensions (should match shell lip)
 *   thickness      - plate thickness (default: 4)
 *   corner_r       - corner radius (default: 8)
 *   screen_size    - [width, height] of screen visible area
 *   screen_corner_r - corner radius for screen opening (default: 3)
 *   screen_depth   - how deep screen sits behind plate (default: 8)
 *   screen_lip     - lip width holding screen in place (default: 1.5)
 *   steel_pockets  - include steel pockets for magnetic mount (default: true)
 *   steel_inset    - distance from corner to pocket center (default: 12)
 *   style          - decorative style: "plain", "industrial", "deco", "midcentury", "braun", "crt"
 *   style_options  - style-specific parameters (see below)
 *   anchor         - BOSL2 anchor (default: BOT)
 *   spin           - BOSL2 spin (default: 0)
 *   orient         - BOSL2 orient (default: UP)
 *
 * Style Options (pass as array: [param1, param2, ...]):
 *   industrial: [bolt_dia, bolt_inset, step_width, step_height]  defaults: [6, 10, 3, 1.5]
 *   deco:       [steps, step_height, step_inset]                 defaults: [3, 0.6, 2]
 *   midcentury: [border_width, border_height]                    defaults: [4, 1.2]
 *   braun:      [border_width, border_height]                    defaults: [2, 0.6]
 *   crt:        [slope_width, slope_angle, slope_height, scoop_radius, convex]
 *               defaults: [12, 45, 6, 15, false]
 *               convex=false: true CRT (outer raised, slopes down to screen)
 *               convex=true: inverted (slopes up toward screen)
 */
module faceplate_bezel(
    size,
    thickness = _FACEPLATE_THICKNESS,
    corner_r = _FACEPLATE_CORNER_R,
    screen_size,
    screen_corner_r = 3,
    screen_depth = _SCREEN_DEPTH,
    screen_lip = _SCREEN_LIP,
    steel_pockets = true,
    steel_inset = 12,
    steel_dia = 10,
    steel_depth = 1,
    style = "plain",
    style_options = [],
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    width = size[0];
    height = size[1];
    screen_w = screen_size[0];
    screen_h = screen_size[1];
    
    // Viewing opening (smaller, goes through)
    view_w = screen_w - screen_lip * 2;
    view_h = screen_h - screen_lip * 2;
    
    // Steel pocket positions
    pocket_positions = [
        [ width/2 - steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset, -height/2 + steel_inset],
        [ width/2 - steel_inset, -height/2 + steel_inset]
    ];
    
    // CRT style params
    crt_slope_height = len(style_options) > 2 ? style_options[2] : 8;
    crt_scoop_r = len(style_options) > 3 ? style_options[3] : 15;
    crt_convex = len(style_options) > 4 ? style_options[4] : false;
    crt_inner_r = max(3, crt_scoop_r);

    // Total height for CRT style
    crt_total_height = style == "crt" ? thickness + crt_slope_height : thickness;

    attachable(anchor, spin, orient, size=[width, height, crt_total_height]) {
        union() {
            if (style == "crt") {
                // CRT style: flat back plate with CURVED concave front surface
                // Like a classic tube TV bezel - smooth dish-like curve to screen

                // Number of steps for smooth curve
                crt_steps = 24;

                // Dimensions for interpolation
                outer_w = width - 2;
                outer_h = height - 2;
                // Inner dimensions match screen opening for clean transition
                inner_w = view_w + 2;
                inner_h = view_h + 2;
                // Inner corner radius matches screen for seamless edge
                crt_inner_r = screen_corner_r + 1;

                difference() {
                    union() {
                        // Full solid block (back plate + raised outer edge)
                        // This ensures everything merges properly
                        translate([0, 0, -thickness/2])
                        linear_extrude(thickness + crt_slope_height)
                        offset(r=corner_r) offset(r=-corner_r)
                        square([outer_w, outer_h], center=true);
                    }

                    // Carve out the curved dish from the top
                    // This creates the concave CRT surface
                    for (i = [0:crt_steps-1]) {
                        t1 = i / crt_steps;
                        t2 = (i + 1) / crt_steps;

                        // Calculate Z heights - we're carving DOWN from the top
                        // For concave: inner is lower (more carved), outer is higher (less carved)
                        carve1 = crt_convex
                            ? cos(t1 * 90) * crt_slope_height
                            : (1 - cos(t1 * 90)) * crt_slope_height;
                        carve2 = crt_convex
                            ? cos(t2 * 90) * crt_slope_height
                            : (1 - cos(t2 * 90)) * crt_slope_height;

                        // Interpolate dimensions
                        w1 = outer_w - t1 * (outer_w - inner_w);
                        w2 = outer_w - t2 * (outer_w - inner_w);
                        h1 = outer_h - t1 * (outer_h - inner_h);
                        h2 = outer_h - t2 * (outer_h - inner_h);
                        r1 = corner_r - t1 * (corner_r - crt_inner_r);
                        r2 = corner_r - t2 * (corner_r - crt_inner_r);

                        // Carve from top surface down
                        hull() {
                            translate([0, 0, thickness/2 + crt_slope_height - carve1])
                            linear_extrude(carve1 + 1)
                            offset(r=r1) offset(r=-r1)
                            square([w1, h1], center=true);

                            translate([0, 0, thickness/2 + crt_slope_height - carve2])
                            linear_extrude(carve2 + 1)
                            offset(r=r2) offset(r=-r2)
                            square([w2, h2], center=true);
                        }
                    }

                    // Screen viewing opening (through everything)
                    translate([0, 0, -thickness/2 - 1])
                    linear_extrude(crt_slope_height + thickness + 3)
                    offset(r=screen_corner_r) offset(r=-screen_corner_r)
                    square([view_w, view_h], center=true);

                    // Screen mounting pocket (back)
                    translate([0, 0, -thickness/2 - screen_depth])
                    linear_extrude(screen_depth + 1)
                    offset(r=screen_corner_r + 1) offset(r=-screen_corner_r - 1)
                    square([screen_w, screen_h], center=true);

                    // Steel disc pockets
                    if (steel_pockets) {
                        for (pos = pocket_positions) {
                            translate([pos[0], pos[1], -thickness/2])
                            cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=TOP, $fn=32);
                        }
                    }
                }
            } else {
                // Non-CRT styles: flat base plate with decorations on top
                diff()
                cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {

                    // Screen viewing opening (through hole)
                    tag("remove")
                    position(TOP)
                    cuboid(
                        [view_w, view_h, thickness + 1],
                        rounding = screen_corner_r,
                        edges = "Z",
                        anchor = TOP
                    );

                    // Screen mounting pocket (on back, doesn't go through)
                    tag("remove")
                    position(BOT)
                    cuboid(
                        [screen_w, screen_h, screen_depth],
                        rounding = screen_corner_r + 1,
                        edges = "Z",
                        anchor = BOT
                    );

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

                // Style-specific frame decorations (additive geometry on top)
                if (style == "industrial") {
                    _bezel_frame_industrial(
                        width, height, thickness, corner_r, 0.5,
                        bolt_dia = len(style_options) > 0 ? style_options[0] : 6,
                        bolt_inset = len(style_options) > 1 ? style_options[1] : 10,
                        step_width = len(style_options) > 2 ? style_options[2] : 3,
                        step_height = len(style_options) > 3 ? style_options[3] : 1.5
                    );
                } else if (style == "deco") {
                    _bezel_frame_deco(
                        width, height, thickness, corner_r, 0.5,
                        steps = len(style_options) > 0 ? style_options[0] : 3,
                        step_height = len(style_options) > 1 ? style_options[1] : 0.6,
                        step_inset = len(style_options) > 2 ? style_options[2] : 2
                    );
                } else if (style == "midcentury") {
                    _bezel_frame_midcentury(
                        width, height, thickness, corner_r, 0.5,
                        border_width = len(style_options) > 0 ? style_options[0] : 4,
                        border_height = len(style_options) > 1 ? style_options[1] : 1.2
                    );
                } else if (style == "braun") {
                    _bezel_frame_braun(
                        width, height, thickness, corner_r, 0.5,
                        border_width = len(style_options) > 0 ? style_options[0] : 2,
                        border_height = len(style_options) > 1 ? style_options[1] : 0.6
                    );
                }
                // "plain" = no decoration
            }
        }

        children();
    }
}

/**
 * Creates a simple flat face plate without screen opening.
 * Useful for control panels or covers.
 *
 * Arguments:
 *   size           - [width, height] outer dimensions
 *   thickness      - plate thickness (default: 4)
 *   corner_r       - corner radius (default: 8)
 *   steel_pockets  - include steel pockets (default: true)
 *   steel_inset    - distance from corner to pocket center (default: 12)
 */
module faceplate_blank(
    size,
    thickness = _FACEPLATE_THICKNESS,
    corner_r = _FACEPLATE_CORNER_R,
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
        diff()
        cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {
            
            // Steel disc pockets
            if (steel_pockets) {
                tag("remove")
                position(BOT)
                for (pos = pocket_positions) {
                    translate([pos[0], pos[1], 0])
                    cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
                }
            }
        }
        
        children();
    }
}

/**
 * Creates a face plate with round meter/gauge opening.
 * For analog meters, VU meters, gauges, circular displays.
 *
 * Arguments:
 *   size           - [width, height] outer dimensions (can be square)
 *   thickness      - plate thickness (default: 4)
 *   corner_r       - outer corner radius (default: 8)
 *   meter_dia      - diameter of meter opening
 *   meter_depth    - depth of meter mounting pocket on back (default: 5)
 *   meter_lip      - lip width holding meter in place (default: 2)
 *   style          - "plain", "crt", "industrial", "deco"
 *   style_options  - style-specific parameters
 *                    crt: [slope_height] default: [8]
 *   steel_pockets  - include steel pockets (default: true)
 *   steel_inset    - distance from corner to pocket center (default: 12)
 */
module faceplate_meter(
    size,
    thickness = _FACEPLATE_THICKNESS,
    corner_r = _FACEPLATE_CORNER_R,
    meter_dia,
    meter_depth = 5,
    meter_lip = 2,
    style = "plain",
    style_options = [],
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

    // Derived dimensions
    view_dia = meter_dia - (meter_lip * 2);  // Visible opening
    mount_dia = meter_dia + 1;  // Slightly larger for mounting

    // CRT style params
    crt_slope_height = len(style_options) > 0 ? style_options[0] : 8;
    crt_steps = 24;

    // Total height
    total_height = style == "crt" ? thickness + crt_slope_height : thickness;

    // Steel pocket positions
    pocket_positions = [
        [ width/2 - steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset, -height/2 + steel_inset],
        [ width/2 - steel_inset, -height/2 + steel_inset]
    ];

    attachable(anchor, spin, orient, size=[width, height, total_height]) {
        if (style == "crt") {
            // CRT style: curved concave dish to round opening
            difference() {
                // Full solid block
                translate([0, 0, -thickness/2])
                linear_extrude(thickness + crt_slope_height)
                offset(r=corner_r) offset(r=-corner_r)
                square([width - 2, height - 2], center=true);

                // Carve curved dish surface
                for (i = [0:crt_steps-1]) {
                    t1 = i / crt_steps;
                    t2 = (i + 1) / crt_steps;

                    // Carve depth follows cosine curve
                    carve1 = (1 - cos(t1 * 90)) * crt_slope_height;
                    carve2 = (1 - cos(t2 * 90)) * crt_slope_height;

                    // Interpolate from outer rectangle to inner circle
                    // Outer shape is rounded rect, inner is circle
                    hull() {
                        // Outer slice - rounded rectangle
                        if (t1 < 0.5) {
                            w1 = (width - 2) - t1 * 2 * ((width - 2) - view_dia - 4);
                            h1 = (height - 2) - t1 * 2 * ((height - 2) - view_dia - 4);
                            r1 = corner_r - t1 * 2 * (corner_r - view_dia/2);
                            translate([0, 0, thickness/2 + crt_slope_height - carve1])
                            linear_extrude(carve1 + 1)
                            offset(r=max(1,r1)) offset(r=-max(1,r1))
                            square([max(view_dia, w1), max(view_dia, h1)], center=true);
                        } else {
                            // Inner slices are circles
                            dia1 = view_dia + 4 - (t1 - 0.5) * 2 * 4;
                            translate([0, 0, thickness/2 + crt_slope_height - carve1])
                            linear_extrude(carve1 + 1)
                            circle(d=max(view_dia, dia1), $fn=64);
                        }

                        // Next slice
                        if (t2 < 0.5) {
                            w2 = (width - 2) - t2 * 2 * ((width - 2) - view_dia - 4);
                            h2 = (height - 2) - t2 * 2 * ((height - 2) - view_dia - 4);
                            r2 = corner_r - t2 * 2 * (corner_r - view_dia/2);
                            translate([0, 0, thickness/2 + crt_slope_height - carve2])
                            linear_extrude(carve2 + 1)
                            offset(r=max(1,r2)) offset(r=-max(1,r2))
                            square([max(view_dia, w2), max(view_dia, h2)], center=true);
                        } else {
                            dia2 = view_dia + 4 - (t2 - 0.5) * 2 * 4;
                            translate([0, 0, thickness/2 + crt_slope_height - carve2])
                            linear_extrude(carve2 + 1)
                            circle(d=max(view_dia, dia2), $fn=64);
                        }
                    }
                }

                // Meter viewing opening (through)
                translate([0, 0, -thickness/2 - 1])
                cylinder(d=view_dia, h=thickness + crt_slope_height + 3, $fn=64);

                // Meter mounting pocket (back)
                translate([0, 0, -thickness/2 - meter_depth])
                cylinder(d=mount_dia, h=meter_depth + 1, $fn=64);

                // Steel disc pockets
                if (steel_pockets) {
                    for (pos = pocket_positions) {
                        translate([pos[0], pos[1], -thickness/2])
                        cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=TOP, $fn=32);
                    }
                }
            }
        } else {
            // Plain style: flat plate with round opening
            diff()
            cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {

                // Meter viewing opening
                tag("remove")
                position(TOP)
                cyl(d=view_dia, h=thickness + 1, anchor=TOP, $fn=64);

                // Meter mounting pocket
                tag("remove")
                position(BOT)
                cyl(d=mount_dia, h=meter_depth, anchor=BOT, $fn=64);

                // Steel disc pockets
                if (steel_pockets) {
                    tag("remove")
                    position(BOT)
                    for (pos = pocket_positions) {
                        translate([pos[0], pos[1], 0])
                        cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
                    }
                }
            }
        }

        children();
    }
}

/**
 * Creates a face plate with multiple openings.
 * Flexible module for combining screens, meters, LEDs, slots on one faceplate.
 *
 * Arguments:
 *   size           - [width, height] outer dimensions
 *   thickness      - plate thickness (default: 4)
 *   corner_r       - outer corner radius (default: 8)
 *   openings       - array of opening definitions, each is:
 *                    ["screen", [x,y], [w,h], corner_r]
 *                    ["meter", [x,y], diameter]
 *                    ["led", [x,y], diameter]  (small round, default 5mm)
 *                    ["slot", [x,y], [w,h], corner_r]
 *   style          - "plain" or "crt" (CRT only affects screen/meter openings)
 *   style_options  - [slope_height] for CRT style
 *   steel_pockets  - include steel pockets (default: true)
 *   steel_inset    - distance from corner to pocket center (default: 12)
 *
 * Example:
 *   faceplate_multi(
 *       size = [200, 100],
 *       openings = [
 *           ["screen", [0, 0], [120, 60], 3],
 *           ["led", [80, 30], 5],
 *           ["led", [80, -30], 5]
 *       ]
 *   );
 */
module faceplate_multi(
    size,
    thickness = _FACEPLATE_THICKNESS,
    corner_r = _FACEPLATE_CORNER_R,
    openings = [],
    style = "plain",
    style_options = [],
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

    // CRT params
    crt_slope_height = len(style_options) > 0 ? style_options[0] : 8;
    crt_steps = 20;

    total_height = style == "crt" ? thickness + crt_slope_height : thickness;

    // Steel pocket positions
    pocket_positions = [
        [ width/2 - steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset, -height/2 + steel_inset],
        [ width/2 - steel_inset, -height/2 + steel_inset]
    ];

    attachable(anchor, spin, orient, size=[width, height, total_height]) {
        difference() {
            // Base plate
            if (style == "crt") {
                // Raised block for CRT carving
                translate([0, 0, -thickness/2])
                linear_extrude(thickness + crt_slope_height)
                offset(r=corner_r) offset(r=-corner_r)
                square([width - 2, height - 2], center=true);
            } else {
                // Plain flat plate
                cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER);
            }

            // Process each opening
            for (op = openings) {
                op_type = op[0];
                op_pos = op[1];
                op_size = op[2];
                op_r = len(op) > 3 ? op[3] : 3;

                if (op_type == "screen") {
                    // Rectangular screen opening
                    op_w = op_size[0];
                    op_h = op_size[1];

                    if (style == "crt") {
                        // Carve CRT dish for this opening
                        _multi_crt_carve_rect(
                            pos = op_pos,
                            inner_w = op_w,
                            inner_h = op_h,
                            inner_r = op_r,
                            outer_w = width - 2,
                            outer_h = height - 2,
                            outer_r = corner_r,
                            thickness = thickness,
                            slope_height = crt_slope_height,
                            steps = crt_steps
                        );
                    }

                    // Through hole
                    translate([op_pos[0], op_pos[1], -thickness/2 - 1])
                    linear_extrude(total_height + 3)
                    offset(r=op_r) offset(r=-op_r)
                    square([op_w, op_h], center=true);

                } else if (op_type == "meter") {
                    // Round meter opening
                    op_dia = op_size;

                    if (style == "crt") {
                        // Carve CRT dish for round opening
                        _multi_crt_carve_round(
                            pos = op_pos,
                            inner_dia = op_dia,
                            outer_w = width - 2,
                            outer_h = height - 2,
                            outer_r = corner_r,
                            thickness = thickness,
                            slope_height = crt_slope_height,
                            steps = crt_steps
                        );
                    }

                    // Through hole
                    translate([op_pos[0], op_pos[1], -thickness/2 - 1])
                    cylinder(d=op_dia, h=total_height + 3, $fn=64);

                } else if (op_type == "led") {
                    // Small LED indicator hole
                    op_dia = is_num(op_size) ? op_size : 5;

                    translate([op_pos[0], op_pos[1], -thickness/2 - 1])
                    cylinder(d=op_dia, h=total_height + 3, $fn=32);

                } else if (op_type == "slot") {
                    // Rectangular slot (like for switches, vents)
                    op_w = op_size[0];
                    op_h = op_size[1];

                    translate([op_pos[0], op_pos[1], -thickness/2 - 1])
                    linear_extrude(total_height + 3)
                    offset(r=op_r) offset(r=-op_r)
                    square([op_w, op_h], center=true);
                }
            }

            // Steel disc pockets
            if (steel_pockets) {
                for (pos = pocket_positions) {
                    translate([pos[0], pos[1], -thickness/2])
                    cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=TOP, $fn=32);
                }
            }
        }

        children();
    }
}

// Internal: Carve CRT dish for rectangular opening
module _multi_crt_carve_rect(pos, inner_w, inner_h, inner_r, outer_w, outer_h, outer_r, thickness, slope_height, steps) {
    for (i = [0:steps-1]) {
        t1 = i / steps;
        t2 = (i + 1) / steps;

        carve1 = (1 - cos(t1 * 90)) * slope_height;
        carve2 = (1 - cos(t2 * 90)) * slope_height;

        // Interpolate from outer to inner
        w1 = outer_w - t1 * (outer_w - inner_w - 4);
        w2 = outer_w - t2 * (outer_w - inner_w - 4);
        h1 = outer_h - t1 * (outer_h - inner_h - 4);
        h2 = outer_h - t2 * (outer_h - inner_h - 4);
        r1 = outer_r - t1 * (outer_r - inner_r);
        r2 = outer_r - t2 * (outer_r - inner_r);

        // Position interpolation toward opening
        px1 = pos[0] * t1;
        py1 = pos[1] * t1;
        px2 = pos[0] * t2;
        py2 = pos[1] * t2;

        hull() {
            translate([px1, py1, thickness/2 + slope_height - carve1])
            linear_extrude(carve1 + 1)
            offset(r=max(1, r1)) offset(r=-max(1, r1))
            square([w1, h1], center=true);

            translate([px2, py2, thickness/2 + slope_height - carve2])
            linear_extrude(carve2 + 1)
            offset(r=max(1, r2)) offset(r=-max(1, r2))
            square([w2, h2], center=true);
        }
    }
}

// Internal: Carve CRT dish for round opening
module _multi_crt_carve_round(pos, inner_dia, outer_w, outer_h, outer_r, thickness, slope_height, steps) {
    for (i = [0:steps-1]) {
        t1 = i / steps;
        t2 = (i + 1) / steps;

        carve1 = (1 - cos(t1 * 90)) * slope_height;
        carve2 = (1 - cos(t2 * 90)) * slope_height;

        // Interpolate size
        w1 = outer_w - t1 * (outer_w - inner_dia - 4);
        w2 = outer_w - t2 * (outer_w - inner_dia - 4);
        h1 = outer_h - t1 * (outer_h - inner_dia - 4);
        h2 = outer_h - t2 * (outer_h - inner_dia - 4);
        r1 = outer_r - t1 * (outer_r - inner_dia/2);
        r2 = outer_r - t2 * (outer_r - inner_dia/2);

        px1 = pos[0] * t1;
        py1 = pos[1] * t1;
        px2 = pos[0] * t2;
        py2 = pos[1] * t2;

        hull() {
            translate([px1, py1, thickness/2 + slope_height - carve1])
            linear_extrude(carve1 + 1)
            offset(r=max(1, r1)) offset(r=-max(1, r1))
            square([w1, h1], center=true);

            translate([px2, py2, thickness/2 + slope_height - carve2])
            linear_extrude(carve2 + 1)
            offset(r=max(1, r2)) offset(r=-max(1, r2))
            square([w2, h2], center=true);
        }
    }
}

/**
 * Creates a face plate designed to hold a lens or cover.
 * For LED domes, display covers, jewel lenses, diffusers.
 *
 * Arguments:
 *   size           - [width, height] outer dimensions
 *   thickness      - plate thickness (default: 4)
 *   corner_r       - outer corner radius (default: 8)
 *   lens_size      - diameter (round) or [width, height] (rect)
 *   lens_shape     - "round" or "rect" (default: "round")
 *   lens_thickness - thickness of the lens material (default: 2)
 *   lens_recess    - how far below surface lens sits, 0=flush (default: 0)
 *   lip            - how much bezel overlaps lens edge (default: 1.5)
 *   viewing_hole   - diameter/size of hole through bezel, 0=no hole (default: 0)
 *   retention      - "none", "friction", "clips" (default: "none")
 *   clip_count     - number of clips for "clips" retention (2 or 4, default: 4)
 *   style          - "plain", "raised_ring", "chamfer" (default: "plain")
 *   style_options  - style-specific: raised_ring=[height, width], chamfer=[angle]
 *   steel_pockets  - include steel pockets (default: true)
 *   steel_inset    - distance from corner to pocket center (default: 12)
 *
 * Lens sits in a recessed pocket, held by the lip overlap.
 * The viewing_hole parameter allows light through without removing the full lens area.
 */
module faceplate_lens(
    size,
    thickness = _FACEPLATE_THICKNESS,
    corner_r = _FACEPLATE_CORNER_R,
    lens_size,
    lens_shape = "round",
    lens_thickness = 2,
    lens_recess = 0,
    lip = 1.5,
    viewing_hole = 0,
    retention = "none",
    clip_count = 4,
    style = "plain",
    style_options = [],
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

    // Calculate lens dimensions
    is_round = lens_shape == "round";
    lens_dia = is_round ? lens_size : 0;
    lens_w = is_round ? lens_size : lens_size[0];
    lens_h = is_round ? lens_size : lens_size[1];
    lens_r = is_round ? lens_dia/2 : (len(lens_size) > 2 ? lens_size[2] : 2);

    // Pocket for lens (slightly larger for fit)
    pocket_clearance = retention == "friction" ? 0 : 0.3;
    pocket_dia = lens_dia + pocket_clearance;
    pocket_w = lens_w + pocket_clearance;
    pocket_h = lens_h + pocket_clearance;

    // Opening through bezel (lens minus lip)
    opening_dia = lens_dia - lip * 2;
    opening_w = lens_w - lip * 2;
    opening_h = lens_h - lip * 2;

    // Viewing hole (if specified, otherwise use opening)
    view_dia = viewing_hole > 0 ? viewing_hole : opening_dia;
    view_w = viewing_hole > 0 ? viewing_hole : opening_w;
    view_h = viewing_hole > 0 ? viewing_hole : opening_h;

    // Style params
    ring_height = len(style_options) > 0 ? style_options[0] : 1.5;
    ring_width = len(style_options) > 1 ? style_options[1] : 3;
    chamfer_angle = len(style_options) > 0 ? style_options[0] : 45;

    // Total height includes any raised elements
    raised_height = style == "raised_ring" ? ring_height : 0;
    total_height = thickness + raised_height;

    // Steel pocket positions
    pocket_positions = [
        [ width/2 - steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset, -height/2 + steel_inset],
        [ width/2 - steel_inset, -height/2 + steel_inset]
    ];

    // Clip dimensions
    clip_width = 3;
    clip_depth = 1.2;
    clip_height = lens_thickness + 0.5;

    attachable(anchor, spin, orient, size=[width, height, total_height]) {
        union() {
            difference() {
                union() {
                    // Base plate
                    cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER);

                    // Style: raised ring around opening
                    if (style == "raised_ring") {
                        translate([0, 0, thickness/2])
                        if (is_round) {
                            difference() {
                                cyl(d=opening_dia + ring_width * 2, h=ring_height, anchor=BOT, $fn=64);
                                translate([0, 0, -0.1])
                                cyl(d=opening_dia, h=ring_height + 1, anchor=BOT, $fn=64);
                            }
                        } else {
                            difference() {
                                cuboid([opening_w + ring_width * 2, opening_h + ring_width * 2, ring_height],
                                       rounding=lens_r + ring_width/2, edges="Z", anchor=BOT);
                                translate([0, 0, -0.1])
                                cuboid([opening_w, opening_h, ring_height + 1],
                                       rounding=max(0.5, lens_r - lip), edges="Z", anchor=BOT);
                            }
                        }
                    }

                    // Style: chamfer ring
                    if (style == "chamfer") {
                        translate([0, 0, thickness/2])
                        if (is_round) {
                            difference() {
                                cyl(d=opening_dia + 6, h=3, anchor=BOT, chamfer2=2, $fn=64);
                                translate([0, 0, -0.1])
                                cyl(d=opening_dia, h=4, anchor=BOT, $fn=64);
                            }
                        } else {
                            difference() {
                                cuboid([opening_w + 6, opening_h + 6, 3],
                                       chamfer=2, edges=TOP, anchor=BOT);
                                translate([0, 0, -0.1])
                                cuboid([opening_w, opening_h, 4],
                                       rounding=max(0.5, lens_r - lip), edges="Z", anchor=BOT);
                            }
                        }
                    }
                }

                // Lens pocket (from back, for lens to sit in)
                translate([0, 0, -thickness/2])
                if (is_round) {
                    cyl(d=pocket_dia, h=lens_thickness + lens_recess + 0.1, anchor=BOT, $fn=64);
                } else {
                    cuboid([pocket_w, pocket_h, lens_thickness + lens_recess + 0.1],
                           rounding=lens_r + 0.2, edges="Z", anchor=BOT);
                }

                // Viewing opening (through the bezel above the lens)
                translate([0, 0, -thickness/2 + lens_thickness + lens_recess - 0.1])
                if (is_round) {
                    cyl(d=view_dia, h=total_height, anchor=BOT, $fn=64);
                } else {
                    linear_extrude(total_height)
                    offset(r=max(0.5, lens_r - lip)) offset(r=-max(0.5, lens_r - lip))
                    square([view_w, view_h], center=true);
                }

                // Steel disc pockets
                if (steel_pockets) {
                    for (pos = pocket_positions) {
                        translate([pos[0], pos[1], -thickness/2])
                        cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
                    }
                }
            }

            // Retention clips (inside the lens pocket)
            if (retention == "clips") {
                clip_positions = clip_count == 2 ?
                    [[0, 1], [0, -1]] :  // Top and bottom
                    [[1, 0], [-1, 0], [0, 1], [0, -1]];  // All 4 sides

                for (cp = clip_positions) {
                    if (is_round) {
                        clip_r = pocket_dia/2 - 0.5;
                        angle = atan2(cp[1], cp[0]);
                        translate([clip_r * cos(angle), clip_r * sin(angle), -thickness/2])
                        rotate([0, 0, angle])
                        _lens_clip(clip_width, clip_depth, clip_height);
                    } else {
                        // Position clips on edges
                        px = cp[0] * (pocket_w/2 - 0.5);
                        py = cp[1] * (pocket_h/2 - 0.5);
                        rot = cp[0] != 0 ? 90 : 0;
                        translate([px, py, -thickness/2])
                        rotate([0, 0, rot])
                        _lens_clip(clip_width, clip_depth, clip_height);
                    }
                }
            }
        }

        children();
    }
}

// Internal: retention clip for lens holder
module _lens_clip(width, depth, height) {
    // Small angled tab that lens snaps under
    hull() {
        // Base
        translate([0, 0, 0])
        cube([width, 0.5, height], center=true);

        // Overhang tip
        translate([0, -depth, height/2 - 0.3])
        cube([width - 0.5, 0.3, 0.6], center=true);
    }
}

// === TEST / DEMO ===
if ($preview) {
    // Demo: Round lens holder with clips
    faceplate_lens(
        size = [60, 60],
        lens_size = 30,
        lens_shape = "round",
        lens_thickness = 3,
        lip = 2,
        retention = "clips",
        style = "raised_ring",
        style_options = [2, 4]
    );
}

