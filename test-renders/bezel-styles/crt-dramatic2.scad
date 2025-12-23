include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// More dramatic CRT with taller slope
faceplate_bezel(
    size=[140,95],
    screen_size=[80,50],  // smaller screen = more bezel area
    style="crt",
    style_options=[12, 45, 12, 20, false]  // slope_height=12 (much taller)
);
