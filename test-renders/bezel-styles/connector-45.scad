include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// 45-degree angled splice
dowel_connector(
    dowel_size = 12,
    arms = 2,
    angle = 45,
    style = "enclosed",
    socket_depth = 10,
    wall = 2
);
