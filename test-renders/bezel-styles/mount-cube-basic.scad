include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// Basic magnet mounting cube
mounting_block(
    size = 15,
    faces = ["magnet", "glue", "none", "none", "none", "none"]
);
