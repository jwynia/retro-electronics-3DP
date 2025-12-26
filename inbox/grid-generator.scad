include <BOSL2/std.scad>;
include <BOSL2/rounding.scad>;

/**
 * Grid Generator
 *      
 * Author: Jason Koolman  
 * Version: 1.0  
 *
 * Description:
 * This OpenSCAD script generates a variety of fully parametric  
 * grid-based patterns. Supports various shapes, layouts, and  
 * interaction modes (union, subtraction, intersection).
 *
 * License:
 * This script is shared under the Standard Digital File License (SDFL).
 */
 
/* [▦ Grid] */

// Defines how the pattern interacts with the base
Mode = "subtract"; // [subtract: Subtract, union: Union, intersect: Intersect]

// Number of rows
Rows = 4;

// Number of columns
Columns = 4;

// Allow pattern shapes to extend beyond the base edges
Overlap = true;
 
/* [🧱 Base] */

// Base shape of the grid
Base = "rect"; // [rect: Rectangle, ellipse: Ellipse, hexagon: Hexagon]

// Dimensions of the base as [width, length]
Base_Size = [40, 40];

// Thickness of the base structure
Base_Thickness = 4;

// Corner rounding factor
Base_Rounding = 0; // [0:0.05:1] 
    
/* [▩ Pattern] */

// Type of shape used in the grid pattern
Pattern = "ellipse"; // [rect: Rectangle, ellipse: Ellipse, octagon: Octagon, hexagon: Hexagon, pentagon: Pentagon, triangle: Triangle]

// Dimensions of each pattern shape as [width, length]
Pattern_Size = [5, 5];

// Thickness of the pattern shape
Pattern_Thickness = 6;

// Distance between pattern shapes as [x, y]
Pattern_Spacing = [4, 4];

// Staggered placement for alternating pattern alignment
Pattern_Stagger = false;

// Raises the pattern above the base
Pattern_Elevate = 0; // [0:0.01:1]

// Rotates each pattern shape by a given angle
Pattern_Rotate = 0; // [0:1:180]

// Rounding applied to pattern shapes
Pattern_Rounding = 0; // [0:0.05:1]

/* [🖼️ Frame] */

// Outer frame thickness (additional border)
Frame = 0;

// Thickness of the frame
Frame_Thickness = 4;

/* [Hidden] */

Base_Width = Base_Size.x;
Base_Length = Base_Size.y;

$fa = 2;
$fs = 0.2;

// Render
grid();

function base_shape(
    name = Base,
    size = Base_Size,
    rounding = Base_Rounding,
    inset = [0, 0]
) =
    let (
        w = size.x - inset.x,
        l = size.y - inset.y,
        rounding = (min(w, l) * rounding) / 2,
        shape = name == "ellipse"
            ? ellipse(d = [w, l])
            : name == "hexagon"
            ? round_corners(ellipse(d = [w, l], $fn = 6), r = rounding / 1.5)
            : rect([w, l], rounding = rounding) // rect as default case
    ) shape;
    
function pointlist_size(points) =
    let (
        bounds = pointlist_bounds(points),
        size = bounds[1] - bounds[0]
    ) [
        round_number(size.x),
        round_number(size.y)
    ];
    
function pattern_shape(name = Pattern, size = Pattern_Size, rounding = Pattern_Rounding, spin = 0, realign = false) =
    let (rounding = (min(size.x, size.y) * rounding) / 2)
    name == "ellipse"
    ? ellipse(d = size)
    : name == "octagon"
    ? round_corners(ellipse(d = size, $fn = 8, circum = true, spin = spin + (realign ? 22.5 : 0)), r = rounding / 2)
    : name == "hexagon"
    ? round_corners(ellipse(d = size, $fn = 6, spin = 0), r = rounding / 2)
    : name == "pentagon"
    ? round_corners(ellipse(d = size, $fn = 5, spin = spin + (realign ? -18 : 0)), r = rounding / 2)
    : name == "triangle"
    ? round_corners(ellipse(d = size, $fn = 3, spin = spin + (realign ? 0 : 0)), r = rounding / 3)
    : name == "star"
    ? round_corners(star(d = size.x), r = rounding / 2)
    : rect(size, rounding = rounding); // rect as default case
    
function round_number(num, decimals = 1) =
    round(num * pow(10, decimals)) / pow(10, decimals);
    
module grid(
    mode = Mode,
    pattern = Pattern,
    size = Pattern_Size,
    spacing = Pattern_Spacing,
    stagger = Pattern_Stagger,
    rounding = Pattern_Rounding,
    spin = Pattern_Rotate,
) {
    bshape = base_shape();
    bshape_height = Base_Thickness;
    
    pshape = pattern_shape(realign = true);
    pshape_height = Pattern_Thickness;
    pshape_size = pointlist_size(pattern_shape(realign = true));
    
    inside = Overlap ? undef : base_shape(inset = pshape_size);
    
    shapes = grid_copies(
        p = zrot(spin, pshape),
        n = [Columns, Rows],
        spacing = pshape_size + spacing,
        stagger = stagger,
        inside = inside,
    );
    
    module base() {
        linear_extrude(height = bshape_height)
            region(bshape);
    }
    
    module pattern() {
        up(bshape_height * Pattern_Elevate)
            linear_extrude(height = pshape_height)
                region(shapes);
    }

    // Base
    if(mode == "subtract") { 
        difference() {
            base();
            pattern();
        }
    } else if (mode == "union") {
        union() {
            base();
            pattern();
        }
    } else if (mode == "intersect") {
        intersection() {
            base();
            pattern();
        }
    }
    
    // Frame
    if (Frame > 0) {
        linear_extrude(Frame_Thickness) {
            shell2d(Frame) region(bshape);
        }
    }
}
