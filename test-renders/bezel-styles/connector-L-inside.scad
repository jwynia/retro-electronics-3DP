include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// L-corner, inside style (flush, pegs insert into dowels)
dowel_connector(
    dowel_size = 12,
    arms = 2,
    angle = 90,
    style = "inside",
    socket_depth = 10,
    wall = 2
);
