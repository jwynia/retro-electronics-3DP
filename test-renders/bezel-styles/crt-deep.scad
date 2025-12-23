include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Deep/dramatic CRT slope
faceplate_bezel(
    size=[140,95],
    screen_size=[80,50],
    style="crt",
    style_options=[12, 45, 18, 20]  // slope_height=18 (dramatic)
);
