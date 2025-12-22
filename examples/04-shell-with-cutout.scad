// Example 04: Shell with Screen Cutout
// Demonstrates: Creating an opening in the front face for a display
// Combines hollow shell with a front opening.

include <BOSL2/std.scad>

// Shell parameters
width = 180;
height = 120;
depth = 60;
wall = 3;
corner_radius = 12;

// Screen opening parameters
screen_width = 140;
screen_height = 80;
screen_corner_radius = 5;
screen_inset_x = (width - screen_width) / 2;
screen_inset_y = (height - screen_height) / 2;

// Inner dimensions
inner_width = width - wall * 2;
inner_height = height - wall * 2;
inner_corner = max(2, corner_radius - wall);

diff()
// Main shell body
cuboid([width, height, depth], rounding=corner_radius, anchor=BOT) {
    
    // Hollow out the interior
    tag("remove")
    position(TOP)
    cuboid(
        [inner_width, inner_height, depth - wall],
        rounding = inner_corner,
        anchor = TOP
    );
    
    // Screen opening - cuts through front face
    // We position at FRONT face and cut through
    tag("remove")
    position(FWD)  // Front face
    cuboid(
        [screen_width, wall + 1, screen_height],  // Slightly deeper than wall
        rounding = screen_corner_radius,
        edges = "Y",  // Only round edges parallel to Y (the horizontal ones on front face)
        anchor = FWD  // Anchor to back of cutout so it extends through front
    );
}
