// 15-googie-boomerangs.scad
// Demonstrates Googie-style boomerang and curved arrow shapes.
// Classic mid-century modern motion symbols.

$parent_modules = true;  // Prevent module test code from running

include <../modules/googie/boomerang.scad>

// === LAYOUT CONFIGURATION ===
SPACING = 130;  // Center-to-center spacing
COLS = 3;
ROWS = 2;

// Calculate scene bounds for centering
SCENE_WIDTH = (COLS - 1) * SPACING;
SCENE_HEIGHT = (ROWS - 1) * SPACING;

// Center offset
CENTER_X = -SCENE_WIDTH / 2;
CENTER_Y = -SCENE_HEIGHT / 2;

// === RENDER ALL BOOMERANGS ===
translate([CENTER_X, CENTER_Y, 0]) {

    // Row 0: Basic shapes

    // Classic boomerang
    translate([0 * SPACING, 0 * SPACING, 0])
    color("Coral")
    boomerang(span=100, sweep_angle=120, width=15);

    // Curved arrow (directional)
    translate([1 * SPACING, 0 * SPACING, 0])
    color("DeepSkyBlue")
    curved_arrow(span=90, sweep_angle=90);

    // Decorative swoosh
    translate([2 * SPACING, 0 * SPACING, 0])
    color("Gold")
    swoosh(span=110, width=18);

    // Row 1: Variations

    // Tight curve
    translate([0 * SPACING, 1 * SPACING, 0])
    color("MediumOrchid")
    boomerang(span=80, sweep_angle=150, width=12, taper=0.1);

    // Wide gentle curve
    translate([1 * SPACING, 1 * SPACING, 0])
    color("LimeGreen")
    boomerang(span=120, sweep_angle=60, width=14, taper=0.4);

    // Double arrow (symmetric)
    translate([2 * SPACING, 1 * SPACING, 0])
    color("Tomato")
    boomerang(span=100, sweep_angle=100, width=12, arrow_head=true, symmetric=true);
}
