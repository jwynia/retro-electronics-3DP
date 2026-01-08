// Living Room Furniture
// Sofas, armchairs, coffee tables, bookcases, TV stands.

include <BOSL2/std.scad>
include <furniture-constants.scad>
include <furniture-utils.scad>

// ========================================
// SOFA
// ========================================

/**
 * Creates a parametric sofa with configurable seats and style.
 *
 * Arguments:
 *   seats       - number of seat cushions (2, 3, or 4)
 *   style       - "retro" (mid-century, tapered legs, tufted) or "modern" (block, clean)
 *   color       - cushion color
 *   wood_color  - leg/frame color
 *   scale       - scale factor (default: FURNITURE_SCALE)
 *   anchor      - BOSL2 anchor (default: BOT)
 *   spin        - BOSL2 spin (default: 0)
 *   orient      - BOSL2 orient (default: UP)
 */
module sofa(
    seats = 3,
    style = "retro",
    color = "SlateGray",
    wood_color = "SaddleBrown",
    scale = undef,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;

    // Real dimensions from constants
    seat_w = _SOFA_SEAT_WIDTH;
    seat_d = _SOFA_SEAT_DEPTH;
    seat_h = _SOFA_SEAT_HEIGHT;
    back_h = _SOFA_BACK_HEIGHT;
    arm_w = _SOFA_ARM_WIDTH;
    arm_h = _SOFA_ARM_HEIGHT;
    cushion_t = _CUSHION_THICK;

    // Calculate total width
    total_w = sofa_width(seats, arm_w, seat_w);

    // Scaled dimensions
    sw = total_w / _scale;
    sd = seat_d / _scale;
    sh = back_h / _scale;
    leg_h = (seat_h - cushion_t) / _scale;

    // Style-specific parameters
    is_retro = (style == "retro");
    leg_style = is_retro ? "tapered" : "block";
    tufted = is_retro;
    arm_rounding = is_retro ? sd/4 : 2;
    back_recline = is_retro ? 12 : 5;

    attachable(anchor, spin, orient, size=[sw, sd, sh]) {
        union() {
            // Legs
            leg_inset = 30 / _scale;
            color(wood_color)
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([x * (sw/2 - leg_inset), y * (sd/2 - leg_inset), 0])
                    furniture_leg(style=leg_style, height=leg_h, size=40/_scale);
                }
            }

            // Frame/base
            frame_h = 30/_scale;
            color(wood_color)
            translate([0, 0, leg_h])
            cuboid([sw - arm_w/_scale, sd - 20/_scale, frame_h], rounding=min(2, frame_h/2), anchor=BOT);

            // Seat cushions
            cushion_w = (seat_w - 20) / _scale;
            cushion_d = (seat_d - 40) / _scale;
            cushion_h = cushion_t / _scale;

            color(color)
            translate([0, 0, leg_h + 30/_scale])
            for (i = [0 : seats - 1]) {
                x_offset = -((seats - 1) / 2) * cushion_w + i * cushion_w;
                translate([x_offset, 0, 0])
                furniture_cushion([cushion_w - 5, cushion_d, cushion_h], tufted=tufted);
            }

            // Back cushion
            back_cushion_h = (back_h - seat_h - 50) / _scale;
            back_cushion_t = 80 / _scale;

            color(color)
            translate([0, -sd/2 + back_cushion_t/2 + 10/_scale, seat_h/_scale])
            furniture_back_cushion(
                size = [sw - arm_w*2/_scale - 10/_scale, back_cushion_h, back_cushion_t],
                recline = back_recline,
                tufted = tufted
            );

            // Arms
            arm_sw = arm_w / _scale;
            arm_sh = arm_h / _scale;
            arm_sd = sd - 20/_scale;
            safe_arm_rounding = min(arm_rounding, arm_sw/2, arm_sd/2, arm_sh/2);

            color(color)
            for (side = [-1, 1]) {
                translate([side * (sw/2 - arm_sw/2), 0, leg_h])
                cuboid([arm_sw, arm_sd, arm_sh], rounding=safe_arm_rounding, anchor=BOT);
            }
        }
        children();
    }
}

