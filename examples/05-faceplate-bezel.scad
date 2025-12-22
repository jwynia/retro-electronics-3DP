// Example 05: Face Plate with Screen Bezel
// Demonstrates: Creating a face plate that fits into a shell's lip
// Includes screen opening and mounting pockets for steel discs.

include <BOSL2/std.scad>

// Face plate outer dimensions (should match shell's lip opening)
plate_width = 147;    // lip_width from shell
plate_height = 97;    // lip_height from shell
plate_thickness = 3;
plate_corner_radius = 8.5;  // lip_corner from shell

// Screen opening
screen_width = 120;
screen_height = 68;
screen_corner_radius = 3;
screen_depth = 8;     // How deep screen sits behind face
screen_lip = 1.5;     // Lip that holds screen in place

// Steel pocket for magnetic attachment (4 corners)
steel_dia = 10;
steel_depth = 1;
pocket_inset = 12;    // Distance from corner to pocket center

// Calculate pocket positions
pocket_x = plate_width/2 - pocket_inset;
pocket_y = plate_height/2 - pocket_inset;

diff()
// Main face plate
cuboid([plate_width, plate_height, plate_thickness], 
       rounding=plate_corner_radius, 
       edges="Z",  // Only round vertical edges
       anchor=BOT) {
    
    // Screen viewing opening (goes all the way through)
    tag("remove")
    position(TOP)
    cuboid(
        [screen_width - screen_lip*2, screen_height - screen_lip*2, plate_thickness + 1],
        rounding = screen_corner_radius,
        edges = "Z",
        anchor = TOP
    );
    
    // Screen mounting pocket (larger, doesn't go through)
    tag("remove")
    position(BOT)
    cuboid(
        [screen_width, screen_height, screen_depth],
        rounding = screen_corner_radius + 1,
        edges = "Z",
        anchor = BOT
    );
    
    // Steel disc pockets (4 corners, on back of plate)
    tag("remove")
    position(BOT)
    for (x = [-1, 1], y = [-1, 1]) {
        translate([x * pocket_x, y * pocket_y, 0])
        cyl(d=steel_dia, h=steel_depth, anchor=BOT);
    }
}
