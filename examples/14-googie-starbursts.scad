// 14-googie-starbursts.scad
// Demonstrates Googie-style starburst decorations for retro signage.
// Classic atomic-age design elements from 1950s-60s.

$parent_modules = true;  // Prevent module test code from running

include <../modules/googie/starburst.scad>

// === LAYOUT CONFIGURATION ===
// Define each piece with position and size for proper spacing

// Grid layout: 3 columns x 2 rows
SPACING = 100;  // Center-to-center spacing
COLS = 3;
ROWS = 2;

// Object definitions: [col, row, radius, color, description]
// This lets us calculate bounds and center the scene
OBJECTS = [
    [0, 0, 40, "Gold"],      // atomic_starburst
    [1, 0, 40, "Crimson"],   // 5-point star
    [2, 0, 35, "Silver"],    // 8-point non-alternating
    [0, 1, 40, "Turquoise"], // 6-point with hole
    [1, 1, 40, "Orange"],    // 12-point
    [2, 1, 45, "HotPink"],   // dramatic skinny
];

// Calculate scene bounds for centering
SCENE_WIDTH = (COLS - 1) * SPACING;
SCENE_HEIGHT = (ROWS - 1) * SPACING;
MAX_RADIUS = 45;  // Largest object radius

// Center offset - shifts everything so scene is centered at origin
CENTER_X = -SCENE_WIDTH / 2;
CENTER_Y = -SCENE_HEIGHT / 2;

// === RENDER ALL STARBURSTS ===
// Centered at origin for optimal camera framing

translate([CENTER_X, CENTER_Y, 0]) {
    // Row 0: Basic shapes

    // Atomic starburst (Las Vegas sign style)
    translate([0 * SPACING, 0 * SPACING, 0])
    color("Gold")
    atomic_starburst(size=80, thickness=8);

    // Simple 5-point star
    translate([1 * SPACING, 0 * SPACING, 0])
    color("Crimson")
    star(points=5, outer_radius=40, inner_radius=16, thickness=8);

    // Non-alternating 8-point
    translate([2 * SPACING, 0 * SPACING, 0])
    color("Silver")
    starburst(
        points = 8,
        outer_radius = 35,
        inner_radius = 14,
        alternating = false,
        thickness = 8
    );

    // Row 1: Variations

    // 6-point with mounting hole
    translate([0 * SPACING, 1 * SPACING, 0])
    color("Turquoise")
    starburst(
        points = 6,
        outer_radius = 40,
        inner_radius = 22,
        thickness = 6,
        center_hole = 8
    );

    // 12-point elaborate
    translate([1 * SPACING, 1 * SPACING, 0])
    color("Orange")
    starburst(
        points = 12,
        outer_radius = 40,
        inner_radius = 25,
        mid_radius = 12,
        thickness = 6
    );

    // Dramatic skinny points
    translate([2 * SPACING, 1 * SPACING, 0])
    color("HotPink")
    starburst(
        points = 8,
        outer_radius = 45,
        inner_radius = 18,
        mid_radius = 7,
        thickness = 5
    );
}

// Debug: show scene bounds (uncomment to visualize)
// %translate([0, 0, -1]) cube([SCENE_WIDTH + MAX_RADIUS*2, SCENE_HEIGHT + MAX_RADIUS*2, 1], center=true);