// ========================================
// ARMCHAIR
// ========================================

/**
 * Creates a parametric armchair.
 *
 * Arguments:
 *   style       - "retro" or "modern"
 *   color       - cushion color
 *   wood_color  - leg/frame color
 *   scale       - scale factor
 */
module armchair(
    style = "retro",
    color = "SlateGray",
    wood_color = "SaddleBrown",
    scale = undef,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;

    // Real dimensions
    total_w = _ARMCHAIR_WIDTH;
    total_d = _ARMCHAIR_DEPTH;
    total_h = _ARMCHAIR_HEIGHT;
    seat_h = _ARMCHAIR_SEAT_HEIGHT;
    cushion_t = _CUSHION_THICK;

    // Scaled dimensions
    sw = total_w / _scale;
    sd = total_d / _scale;
    sh = total_h / _scale;
    leg_h = (seat_h - cushion_t) / _scale;

    // Style parameters
    is_retro = (style == "retro");
    leg_style = is_retro ? "tapered" : "block";
    tufted = is_retro;
    arm_rounding = is_retro ? sd/4 : 2;

    attachable(anchor, spin, orient, size=[sw, sd, sh]) {
        union() {
            // Legs
            leg_inset = 25 / _scale;
            color(wood_color)
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([x * (sw/2 - leg_inset), y * (sd/2 - leg_inset), 0])
                    furniture_leg(style=leg_style, height=leg_h, size=35/_scale);
                }
            }

            // Frame
            frame_w = sw - 150/_scale;  // Interior seat width
            arm_frame_h = 25/_scale;
            color(wood_color)
            translate([0, 0, leg_h])
            cuboid([frame_w, sd - 30/_scale, arm_frame_h], rounding=min(2, arm_frame_h/2), anchor=BOT);

            // Seat cushion
            cushion_w = frame_w - 10/_scale;
            cushion_d = sd - 200/_scale;
            cushion_h = cushion_t / _scale;

            color(color)
            translate([0, 20/_scale, leg_h + arm_frame_h])
            furniture_cushion([cushion_w, cushion_d, cushion_h], tufted=tufted);

            // Back cushion
            back_h = (total_h - seat_h - 50) / _scale;
            back_t = 100 / _scale;

            color(color)
            translate([0, -sd/2 + back_t/2 + 10/_scale, seat_h/_scale])
            furniture_back_cushion(
                size = [cushion_w, back_h, back_t],
                recline = is_retro ? 15 : 8,
                tufted = tufted
            );

            // Arms
            arm_w = 120 / _scale;
            arm_h = 350 / _scale;
            arm_d = sd - 30/_scale;
            safe_chair_arm_rounding = min(arm_rounding, arm_w/2, arm_d/2, arm_h/2);

            color(color)
            for (side = [-1, 1]) {
                translate([side * (sw/2 - arm_w/2), 0, leg_h])
                cuboid([arm_w, arm_d, arm_h], rounding=safe_chair_arm_rounding, anchor=BOT);
            }
        }
        children();
    }
}

// ========================================
// COFFEE TABLE
// ========================================

/**
 * Creates a parametric coffee table.
 *
 * Arguments:
 *   size        - [width, depth, height] in real mm (or uses defaults)
 *   style       - "retro" or "modern"
 *   has_shelf   - include lower shelf
 *   wood_color  - table color
 *   scale       - scale factor
 */
module coffee_table(
    size = undef,
    style = "retro",
    has_shelf = true,
    wood_color = "SaddleBrown",
    scale = undef,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;

    // Use provided size or defaults
    _size = is_undef(size) ? [_COFFEE_TABLE_WIDTH, _COFFEE_TABLE_DEPTH, _COFFEE_TABLE_HEIGHT] : size;

    // Scaled dimensions
    sw = _size[0] / _scale;
    sd = _size[1] / _scale;
    sh = _size[2] / _scale;

    // Style parameters
    is_retro = (style == "retro");
    leg_style = is_retro ? "tapered" : "block";
    top_thick = _TABLETOP_THICK / _scale;
    top_rounding = is_retro ? 15/_scale : 2;
    leg_h = sh - top_thick;

    attachable(anchor, spin, orient, size=[sw, sd, sh]) {
        color(wood_color)
        union() {
            // Legs
            leg_inset = 40 / _scale;
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([x * (sw/2 - leg_inset), y * (sd/2 - leg_inset), 0])
                    furniture_leg(style=leg_style, height=leg_h, size=40/_scale);
                }
            }

            // Table top
            translate([0, 0, leg_h])
            furniture_panel([sw, sd, top_thick], rounding=top_rounding);

            // Lower shelf (if enabled)
            if (has_shelf) {
                shelf_h = leg_h * 0.3;
                shelf_thick = top_thick * 0.7;
                translate([0, 0, shelf_h])
                furniture_panel([sw - leg_inset, sd - leg_inset, shelf_thick], rounding=top_rounding);
            }
        }
        children();
    }
}

