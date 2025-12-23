include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Round lens holder - raised ring style
faceplate_lens(
    size = [60, 60],
    lens_size = 30,
    lens_shape = "round",
    lens_thickness = 3,
    lip = 2,
    retention = "none",
    style = "raised_ring",
    style_options = [2, 4]
);
