// Mounting Block and Dowel Generators
// For prototyping attachment points with magnetic hardware.
// Small structural pieces that can be glued in place with magnets on specific faces.

include <BOSL2/std.scad>

// === CONSTANTS ===
_MOUNT_BLOCK_SIZE = 15;        // Default cube size in mm
_MOUNT_DOWEL_LENGTH = 50;      // Default dowel length
_MOUNT_CROSS_SECTION = 12;     // Default square cross-section
_MOUNT_MAGNET_DIA = 10;        // Standard 10mm disc magnet
_MOUNT_MAGNET_DEPTH = 3;       // Standard 3mm magnet thickness
_MOUNT_TOLERANCE = 0.3;        // Pocket clearance

// === INTERNAL FUNCTIONS ===

/**
 * Maps face index to BOSL2 anchor.
 * Face order: [TOP, BOT, LEFT, RIGHT, FWD, BACK]
 */
function _face_anchor(index) =
    index == 0 ? TOP :
    index == 1 ? BOT :
    index == 2 ? LEFT :
    index == 3 ? RIGHT :
    index == 4 ? FWD :
    index == 5 ? BACK : CENTER;

/**
 * Returns orientation vector for pocket to open outward from face.
 */
function _face_orient(index) =
    index == 0 ? UP :
    index == 1 ? DOWN :
    index == 2 ? LEFT :
    index == 3 ? RIGHT :
    index == 4 ? FWD :
    index == 5 ? BACK : UP;

/**
 * Gets the minimum dimension of a face for size validation.
 * dims = [x, y, z]
 */
function _face_min_dim(dims, face_idx) =
    face_idx <= 1 ? min(dims[0], dims[1]) :  // TOP/BOT use X,Y
    face_idx <= 3 ? min(dims[1], dims[2]) :  // LEFT/RIGHT use Y,Z
    min(dims[0], dims[2]);                    // FWD/BACK use X,Z

// === PUBLIC MODULES ===

/**
 * Creates a mounting cube with configurable hardware on each face.
 * Use for prototyping magnet placement before finalizing designs.
 *
 * Arguments:
 *   size         - cube size (single number for cube, or [x,y,z] for cuboid)
 *   faces        - face configuration array: [TOP, BOT, LEFT, RIGHT, FWD, BACK]
 *                  Each element: "none", "magnet", or "glue"
 *   magnet_dia   - magnet diameter (default: 10)
 *   magnet_depth - magnet pocket depth (default: 3)
 *   tolerance    - pocket clearance (default: 0.3)
 *   anchor       - BOSL2 anchor (default: BOT)
 *   spin         - BOSL2 spin (default: 0)
 *   orient       - BOSL2 orient (default: UP)
 *
 * Face Configuration:
 *   [0] TOP   - top face (Z+)
 *   [1] BOT   - bottom face (Z-)
 *   [2] LEFT  - left face (X-)
 *   [3] RIGHT - right face (X+)
 *   [4] FWD   - front face (Y-)
 *   [5] BACK  - back face (Y+)
 *
 * Default faces: magnet on top, glue on bottom, solid sides
 */
