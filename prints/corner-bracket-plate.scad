// Print Plate Layout for Corner Brackets
// Arranges bracket and feet flat for FDM printing

$parent_modules = true;

include <../modules/hardware/corner-bracket.scad>

// === PRINT PARAMETERS ===
// Adjust these to match your case

PLY = PLY_3_8;           // Plywood thickness
WALL = 3;                // Bracket wall thickness
CASE_HEIGHT = 152;       // Interior case height
CHAMFER = 1;             // Chamfer size
TOLERANCE = 0.2;         // Plywood fit clearance

// Layout spacing
SPACING = 10;

// === DERIVED VALUES ===
arm_width = WALL + (PLY + TOLERANCE) * 2 + WALL;
floor_size = arm_width - WALL;

// === BRACKET ===
// Print upside down (top edge on bed) for best surface quality on visible top
module print_bracket() {
    // Flip so top chamfer edge is on print bed
    rotate([180, 0, 0])
    corner_bracket(
        case_height = CASE_HEIGHT,
        ply_thickness = PLY,
        wall = WALL,
        tolerance = TOLERANCE,
        screw_holes = true,
        chamfer = CHAMFER,
        foot_hole = true,
        anchor = TOP  // Anchor at top so rotation puts it on bed
    );
}

// === FOOT ===
// Print right-side up (bottom on bed)
module print_foot() {
    corner_foot(
        foot_dia = 20,
        foot_height = 8,
        chamfer = CHAMFER,
        anchor = BOT
    );
}

// === PLATE LAYOUT ===
// One bracket + one foot for testing, or generate multiples

// Single bracket
translate([0, 0, 0])
color("teal")
print_bracket();

// Single foot next to bracket
translate([arm_width + SPACING, floor_size/2 + SPACING, 0])
color("gray")
print_foot();

// === FULL SET (4 brackets + 4 feet) ===
// Uncomment below for complete case set

/*
for (i = [0:3]) {
    translate([i * (arm_width + SPACING), 0, 0])
    color("teal")
    print_bracket();

    translate([i * (arm_width + SPACING), -30, 0])
    color("gray")
    print_foot();
}
*/
