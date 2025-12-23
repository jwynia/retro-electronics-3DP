include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Screen with LED indicators
faceplate_multi(
    size = [180, 100],
    openings = [
        ["screen", [-20, 0], [100, 60], 3],
        ["led", [60, 25], 5],
        ["led", [60, 0], 5],
        ["led", [60, -25], 5]
    ],
    style = "crt",
    style_options = [8]
);
