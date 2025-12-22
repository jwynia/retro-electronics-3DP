// Example 04: Shell with Screen Cutout
// Demonstrates: Creating an opening in the front face for a display
// Uses traditional difference() for cleaner preview rendering.

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

// Inner dimensions
inner_width = width - wall * 2;
inner_height = height - wall * 2;
inner_corner = max(2, corner_radius - wall);

difference() {
    // Main shell body
    cuboid([width, height, depth], rounding=corner_radius, edges="Z", anchor=BOT);

    // Hollow out the interior - position manually
    translate([0, 0, depth - wall/2])
    cuboid(
        [inner_width, inner_height, depth],
        rounding = inner_corner,
        edges = "Z",
        anchor = TOP
    );

    // Screen opening - cuts through front face
    translate([0, -height/2, depth/2])
    cuboid(
        [screen_width, wall * 3, screen_height],
        anchor = CENTER
    );
}
