include <BOSL2/std.scad>;
include <BOSL2/rounding.scad>;
include <BOSL2/screws.scad>;

/**
 * Grille Generator
 *      
 * Author: Jason Koolman  
 * Version: 1.0  
 *
 * Description:
 * This OpenSCAD script generates a variety of fully parametric
 * grilles - vents, covers, caps, exhausts, and drains. Supports
 * slatted vents, mesh patterns, and solid caps with customizable
 * insert, cover, and screw-hole placement for mounting.
 *
 * License:
 * This script is shared under the Standard Digital File License.
 */
 
/* [🪟 Grille] */

// Grille size as [width, length]
Grille_Size = [100, 100];

// Type of grille: vent (slats), mesh (pattern), or solid cap
Grille_Type = "vent"; // [vent: Vent, mesh: Mesh, solid: Solid]

// Depth of the grille
Grille_Depth = 10;

// Rounding of the grille (1 = fully round)
Grille_Rounding = 0.5; // [0:0.01:1]

/* [🪟 Vent] */

// Number of rows (vertical direction)
Slat_Rows = 8;

// Number of columns (horizontal direction)
Slat_Columns = 2;

// Slat thickness on [rows, columns]
Slat_Width = [2, 2];

// Distribution of slats
Slat_Distribution = "between"; // [around: Gaps split at edges, between: Gaps only in between]

// Slat spacing offset on [rows, columns]
Slat_Spacing = [0, 0];

// Tilt slats by angle on rows
Slat_Angle = 0; // [-45:1:45]

/* [🪟 Mesh] */

// Shape type used in the mesh pattern
Mesh_Shape = "ellipse"; // [rect: Rectangle, ellipse: Ellipse, octagon: Octagon, hexagon: Hexagon, pentagon: Pentagon, triangle: Triangle]

// Size of each pattern shape as [width, length]
Mesh_Size = [4, 4];

// Gap between pattern shapes as [x, y]
Mesh_Spacing = [3, 3];

// Staggered placement for alternating rows
Mesh_Stagger = "stagger"; // [none: None, stagger: Staggered, alt: Alternate]

// Offset pattern from edge
Mesh_Offset = 0;

// Rounding for pattern shapes
Mesh_Rounding = 0; // [0:0.05:1]

// Rotate mesh shapes
Mesh_Rotate = 0; // [0:15:180]

/* [🧱 Insert] */

// Wall thickness of the insert
Insert_Wall = 2.0;

// Depth of the insert
Insert_Depth = 20;

// Chamfer size on insert top edge
Insert_Chamfer = 0.0;

/* [🔲 Cover] */

// Width around the grille
Cover_Width = 10;

// Shape of the cover
Cover_Shape = "auto"; // [auto: Auto, rect: Rectangle, hexagon: Hexagon, flower: Flower]

// Thickness of the cover plate
Cover_Depth = 3.0;

// Rounding of the cover shape (if not auto)
Cover_Rounding = 0; // [0:0.01:1]

/* [🪛 Holes] */

// Number of screw holes distributed around the cover
Hole_Count = 0; // [0:2:12]

// Offset holes from edges
Hole_Offset = 0;

// Screw specification (ISO/UTS)
Screw_Spec = "M4"; // [M2, M2.5, M3, M4, M5, M6, M8, M10, #4, #6, #8, #10, #12, 1/4, 5/16, 3/8]

// Screw head type
Screw_Head = "none"; // [none: None, flat: Flat, button: Button, socket: Socket, hex: Hex, pan: Pan, cheese: Cheese]

// Counterbore depth (-1 = auto)
Screw_Counterbore = -1;

// Add screw thread
Screw_Thread = false;

/* [📷 Render] */

// Render resolution (detail level)
Resolution = 2; // [3: High, 2: Medium, 1: Low]

// Color of the model
Color = "#222222"; // color

// Enable preview mode
Preview = false;

// Determine face angle and size based on resolution
Face = (Resolution == 3) ? [2, 0.2]
    : (Resolution == 2) ? [4, 0.4]
    : [6, 0.6];

$fa = Face[0];
$fs = Face[1];

/* [Hidden] */

_Grille_Width  = Grille_Size.x;
_Grille_Length = Grille_Size.y;
_Grille_Depth  = min(Grille_Depth, Insert_Depth);
_Grille_Shape = grille_shape();

_Cover_Shape = Cover_Shape == "auto"
    ? offset(_Grille_Shape, delta=Cover_Width, closed=true)
    : cover_shape();
    