// ========================================
// END TABLE / SIDE TABLE
// ========================================

/**
 * Creates an end table / side table.
 *
 * Arguments:
 *   size        - [width, depth, height] in real mm
 *   style       - "retro" or "modern"
 *   has_shelf   - include lower shelf
 *   wood_color  - table color
 *   scale       - scale factor
 */
module end_table(
    size = undef,
    style = "retro",
    has_shelf = false,
    wood_color = "SaddleBrown",
    scale = undef,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;

    _size = is_undef(size) ? [_END_TABLE_WIDTH, _END_TABLE_DEPTH, _END_TABLE_HEIGHT] : size;

    sw = _size[0] / _scale;
    sd = _size[1] / _scale;
    sh = _size[2] / _scale;

    is_retro = (style == "retro");
    leg_style = is_retro ? "tapered" : "block";
    top_thick = _TABLETOP_THICK / _scale;
    leg_h = sh - top_thick;

    attachable(anchor, spin, orient, size=[sw, sd, sh]) {
        color(wood_color)
        union() {
            // Legs
            leg_inset = 25 / _scale;
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([x * (sw/2 - leg_inset), y * (sd/2 - leg_inset), 0])
                    furniture_leg(style=leg_style, height=leg_h, size=30/_scale);
                }
            }

            // Table top
            translate([0, 0, leg_h])
            furniture_panel([sw, sd, top_thick], rounding=is_retro ? 10/_scale : 2);

            if (has_shelf) {
                translate([0, 0, leg_h * 0.3])
                furniture_panel([sw - leg_inset, sd - leg_inset, top_thick * 0.7], rounding=5/_scale);
            }
        }
        children();
    }
}

// ========================================
// BOOKCASE
// ========================================

/**
 * Creates a bookcase / shelving unit.
 *
 * Arguments:
 *   units_wide  - number of column units
 *   units_tall  - number of shelf levels
 *   style       - "retro" or "modern"
 *   wood_color  - color
 *   scale       - scale factor
 */
module bookcase(
    units_wide = 3,
    units_tall = 5,
    style = "retro",
    wood_color = "SaddleBrown",
    scale = undef,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;

    // Calculate dimensions from units
    unit_w = _BOOKCASE_WIDTH / 3;  // Per unit width
    unit_h = _SHELF_HEIGHT;
    depth = _BOOKCASE_DEPTH;
    panel_t = _PANEL_THICK;

    total_w = unit_w * units_wide;
    total_h = unit_h * units_tall + panel_t;
    total_d = depth;

    // Scaled
    sw = total_w / _scale;
    sh = total_h / _scale;
    sd = total_d / _scale;
    pt = panel_t / _scale;
    unit_sw = unit_w / _scale;
    unit_sh = unit_h / _scale;

    is_retro = (style == "retro");
    base_rounding = is_retro ? 3 : 1;
    safe_rounding = min(base_rounding, pt/2);

    attachable(anchor, spin, orient, size=[sw, sd, sh]) {
        color(wood_color)
        union() {
            // Side panels
            for (side = [-1, 1]) {
                translate([side * (sw/2 - pt/2), 0, sh/2])
                cuboid([pt, sd, sh], rounding=safe_rounding, edges="Y", anchor=CENTER);
            }

            // Back panel
            translate([0, -sd/2 + pt/2, sh/2])
            cuboid([sw - pt*2, pt, sh], anchor=CENTER);

            // Shelves
            for (i = [0 : units_tall]) {
                translate([0, 0, i * unit_sh + pt/2])
                cuboid([sw - pt*2, sd - pt, pt], rounding=safe_rounding, edges="Y", anchor=BOT);
            }

            // Vertical dividers (if more than 1 unit wide)
            if (units_wide > 1) {
                for (i = [1 : units_wide - 1]) {
                    x_pos = -sw/2 + pt + i * unit_sw;
                    translate([x_pos, pt/2, sh/2])
                    cuboid([pt, sd - pt*2, sh - pt*2], anchor=CENTER);
                }
            }
        }
        children();
    }
}

