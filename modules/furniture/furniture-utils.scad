// Furniture Utilities
// Helper modules for legs, cushions, handles, and common furniture geometry.

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

// ========================================
// LEG GENERATORS
// ========================================

/**
 * Creates a tapered furniture leg (retro/mid-century style).
 * Legs taper from top to bottom.
 *
 * Arguments:
 *   height    - leg height
 *   top_dia   - diameter at top (attaches to furniture)
 *   bot_dia   - diameter at bottom (floor contact)
 *   anchor    - BOSL2 anchor (default: BOT)
 *   spin      - BOSL2 spin (default: 0)
 *   orient    - BOSL2 orient (default: UP)
 */
module leg_tapered(
    height,
    top_dia = 50,
    bot_dia = 25,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    attachable(anchor, spin, orient, d1=bot_dia, d2=top_dia, h=height) {
        cyl(h=height, d1=bot_dia, d2=top_dia, anchor=CENTER);
        children();
    }
}

/**
 * Creates a block/square furniture leg (modern style).
 *
 * Arguments:
 *   height    - leg height
 *   size      - leg width/depth (square)
 *   rounding  - corner rounding radius
 *   anchor    - BOSL2 anchor (default: BOT)
 *   spin      - BOSL2 spin (default: 0)
 *   orient    - BOSL2 orient (default: UP)
 */
module leg_block(
    height,
    size = 50,
    rounding = 2,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    safe_rounding = min(rounding, size/2, height/2);
    attachable(anchor, spin, orient, size=[size, size, height]) {
        cuboid([size, size, height], rounding=safe_rounding, edges="Z", anchor=CENTER);
        children();
    }
}

/**
 * Creates a hairpin furniture leg (2-rod style).
 *
 * Arguments:
 *   height    - leg height
 *   rod_dia   - diameter of the rod
 *   spread    - distance between rods at top
 *   anchor    - BOSL2 anchor (default: BOT)
 *   spin      - BOSL2 spin (default: 0)
 *   orient    - BOSL2 orient (default: UP)
 */
module leg_hairpin(
    height,
    rod_dia = 10,
    spread = 80,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    attachable(anchor, spin, orient, size=[spread, rod_dia, height]) {
        color(_COLOR_METAL)
        union() {
            // Two angled rods meeting at bottom
            for (side = [-1, 1]) {
                hull() {
                    // Top attachment point
                    translate([side * spread/2, 0, height - rod_dia/2])
                    sphere(d=rod_dia);
                    // Bottom point (rods meet)
                    translate([0, 0, rod_dia/2])
                    sphere(d=rod_dia);
                }
            }
        }
        children();
    }
}

/**
 * Creates a turned/spindle furniture leg (traditional style).
 *
 * Arguments:
 *   height    - leg height
 *   dia       - main diameter
 *   anchor    - BOSL2 anchor (default: BOT)
 *   spin      - BOSL2 spin (default: 0)
 *   orient    - BOSL2 orient (default: UP)
 */
module leg_turned(
    height,
    dia = 40,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    // Simple turned profile with bulge in middle
    attachable(anchor, spin, orient, d=dia, h=height) {
        union() {
            // Bottom taper
            cyl(h=height*0.2, d1=dia*0.6, d2=dia, anchor=BOT);
            // Main shaft with slight bulge
            up(height*0.2)
            cyl(h=height*0.6, d1=dia, d2=dia*0.9, anchor=BOT);
            // Top section
            up(height*0.8)
            cyl(h=height*0.2, d1=dia*0.9, d2=dia*0.8, anchor=BOT);
        }
        children();
    }
}

/**
 * Creates a leg based on style string.
 *
 * Arguments:
 *   style     - "tapered", "block", "hairpin", "turned"
 *   height    - leg height
 *   size      - size parameter (interpreted based on style)
 */
module furniture_leg(
    style = "tapered",
    height = 150,
    size = 50,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    if (style == "tapered") {
        leg_tapered(height=height, top_dia=size, bot_dia=size*0.5, anchor=anchor, spin=spin, orient=orient)
            children();
    } else if (style == "block") {
        leg_block(height=height, size=size*0.8, anchor=anchor, spin=spin, orient=orient)
            children();
    } else if (style == "hairpin") {
        leg_hairpin(height=height, rod_dia=size*0.2, spread=size*1.5, anchor=anchor, spin=spin, orient=orient)
            children();
    } else if (style == "turned") {
        leg_turned(height=height, dia=size*0.8, anchor=anchor, spin=spin, orient=orient)
            children();
    } else {
        // Default to tapered
        leg_tapered(height=height, top_dia=size, bot_dia=size*0.5, anchor=anchor, spin=spin, orient=orient)
            children();
    }
}

// ========================================
// CUSHION GENERATORS
// ========================================

/**
 * Creates a furniture cushion with optional tufting.
 *
 * Arguments:
 *   size      - [width, depth, height] of cushion
 *   rounding  - corner rounding
 *   tufted    - whether to add button tufting (retro style)
 *   anchor    - BOSL2 anchor (default: BOT)
 *   spin      - BOSL2 spin (default: 0)
 *   orient    - BOSL2 orient (default: UP)
 */
