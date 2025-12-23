include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Screen with side meter
faceplate_multi(
    size = [200, 100],
    openings = [
        ["screen", [-30, 0], [100, 70], 3],
        ["meter", [60, 0], 45]
    ],
    style = "crt",
    style_options = [10]
);