module mounting_block(
    size = _MOUNT_BLOCK_SIZE,
    faces = ["magnet", "glue", "none", "none", "none", "none"],
    magnet_dia = _MOUNT_MAGNET_DIA,
    magnet_depth = _MOUNT_MAGNET_DEPTH,
    tolerance = _MOUNT_TOLERANCE,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    // Normalize size to [x, y, z]
    dims = is_num(size) ? [size, size, size] : size;

    // Minimum size for magnet pocket (wall thickness of 2mm)
    min_size = magnet_dia + tolerance + 2;

    attachable(anchor, spin, orient, size=dims) {
        difference() {
            // Base cube/cuboid
            cuboid(dims, anchor=CENTER);

            // Process each face
            for (i = [0:5]) {
                face_type = faces[i];
                if (face_type == "magnet") {
                    // Validate this face is large enough
                    face_min = _face_min_dim(dims, i);
                    if (face_min >= min_size) {
                        // Calculate pocket depth (don't go more than halfway through)
                        face_thickness = i <= 1 ? dims[2] : (i <= 3 ? dims[0] : dims[1]);
                        effective_depth = min(magnet_depth + tolerance/2, face_thickness/2 - 0.5);

                        // Position and orient pocket for this face
                        _mount_pocket_at_face(i, dims, magnet_dia, effective_depth, tolerance);
                    } else {
                        echo(str("WARNING: Face ", i, " too small for magnet. Min: ", min_size, ", Got: ", face_min));
                    }
                }
                // "glue" and "none" don't modify geometry
            }
        }

        children();
    }
}

/**
 * Creates a square dowel stock with hardware at ends or along length.
 * For creating mounting rails or extended attachment points.
 *
 * Arguments:
 *   cross_section - cross-section size (single number for square, default: 12)
 *   length        - dowel length along X axis (default: 50)
 *   end_faces     - [LEFT, RIGHT] face configuration for ends
 *   side_faces    - [TOP, BOT, FWD, BACK] face configuration
 *   side_count    - number of hardware points per configured side (default: 1)
 *   side_spacing  - spacing between side hardware points (auto-calculated if undef)
 *   magnet_dia    - magnet diameter (default: 10)
 *   magnet_depth  - magnet pocket depth (default: 3)
 *   tolerance     - pocket clearance (default: 0.3)
 *   anchor        - BOSL2 anchor (default: BOT)
 *   spin          - BOSL2 spin (default: 0)
 *   orient        - BOSL2 orient (default: UP)
 *
 * End faces: [0]=LEFT (X-), [1]=RIGHT (X+)
 * Side faces: [0]=TOP (Z+), [1]=BOT (Z-), [2]=FWD (Y-), [3]=BACK (Y+)
 */
module mounting_dowel(
    cross_section = _MOUNT_CROSS_SECTION,
    length = _MOUNT_DOWEL_LENGTH,
    end_faces = ["none", "none"],
    side_faces = ["none", "glue", "none", "none"],
    side_count = 1,
    side_spacing = undef,
    magnet_dia = _MOUNT_MAGNET_DIA,
    magnet_depth = _MOUNT_MAGNET_DEPTH,
    tolerance = _MOUNT_TOLERANCE,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    // Dimensions: length along X, cross_section for Y and Z
    dims = [length, cross_section, cross_section];

    // Minimum size for magnet pocket
    min_size = magnet_dia + tolerance + 2;

    // Calculate spacing for side hardware
    actual_spacing = is_undef(side_spacing)
        ? length / (side_count + 1)
        : side_spacing;

    // X positions for side hardware
    x_positions = [for (i = [1:side_count])
        -length/2 + i * actual_spacing
    ];

    attachable(anchor, spin, orient, size=dims) {
        difference() {
            // Base dowel
            cuboid(dims, anchor=CENTER);

            // End faces (LEFT=0, RIGHT=1 in end_faces array)
            // Map to full face indices: LEFT=2, RIGHT=3
            for (i = [0:1]) {
                face_type = end_faces[i];
                full_idx = i + 2;  // LEFT=2, RIGHT=3
                if (face_type == "magnet") {
                    if (cross_section >= min_size) {
                        effective_depth = min(magnet_depth + tolerance/2, length/2 - 0.5);
                        _mount_pocket_at_face(full_idx, dims, magnet_dia, effective_depth, tolerance);
                    } else {
                        echo(str("WARNING: Cross-section too small for end magnet. Min: ", min_size));
                    }
                }
            }

            // Side faces with multiple positions along length
            // side_faces: [TOP, BOT, FWD, BACK] -> full indices [0, 1, 4, 5]
            side_to_full = [0, 1, 4, 5];
            for (si = [0:3]) {
                face_type = side_faces[si];
                if (face_type == "magnet") {
                    if (cross_section >= min_size) {
                        full_idx = side_to_full[si];
                        effective_depth = min(magnet_depth + tolerance/2, cross_section/2 - 0.5);

                        // Place at each X position
                        for (px = x_positions) {
                            translate([px, 0, 0])
                            _mount_pocket_at_face_centered(full_idx, [0, cross_section, cross_section],
                                                          magnet_dia, effective_depth, tolerance);
                        }
                    } else {
                        echo(str("WARNING: Cross-section too small for side magnet. Min: ", min_size));
                    }
                }
            }
        }

        children();
    }
}

