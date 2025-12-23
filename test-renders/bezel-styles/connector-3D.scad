include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// 3D corner (6-way), enclosed style
dowel_connector(
    dowel_size = 12,
    arms = 6,
    style = "enclosed",
    socket_depth = 10,
    wall = 2
);
