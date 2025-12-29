// Googie Sign Assembly
// Combines base, pylon, sign body, and decorative elements into complete signs.
// Desktop-scale Googie/Space Age sign assemblies.

include <BOSL2/std.scad>
include <starburst.scad>
include <boomerang.scad>
include <pylon.scad>
include <atomic-orbit.scad>

// === BASE MODULES ===

/**
 * Simple weighted disc base.
 */
module base_disc(
    diameter = 60,
    height = 8,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    attachable(anchor, spin, orient, size=[diameter, diameter, height]) {
        cylinder(h=height, d=diameter, center=false, $fn=48);
        children();
    }
}

/**
 * Kidney/boomerang shaped base (classic atomic age).
 */
module base_kidney(
    length = 80,
    width = 50,
    height = 8,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    attachable(anchor, spin, orient, size=[length, width, height]) {
        linear_extrude(height=height)
        hull() {
            translate([-length/4, 0])
            circle(d=width * 0.8, $fn=32);
            translate([length/4, 0])
            circle(d=width * 0.6, $fn=32);
        }
        children();
    }
}

/**
 * Rectangular base with rounded corners.
 */
module base_rect(
    size = [70, 50, 8],
    radius = 5,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    attachable(anchor, spin, orient, size=size) {
        linear_extrude(height=size[2])
        offset(r=radius)
        offset(r=-radius)
        square([size[0], size[1]], center=true);
        children();
    }
}


// === SIGN BODY MODULES ===

/**
 * Basic rectangular sign body (placeholder for text).
 * Use this as the foundation, then add text/graphics.
 */
module sign_body_rect(
    size = [80, 40, 6],
    corner_radius = 3,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    attachable(anchor, spin, orient, size=size) {
        linear_extrude(height=size[2])
        offset(r=corner_radius)
        offset(r=-corner_radius)
        square([size[0], size[1]], center=true);
        children();
    }
}

/**
 * Arrow-shaped sign body (points right by default).
 */
module sign_body_arrow(
    length = 100,
    height = 35,
    thickness = 6,
    arrow_depth = 15,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    size = [length, height, thickness];

    attachable(anchor, spin, orient, size=size) {
        linear_extrude(height=thickness)
        polygon([
            [-length/2, -height/2],
            [-length/2, height/2],
            [length/2 - arrow_depth, height/2],
            [length/2, 0],
            [length/2 - arrow_depth, -height/2]
        ]);
        children();
    }
}

/**
 * Oval/ellipse sign body.
 */
module sign_body_oval(
    width = 90,
    height = 45,
    thickness = 6,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    size = [width, height, thickness];

    attachable(anchor, spin, orient, size=size) {
        linear_extrude(height=thickness)
        scale([1, height/width])
        circle(d=width, $fn=48);
        children();
    }
}

/**
 * Shield/badge shaped sign body.
 */
module sign_body_shield(
    width = 60,
    height = 70,
    thickness = 6,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    size = [width, height, thickness];

    attachable(anchor, spin, orient, size=size) {
        linear_extrude(height=thickness)
        hull() {
            // Top rounded corners
            translate([-width/2 + 8, height/2 - 8])
            circle(r=8, $fn=24);
            translate([width/2 - 8, height/2 - 8])
            circle(r=8, $fn=24);
            // Bottom point
            translate([0, -height/2 + 5])
            circle(r=5, $fn=24);
        }
        children();
    }
}


// === COMPLETE SIGN ASSEMBLIES ===

/**
 * Sign mounted directly on base (no pylon).
 * Compact desktop sign.
 */
module sign_direct_mount(
    sign_size = [80, 40, 6],
    sign_style = "rect",
    base_style = "disc",
    base_size = 60,
    base_height = 10,
    sign_tilt = 10,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    // Calculate total height
    sign_height = sign_style == "shield" ? sign_size[1] :
                  sign_style == "oval" ? sign_size[1] : sign_size[1];
    total_height = base_height + sign_height/2 + sign_height * sin(sign_tilt)/2;

    size = [base_size, base_size, total_height + 20];

    attachable(anchor, spin, orient, size=size) {
        union() {
            // Base
            if (base_style == "disc") {
                base_disc(diameter=base_size, height=base_height);
            } else if (base_style == "kidney") {
                base_kidney(length=base_size * 1.3, width=base_size * 0.8, height=base_height);
            } else {
                base_rect(size=[base_size, base_size * 0.7, base_height]);
            }

            // Sign body (tilted back slightly)
            translate([0, 0, base_height])
            rotate([90 - sign_tilt, 0, 0])
            if (sign_style == "rect") {
                sign_body_rect(size=sign_size, anchor=BOT);
            } else if (sign_style == "arrow") {
                sign_body_arrow(length=sign_size[0], height=sign_size[1], thickness=sign_size[2], anchor=BOT);
            } else if (sign_style == "oval") {
                sign_body_oval(width=sign_size[0], height=sign_size[1], thickness=sign_size[2], anchor=BOT);
            } else if (sign_style == "shield") {
                sign_body_shield(width=sign_size[0], height=sign_size[1], thickness=sign_size[2], anchor=BOT);
            }
        }
        children();
    }
}

