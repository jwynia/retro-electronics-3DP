include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Plain round meter bezel
faceplate_meter(
    size = [80, 80],
    meter_dia = 52,
    style = "plain"
);
