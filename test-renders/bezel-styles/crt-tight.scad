include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Tight corners, moderate slope
faceplate_bezel(
    size=[140,95],
    screen_size=[100,65],
    style="crt",
    style_options=[12, 45, 10, 5]  // scoop_radius=5 (sharp corners)
);
