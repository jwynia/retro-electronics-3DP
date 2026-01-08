// Floor Plan Utilities
// Grid, room outlines, door/window symbols for home layout planning.

include <BOSL2/std.scad>
include <furniture-constants.scad>

// ========================================
// DEFAULTS
// ========================================
_GRID_THICKNESS = 0.5;
_WALL_HEIGHT = 100;    // Default wall height for visualization
_WALL_THICK = 4;       // Default wall thickness at scale

// ========================================
// FLOOR GRID
// ========================================

/**
 * Creates a floor grid for furniture placement reference.
 * Grid lines represent a configurable spacing (default 1 foot = 304.8mm real).
 *
 * Arguments:
 *   size        - [width, depth] of floor area in real mm
 *   grid_size   - grid spacing in real mm (default: 304.8 = 1 foot)
 *   thickness   - line thickness at scale
 *   show_major  - show major grid lines (every 4 units)
 *   scale       - scale factor (default: FURNITURE_SCALE)
 *   anchor      - BOSL2 anchor (default: BOT)
 *   spin        - BOSL2 spin (default: 0)
 *   orient      - BOSL2 orient (default: UP)
 */
module floor_grid(
    size,
    grid_size = 304.8,
    thickness = _GRID_THICKNESS,
    show_major = true,
    scale = undef,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;

    // Scaled dimensions
    sw = size[0] / _scale;
    sd = size[1] / _scale;
    sg = grid_size / _scale;

    // Number of grid lines
    nx = floor(sw / sg);
    ny = floor(sd / sg);

    attachable(anchor, spin, orient, size=[sw, sd, thickness]) {
        union() {
            // Base floor
            color("White", 0.3)
            cuboid([sw, sd, thickness*0.5], anchor=BOT);

            // Grid lines along X
            color("LightGray")
            for (i = [0 : ny]) {
                y_pos = -sd/2 + i * sg;
                is_major = (i % 4 == 0);
                line_thick = is_major && show_major ? thickness * 2 : thickness;
                translate([0, y_pos, thickness*0.5])
                cuboid([sw, line_thick, thickness], anchor=BOT);
            }

            // Grid lines along Y
            color("LightGray")
            for (i = [0 : nx]) {
                x_pos = -sw/2 + i * sg;
                is_major = (i % 4 == 0);
                line_thick = is_major && show_major ? thickness * 2 : thickness;
                translate([x_pos, 0, thickness*0.5])
                cuboid([line_thick, sd, thickness], anchor=BOT);
            }
        }
        children();
    }
}

// ========================================
// ROOM OUTLINE
// ========================================

/**
 * Creates a room outline (walls) for layout visualization.
 *
 * Arguments:
 *   size        - [width, depth] of room interior in real mm
 *   wall_height - wall height in real mm (default: 2400 = 8 feet)
 *   wall_thick  - wall thickness in scaled mm
 *   scale       - scale factor (default: FURNITURE_SCALE)
 *   anchor      - BOSL2 anchor (default: BOT)
 *   spin        - BOSL2 spin (default: 0)
 *   orient      - BOSL2 orient (default: UP)
 */
module room_outline(
    size,
    wall_height = 2400,
    wall_thick = _WALL_THICK,
    scale = undef,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;

    // Scaled dimensions
    sw = size[0] / _scale;
    sd = size[1] / _scale;
    sh = wall_height / _scale;

    // Outer dimensions include wall thickness
    outer_w = sw + wall_thick * 2;
    outer_d = sd + wall_thick * 2;

    attachable(anchor, spin, orient, size=[outer_w, outer_d, sh]) {
        color("WhiteSmoke", 0.5)
        diff()
        cuboid([outer_w, outer_d, sh], anchor=BOT) {
            // Remove interior
            tag("remove")
            position(TOP)
            up(0.01)
            cuboid([sw, sd, sh + 0.02], anchor=TOP);
        }
        children();
    }
}

/**
 * Creates a room outline with optional door and window openings.
 *
 * Arguments:
 *   size        - [width, depth] of room interior in real mm
 *   wall_height - wall height in real mm
 *   wall_thick  - wall thickness in scaled mm
 *   doors       - list of door specs: [[wall, position, width], ...]
 *                 wall: "front", "back", "left", "right"
 *                 position: center offset along wall in real mm
 *                 width: door width in real mm
 *   windows     - list of window specs: [[wall, position, width, sill_height], ...]
 *   scale       - scale factor
 */
