include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// T-junction, enclosed style
dowel_connector(
    dowel_size = 12,
    arms = 3,
    style = "enclosed",
    socket_depth = 10,
    wall = 2
);