// ========================================
// TV STAND / MEDIA CONSOLE
// ========================================

/**
 * Creates a TV stand / media console.
 *
 * Arguments:
 *   size        - [width, depth, height] in real mm
 *   style       - "retro" or "modern"
 *   cabinets    - number of cabinet doors
 *   wood_color  - color
 *   scale       - scale factor
 */
module tv_stand(
    size = undef,
    style = "retro",
    cabinets = 2,
    wood_color = "SaddleBrown",
    scale = undef,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;

    _size = is_undef(size) ? [_TV_STAND_WIDTH, _TV_STAND_DEPTH, _TV_STAND_HEIGHT] : size;

    sw = _size[0] / _scale;
    sd = _size[1] / _scale;
    sh = _size[2] / _scale;
    pt = _PANEL_THICK / _scale;

    is_retro = (style == "retro");
    leg_style = is_retro ? "tapered" : "block";
    leg_h = is_retro ? 100/_scale : 50/_scale;
    cabinet_h = sh - leg_h - pt;

    attachable(anchor, spin, orient, size=[sw, sd, sh]) {
        color(wood_color)
        union() {
            // Legs
            leg_inset = 30 / _scale;
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([x * (sw/2 - leg_inset), y * (sd/2 - leg_inset), 0])
                    furniture_leg(style=leg_style, height=leg_h, size=35/_scale);
                }
            }

            // Cabinet box
            translate([0, 0, leg_h])
            diff()
            cuboid([sw, sd, cabinet_h], rounding=is_retro ? 3 : 1, edges="Z", anchor=BOT) {
                // Hollow interior
                tag("remove")
                position(FWD)
                translate([0, -0.01, pt])
                cuboid([sw - pt*2, sd - pt, cabinet_h - pt*2], anchor=FWD+BOT);

                // Cabinet door lines
                cabinet_w = (sw - pt*2) / cabinets;
                for (i = [0 : cabinets - 1]) {
                    x_pos = -sw/2 + pt + cabinet_w/2 + i * cabinet_w;
                    tag("remove")
                    position(FWD)
                    translate([x_pos, 0, cabinet_h/2])
                    cuboid([cabinet_w - 4/_scale, pt + 0.02, cabinet_h - pt*2 - 4/_scale], anchor=FWD);
                }
            }

            // Top surface
            translate([0, 0, leg_h + cabinet_h])
            furniture_panel([sw, sd, pt], rounding=is_retro ? 5/_scale : 1);
        }
        children();
    }
}

// ========================================
// TEST / DEMO
// ========================================
if ($preview) {
    // Display furniture at 1:24 scale
    spacing = 150;

    // Sofa
    translate([0, 0, 0])
    sofa(seats=3, style="retro");

    // Armchair
    translate([spacing, 0, 0])
    armchair(style="retro");

    // Coffee table
    translate([0, spacing, 0])
    coffee_table(style="retro");

    // End table
    translate([spacing * 0.7, spacing, 0])
    end_table(style="retro");

    // Bookcase
    translate([-spacing, 0, 0])
    bookcase(units_wide=2, units_tall=4, style="retro");

    // TV stand
    translate([0, -spacing, 0])
    tv_stand(style="retro", cabinets=3);

    // Modern variants for comparison
    translate([0, -spacing*2, 0])
    sofa(seats=2, style="modern", color="DarkSlateGray");

    translate([spacing, -spacing*2, 0])
    coffee_table(style="modern", wood_color="Sienna");
}
