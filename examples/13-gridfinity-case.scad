// 13-gridfinity-case.scad
// Demonstrates a plywood case with Gridfinity baseplate integration.
// Uses corner brackets for the case frame and a Gridfinity baseplate
// as the case bottom for modular storage organization.

$parent_modules = true;  // Prevent demo code in included modules from rendering

include <../modules/hardware/corner-bracket.scad>

// Include Gridfinity library
// Note: The library expects to be run from its own directory for includes.
// For now we use the NopSCADlib Gridfinity implementation which is simpler.
use <../lib/NopSCADlib/printed/gridfinity.scad>

// === CASE PARAMETERS ===
// Interior dimensions of the case (these determine Gridfinity capacity)

CASE_WIDTH = 400;   // Interior width (X) - fits 9 grid units (9 * 42 = 378mm)
CASE_DEPTH = 300;   // Interior depth (Y) - fits 7 grid units (7 * 42 = 294mm)
CASE_HEIGHT = 150;  // Side panel height (Z) - fits bins up to ~17 units tall

// Material parameters
PLY = PLY_3_8;      // 3/8" nominal plywood (actual: 11/32" = 8.7mm)
WALL = 3;           // Bracket wall thickness
TOLERANCE = 0.2;    // Clearance for plywood fit

// Assembly options
ADD_SCREWS = true;  // Add screw holes to brackets
SHOW_FEET = true;   // Show feet under brackets
CHAMFER = 1;        // Chamfer size for edges

// Gridfinity settings
GRID_X = 9;         // Number of grid units in X (calculated: floor(400/42) = 9)
GRID_Y = 7;         // Number of grid units in Y (calculated: floor(300/42) = 7)
SHOW_BASEPLATE = true;
SHOW_SAMPLE_BINS = true;

// === DERIVED VALUES ===
ARM = WALL + (PLY + TOLERANCE) * 2 + WALL;  // Corner bracket arm width

// Gridfinity dimensions
GRID_PITCH = 42;    // Standard Gridfinity pitch
BASE_HEIGHT = 7;    // Standard height per unit

// Baseplate positioning (centered in case interior)
BASEPLATE_WIDTH = GRID_X * GRID_PITCH;
BASEPLATE_DEPTH = GRID_Y * GRID_PITCH;
MARGIN_X = CASE_WIDTH - BASEPLATE_WIDTH;   // 400 - 378 = 22mm
MARGIN_Y = CASE_DEPTH - BASEPLATE_DEPTH;   // 300 - 294 = 6mm
OFFSET_X = MARGIN_X / 2;                   // Center offset
OFFSET_Y = MARGIN_Y / 2;

// === CORNER BRACKETS ===
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

// === FEET ===
module place_feet() {
    foot_dia = 20;
    foot_h = 8;

    floor_size = ARM - WALL;
    floor_rel = -ARM/2 + WALL * 2 + floor_size/2;

    bx = CASE_WIDTH/2 + ARM/2;
    by = CASE_DEPTH/2 + ARM/2;

    positions = [
        [-bx + floor_rel, -by + floor_rel],
        [bx - floor_rel, -by + floor_rel],
        [-bx + floor_rel, by - floor_rel],
        [bx - floor_rel, by - floor_rel]
    ];

    for (pos = positions) {
        translate([pos[0], pos[1], -foot_h])
        corner_foot(foot_dia = foot_dia, foot_height = foot_h, chamfer = CHAMFER, anchor = BOT);
    }
}

// === GRIDFINITY BASEPLATE ===
// Simple baseplate representation (since full library has complex includes)
module simple_baseplate(grid_x, grid_y) {
    base_height = 5;  // Thin baseplate style
    width = grid_x * GRID_PITCH;
    depth = grid_y * GRID_PITCH;

    color("tomato", 0.8)
    translate([0, 0, base_height/2])
    difference() {
        // Main baseplate body
        cube([width, depth, base_height], center=true);

        // Grid pattern cutouts (simplified representation)
        for (gx = [0:grid_x-1]) {
            for (gy = [0:grid_y-1]) {
                translate([
                    -width/2 + GRID_PITCH/2 + gx * GRID_PITCH,
                    -depth/2 + GRID_PITCH/2 + gy * GRID_PITCH,
                    base_height/2 - 2
                ])
                linear_extrude(3)
                offset(r=2)
                square([GRID_PITCH - 1, GRID_PITCH - 1], center=true);
            }
        }
    }
}

