include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Round lens holder with snap clips
faceplate_lens(
    size = [60, 60],
    lens_size = 30,
    lens_shape = "round",
    lens_thickness = 3,
    lip = 2,
    retention = "clips",
    clip_count = 4,
    style = "plain"
);
