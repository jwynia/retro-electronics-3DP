include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// Rectangular lens holder - plain style (for display covers)
faceplate_lens(
    size = [100, 60],
    lens_size = [70, 35, 3],
    lens_shape = "rect",
    lens_thickness = 2,
    lip = 2,
    retention = "none",
    style = "plain"
);
