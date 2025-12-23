include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// CRT style round meter bezel
faceplate_meter(
    size = [80, 80],
    meter_dia = 52,
    style = "crt",
    style_options = [10]
);