// === INTERNAL MODULES ===

/**
 * Places a magnet pocket at a face, centered on that face.
 */
module _mount_pocket_at_face(face_idx, dims, dia, depth, tolerance) {
    pocket_dia = dia + tolerance;

    if (face_idx == 0) {  // TOP
        translate([0, 0, dims[2]/2 - depth + 0.01])
        cyl(d=pocket_dia, h=depth + 0.01, anchor=BOT, $fn=32);
    } else if (face_idx == 1) {  // BOT
        translate([0, 0, -dims[2]/2 + depth - 0.01])
        cyl(d=pocket_dia, h=depth + 0.01, anchor=TOP, $fn=32);
    } else if (face_idx == 2) {  // LEFT
        translate([-dims[0]/2 + depth - 0.01, 0, 0])
        cyl(d=pocket_dia, h=depth + 0.01, anchor=TOP, orient=LEFT, $fn=32);
    } else if (face_idx == 3) {  // RIGHT
        translate([dims[0]/2 - depth + 0.01, 0, 0])
        cyl(d=pocket_dia, h=depth + 0.01, anchor=TOP, orient=RIGHT, $fn=32);
    } else if (face_idx == 4) {  // FWD
        translate([0, -dims[1]/2 + depth - 0.01, 0])
        cyl(d=pocket_dia, h=depth + 0.01, anchor=TOP, orient=FWD, $fn=32);
    } else if (face_idx == 5) {  // BACK
        translate([0, dims[1]/2 - depth + 0.01, 0])
        cyl(d=pocket_dia, h=depth + 0.01, anchor=TOP, orient=BACK, $fn=32);
    }
}

/**
 * Places a magnet pocket at a face, using provided dims for positioning.
 * Used for dowel side faces where X is already translated.
 */
module _mount_pocket_at_face_centered(face_idx, dims, dia, depth, tolerance) {
    pocket_dia = dia + tolerance;

    if (face_idx == 0) {  // TOP
        translate([0, 0, dims[2]/2 - depth + 0.01])
        cyl(d=pocket_dia, h=depth + 0.01, anchor=BOT, $fn=32);
    } else if (face_idx == 1) {  // BOT
        translate([0, 0, -dims[2]/2 + depth - 0.01])
        cyl(d=pocket_dia, h=depth + 0.01, anchor=TOP, $fn=32);
    } else if (face_idx == 4) {  // FWD
        translate([0, -dims[1]/2 + depth - 0.01, 0])
        cyl(d=pocket_dia, h=depth + 0.01, anchor=TOP, orient=FWD, $fn=32);
    } else if (face_idx == 5) {  // BACK
        translate([0, dims[1]/2 - depth + 0.01, 0])
        cyl(d=pocket_dia, h=depth + 0.01, anchor=TOP, orient=BACK, $fn=32);
    }
}

// === CONVENIENCE MODULES ===

/**
 * Quick magnet block with magnet on top, glue on bottom.
 * The most common configuration for mounting.
 */
module magnet_mount_cube(
    size = 15,
    magnet_dia = _MOUNT_MAGNET_DIA,
    magnet_depth = _MOUNT_MAGNET_DEPTH,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    mounting_block(
        size = size,
        faces = ["magnet", "glue", "none", "none", "none", "none"],
        magnet_dia = magnet_dia,
        magnet_depth = magnet_depth,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) children();
}