/**
 * Sign mounted on pylon top.
 * Classic tall Googie sign.
 */
module sign_pylon_mount(
    sign_size = [80, 40, 6],
    sign_style = "rect",
    pylon_height = 60,
    pylon_base_dia = 25,
    pylon_top_dia = 15,
    pylon_profile = "round",
    base_width = 50,
    base_height = 8,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    total_height = base_height + pylon_height + sign_size[1];
    size = [max(base_width, sign_size[0]), max(base_width, sign_size[0]), total_height];

    attachable(anchor, spin, orient, size=size) {
        union() {
            // Pylon with integrated base
            pylon_with_base(
                height = pylon_height,
                base_dia = pylon_base_dia,
                top_dia = pylon_top_dia,
                base_width = base_width,
                base_height = base_height,
                profile = pylon_profile,
                top_plate = true,
                anchor = BOT
            );

            // Sign body on top
            translate([0, 0, base_height + pylon_height + 3])
            if (sign_style == "rect") {
                sign_body_rect(size=sign_size, anchor=BOT);
            } else if (sign_style == "arrow") {
                sign_body_arrow(length=sign_size[0], height=sign_size[1], thickness=sign_size[2], anchor=BOT);
            } else if (sign_style == "oval") {
                sign_body_oval(width=sign_size[0], height=sign_size[1], thickness=sign_size[2], anchor=BOT);
            } else if (sign_style == "shield") {
                sign_body_shield(width=sign_size[0], height=sign_size[1], thickness=sign_size[2], anchor=BOT);
            }
        }
        children();
    }
}

/**
 * Complete Googie sign with decorations.
 * Adds starbursts and/or boomerangs to a sign assembly.
 */
module googie_sign(
    // Sign parameters
    sign_size = [80, 40, 6],
    sign_style = "rect",

    // Mount parameters
    mount_style = "pylon",  // "pylon" or "direct"
    pylon_height = 50,
    base_width = 45,

    // Decoration parameters
    add_starburst = true,
    starburst_size = 25,
    starburst_pos = "top-right",  // "top-right", "top-left", "top-center"

    add_boomerang = false,
    boomerang_span = 40,

    anchor = BOT,
    spin = 0,
    orient = UP
) {
    // Calculate positions
    sign_center_z = mount_style == "pylon" ?
        8 + pylon_height + 3 + sign_size[1]/2 :
        10 + sign_size[1]/2;

    starburst_offset = sign_style == "arrow" ?
        [sign_size[0]/2 + starburst_size/3, 0, sign_center_z] :
        starburst_pos == "top-right" ?
            [sign_size[0]/2 - 5, 0, sign_center_z + sign_size[1]/2 - 5] :
        starburst_pos == "top-left" ?
            [-sign_size[0]/2 + 5, 0, sign_center_z + sign_size[1]/2 - 5] :
            [0, 0, sign_center_z + sign_size[1]/2 + starburst_size/2];

    union() {
        // Base sign assembly
        if (mount_style == "pylon") {
            sign_pylon_mount(
                sign_size = sign_size,
                sign_style = sign_style,
                pylon_height = pylon_height,
                base_width = base_width,
                anchor = anchor
            );
        } else {
            sign_direct_mount(
                sign_size = sign_size,
                sign_style = sign_style,
                base_size = base_width,
                anchor = anchor
            );
        }

        // Starburst decoration
        if (add_starburst) {
            translate(starburst_offset)
            rotate([90, 0, 0])
            atomic_starburst(size=starburst_size, thickness=sign_size[2]);
        }

        // Boomerang decoration (at base or top)
        if (add_boomerang) {
            translate([0, 0, sign_center_z - sign_size[1]/2 - 10])
            rotate([90, 0, 0])
            swoosh(span=boomerang_span, thickness=sign_size[2]/2);
        }
    }
}


// === TEST / DEMO ===
if ($preview && is_undef($parent_modules)) {
    $parent_modules = true;

    // Direct mount with disc base
    sign_direct_mount(sign_style="rect", base_style="disc");

    // Pylon mount
    translate([100, 0, 0])
    sign_pylon_mount(sign_style="oval", pylon_profile="diamond");

    // Complete Googie sign with decorations
    translate([200, 0, 0])
    googie_sign(
        sign_style = "arrow",
        mount_style = "pylon",
        add_starburst = true,
        pylon_height = 40
    );

    // Shield on kidney base
    translate([0, 100, 0])
    sign_direct_mount(sign_style="shield", base_style="kidney", sign_size=[50, 60, 6]);
}