_Mesh_Stagger = Mesh_Stagger == "alt"
    ? "alt"
    : Mesh_Stagger == "stagger"
    ? true
    : false;
    
_Screw_Counterbore = Screw_Head == "none" || Screw_Counterbore == 0
    ? false
    : Screw_Counterbore < 0
    ? true : Screw_Counterbore;

// Render
color(Color) xrot(Preview ? -90 : 0) grille();

module grille() {
    if (Grille_Type == "mesh") {
        mesh();
    } else if (Grille_Type == "solid") {
        cap();
    } else {
        slats();
    }

    insert();

    difference() {
        cover();
        holes();
    }
}

/**
 * Creates a mesh pattern for the grille.
 */
module mesh() {
    spacing = Mesh_Size + Mesh_Spacing + (_Mesh_Stagger == false ? [0,0] : [0, -Mesh_Size.y/2]);
    inside = Mesh_Offset == 0 ? _Grille_Shape : offset(_Grille_Shape, delta = -Mesh_Offset, closed = true);
    pattern = grid_copies(
        p = zrot(Mesh_Rotate, pattern_shape()),
        inside = inside,
        spacing = spacing,
        stagger = _Mesh_Stagger
    );

    difference() {
        linear_extrude(height = _Grille_Depth) {
            polygon(_Grille_Shape);
        }
        if (Grille_Type == "mesh") {
            down(0.01) linear_extrude(height = _Grille_Depth + 0.02) {
                region(pattern);
            }
        }
    }
}

/**
 * Creates a solid cap for the grille.
 */
module cap() {
    linear_extrude(height = _Grille_Depth) {
        polygon(_Grille_Shape);
    }
}

/**
 * Creates slats for the grille.
 */
module slats() {
    iw = _Grille_Width - Insert_Wall*2;
    il = _Grille_Length - Insert_Wall*2;
    wx = Slat_Width[0];
    wy = Slat_Width[1];
    sx = Slat_Spacing[0];
    sy = Slat_Spacing[1];
    
    assert(wy <= iw/Slat_Columns,
           "Slat width too large for column spacing");
    assert(wx <= il/Slat_Rows,
           "Slat width too large for row spacing");

    intersection() {
        union() {
            up(_Grille_Depth/2) {
                // Vertical slats (columns)
                for (x = slat_centers(iw, Slat_Columns, Slat_Distribution, wy, sy))
                    right(x)
                        cube([wy, il, _Grille_Depth*3], anchor=CENTER);

                // Horizontal slats (rows)
                for (y = slat_centers(il, Slat_Rows, Slat_Distribution, wx, sx)) {
                    back(y) xrot(Slat_Angle)
                        cube([iw, wx, _Grille_Depth*3], anchor=CENTER);}
            }
        }

        linear_extrude(height=_Grille_Depth) {
            polygon(_Grille_Shape);
        }
    }
    
}

/**
 * Creates an insert inside of the grille shape.
 */
module insert(
    wall = Insert_Wall,
    depth = Insert_Depth,
    chamfer = min(Insert_Chamfer, Insert_Wall/2),
) {
    if (wall > 0 && depth > 0) {
        path = _Grille_Shape;
        profile = rect(
            [wall, depth],
            chamfer = [chamfer, chamfer, 0, 0],
            anchor = BOTTOM+RIGHT
        );
        
        if (len(path) == 4) {
            path_sweep2d(profile, path, closed = true);
        } else {
            path_sweep(profile, path, closed = true);
        }
    }
}

/**
 * Creates a cover (brim) around the grille shape.
 */
module cover(
    width = Cover_Width,
    depth = Cover_Depth,
    cover_shape = _Cover_Shape,
    grille_shape = _Grille_Shape
) {       
    if (width > 0 && depth > 0) {
        linear_extrude(height = depth) {
            region(
                difference([cover_shape, offset(grille_shape, delta = -0.1, closed=true)])
            );
        }
    }
}

/**
 * Places screw holes around the cover.
 */
module holes() {
    if (Hole_Count > 0) {
        is_rect = Cover_Shape == "auto" || Cover_Shape == "rect";
        
        // Target outline to place holes on
        path = offset(_Cover_Shape, delta = -Cover_Width/2 - Hole_Offset, closed=true);

        pts = is_rect ?
            project_rect_path(path, n=Hole_Count)
            : resample_path(path, n=Hole_Count);
        
        down(0.01)
        move_copies(pts) {
            screw_hole(Screw_Spec, 
                length = Cover_Depth + 0.02, 
                thread = Screw_Thread,
                head = Screw_Head,
                counterbore = _Screw_Counterbore,
                $slop = Screw_Thread ? 0.1 : 0,
                anchor = TOP,
                orient = DOWN
            );
        }
    }
}