/**
 * Magnetic rail with magnets on both ends.
 * For spanning between two magnetic attachment points.
 */
module magnet_rail(
    length = 50,
    cross_section = 12,
    magnet_dia = _MOUNT_MAGNET_DIA,
    magnet_depth = _MOUNT_MAGNET_DEPTH,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    mounting_dowel(
        cross_section = cross_section,
        length = length,
        end_faces = ["magnet", "magnet"],
        side_faces = ["none", "glue", "none", "none"],
        magnet_dia = magnet_dia,
        magnet_depth = magnet_depth,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) children();
}

/**
 * Corner mount block with magnets on two adjacent faces.
 * For mounting in inside corners.
 */
module corner_mount_block(
    size = 18,
    magnet_dia = _MOUNT_MAGNET_DIA,
    magnet_depth = _MOUNT_MAGNET_DEPTH,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    mounting_block(
        size = size,
        faces = ["magnet", "glue", "none", "none", "magnet", "none"],
        magnet_dia = magnet_dia,
        magnet_depth = magnet_depth,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) children();
}

// ============================================================
// CORNER CONNECTORS
// ============================================================

/**
 * Creates a corner connector for joining square dowels.
 *
 * Arguments:
 *   dowel_size    - square cross-section of dowels to connect (default: 12)
 *   arms          - number of connection points: 2, 3, 4, or 6 (default: 2)
 *   angle         - angle between arms in degrees (default: 90)
 *                   For 2 arms: 90=L-corner, 45/135=angled splice
 *                   For 3+ arms: angle between adjacent arms
 *   style         - "enclosed" (wraps dowel, proud outside) or
 *                   "inside" (open-top jig for gluing, flush exterior)
 *   socket_depth  - how deep dowels insert/rest (default: 10)
 *   wall          - wall thickness (default: 2)
 *   channel_depth - for "inside" style: how deep channels are as fraction
 *                   of dowel_size (0.0-1.0, default: 0.6 = 60%)
 *   tolerance     - fit clearance (default: 0.3)
 *   magnet        - add magnet pocket at corner for attachment (default: false)
 *   magnet_dia    - magnet diameter (default: 10)
 *   magnet_depth  - magnet pocket depth (default: 3)
 *   anchor        - BOSL2 anchor (default: CENTER)
 *   spin          - BOSL2 spin (default: 0)
 *   orient        - BOSL2 orient (default: UP)
 *
 * Arm configurations:
 *   2 arms: L-corner or angled splice (in XY plane)
 *   3 arms: T-junction (one arm opposite, two at angle)
 *   4 arms: + cross junction (all in XY plane)
 *   6 arms: 3D corner (arms along +X, -X, +Y, -Y, +Z, -Z)
 *
 * Style notes:
 *   "enclosed" - Dowels insert into sockets from ends. Connector is proud
 *                (larger than dowel stock) on outside of frame.
 *   "inside"   - Open-top jig. Dowels drop in from above for alignment
 *                while gluing. Jig stays flush with frame exterior.
 */
