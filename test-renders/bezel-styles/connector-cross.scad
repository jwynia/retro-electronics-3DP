include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// + cross junction, enclosed style
dowel_connector(
    dowel_size = 12,
    arms = 4,
    style = "enclosed",
    socket_depth = 10,
    wall = 2
);
