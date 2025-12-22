// Example 03: Hollow Shell with Lip
// Demonstrates: diff() for hollowing, creating a rebated lip for face plate
// This is the core pattern for RetroCase shells.

include <BOSL2/std.scad>

// Shell parameters
width = 150;
height = 100;
depth = 80;
wall = 3;
corner_radius = 10;

// Lip parameters (where face plate sits)
lip_depth = 3;       // How deep face plate sits
lip_inset = 1.5;     // Inset from outer edge

// Inner dimensions (auto-calculated)
inner_width = width - wall * 2;
inner_height = height - wall * 2;
inner_corner = max(1, corner_radius - wall);

// Lip dimensions
lip_width = width - lip_inset * 2;
lip_height = height - lip_inset * 2;
lip_corner = corner_radius - lip_inset;

diff()
cuboid([width, height, depth], rounding=corner_radius, anchor=BOT) {
    
    // Main cavity - hollows out the shell
    tag("remove")
    position(TOP)
    cuboid(
        [inner_width, inner_height, depth - wall],
        rounding = inner_corner,
        anchor = TOP
    );
    
    // Lip rebate - where face plate sits flush
    tag("remove")
    position(TOP)
    cuboid(
        [lip_width, lip_height, lip_depth + 0.01],
        rounding = lip_corner,
        edges = "Z",  // Only round vertical edges
        anchor = TOP
    );
}