module dowel_connector(
    dowel_size = _MOUNT_CROSS_SECTION,
    arms = 2,
    angle = 90,
    style = "enclosed",
    socket_depth = 10,
    wall = 2,
    channel_depth = 0.6,
    tolerance = _MOUNT_TOLERANCE,
    magnet = false,
    magnet_dia = _MOUNT_MAGNET_DIA,
    magnet_depth = _MOUNT_MAGNET_DEPTH,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    // Socket inner size (what the dowel fits into)
    socket_size = dowel_size + tolerance;

    // Outer size depends on style
    outer_size = style == "enclosed" ? dowel_size + wall * 2 : dowel_size;

    // For inside style, the "socket" is actually a peg that goes into the dowel
    peg_size = style == "inside" ? dowel_size - wall * 2 - tolerance : 0;
    peg_depth = style == "inside" ? socket_depth : 0;

    // Calculate overall bounding box for attachable
    // This is approximate - actual shape depends on arms/angle
    bbox = arms == 6 ?
        [outer_size + socket_depth * 2, outer_size + socket_depth * 2, outer_size + socket_depth * 2] :
        [outer_size + socket_depth * 2, outer_size + socket_depth * 2, outer_size];

    attachable(anchor, spin, orient, size=bbox) {
        if (style == "enclosed") {
            _connector_enclosed(dowel_size, arms, angle, socket_depth, wall, tolerance,
                               magnet, magnet_dia, magnet_depth);
        } else {
            _connector_inside(dowel_size, arms, angle, socket_depth, wall, channel_depth,
                             tolerance, magnet, magnet_dia, magnet_depth);
        }
        children();
    }
}

/**
 * Enclosed style connector - sockets wrap around dowel ends
 */
module _connector_enclosed(dowel_size, arms, angle, socket_depth, wall, tolerance,
                           magnet, magnet_dia, magnet_depth) {
    socket_size = dowel_size + tolerance;
    outer_size = dowel_size + wall * 2;

    difference() {
        union() {
            // Central hub
            cuboid([outer_size, outer_size, outer_size], anchor=CENTER);

            // Arms based on count and angle
            if (arms == 2) {
                // 2-way: L-corner or angled
                // Arm 1: +X direction
                translate([outer_size/2, 0, 0])
                cuboid([socket_depth, outer_size, outer_size], anchor=LEFT);

                // Arm 2: rotated by angle from +X
                rotate([0, 0, angle])
                translate([outer_size/2, 0, 0])
                cuboid([socket_depth, outer_size, outer_size], anchor=LEFT);

            } else if (arms == 3) {
                // 3-way T-junction: +X, -X, +Y
                translate([outer_size/2, 0, 0])
                cuboid([socket_depth, outer_size, outer_size], anchor=LEFT);
                translate([-outer_size/2, 0, 0])
                cuboid([socket_depth, outer_size, outer_size], anchor=RIGHT);
                translate([0, outer_size/2, 0])
                cuboid([outer_size, socket_depth, outer_size], anchor=FWD);

            } else if (arms == 4) {
                // 4-way + junction: +X, -X, +Y, -Y
                translate([outer_size/2, 0, 0])
                cuboid([socket_depth, outer_size, outer_size], anchor=LEFT);
                translate([-outer_size/2, 0, 0])
                cuboid([socket_depth, outer_size, outer_size], anchor=RIGHT);
                translate([0, outer_size/2, 0])
                cuboid([outer_size, socket_depth, outer_size], anchor=FWD);
                translate([0, -outer_size/2, 0])
                cuboid([outer_size, socket_depth, outer_size], anchor=BACK);

            } else if (arms == 6) {
                // 6-way 3D corner: all 6 directions
                translate([outer_size/2, 0, 0])
                cuboid([socket_depth, outer_size, outer_size], anchor=LEFT);
                translate([-outer_size/2, 0, 0])
                cuboid([socket_depth, outer_size, outer_size], anchor=RIGHT);
                translate([0, outer_size/2, 0])
                cuboid([outer_size, socket_depth, outer_size], anchor=FWD);
                translate([0, -outer_size/2, 0])
                cuboid([outer_size, socket_depth, outer_size], anchor=BACK);
                translate([0, 0, outer_size/2])
                cuboid([outer_size, outer_size, socket_depth], anchor=BOT);
                translate([0, 0, -outer_size/2])
                cuboid([outer_size, outer_size, socket_depth], anchor=TOP);
            }
        }

        // Socket cavities (where dowels insert)
        if (arms == 2) {
            // Socket 1: +X
            translate([wall, 0, 0])
            cuboid([socket_depth + outer_size/2, socket_size, socket_size], anchor=LEFT);

            // Socket 2: rotated by angle
            rotate([0, 0, angle])
            translate([wall, 0, 0])
            cuboid([socket_depth + outer_size/2, socket_size, socket_size], anchor=LEFT);

        } else if (arms == 3) {
            translate([wall, 0, 0])
            cuboid([socket_depth + outer_size/2, socket_size, socket_size], anchor=LEFT);
            translate([-wall, 0, 0])
            cuboid([socket_depth + outer_size/2, socket_size, socket_size], anchor=RIGHT);
            translate([0, wall, 0])
            cuboid([socket_size, socket_depth + outer_size/2, socket_size], anchor=FWD);

        } else if (arms == 4) {
            translate([wall, 0, 0])
            cuboid([socket_depth + outer_size/2, socket_size, socket_size], anchor=LEFT);
            translate([-wall, 0, 0])
            cuboid([socket_depth + outer_size/2, socket_size, socket_size], anchor=RIGHT);
            translate([0, wall, 0])
            cuboid([socket_size, socket_depth + outer_size/2, socket_size], anchor=FWD);
            translate([0, -wall, 0])
            cuboid([socket_size, socket_depth + outer_size/2, socket_size], anchor=BACK);

        } else if (arms == 6) {
            translate([wall, 0, 0])
            cuboid([socket_depth + outer_size/2, socket_size, socket_size], anchor=LEFT);
            translate([-wall, 0, 0])
            cuboid([socket_depth + outer_size/2, socket_size, socket_size], anchor=RIGHT);
            translate([0, wall, 0])
            cuboid([socket_size, socket_depth + outer_size/2, socket_size], anchor=FWD);
            translate([0, -wall, 0])
            cuboid([socket_size, socket_depth + outer_size/2, socket_size], anchor=BACK);
            translate([0, 0, wall])
            cuboid([socket_size, socket_size, socket_depth + outer_size/2], anchor=BOT);
            translate([0, 0, -wall])
            cuboid([socket_size, socket_size, socket_depth + outer_size/2], anchor=TOP);
        }

        // Optional magnet pocket at center (accessible from one face)
        if (magnet) {
            translate([0, 0, outer_size/2 - magnet_depth + 0.01])
            cyl(d=magnet_dia + tolerance, h=magnet_depth + 0.01, anchor=BOT, $fn=32);
        }
    }
}

