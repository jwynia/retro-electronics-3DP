// Single Corner Foot for Export
// Print bottom-down (default orientation)

$parent_modules = true;

include <../modules/hardware/corner-bracket.scad>

// === PARAMETERS ===
CHAMFER = 1;

corner_foot(
    foot_dia = 20,
    foot_height = 8,
    chamfer = CHAMFER,
    anchor = BOT
);
