// Magnet and Steel Pocket Hardware
// For magnetic attachment between shells and face plates.

include <BOSL2/std.scad>

// Default pocket dimensions
_MAGNET_DIA = 10;       // 10mm disc magnets are common
_MAGNET_DEPTH = 3;      // 3mm thick magnets
_STEEL_DIA = 10;        // Matching steel washers
_STEEL_DEPTH = 1;       // Steel discs are thinner
_POCKET_TOLERANCE = 0.3; // Clearance for press/glue fit

/**
 * Creates a cylindrical pocket for a disc magnet.
 * Use with diff() and tag("remove").
 *
 * Arguments:
 *   dia       - magnet diameter (default: 10)
 *   depth     - magnet thickness (default: 3)
 *   tolerance - extra clearance (default: 0.3)
 *   anchor    - BOSL2 anchor (default: TOP, pocket opens upward)
 */
module magnet_pocket(
    dia = _MAGNET_DIA,
    depth = _MAGNET_DEPTH,
    tolerance = _POCKET_TOLERANCE,
    anchor = TOP
) {
    cyl(
        d = dia + tolerance,
        h = depth + tolerance/2,  // Slight extra depth for glue
        anchor = anchor,
        $fn = 32
    );
}

/**
 * Creates a cylindrical pocket for a steel disc/washer.
 * Shallower than magnet pocket since steel is thinner.
 *
 * Arguments:
 *   dia       - disc diameter (default: 10)
 *   depth     - disc thickness (default: 1)
 *   tolerance - extra clearance (default: 0.3)
 *   anchor    - BOSL2 anchor (default: TOP)
 */
module steel_pocket(
    dia = _STEEL_DIA,
    depth = _STEEL_DEPTH,
    tolerance = _POCKET_TOLERANCE,
    anchor = TOP
) {
    cyl(
        d = dia + tolerance,
        h = depth + tolerance/2,
        anchor = anchor,
        $fn = 32
    );
}

/**
 * Creates a set of magnet pockets at specified positions.
 * Positions are [x, y] coordinates relative to center.
 *
 * Arguments:
 *   positions - list of [x, y] positions
 *   dia       - magnet diameter
 *   depth     - magnet thickness
 */
module magnet_pocket_array(
    positions,
    dia = _MAGNET_DIA,
    depth = _MAGNET_DEPTH,
    tolerance = _POCKET_TOLERANCE
) {
    for (pos = positions) {
        translate([pos[0], pos[1], 0])
        magnet_pocket(dia, depth, tolerance);
    }
}

/**
 * Creates a set of steel pockets at specified positions.
 *
 * Arguments:
 *   positions - list of [x, y] positions
 *   dia       - disc diameter
 *   depth     - disc thickness
 */
module steel_pocket_array(
    positions,
    dia = _STEEL_DIA,
    depth = _STEEL_DEPTH,
    tolerance = _POCKET_TOLERANCE
) {
    for (pos = positions) {
        translate([pos[0], pos[1], 0])
        steel_pocket(dia, depth, tolerance);
    }
}

/**
 * Calculates corner pocket positions for a rectangle.
 * Returns list of [x, y] positions.
 *
 * Arguments:
 *   width    - rectangle width
 *   height   - rectangle height
 *   inset    - distance from corner to pocket center
 */
function corner_pocket_positions(width, height, inset) = [
    [ width/2 - inset,  height/2 - inset],
    [-width/2 + inset,  height/2 - inset],
    [-width/2 + inset, -height/2 + inset],
    [ width/2 - inset, -height/2 + inset]
];

/**
 * Calculates edge midpoint pocket positions for a rectangle.
 * Returns list of [x, y] positions.
 *
 * Arguments:
 *   width    - rectangle width
 *   height   - rectangle height
 *   inset    - distance from edge to pocket center
 */
function edge_pocket_positions(width, height, inset) = [
    [0,  height/2 - inset],  // Top
    [0, -height/2 + inset],  // Bottom
    [ width/2 - inset, 0],   // Right
    [-width/2 + inset, 0]    // Left
];

// === CONVENIENCE MODULES ===

/**
 * Creates 4 corner magnet pockets for a shell.
 * Use inside a diff() block with the shell.
 */
module shell_magnet_pockets(width, height, inset=12, dia=_MAGNET_DIA, depth=_MAGNET_DEPTH) {
    positions = corner_pocket_positions(width, height, inset);
    magnet_pocket_array(positions, dia, depth);
}

/**
 * Creates 4 corner steel pockets for a face plate.
 * Use inside a diff() block with the face plate.
 */
module faceplate_steel_pockets(width, height, inset=12, dia=_STEEL_DIA, depth=_STEEL_DEPTH) {
    positions = corner_pocket_positions(width, height, inset);
    steel_pocket_array(positions, dia, depth);
}

// === TEST / DEMO ===
if ($preview) {
    // Demo: Shell interior with magnet pockets
    translate([0, 0, 0]) {
        color("lightgray", 0.5)
        diff()
        cuboid([100, 80, 10], anchor=BOT) {
            // Pockets on bottom surface
            tag("remove")
            position(TOP)
            shell_magnet_pockets(100, 80, inset=15);
        }
    }
    
    // Demo: Face plate with steel pockets
    translate([0, 0, 20]) {
        color("white")
        diff()
        cuboid([96, 76, 4], anchor=BOT) {
            // Pockets on back (bottom when placed)
            tag("remove")
            position(BOT)
            faceplate_steel_pockets(96, 76, inset=15);
        }
    }
}