/**
 * Inside/jig style connector - open-top tray for positioning and gluing
 * Dowels drop in from above, jig holds alignment while gluing
 * Stays flush with frame exterior (doesn't protrude beyond dowel stock)
 */
module _connector_inside(dowel_size, arms, angle, socket_depth, wall, channel_depth_ratio,
                         tolerance, magnet, magnet_dia, magnet_depth) {
    // Jig is same outer size as dowel so it's flush
    jig_size = dowel_size;
    // Channel size for dowels to sit in (with tolerance)
    channel_size = dowel_size + tolerance;
    // How deep the channels are (dowels rest on bottom)
    // channel_depth_ratio: 0.0 = flush/no channel, 1.0 = full depth
    actual_channel_depth = dowel_size * channel_depth_ratio;
    // Wall thickness at bottom of jig
    floor_thickness = wall;

    difference() {
        union() {
            // Central block
            cuboid([jig_size, jig_size, jig_size], anchor=CENTER);

            // Extended arms (same height as center, channels cut into them)
            if (arms == 2) {
                // Arm 1: +X
                translate([jig_size/2, 0, 0])
                cuboid([socket_depth, jig_size, jig_size], anchor=LEFT);

                // Arm 2: rotated by angle
                rotate([0, 0, angle])
                translate([jig_size/2, 0, 0])
                cuboid([socket_depth, jig_size, jig_size], anchor=LEFT);

            } else if (arms == 3) {
                translate([jig_size/2, 0, 0])
                cuboid([socket_depth, jig_size, jig_size], anchor=LEFT);
                translate([-jig_size/2, 0, 0])
                cuboid([socket_depth, jig_size, jig_size], anchor=RIGHT);
                translate([0, jig_size/2, 0])
                cuboid([jig_size, socket_depth, jig_size], anchor=FWD);

            } else if (arms == 4) {
                translate([jig_size/2, 0, 0])
                cuboid([socket_depth, jig_size, jig_size], anchor=LEFT);
                translate([-jig_size/2, 0, 0])
                cuboid([socket_depth, jig_size, jig_size], anchor=RIGHT);
                translate([0, jig_size/2, 0])
                cuboid([jig_size, socket_depth, jig_size], anchor=FWD);
                translate([0, -jig_size/2, 0])
                cuboid([jig_size, socket_depth, jig_size], anchor=BACK);

            } else if (arms == 6) {
                // 6-way: X, Y arms same as 4-way, Z arms are vertical posts
                translate([jig_size/2, 0, 0])
                cuboid([socket_depth, jig_size, jig_size], anchor=LEFT);
                translate([-jig_size/2, 0, 0])
                cuboid([socket_depth, jig_size, jig_size], anchor=RIGHT);
                translate([0, jig_size/2, 0])
                cuboid([jig_size, socket_depth, jig_size], anchor=FWD);
                translate([0, -jig_size/2, 0])
                cuboid([jig_size, socket_depth, jig_size], anchor=BACK);
                // Z-axis arms extend up and down
                translate([0, 0, jig_size/2])
                cuboid([jig_size, jig_size, socket_depth], anchor=BOT);
                translate([0, 0, -jig_size/2])
                cuboid([jig_size, jig_size, socket_depth], anchor=TOP);
            }
        }

        // Cut channels from top for dowels to drop into
        if (arms == 2) {
            // Channel 1: +X direction
            translate([0, 0, jig_size/2 - actual_channel_depth + floor_thickness])
            cuboid([socket_depth + jig_size, channel_size, actual_channel_depth + 1], anchor=BOT);

            // Channel 2: rotated by angle
            rotate([0, 0, angle])
            translate([0, 0, jig_size/2 - actual_channel_depth + floor_thickness])
            cuboid([socket_depth + jig_size, channel_size, actual_channel_depth + 1], anchor=BOT);

        } else if (arms == 3) {
            // X-axis channel (full length)
            translate([0, 0, jig_size/2 - actual_channel_depth + floor_thickness])
            cuboid([socket_depth * 2 + jig_size, channel_size, actual_channel_depth + 1], anchor=BOT);
            // Y+ channel
            translate([0, 0, jig_size/2 - actual_channel_depth + floor_thickness])
            cuboid([channel_size, socket_depth + jig_size/2, actual_channel_depth + 1], anchor=BOT);

        } else if (arms == 4) {
            // X-axis channel (full length)
            translate([0, 0, jig_size/2 - actual_channel_depth + floor_thickness])
            cuboid([socket_depth * 2 + jig_size, channel_size, actual_channel_depth + 1], anchor=BOT);
            // Y-axis channel (full length)
            translate([0, 0, jig_size/2 - actual_channel_depth + floor_thickness])
            cuboid([channel_size, socket_depth * 2 + jig_size, actual_channel_depth + 1], anchor=BOT);

        } else if (arms == 6) {
            // X-axis channel
            translate([0, 0, jig_size/2 - actual_channel_depth + floor_thickness])
            cuboid([socket_depth * 2 + jig_size, channel_size, actual_channel_depth + 1], anchor=BOT);
            // Y-axis channel
            translate([0, 0, jig_size/2 - actual_channel_depth + floor_thickness])
            cuboid([channel_size, socket_depth * 2 + jig_size, actual_channel_depth + 1], anchor=BOT);
            // Z-axis channels cut from sides
            translate([jig_size/2 - actual_channel_depth + floor_thickness, 0, 0])
            cuboid([actual_channel_depth + 1, channel_size, socket_depth * 2 + jig_size], anchor=LEFT);
            translate([-jig_size/2 + actual_channel_depth - floor_thickness, 0, 0])
            cuboid([actual_channel_depth + 1, channel_size, socket_depth * 2 + jig_size], anchor=RIGHT);
        }

        // Optional magnet pocket in floor
        if (magnet) {
            translate([0, 0, -jig_size/2 + magnet_depth - 0.01])
            cyl(d=magnet_dia + tolerance, h=magnet_depth + 0.01, anchor=TOP, $fn=32);
        }
    }
}

