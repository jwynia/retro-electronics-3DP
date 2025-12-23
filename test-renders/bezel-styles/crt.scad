include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// True CRT style - outer raised, slopes DOWN to screen
// slope_height=12 for dramatic effect
faceplate_bezel(
    size=[140,95],
    screen_size=[90,55],
    style="crt",
    style_options=[12, 45, 12, 18]  // slope_width, angle, height, scoop_r
);