module furniture_cushion(
    size,
    rounding = undef,
    tufted = false,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    w = size[0];
    d = size[1];
    h = size[2];
    // Auto-calculate safe rounding based on smallest dimension
    min_dim = min(w, d, h);
    _rounding = is_undef(rounding) ? min(min_dim/3, 10) : min(rounding, min_dim/2);

    attachable(anchor, spin, orient, size=size) {
        diff()
        cuboid(size, rounding=_rounding, anchor=CENTER) {
            // Tufting dimples
            if (tufted) {
                tuft_cols = max(2, floor(w / 150));
                tuft_rows = max(2, floor(d / 150));
                tuft_spacing_x = w / (tuft_cols + 1);
                tuft_spacing_y = d / (tuft_rows + 1);

                tag("remove")
                position(TOP)
                grid_copies(spacing=[tuft_spacing_x, tuft_spacing_y], n=[tuft_cols, tuft_rows])
                cyl(h=h*0.3, d1=20, d2=5, anchor=TOP);
            }
        }
        children();
    }
}

/**
 * Creates a back cushion (taller, with slight recline).
 *
 * Arguments:
 *   size      - [width, height, thickness]
 *   recline   - recline angle in degrees (0 = vertical)
 *   rounding  - corner rounding
 *   tufted    - button tufting
 */
module furniture_back_cushion(
    size,
    recline = 10,
    rounding = undef,
    tufted = false,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    w = size[0];
    h = size[1];
    t = size[2];
    // Auto-calculate safe rounding based on smallest dimension
    _rounding = is_undef(rounding) ? min(t/2, h/4, 15) : min(rounding, t/2, h/4);

    attachable(anchor, spin, orient, size=[w, t, h]) {
        rotate([recline, 0, 0])
        diff()
        cuboid([w, t, h], rounding=_rounding, anchor=BOT) {
            if (tufted) {
                tuft_cols = max(2, floor(w / 200));
                tuft_rows = max(2, floor(h / 200));
                tuft_spacing_x = w / (tuft_cols + 1);
                tuft_spacing_z = h / (tuft_rows + 1);

                tag("remove")
                position(FWD)
                xrot(90)
                grid_copies(spacing=[tuft_spacing_x, tuft_spacing_z], n=[tuft_cols, tuft_rows])
                cyl(h=t*0.3, d1=20, d2=5, anchor=TOP);
            }
        }
        children();
    }
}

// ========================================
// HANDLE/PULL GENERATORS
// ========================================

/**
 * Creates a drawer/door handle.
 *
 * Arguments:
 *   style     - "bar" (modern) or "cup" (retro)
 *   width     - handle width
 *   depth     - how far it protrudes
 */
module furniture_handle(
    style = "bar",
    width = 100,
    depth = 20,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    handle_dia = 12;

    attachable(anchor, spin, orient, size=[width, depth, handle_dia]) {
        if (style == "bar") {
            // Modern bar handle
            color(_COLOR_METAL)
            union() {
                // Bar
                xcyl(l=width - 20, d=handle_dia);
                // End posts
                for (side = [-1, 1]) {
                    translate([side * (width/2 - 10), -depth/2, 0])
                    ycyl(l=depth, d=handle_dia);
                }
            }
        } else if (style == "cup") {
            // Retro cup/bin pull
            color(_COLOR_METAL)
            difference() {
                hull() {
                    translate([0, 0, 0])
                    xcyl(l=width*0.8, d=handle_dia);
                    translate([0, -depth, -handle_dia*0.3])
                    xcyl(l=width*0.6, d=handle_dia*0.7);
                }
                // Hollow out
                translate([0, -depth*0.3, -handle_dia*0.5])
                cuboid([width*0.7, depth, handle_dia], anchor=CENTER);
            }
        }
        children();
    }
}

// ========================================
// PANEL/FRAME GENERATORS
// ========================================

/**
 * Creates a simple panel (tabletop, shelf, etc.).
 *
 * Arguments:
 *   size      - [width, depth, thickness]
 *   rounding  - edge rounding
 */
module furniture_panel(
    size,
    rounding = 2,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    attachable(anchor, spin, orient, size=size) {
        cuboid(size, rounding=rounding, edges="Z", anchor=CENTER);
        children();
    }
}

/**
 * Creates a rectangular frame (for bed frames, table aprons, etc.).
 *
 * Arguments:
 *   outer     - [width, depth] outer dimensions
 *   height    - frame height
 *   thickness - frame member thickness
 *   rounding  - corner rounding
 */
module furniture_frame(
    outer,
    height,
    thickness = 50,
    rounding = 2,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    w = outer[0];
    d = outer[1];
    inner_w = w - thickness * 2;
    inner_d = d - thickness * 2;

    attachable(anchor, spin, orient, size=[w, d, height]) {
        diff()
        cuboid([w, d, height], rounding=rounding, edges="Z", anchor=CENTER) {
            tag("remove")
            cuboid([inner_w, inner_d, height + 0.02], anchor=CENTER);
        }
        children();
    }
}

// ========================================
// PREVIEW COLORS (imported from constants)
// ========================================
_COLOR_METAL = "Silver";
_COLOR_WOOD_LIGHT = "BurlyWood";

// ========================================
// TEST / DEMO
// ========================================
if ($preview) {
    // Display all leg styles
    spacing = 100;

    translate([-spacing*1.5, 0, 0])
    leg_tapered(height=150, top_dia=40, bot_dia=20);

    translate([-spacing*0.5, 0, 0])
    leg_block(height=100, size=40);

    translate([spacing*0.5, 0, 0])
    leg_hairpin(height=150, rod_dia=8, spread=60);

    translate([spacing*1.5, 0, 0])
    leg_turned(height=150, dia=35);

    // Cushion examples
    translate([0, 150, 0])
    furniture_cushion([200, 150, 80], tufted=false);

    translate([0, 350, 0])
    furniture_cushion([200, 150, 80], tufted=true);
}
