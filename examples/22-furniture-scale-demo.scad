// Furniture Scale Demo
// Demonstrates the same furniture pieces at different scales (1:12, 1:24, 1:48)

include <BOSL2/std.scad>
include <../modules/furniture/furniture-constants.scad>
include <../modules/furniture/living-room.scad>

// ========================================
// SCALE COMPARISON
// ========================================
// This demo shows identical furniture at three common scales:
// - 1:12 (Dollhouse scale, 1" = 1')
// - 1:24 (Half-inch scale, 1/2" = 1')
// - 1:48 (Quarter-inch scale, 1/4" = 1')

// Layout spacing
row_spacing = 200;
col_spacing = 120;

// Labels (using simple cubes as markers)
module scale_marker(label_scale) {
    marker_size = 300 / label_scale;
    color("DarkGray")
    cuboid([marker_size, 5, 2], anchor=BOT);
}

// ========================================
// 1:12 SCALE (Dollhouse)
// ========================================
translate([-col_spacing, row_spacing, 0]) {
    scale_marker(12);

    // Sofa at 1:12
    translate([0, 50, 0])
    sofa(seats=3, style="retro", scale=12);

    // Coffee table at 1:12
    translate([0, -30, 0])
    coffee_table(style="retro", scale=12);

    // Armchair at 1:12
    translate([80, 20, 0])
    rotate([0, 0, -30])
    armchair(style="retro", scale=12);
}

// ========================================
// 1:24 SCALE (Half-inch)
// ========================================
translate([0, 0, 0]) {
    scale_marker(24);

    // Sofa at 1:24 (default)
    translate([0, 50, 0])
    sofa(seats=3, style="retro", scale=24);

    // Coffee table at 1:24
    translate([0, -15, 0])
    coffee_table(style="retro", scale=24);

    // Armchair at 1:24
    translate([50, 10, 0])
    rotate([0, 0, -30])
    armchair(style="retro", scale=24);
}

// ========================================
// 1:48 SCALE (Quarter-inch)
// ========================================
translate([col_spacing, -row_spacing/2, 0]) {
    scale_marker(48);

    // Sofa at 1:48
    translate([0, 30, 0])
    sofa(seats=3, style="retro", scale=48);

    // Coffee table at 1:48
    translate([0, -5, 0])
    coffee_table(style="retro", scale=48);

    // Armchair at 1:48
    translate([25, 5, 0])
    rotate([0, 0, -30])
    armchair(style="retro", scale=48);
}

// ========================================
// STYLE COMPARISON (at 1:24)
// ========================================
translate([-col_spacing, -row_spacing, 0]) {
    // Retro style
    translate([-40, 0, 0])
    sofa(seats=2, style="retro", color="SteelBlue", scale=24);

    // Modern style
    translate([40, 0, 0])
    sofa(seats=2, style="modern", color="DarkSlateGray", scale=24);
}
