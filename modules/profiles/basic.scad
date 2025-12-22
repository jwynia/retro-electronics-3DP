// 2D Profile Generators
// These modules create 2D shapes for use with offset_sweep, skin, etc.

include <BOSL2/std.scad>

/**
 * Creates a rounded rectangle profile.
 * Wrapper around BOSL2's rect() for consistency.
 */
module profile_rounded_rect(size, corner_r) {
    rect(size, rounding=corner_r);
}

/**
 * Creates a wedge/trapezoidal profile (2D side view).
 * Useful for swept/lofted retro shapes.
 *
 * Arguments:
 *   height     - profile height
 *   base_width - width at base (bottom)
 *   top_width  - width at top
 *   corner_r   - corner rounding radius
 */
module profile_wedge(height, base_width, top_width, corner_r=0) {
    points = [
        [-base_width/2, 0],
        [ base_width/2, 0],
        [ top_width/2, height],
        [-top_width/2, height]
    ];
    
    if (corner_r > 0) {
        polygon(round_corners(points, r=corner_r, $fn=16));
    } else {
        polygon(points);
    }
}

/**
 * Returns a path (point list) for a rounded rectangle.
 * Use with offset_sweep() or skin().
 *
 * Arguments:
 *   size     - [width, height]
 *   corner_r - corner radius
 */
function path_rounded_rect(size, corner_r) = 
    rect(size, rounding=corner_r, $fn=32);

// === TEST / DEMO ===
if ($preview) {
    // Side by side demo of profiles
    translate([-50, 0, 0])
    linear_extrude(5)
    profile_rounded_rect([80, 60], 10);
    
    translate([50, 0, 0])
    linear_extrude(5)
    profile_wedge(60, 80, 50, corner_r=5);
}
