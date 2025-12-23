include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// Corner mount with magnets on top + front
mounting_block(
    size = 18,
    faces = ["magnet", "glue", "none", "none", "magnet", "none"]
);
