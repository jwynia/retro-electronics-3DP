// Example 11: Mounting Blocks and Dowels
// Demonstrates: Parametric mounting hardware for prototyping attachment points
//
// These small structural pieces can be glued in place with magnets on specific
// faces, useful for prototyping where attachment points should go before
// incorporating them into final models.

include <BOSL2/std.scad>
use <../modules/hardware/mounting-blocks.scad>

// === Example 1: Basic magnet mounting cube ===
// Magnet on top for attachment, glue surface on bottom
mounting_block(
    size = 15,
    faces = ["magnet", "glue", "none", "none", "none", "none"]
);

// === Example 2: Corner mount (two adjacent faces) ===
// Magnets on top and front, for inside-corner mounting
translate([40, 0, 0])
mounting_block(
    size = 18,
    faces = ["magnet", "glue", "none", "none", "magnet", "none"]
);

// === Example 3: Rectangular mounting block ===
// Non-cube proportions, magnet on largest face
translate([80, 0, 0])
mounting_block(
    size = [25, 20, 12],
    faces = ["magnet", "glue", "none", "none", "none", "none"]
);

// === Example 4: Magnetic rail with end magnets ===
// For spanning between two points
translate([0, 50, 0])
mounting_dowel(
    cross_section = 13,
    length = 80,
    end_faces = ["magnet", "magnet"],
    side_faces = ["none", "glue", "none", "none"]
);

// === Example 5: Long rail with multiple top magnets ===
// For attachment along length
translate([0, 80, 0])
mounting_dowel(
    cross_section = 15,
    length = 120,
    end_faces = ["none", "none"],
    side_faces = ["magnet", "glue", "none", "none"],
    side_count = 4
);

// === Example 6: All-magnet cube (for testing) ===
// Magnets on all 6 faces - uses smaller magnets
translate([130, 0, 0])
mounting_block(
    size = 20,
    faces = ["magnet", "magnet", "magnet", "magnet", "magnet", "magnet"],
    magnet_dia = 8,
    magnet_depth = 2
);

// === Example 7: Convenience modules ===
translate([0, 110, 0])
magnet_mount_cube(15);

translate([40, 110, 0])
corner_mount_block(18);

translate([80, 110, 0])
magnet_rail(50, 13);
