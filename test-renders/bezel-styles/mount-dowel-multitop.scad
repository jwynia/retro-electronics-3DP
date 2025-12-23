include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// Long rail with multiple top magnets
mounting_dowel(
    cross_section = 15,
    length = 100,
    end_faces = ["none", "none"],
    side_faces = ["magnet", "glue", "none", "none"],
    side_count = 3
);