// === CONNECTOR CONVENIENCE MODULES ===

/**
 * 90-degree L-corner, enclosed style
 */
module corner_L(dowel_size = 12, socket_depth = 10, wall = 2) {
    dowel_connector(dowel_size, arms=2, angle=90, style="enclosed",
                   socket_depth=socket_depth, wall=wall);
}

/**
 * 90-degree L-corner, inside/flush style
 */
module corner_L_inside(dowel_size = 12, socket_depth = 10, wall = 2) {
    dowel_connector(dowel_size, arms=2, angle=90, style="inside",
                   socket_depth=socket_depth, wall=wall);
}

/**
 * T-junction, enclosed style
 */
module corner_T(dowel_size = 12, socket_depth = 10, wall = 2) {
    dowel_connector(dowel_size, arms=3, angle=90, style="enclosed",
                   socket_depth=socket_depth, wall=wall);
}

/**
 * + cross junction, enclosed style
 */
module corner_cross(dowel_size = 12, socket_depth = 10, wall = 2) {
    dowel_connector(dowel_size, arms=4, angle=90, style="enclosed",
                   socket_depth=socket_depth, wall=wall);
}

/**
 * 3D corner (6-way), enclosed style
 */
module corner_3D(dowel_size = 12, socket_depth = 10, wall = 2) {
    dowel_connector(dowel_size, arms=6, style="enclosed",
                   socket_depth=socket_depth, wall=wall);
}