/**
 * Projects evenly spaced points around a (rounded) rectangular path.
 * This ensures corners are included when placing holes.
 */
function project_rect_path(path, n) =
    let (
        // Sample a plain bbox (no rounding) with corner lock
        path_bounds = pointlist_bounds(path),
        bbox_path = rect(path_bounds[1] - path_bounds[0], anchor=CENTER),
        pts_seed = resample_path(bbox_path, n=n, keep_corners=n>2 ? 90 : undef)
    )
    // Project each seed point to the real path
    [ for (p = pts_seed) path_closest_point(path, p)[1] ];


/**
 * Returns a 2D shape for the grille base.
 */
function grille_shape(
    size = Grille_Size,
    rounding = Grille_Rounding,
) =
    let (rr = (min(size.x, size.y) * rounding) / 2)
    rect([size.x, size.y], rounding = rr);

/**
 * Returns a 2D shape for the cover brim.
 */
function cover_shape(
    name = Cover_Shape,
    w = _Grille_Width + Cover_Width * 2,
    l = _Grille_Length + Cover_Width * 2,
    rounding = Cover_Shape == "auto" ? Grille_Rounding : Cover_Rounding
) =
    let (
        max_size = max(w, l),
        rr = (min(w, l) * rounding) / 2,
        shape = name == "hexagon"
            ? hexagon(id = max_size, rounding = rr)
            : name == "flower"
            ? flower(max_size, rounding)
            : rect([w, l], rounding = rr) // rect as default case
    ) path_merge_collinear(shape);

/**
 * Returns a flower-shaped polygon.
 * 
 * Scaled to `size` where:
 * - `petals` is the frequency of the sinus bump.
 * - `phase_deg` rotates the flower so a petal lands where you like.
 */
function flower(size, rounding, petals=6, phase_deg=15) =
    let (
        // Amplitude B so that r(theta) = size/2 + B * (1 + sin(petals*theta))
        df = 0.2 + (rounding * 0.2),
        B  = df * (size / 4)
    )
    zrot(-phase_deg,
        [for (theta = lerpn(phase_deg, 360 + phase_deg, 180 + phase_deg, endpoint=false))
            (size/2 + B * (1 + sin(petals * theta))) * [cos(theta), sin(theta)]]
    );

/**
 * Returns a 2D shape for the mesh pattern.
 */
function pattern_shape(name = Mesh_Shape, size = Mesh_Size, rounding = Mesh_Rounding, realign = true) =
    let (rounding = (min(size.x, size.y) * rounding) / 2)
    name == "ellipse"
    ? ellipse(d = size)
    : name == "octagon"
    ? round_corners(ellipse(d = size, $fn = 8, circum = true, spin = realign ? 22.5 : 0), r = rounding / 2)
    : name == "hexagon"
    ? round_corners(ellipse(d = size, $fn = 6), r = rounding / 2)
    : name == "pentagon"
    ? round_corners(ellipse(d = size, $fn = 5, spin = realign ? 18 : 0), r = rounding / 2)
    : name == "triangle"
    ? round_corners(ellipse(d = size, $fn = 3), r = rounding / 3)
    : rect(size, rounding = rounding); // rect as default case

/**
 * Returns an array of center positions for slats along a given length.
 */
function slat_centers(len, cells, mode, w, s=0) =
    (cells <= 0) ? [] :
    (mode == "around") ?
        let(
            pitch0 = len/cells,                 // default center-to-center
            g0     = pitch0 - w,                // default clear gap
            g      = max(0, g0 + s),            // adjusted gap (>=0)
            pitch  = w + g                      // new center-to-center
        )
        // symmetric about 0, keeps equal half-gaps at edges for this pitch
        [ for (k=[0:cells-1]) -((cells-1)*pitch)/2 + k*pitch ] :
    // mode == "between"
        (cells <= 1) ? [] :
        let(
            S   = cells - 1,                    // number of slats
            g0  = (len - S*w)/cells,            // default clear gap
            g   = max(0, g0 + s),               // adjusted clear gap (>=0)
            P   = w + g,                        // center-to-center
            T   = S*w + cells*g,                // total span covered
            x0  = -T/2 + g + w/2                // first slat center
        )
        [ for (i=[0:S-1]) x0 + i*P ];
