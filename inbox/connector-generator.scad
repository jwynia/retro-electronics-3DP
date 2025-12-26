
include <BOSL2/std.scad>;

/**
 * Connector Generator
 *      
 * Author: Jason Koolman  
 * Version: 1.1
 *
 * Description:
 * This OpenSCAD script generates a variety of fully parametric connectors 
 * that can be used for modular assembly systems. It supports multiple 
 * arm shapes, customizable hub configurations, and internal cutouts for 
 * tube-like structures. This makes it ideal for applications such as 
 * garden hose fittings, toy construction kits, and custom mechanical 
 * connectors.
 *
 * License:
 * This script is shared under the Standard Digital File License (SDFL).
 *
 * Changelog:
 * [v1.1]:
 * - Added support for variable arm widths.
 */
 
/* [⚙️ General] */

// Shape of the connector arms.
Arm_Shape = "round"; // [round: Round, square: Square, octagon: Octagon]

// Number of arms extending from the central hub.
Arm_Count = 2; // [2:1:6]
 
// Inner size of the arm (hole diameter or width).
Arm_Size = 10;

// Length of each arm extending from the hub.
Arm_Length = 20;

// Wall thickness of the arms.
Arm_Wall = 2.0;

/* [🔧 Advanced] */

// Shape of the central hub.
Hub_Shape = "auto"; // [auto: Auto, square: Square]

// Shape of the internal hole.
Hole_Shape = "auto"; // [auto: Auto, round: Round, square: Square, octagon: Octagon, hexagon: Hexagon]

// Extra clearance added to the hole size.
Hole_Clearance = 0.0;

// Default arm orientation.
Arm_Orientation = "v"; // [v: Start upright, h: Start flat]

// X Rotation of each arm (comma-separated).
Arm_X_Angles = "0";

// Y Rotation of each arm (comma-separated).
Arm_Y_Angles = "0";

// Variable size of each arm (comma-separated).
Arm_Sizes = "0";

/* [📐 Support] */

// Whether to add supports between arms.
Support_Enabled = false;

// Taper ratio (coverage area).
Support_Taper = 0.5; // [0:0.05:1]

// Support thickness.
Support_Thickness = 2;

/* [📌 Pin] */

// Length of the pin.
Pin_Length = 40;

// Chamfer of the pin ends.
Pin_Chamfer = 1;

/* [📷 Render] */

// The model to display.
Display = "connector"; // [connector: Connector, pin: Pin]

// Mirror the model.
Mirror = "none"; // [none: No mirroring, x: Mirror across X-axis, y: Mirror across Y-axis]

// Color of the model.
Color = "#e2dede"; // color

/* [Hidden] */

$fa = 2;
$fs = 0.3;

_Hub_Shape = Hub_Shape == "auto" ? Arm_Shape : Hub_Shape;

_Hole_Shape = Hole_Shape == "auto" ? Arm_Shape : Hole_Shape;

_Arm_Length = max(0, Arm_Length);
_Arm_Wall = max(0.4, Arm_Wall);
_Arm_VStart = Arm_Orientation == "v";
_Arm_Sizes_Disabled = (Arm_Sizes == "0" || Arm_Sizes == "") && (Arm_Sizes == "0" || Arm_Sizes == "");
_Arm_Sizes = str_split(Arm_Sizes, ",");

_Inner_Size = Arm_Size;
_Outer_Size = Arm_Size + _Arm_Wall * 2;

_Angles_Disabled = (Arm_X_Angles == "0" || Arm_X_Angles == "") && (Arm_Y_Angles == "0" || Arm_Y_Angles == "");
_XAngles = str_split(Arm_X_Angles, ",");
_YAngles = str_split(Arm_Y_Angles, ",");

_XMirror = Mirror == "x" ? 1 : 0;
_YMirror = Mirror == "y" ? 1 : 0;

_VPositions = [
    [],
    [TOP, FRONT],
    [TOP, FRONT, RIGHT],
    [TOP, FRONT, RIGHT, BACK],
    [TOP, FRONT, RIGHT, BACK, LEFT],
    [TOP, FRONT, RIGHT, BACK, LEFT, DOWN],
];

_VSidePositions = [
    [],
    [BACK],
    [BACK, RIGHT],
    [BACK, RIGHT],
    [BACK, RIGHT, LEFT],
    [BACK, RIGHT, LEFT, FRONT],
];

_HPositions = [
    [],
    [BACK, FRONT],
    [BACK, FRONT, RIGHT],
    [BACK, FRONT, RIGHT, LEFT],
    [BACK, FRONT, RIGHT, LEFT, TOP],
    [BACK, FRONT, RIGHT, LEFT, TOP, DOWN],
];

