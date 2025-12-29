// 16-googie-pylons.scad
// Demonstrates Googie-style pylons and mounting poles.
// Classic "reaching skyward" Space Age structures.

$parent_modules = true;  // Prevent module test code from running

include <../modules/googie/pylon.scad>

// === LAYOUT CONFIGURATION ===
SPACING = 70;
COLS = 3;
ROWS = 2;

// Calculate scene bounds for centering
SCENE_WIDTH = (COLS - 1) * SPACING;
SCENE_HEIGHT = (ROWS - 1) * SPACING;

// Center offset
CENTER_X = -SCENE_WIDTH / 2;
CENTER_Y = -SCENE_HEIGHT / 2;

// === RENDER ALL PYLONS ===
translate([CENTER_X, CENTER_Y, 0]) {

    // Row 0: Basic profiles

    // Classic round tapered
    translate([0 * SPACING, 0 * SPACING, 0])
    color("Silver")
    pylon(height=80, base_dia=25, top_dia=12);

    // Square profile
    translate([1 * SPACING, 0 * SPACING, 0])
    color("SlateGray")
    pylon(height=75, base_dia=22, top_dia=12, profile="square");

    // Diamond profile
    translate([2 * SPACING, 0 * SPACING, 0])
    color("Teal")
    pylon(height=85, base_dia=24, top_dia=14, profile="diamond");

    // Row 1: Structural variations

    // With weighted base (freestanding)
    translate([0 * SPACING, 1 * SPACING, 0])
    color("DarkOrange")
    pylon_with_base(height=70, base_width=45, top_plate=true);

    // Double fin (classic Googie)
    translate([1 * SPACING, 1 * SPACING, 0])
    color("Crimson")
    double_fin_pylon(height=80, base_size=28, top_size=16);

    // Fin with mounting plate and holes
    translate([2 * SPACING, 1 * SPACING, 0])
    color("Gold")
    pylon(
        height = 75,
        base_dia = 26,
        top_dia = 16,
        profile = "fin",
        top_plate = true,
        plate_size = [30, 20],
        mount_holes = true
    );
}
