include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// More dramatic Art Deco - taller steps
faceplate_bezel(
    size=[140,95],
    screen_size=[120,68],
    style="deco",
    style_options=[5, 1.2, 3]  // 5 steps, 1.2mm tall each, 3mm inset
);
