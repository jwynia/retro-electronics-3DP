// Single Corner Bracket for Export
// Laid flat for support-free FDM printing

$parent_modules = true;

include <../modules/hardware/corner-bracket.scad>

// === PARAMETERS - EDIT THESE FOR YOUR CASE ===
PLY = PLY_3_8;           // Plywood thickness
WALL = 3;                // Bracket wall thickness
CASE_HEIGHT = 152;       // Interior case height
CHAMFER = 1;             // Chamfer size
TOLERANCE = 0.2;         // Plywood fit clearance

// Derived
arm_width = WALL + (PLY + TOLERANCE) * 2 + WALL;
total_height = CASE_HEIGHT + WALL;

// Lay flat - one arm on bed, other arm vertical (no supports needed)
// Position entirely in positive X/Y space for slicer compatibility
translate([arm_width/2, total_height/2, arm_width/2])
rotate([90, 0, 0])
corner_bracket(
    case_height = CASE_HEIGHT,
    ply_thickness = PLY,
    wall = WALL,
    tolerance = TOLERANCE,
    screw_holes = true,
    chamfer = CHAMFER,
    foot_hole = true,
    anchor = CENTER
);