_HSidePositions = [
    [],
    [],
    [LEFT, RIGHT],
    [LEFT, RIGHT],
    [LEFT, RIGHT, BACK, FRONT],
    [LEFT, RIGHT, BACK, FRONT],
];

// Render

mirror([_XMirror, _YMirror])
recolor(Color) {
    if (Display == "pin") {
        pin();
    } else {
        connector();
    }
}

/**
 * Generates a connector.
 */
module connector() {
    positions = _Arm_VStart ? _VPositions[Arm_Count - 1] : _HPositions[Arm_Count - 1];

    hub() {
        attach(positions, UP) {
            angle = [_XAngles[$idx], _YAngles[$idx]];
            isize = _Arm_Sizes_Disabled
                ? Arm_Size
                : parse_int(str_strip(select(_Arm_Sizes, $idx), " "));
            osize = isize + _Arm_Wall * 2;

            down(osize / 2)
            rotate([
                angle.x ? parse_int(str_strip(angle.x, " ")) : 0,
                angle.y ? parse_int(str_strip(angle.y, " ")) : 0
            ]) {
                arm(osize) {
                    if (Support_Enabled && _Angles_Disabled && _Arm_Sizes_Disabled && $idx != 0) {
                        support();
                    }
                }
                tag("remove") hole(isize);                
            }
        }
    }
}

/**
 * Creates the central hub from which arms extend.
 */
module hub() {        
    msize = _Inner_Size + Hole_Clearance * 2;

    diff() {
        if (_Hub_Shape == "round") {
            sphere(d = _Outer_Size) children();
        } else if (_Hub_Shape == "square") {
            cuboid(_Outer_Size) children();
        } else if (_Hub_Shape == "octagon") {
            spheroid(d = _Outer_Size, style = "orig", circum = true, spin = 22.5, $fn = 8) {
                $fn = 0;
                zrot(-22.5) children();
            }
        }
        
        if (_Hole_Shape == "round") {
            tag("remove") sphere(d = msize);
        } else if (_Hole_Shape == "square") {
            tag("remove") cuboid(msize);
        } else if (_Hole_Shape == "octagon") {
            tag("remove") spheroid(d = msize, style = "orig", circum = true, spin = 22.5, $fn = 8);
        }
    }
}

/**
 * Creates a single connector arm extending from the hub.
 */
module arm(size = _Outer_Size) {
    length = _Arm_Length + size / 2;

    if (Arm_Shape == "round") {
        cyl(d = size, l = length) children();
    } else if (Arm_Shape == "square") {
        cube([size, size, length], center = true) children();
    } else if (Arm_Shape == "octagon") {
        od = size * (1 / cos(180 / 8)); // circumscribe
        regular_prism(8, d = od, l = length, realign = true) {
            $fn = 0;
            children();
        }
    }
}

/**
 * Creates a cutout mask for the arm's internal hole.
 */
module hole(size = _Inner_Size) {
    size = size + Hole_Clearance * 2;
    length = (_Arm_Length + _Outer_Size / 2) + 0.1;

    if (_Hole_Shape == "round") {
        cyl(d = size, l = length);
    } else if (_Hole_Shape == "square") {
        cube([size, size, length], center = true);
    } else if (_Hole_Shape == "octagon") {
        cyl(d = size, l = length, circum = true, realign = true, $fn = 8);
    } else if (_Hole_Shape == "hexagon") {
        cyl(d = size, l = length, circum = true, $fn = 6);
    }
}

/**
 * Creates supports for the parent arm.
 */
module support() {
    positions = _Arm_VStart ? _VSidePositions[$idx] : _HSidePositions[$idx];
    size = Support_Taper * _Arm_Length;
    thickness = min(Support_Thickness, _Outer_Size);
    shift = -_Arm_Wall / 4;
    
    attach(positions, RIGHT, align = TOP) {
        fwd(_Outer_Size / 2)
        translate([0, -shift, shift])
        cuboid([size - shift, thickness, size - shift], chamfer = size, edges = [BOTTOM+LEFT]);
    }
}

/**
 * Creates a pin that fits inside the arm’s internal hole.
 */
module pin(l = Pin_Length) {
    size = _Inner_Size;
    chamfer = max(0, min(Pin_Chamfer, size / 2));

    if (_Hole_Shape == "round") {
        cyl(d = size, l = l, chamfer = chamfer, orient = RIGHT);
    } else if (_Hole_Shape == "square") {
        cuboid([size, size, l], edges = [TOP, BOTTOM], chamfer = chamfer, orient = RIGHT);
    } else if (_Hole_Shape == "octagon") {
        cyl(d = size, l = l, chamfer = chamfer, circum = true, spin = 22.5, $fn = 8, orient = RIGHT);
    } else if (_Hole_Shape == "hexagon") {
        cyl(d = size, l = l, chamfer = chamfer, circum = true, realign = true, $fn = 6, orient = RIGHT);
    }
}
