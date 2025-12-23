include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// Magnetic rail with magnets at both ends
mounting_dowel(
    cross_section = 13,
    length = 60,
    end_faces = ["magnet", "magnet"],
    side_faces = ["none", "glue", "none", "none"]
);
