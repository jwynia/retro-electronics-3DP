include <BOSL2/std.scad>
use <../../modules/faces/bezel.scad>

// True CRT style - outer raised, slopes DOWN to screen (concave/recessed)
faceplate_bezel(size=[140,95], screen_size=[100,60], style="crt");
