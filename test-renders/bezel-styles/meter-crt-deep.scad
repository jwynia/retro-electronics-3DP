include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Deep CRT meter bezel
faceplate_meter(
    size = [90, 90],
    meter_dia = 52,
    style = "crt",
    style_options = [15]  // deeper slope
);