// === SAMPLE BINS ===
// Simple bin representation for visualization
module simple_bin(grid_x, grid_y, grid_z) {
    bin_width = grid_x * GRID_PITCH - 0.5;
    bin_depth = grid_y * GRID_PITCH - 0.5;
    bin_height = grid_z * BASE_HEIGHT + 7;  // +7 for base profile
    wall = 1.2;

    translate([0, 0, bin_height/2 + 5])  // +5 for baseplate
    difference() {
        // Outer shell
        hull() {
            translate([0, 0, -bin_height/2 + 3])
            cube([bin_width - 6, bin_depth - 6, 0.1], center=true);

            translate([0, 0, bin_height/2 - 2])
            cube([bin_width, bin_depth, 0.1], center=true);
        }

        // Inner cavity
        translate([0, 0, wall])
        hull() {
            translate([0, 0, -bin_height/2 + 3])
            cube([bin_width - 6 - wall*2, bin_depth - 6 - wall*2, 0.1], center=true);

            translate([0, 0, bin_height/2 - 2])
            cube([bin_width - wall*2, bin_depth - wall*2, 0.1], center=true);
        }
    }
}

module place_sample_bins() {
    // Various bin sizes to show versatility
    bins = [
        // [grid_x, grid_y, grid_z, pos_x, pos_y, color]
        [2, 2, 3, -3, -2, "SteelBlue"],
        [3, 2, 4, -1, -2, "SeaGreen"],
        [1, 1, 2, 1.5, -2, "Orange"],
        [1, 1, 2, 2.5, -2, "Orange"],
        [4, 3, 5, -2.5, 0.5, "SlateGray"],
        [2, 3, 3, 1.5, 0.5, "Coral"],
        [2, 2, 2, -3, 2, "MediumPurple"],
    ];

    for (bin = bins) {
        gx = bin[0];
        gy = bin[1];
        gz = bin[2];
        px = bin[3];
        py = bin[4];
        c = bin[5];

        translate([
            px * GRID_PITCH + (gx * GRID_PITCH)/2 - GRID_PITCH/2,
            py * GRID_PITCH + (gy * GRID_PITCH)/2 - GRID_PITCH/2,
            0
        ])
        color(c, 0.7)
        simple_bin(gx, gy, gz);
    }
}

// === GHOST PLYWOOD PANELS ===
// Show where plywood panels go (for visualization)
module ghost_panels() {
    // Side panels
    color("BurlyWood", 0.3) {
        // Left side
        translate([-CASE_WIDTH/2 - PLY/2, 0, CASE_HEIGHT/2])
        cube([PLY, CASE_DEPTH + ARM*2, CASE_HEIGHT], center=true);

        // Right side
        translate([CASE_WIDTH/2 + PLY/2, 0, CASE_HEIGHT/2])
        cube([PLY, CASE_DEPTH + ARM*2, CASE_HEIGHT], center=true);

        // Front
        translate([0, -CASE_DEPTH/2 - PLY/2, CASE_HEIGHT/2])
        cube([CASE_WIDTH, PLY, CASE_HEIGHT], center=true);

        // Back
        translate([0, CASE_DEPTH/2 + PLY/2, CASE_HEIGHT/2])
        cube([CASE_WIDTH, PLY, CASE_HEIGHT], center=true);

        // Bottom
        translate([0, 0, -PLY/2])
        cube([CASE_WIDTH, CASE_DEPTH, PLY], center=true);
    }
}

// === ASSEMBLY ===

// Corner brackets
color("teal")
place_corner_brackets();

// Feet
if (SHOW_FEET) {
    color("gray")
    place_feet();
}

// Gridfinity baseplate
if (SHOW_BASEPLATE) {
    translate([0, 0, 0])
    simple_baseplate(GRID_X, GRID_Y);
}

// Sample bins
if (SHOW_SAMPLE_BINS) {
    place_sample_bins();
}

// Ghost panels (comment out to hide)
// ghost_panels();

// === INFO ===
// Uncomment to see calculated values in console
echo(str("Case interior: ", CASE_WIDTH, " x ", CASE_DEPTH, " x ", CASE_HEIGHT, " mm"));
echo(str("Gridfinity grid: ", GRID_X, " x ", GRID_Y, " units (", GRID_X * GRID_Y, " total)"));
echo(str("Baseplate size: ", BASEPLATE_WIDTH, " x ", BASEPLATE_DEPTH, " mm"));
echo(str("Margin: X=", MARGIN_X, "mm, Y=", MARGIN_Y, "mm"));
echo(str("Max bin height: ~", floor((CASE_HEIGHT - 25) / BASE_HEIGHT), " units"));
