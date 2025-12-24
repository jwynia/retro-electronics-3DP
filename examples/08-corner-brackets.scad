// 08-corner-brackets.scad
// Demonstrates corner brackets assembled into a plywood case frame.

$parent_modules = true;  // Prevent demo code in included modules from rendering

include <../modules/hardware/corner-bracket.scad>
include <../modules/hardware/edge-strip.scad>

// === CASE PARAMETERS ===
// Adjust these to match your case design

// Interior dimensions of the case
CASE_WIDTH = 200;   // Interior width (X)
CASE_DEPTH = 150;   // Interior depth (Y)
CASE_HEIGHT = 152;  // Side panel height (Z)

// Material parameters
PLY = PLY_3_8;      // 3/8" nominal plywood (actual: 11/32" = 8.7mm)
WALL = 3;           // Bracket wall thickness
TOLERANCE = 0.2;    // Clearance for plywood fit

// Assembly options
SHOW_EDGE_STRIPS = false;  // Show mid-edge support strips
ADD_SCREWS = true;         // Add screw holes to brackets
SHOW_FEET = true;          // Show feet under brackets
CHAMFER = 1;               // Chamfer size for edges (0 = none)

// === DERIVED VALUES ===
ARM = WALL + (PLY + TOLERANCE) * 2 + WALL;  // Corner bracket arm width (~25mm)

// === CORNER BRACKETS ===
// Position at all 4 bottom corners

module place_corner_brackets() {
    // Front-left corner
    translate([-CASE_WIDTH/2 - ARM/2, -CASE_DEPTH/2 - ARM/2, 0])
    corner_bracket(
        case_height = CASE_HEIGHT,
        ply_thickness = PLY,
        wall = WALL,
        screw_holes = ADD_SCREWS,
        chamfer = CHAMFER,
        anchor = BOT
    );

    // Front-right corner (mirrored in X)
    translate([CASE_WIDTH/2 + ARM/2, -CASE_DEPTH/2 - ARM/2, 0])
    mirror([1, 0, 0])
    corner_bracket(
        case_height = CASE_HEIGHT,
        ply_thickness = PLY,
        wall = WALL,
        screw_holes = ADD_SCREWS,
        chamfer = CHAMFER,
        anchor = BOT
    );

    // Back-left corner (mirrored in Y)
    translate([-CASE_WIDTH/2 - ARM/2, CASE_DEPTH/2 + ARM/2, 0])
    mirror([0, 1, 0])
    corner_bracket(
        case_height = CASE_HEIGHT,
        ply_thickness = PLY,
        wall = WALL,
        screw_holes = ADD_SCREWS,
        chamfer = CHAMFER,
        anchor = BOT
    );

    // Back-right corner (mirrored in X and Y)
    translate([CASE_WIDTH/2 + ARM/2, CASE_DEPTH/2 + ARM/2, 0])
    mirror([1, 0, 0])
    mirror([0, 1, 0])
    corner_bracket(
        case_height = CASE_HEIGHT,
        ply_thickness = PLY,
        wall = WALL,
        screw_holes = ADD_SCREWS,
        chamfer = CHAMFER,
        anchor = BOT
    );
}

// === EDGE STRIPS ===
// Optional mid-span support for longer edges

module place_edge_strips() {
    strip_len_x = CASE_WIDTH - 2 * ARM - 20;  // Leave gap for corner brackets
    strip_len_y = CASE_DEPTH - 2 * ARM - 20;
    strip_depth = WALL + SLOT_DEPTH;

    // Front edge strip (along X)
    translate([0, -CASE_DEPTH/2 - strip_depth/2, 0])
    edge_strip(
        length = strip_len_x,
        case_height = CASE_HEIGHT,
        ply_thickness = PLY,
        wall = WALL,
        screw_holes = ADD_SCREWS,
        anchor = BOT
    );

    // Back edge strip (along X)
    translate([0, CASE_DEPTH/2 + strip_depth/2, 0])
    rotate([0, 0, 180])
    edge_strip(
        length = strip_len_x,
        case_height = CASE_HEIGHT,
        ply_thickness = PLY,
        wall = WALL,
        screw_holes = ADD_SCREWS,
        anchor = BOT
    );

    // Left edge strip (along Y)
    translate([-CASE_WIDTH/2 - strip_depth/2, 0, 0])
    rotate([0, 0, 90])
    edge_strip(
        length = strip_len_y,
        case_height = CASE_HEIGHT,
        ply_thickness = PLY,
        wall = WALL,
        screw_holes = ADD_SCREWS,
        anchor = BOT
    );

    // Right edge strip (along Y)
    translate([CASE_WIDTH/2 + strip_depth/2, 0, 0])
    rotate([0, 0, -90])
    edge_strip(
        length = strip_len_y,
        case_height = CASE_HEIGHT,
        ply_thickness = PLY,
        wall = WALL,
        screw_holes = ADD_SCREWS,
        anchor = BOT
    );
}

// === FEET ===
// Round feet under each bracket floor

module place_feet() {
    foot_dia = 20;
    foot_h = 8;

    // Floor center relative to bracket center
    // In bracket: floor_pos = ext_corner + wall*2 + floor_size/2
    // where ext_corner = -arm_width/2
    floor_size = ARM - WALL;  // Matches bracket floor_size = arm_width - wall
    floor_rel = -ARM/2 + WALL * 2 + floor_size/2;

    // Bracket centers (same as in place_corner_brackets)
    bx = CASE_WIDTH/2 + ARM/2;
    by = CASE_DEPTH/2 + ARM/2;

    // Foot positions (at floor centers, accounting for bracket orientation/mirroring)
    positions = [
        [-bx + floor_rel, -by + floor_rel],   // Front-left (no mirror)
        [bx - floor_rel, -by + floor_rel],    // Front-right (mirror X)
        [-bx + floor_rel, by - floor_rel],    // Back-left (mirror Y)
        [bx - floor_rel, by - floor_rel]      // Back-right (mirror X and Y)
    ];

    for (pos = positions) {
        translate([pos[0], pos[1], -foot_h])
        corner_foot(foot_dia = foot_dia, foot_height = foot_h, chamfer = CHAMFER, anchor = BOT);
    }
}

// === ASSEMBLY ===

color("teal")
place_corner_brackets();

if (SHOW_FEET) {
    color("gray")
    place_feet();
}

if (SHOW_EDGE_STRIPS) {
    color("teal")
    place_edge_strips();
}
