include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// L-corner, enclosed style (proud outside)
dowel_connector(
    dowel_size = 12,
    arms = 2,
    angle = 90,
    style = "enclosed",
    socket_depth = 10,
    wall = 2
);
