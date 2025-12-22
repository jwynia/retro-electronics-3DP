// Example 09: Grille Faceplate Patterns
// Demonstrates: All 7 grille patterns available in faceplate_grille()
// Patterns: perf, slots, vslots, hex, circles, diamond, sunburst

include <../modules/faces/grille.scad>

// Common size for all panels
panel_size = [100, 80];
panel_thickness = 4;

// Layout spacing
x_spacing = 120;
y_spacing = 100;

// Row 1: Grid-based patterns
// ===========================

// Circular perforations
translate([-x_spacing, y_spacing, 0])
faceplate_grille(
    size = panel_size,
    thickness = panel_thickness,
    pattern = "perf",
    hole_dia = 4,
    spacing = 6
);

// Horizontal slots
translate([0, y_spacing, 0])
faceplate_grille(
    size = panel_size,
    thickness = panel_thickness,
    pattern = "slots",
    slot_width = 60,
    slot_height = 2,
    spacing = 5
);

// Hexagonal honeycomb
translate([x_spacing, y_spacing, 0])
faceplate_grille(
    size = panel_size,
    thickness = panel_thickness,
    pattern = "hex",
    cell_size = 8,
    hex_wall = 1.5
);

// Row 2: More patterns
// ====================

// Vertical slots (Braun style)
translate([-x_spacing, 0, 0])
faceplate_grille(
    size = panel_size,
    thickness = panel_thickness,
    pattern = "vslots",
    slot_width = 50,
    slot_height = 2,
    spacing = 5
);

// Concentric circles
translate([0, 0, 0])
faceplate_grille(
    size = panel_size,
    thickness = panel_thickness,
    pattern = "circles",
    ring_count = 6,
    ring_width = 2,
    ring_gap = 4
);

// Diamond grid (45 deg)
translate([x_spacing, 0, 0])
faceplate_grille(
    size = panel_size,
    thickness = panel_thickness,
    pattern = "diamond",
    hole_dia = 5,
    spacing = 10
);

// Row 3: Radial pattern
// =====================

// Sunburst
translate([0, -y_spacing, 0])
faceplate_grille(
    size = panel_size,
    thickness = panel_thickness,
    pattern = "sunburst",
    ray_count = 16,
    ray_width = 3,
    center_dia = 12
);
