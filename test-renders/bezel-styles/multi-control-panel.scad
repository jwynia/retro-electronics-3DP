include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Control panel with slots and LEDs
faceplate_multi(
    size = [150, 80],
    openings = [
        ["slot", [-40, 0], [30, 10], 2],
        ["slot", [0, 0], [30, 10], 2],
        ["slot", [40, 0], [30, 10], 2],
        ["led", [-40, 25], 5],
        ["led", [0, 25], 5],
        ["led", [40, 25], 5]
    ],
    style = "plain"
);
