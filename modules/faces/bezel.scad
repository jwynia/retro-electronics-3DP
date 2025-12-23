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
                crt_steps = 16;

                // Dimensions for interpolation
                outer_w = width - 2;
                outer_h = height - 2;
                inner_w = view_w + 6;
                inner_h = view_h + 6;

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

// === TEST / DEMO ===
if ($preview) {
    // Demo: Screen bezel face plate with CRT style
    faceplate_bezel(
        size = [140, 95],
        thickness = 4,
        corner_r = 10,
        screen_size = [100, 60],
        screen_corner_r = 3,
        screen_depth = 8,
        style = "crt"
        // style_options = [slope_width, slope_angle, slope_height, scoop_radius]
        // style_options = [15, 45, 8, 20]  // more dramatic slope
    );
}
