// Example 08: Wedge Shell Module
// Demonstrates: shell_wedge() with both taper styles
// The wedge shell creates tapered retro enclosures.

include <../modules/shells/wedge.scad>

// Side-by-side comparison of the two taper styles

// Left: "top" taper style
// - Wider at bottom, narrower at top
// - Opening on vertical front face
// - Good for: control panels, tabletop displays
translate([-80, 0, 0])
shell_wedge(
    size = [120, 80, 60],
    taper = 0.7,
    taper_style = "top",
    wall = 3,
    corner_r = 10,
    opening = [80, 50],
    opening_r = 5
);

// Right: "front" taper style
// - Taller at back, shorter at front
// - Sloped top surface, raked front face
// - Opening on the angled face
// - Good for: flip clocks, desk radios, angled displays
translate([80, 0, 0])
shell_wedge(
    size = [120, 80, 60],
    taper = 0.6,
    taper_style = "front",
    wall = 3,
    corner_r = 10,
    opening = [80, 30],
    opening_r = 5
);
