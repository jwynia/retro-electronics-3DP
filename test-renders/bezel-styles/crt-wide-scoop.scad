include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Wide scooped corners
faceplate_bezel(
    size=[140,95],
    screen_size=[90,55],
    style="crt",
    style_options=[12, 45, 10, 30]  // scoop_radius=30 (very rounded)
);
