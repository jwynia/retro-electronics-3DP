include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Small indicator meter
faceplate_meter(
    size = [50, 50],
    corner_r = 6,
    meter_dia = 30,
    style = "crt",
    style_options = [6]
);
