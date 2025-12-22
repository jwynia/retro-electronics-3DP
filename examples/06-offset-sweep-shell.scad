// Example 06: Fully Rounded Shell with offset_sweep
// Demonstrates: Using offset_sweep for rounded top/bottom edges
// This creates smoother, more organic retro shapes.

include <BOSL2/std.scad>

// Shell parameters
width = 150;
height = 100;
depth = 70;
wall = 3;
corner_radius = 15;

// Edge rounding (top and bottom face edges)
edge_radius_bottom = 8;
edge_radius_top = 5;

// Create the 2D profile with rounded corners
outer_profile = rect([width, height], rounding=corner_radius);
inner_profile = rect([width - wall*2, height - wall*2], rounding=max(2, corner_radius - wall));

// Outer shell with fully rounded edges
difference() {
    // Outer body
    offset_sweep(
        outer_profile,
        height = depth,
        bottom = os_circle(r=edge_radius_bottom),
        top = os_circle(r=edge_radius_top),
        steps = 16
    );
    
    // Inner cavity
    up(wall)
    offset_sweep(
        inner_profile,
        height = depth,
        bottom = os_circle(r=-3),  // Negative = fillet inside
        top = os_circle(r=edge_radius_top - 1),
        steps = 16
    );
}