module room_with_openings(
    size,
    wall_height = 2400,
    wall_thick = _WALL_THICK,
    doors = [],
    windows = [],
    scale = undef,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;

    // Scaled dimensions
    sw = size[0] / _scale;
    sd = size[1] / _scale;
    sh = wall_height / _scale;

    // Standard opening dimensions (real mm, will be scaled)
    door_height = 2100;  // 7 feet
    window_height = 1200;  // 4 feet

    outer_w = sw + wall_thick * 2;
    outer_d = sd + wall_thick * 2;

    attachable(anchor, spin, orient, size=[outer_w, outer_d, sh]) {
        color("WhiteSmoke", 0.5)
        diff()
        cuboid([outer_w, outer_d, sh], anchor=BOT) {
            // Remove interior
            tag("remove")
            position(TOP)
            up(0.01)
            cuboid([sw, sd, sh + 0.02], anchor=TOP);

            // Door openings
            for (door = doors) {
                wall = door[0];
                pos = door[1] / _scale;
                w = door[2] / _scale;
                h = door_height / _scale;

                tag("remove")
                if (wall == "front") {
                    translate([pos, -sd/2 - wall_thick/2, 0])
                    cuboid([w, wall_thick + 0.02, h], anchor=BOT);
                } else if (wall == "back") {
                    translate([pos, sd/2 + wall_thick/2, 0])
                    cuboid([w, wall_thick + 0.02, h], anchor=BOT);
                } else if (wall == "left") {
                    translate([-sw/2 - wall_thick/2, pos, 0])
                    cuboid([wall_thick + 0.02, w, h], anchor=BOT);
                } else if (wall == "right") {
                    translate([sw/2 + wall_thick/2, pos, 0])
                    cuboid([wall_thick + 0.02, w, h], anchor=BOT);
                }
            }

            // Window openings
            for (win = windows) {
                wall = win[0];
                pos = win[1] / _scale;
                w = win[2] / _scale;
                sill = (len(win) > 3 ? win[3] : 900) / _scale;  // Default sill 3ft
                h = window_height / _scale;

                tag("remove")
                if (wall == "front") {
                    translate([pos, -sd/2 - wall_thick/2, sill])
                    cuboid([w, wall_thick + 0.02, h], anchor=BOT);
                } else if (wall == "back") {
                    translate([pos, sd/2 + wall_thick/2, sill])
                    cuboid([w, wall_thick + 0.02, h], anchor=BOT);
                } else if (wall == "left") {
                    translate([-sw/2 - wall_thick/2, pos, sill])
                    cuboid([wall_thick + 0.02, w, h], anchor=BOT);
                } else if (wall == "right") {
                    translate([sw/2 + wall_thick/2, pos, sill])
                    cuboid([wall_thick + 0.02, w, h], anchor=BOT);
                }
            }
        }
        children();
    }
}

// ========================================
// DOOR SYMBOL (2D floor plan style)
// ========================================

/**
 * Creates a door swing symbol for floor plan views.
 *
 * Arguments:
 *   width       - door width in real mm (default: 900 = 36")
 *   swing       - "left" or "right" swing direction
 *   scale       - scale factor
 */
module door_symbol(
    width = 900,
    swing = "left",
    thickness = 1,
    scale = undef,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;
    sw = width / _scale;

    attachable(anchor, spin, orient, size=[sw, sw, thickness]) {
        color("SaddleBrown")
        union() {
            // Door panel (closed position indicator)
            cuboid([sw, thickness*2, thickness], anchor=CENTER);

            // Swing arc
            swing_mult = swing == "left" ? 1 : -1;
            translate([swing_mult * sw/2, 0, 0])
            rotate([0, 0, swing_mult * 90])
            difference() {
                pie_slice(d=sw*2, h=thickness, ang=90, spin=-45);
                cyl(d=sw*2 - thickness*4, h=thickness+0.02);
            }
        }
        children();
    }
}

// ========================================
// WINDOW SYMBOL (2D floor plan style)
// ========================================

/**
 * Creates a window symbol for floor plan views.
 *
 * Arguments:
 *   width       - window width in real mm (default: 1200 = 48")
 *   wall_thick  - wall thickness for context
 *   scale       - scale factor
 */
module window_symbol(
    width = 1200,
    wall_thick = _WALL_THICK,
    thickness = 1,
    scale = undef,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;
    sw = width / _scale;

    attachable(anchor, spin, orient, size=[sw, wall_thick, thickness]) {
        color("LightBlue")
        union() {
            // Window frame
            diff()
            cuboid([sw, wall_thick, thickness], anchor=CENTER) {
                // Glass panes (3 sections)
                tag("remove")
                for (i = [-1, 0, 1]) {
                    translate([i * sw/3, 0, 0])
                    cuboid([sw/3 - 1, wall_thick - 1, thickness + 0.02], anchor=CENTER);
                }
            }
        }
        children();
    }
}

// ========================================
// STAIRCASE SYMBOL
// ========================================

/**
 * Creates a simple staircase representation.
 *
 * Arguments:
 *   size        - [width, run_length] in real mm
 *   steps       - number of steps
 *   scale       - scale factor
 */
module stair_symbol(
    size = [900, 3000],
    steps = 12,
    scale = undef,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    _scale = is_undef(scale) ? FURNITURE_SCALE : scale;
    sw = size[0] / _scale;
    sl = size[1] / _scale;
    step_depth = sl / steps;
    step_height = 2;  // Visual representation height

    attachable(anchor, spin, orient, size=[sw, sl, step_height * steps]) {
        color("BurlyWood")
        union() {
            for (i = [0 : steps - 1]) {
                translate([0, -sl/2 + step_depth/2 + i * step_depth, i * step_height])
                cuboid([sw, step_depth - 0.5, step_height], anchor=BOT);
            }
            // Direction arrow
            translate([0, 0, steps * step_height])
            color("Gray")
            linear_extrude(1)
            polygon([[-sw/6, -sl/3], [sw/6, -sl/3], [0, sl/3]]);
        }
        children();
    }
}

// ========================================
// TEST / DEMO
// ========================================
if ($preview) {
    // Demo room: 15ft x 12ft (4572mm x 3658mm)
    room_size = [4572, 3658];

    // Floor grid
    floor_grid(room_size);

    // Room outline with a door and window
    room_with_openings(
        size = room_size,
        doors = [["front", 0, 900]],
        windows = [["back", 0, 1200]]
    );

    // Door symbol at entrance
    translate([0, -room_size[1]/FURNITURE_SCALE/2 - 10, 0])
    door_symbol(width=900, swing="right");
}
