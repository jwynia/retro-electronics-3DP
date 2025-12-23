include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Convex version - slopes UP toward screen (the previous behavior)
faceplate_bezel(
    size=[140,95],
    screen_size=[90,55],
    style="crt",
    style_options=[15, 45, 8, 15, true]  // convex=true for raised inner frame
);
