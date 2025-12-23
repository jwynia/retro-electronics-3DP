include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Dual VU meters
faceplate_multi(
    size = [160, 80],
    openings = [
        ["meter", [-40, 0], 50],
        ["meter", [40, 0], 50]
    ],
    style = "plain"
);
