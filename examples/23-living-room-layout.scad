// Living Room Layout Demo
// Shows furniture placement on a floor plan grid at 1:24 scale
// This demonstrates the home layout planning use case.

include <BOSL2/std.scad>
include <../modules/furniture/furniture-constants.scad>
include <../modules/furniture/floor-plan.scad>
include <../modules/furniture/living-room.scad>

// ========================================
// ROOM CONFIGURATION
// ========================================

// Room dimensions (real mm)
// 15ft x 12ft living room = 4572mm x 3658mm
ROOM_WIDTH = 4572;
ROOM_DEPTH = 3658;

// Using 1:24 scale (can change to 12 or 48)
LAYOUT_SCALE = 24;

// Scaled room dimensions for positioning
room_w = ROOM_WIDTH / LAYOUT_SCALE;
room_d = ROOM_DEPTH / LAYOUT_SCALE;

// ========================================
// FLOOR PLAN BASE
// ========================================

// Floor grid (1-foot squares)
floor_grid(
    size = [ROOM_WIDTH, ROOM_DEPTH],
    grid_size = 304.8,  // 1 foot in mm
    scale = LAYOUT_SCALE
);

// Room walls with door and window
room_with_openings(
    size = [ROOM_WIDTH, ROOM_DEPTH],
    wall_height = 2400,
    doors = [
        ["front", -ROOM_WIDTH/4, 900]  // Door on front wall, left of center
    ],
    windows = [
        ["back", 0, 1500]  // Large window on back wall, centered
    ],
    scale = LAYOUT_SCALE
);

// ========================================
// FURNITURE PLACEMENT
// ========================================

// 3-seat sofa against back wall, facing forward
// Position: centered, near back wall
translate([0, room_d/2 - 40, 0])
rotate([0, 0, 180])  // Face forward
sofa(seats=3, style="retro", color="SteelBlue", scale=LAYOUT_SCALE);

// Coffee table in front of sofa
translate([0, room_d/4, 0])
coffee_table(style="retro", scale=LAYOUT_SCALE);

// Two armchairs flanking the coffee table
// Left armchair, angled toward center
translate([-room_w/3, room_d/6, 0])
rotate([0, 0, 30])
armchair(style="retro", color="DarkOliveGreen", scale=LAYOUT_SCALE);

// Right armchair, angled toward center
translate([room_w/3, room_d/6, 0])
rotate([0, 0, -30])
armchair(style="retro", color="DarkOliveGreen", scale=LAYOUT_SCALE);

// End tables next to each armchair
translate([-room_w/3 - 30, room_d/6 + 20, 0])
end_table(style="retro", scale=LAYOUT_SCALE);

translate([room_w/3 + 30, room_d/6 + 20, 0])
end_table(style="retro", scale=LAYOUT_SCALE);

// Bookcase on left wall
translate([-room_w/2 + 20, 0, 0])
rotate([0, 0, 90])
bookcase(units_wide=3, units_tall=5, style="retro", scale=LAYOUT_SCALE);

// TV stand on front wall (opposite sofa)
translate([room_w/4, -room_d/2 + 25, 0])
tv_stand(style="retro", cabinets=2, scale=LAYOUT_SCALE);

// ========================================
// NOTES
// ========================================
// This layout demonstrates:
// - Conversation grouping (sofa + chairs around coffee table)
// - Traffic flow (clear path from door)
// - Focal points (TV, window view)
// - Wall utilization (bookcase, TV stand)
//
// To experiment with the layout:
// - Change furniture positions by modifying translate() values
// - Swap furniture pieces (e.g., 2-seat sofa instead of 3-seat)
// - Try different styles ("modern" vs "retro")
// - Adjust LAYOUT_SCALE to see at different sizes