/**
 * 45-degree angled splice, enclosed style
 */
module corner_45(dowel_size = 12, socket_depth = 10, wall = 2) {
    dowel_connector(dowel_size, arms=2, angle=45, style="enclosed",
                   socket_depth=socket_depth, wall=wall);
}

// === TEST / DEMO ===
if ($preview) {
    // Row 1: Various mounting blocks

    // Basic magnet-top cube
    mounting_block(
        size = 15,
        faces = ["magnet", "glue", "none", "none", "none", "none"]
    );

    // Dual-magnet cube (top and front)
    translate([30, 0, 0])
    mounting_block(
        size = 15,
        faces = ["magnet", "glue", "none", "none", "magnet", "none"]
    );

    // All-magnet cube (smaller magnets)
    translate([60, 0, 0])
    mounting_block(
        size = 20,
        faces = ["magnet", "magnet", "magnet", "magnet", "magnet", "magnet"],
        magnet_dia = 8,
        magnet_depth = 2
    );

    // Row 2: Dowels

    // Dowel with end magnets
    translate([0, 40, 0])
    mounting_dowel(
        cross_section = 12,
        length = 60,
        end_faces = ["magnet", "magnet"],
        side_faces = ["none", "glue", "none", "none"]
    );

    // Long rail with multiple top magnets
    translate([0, 70, 0])
    mounting_dowel(
        cross_section = 15,
        length = 100,
        end_faces = ["none", "none"],
        side_faces = ["magnet", "glue", "none", "none"],
        side_count = 3
    );

    // Row 3: Convenience modules

    translate([0, 100, 0])
    magnet_mount_cube(15);

    translate([30, 100, 0])
    corner_mount_block(18);

    translate([60, 100, 0])
    magnet_rail(40, 13);
}
