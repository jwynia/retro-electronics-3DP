// Example 02: Wedge Shell
// Demonstrates: prismoid for tapered shape, rounding vertical edges
// Creates a classic retro "raked" enclosure shape.

include <BOSL2/std.scad>

// Parameters
width = 150;
height = 100;
depth = 80;
taper = 0.75;          // Top is 75% of bottom size
corner_radius = 12;

// Wedge shape using prismoid
// Note: prismoid only rounds VERTICAL edges
prismoid(
    size1 = [width, height],           // Bottom dimensions
    size2 = [width * taper, height * taper],  // Top dimensions  
    h = depth,
    rounding = corner_radius,
    anchor = BOT
);
