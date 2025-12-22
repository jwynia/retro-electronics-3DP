// Example 01: Basic Rounded Box
// Demonstrates: cuboid with rounding, anchoring
// This is the simplest possible starting point.

include <BOSL2/std.scad>

// Parameters
width = 100;
height = 80;
depth = 60;
corner_radius = 10;

// Simple rounded box, anchored to bottom (sits on build plate)
cuboid(
    [width, height, depth],
    rounding = corner_radius,
    anchor = BOT
);
