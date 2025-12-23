include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// Cross junction jig style (open top for gluing)
dowel_connector(
    dowel_size = 12,
    arms = 4,
    style = "inside",
    socket_depth = 10,
    wall = 2
);
