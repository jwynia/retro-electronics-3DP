include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Shallow/subtle CRT slope
faceplate_bezel(
    size=[140,95],
    screen_size=[100,65],
    style="crt",
    style_options=[12, 45, 5, 8]  // slope_height=5 (subtle)
);
