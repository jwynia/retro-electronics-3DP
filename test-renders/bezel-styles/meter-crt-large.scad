include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Large VU meter style
faceplate_meter(
    size = [120, 80],
    corner_r = 12,
    meter_dia = 60,
    style = "crt",
    style_options = [12]
);
