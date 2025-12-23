include <BOSL2/std.scad>
use <../../modules/hardware/mounting-blocks.scad>

// L-corner jig with deep channels (80%)
dowel_connector(
    dowel_size = 12,
    arms = 2,
    angle = 90,
    style = "inside",
    socket_depth = 10,
    channel_depth = 0.8
);
