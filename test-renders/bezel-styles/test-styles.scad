// Individual bezel style test - change STYLE variable to render each
include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Change this to test each style: "plain", "industrial", "deco", "midcentury", "braun"
STYLE = "industrial";

faceplate_bezel(
    size = [140, 95],
    screen_size = [120, 68],
    thickness = 4,
    corner_r = 10,
    screen_corner_r = 3,
    style = STYLE
);
