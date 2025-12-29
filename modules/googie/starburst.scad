// Googie Starburst
// Parametric atomic-age starburst decorations for Googie-style signs.
// Classic mid-century modern design element.

include <BOSL2/std.scad>

// Default values
_DEFAULT_POINTS = 8;
_DEFAULT_OUTER_RADIUS = 50;
_DEFAULT_INNER_RADIUS = 20;
_DEFAULT_THICKNESS = 5;

/**
 * Creates a Googie-style starburst decoration.
 *
 * The starburst is a classic atomic-age design element featuring
 * alternating long and short points radiating from a center.
 * Common on 1950s-60s signs, diners, and the Las Vegas welcome sign.
 *
 * Arguments:
 *   points        - Number of long points (short points fill between)
 *   outer_radius  - Length of long points from center (mm)
 *   inner_radius  - Length of short points from center (mm)
 *   mid_radius    - Width at the base of points (controls point sharpness)
 *   thickness     - 3D extrusion depth (mm)
 *   alternating   - If true, add short points between long ones
 *   center_hole   - Diameter of center mounting hole (0 = none)
 *   anchor        - BOSL2 anchor (default: CENTER)
 *   spin          - BOSL2 spin (default: 0)
 *   orient        - BOSL2 orient (default: UP)
 *
 * Example:
 *   starburst();  // 8-point default
 *   starburst(points=12, outer_radius=80);  // Larger 12-point
 *   starburst(alternating=false);  // Simple star without short points
 */
module starburst(
    points = _DEFAULT_POINTS,
    outer_radius = _DEFAULT_OUTER_RADIUS,
    inner_radius = _DEFAULT_INNER_RADIUS,
    mid_radius = undef,
    thickness = _DEFAULT_THICKNESS,
    alternating = true,
    center_hole = 0,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    // Validate
    assert(points >= 3, "starburst requires at least 3 points");
    assert(outer_radius > inner_radius, "outer_radius must be > inner_radius");
    assert(thickness > 0, "thickness must be positive");

    // Default mid_radius creates nice pointed stars
    _mid = is_undef(mid_radius) ? inner_radius * 0.4 : mid_radius;

    // Calculate total points (doubled if alternating)
    total_points = alternating ? points * 2 : points;
    angle_step = 360 / total_points;

    // Size for attachable (bounding box)
    size = [outer_radius * 2, outer_radius * 2, thickness];

    // Build the star profile
    // Each point: go to tip, then back to base
    star_points = [
        for (i = [0:total_points-1])
        let(
            angle = i * angle_step,
            // Alternate between long and short points
            is_long = alternating ? (i % 2 == 0) : true,
            tip_r = is_long ? outer_radius : inner_radius,
            // The "base" between points
            base_angle = angle + angle_step/2,
            base_r = _mid
        )
        each [
            [tip_r * cos(angle), tip_r * sin(angle)],
            [base_r * cos(base_angle), base_r * sin(base_angle)]
        ]
    ];

    attachable(anchor, spin, orient, size=size) {
        difference() {
            // Main starburst shape
            linear_extrude(height=thickness, center=true)
            polygon(star_points);

            // Optional center hole
            if (center_hole > 0) {
                cylinder(h=thickness+1, d=center_hole, center=true, $fn=32);
            }
        }
        children();
    }
}

/**
 * Creates a simpler pointed star (non-alternating).
 * Convenience wrapper for basic star shapes.
 */
module star(
    points = 5,
    outer_radius = 50,
    inner_radius = 20,
    thickness = 5,
    center_hole = 0,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    starburst(
        points = points,
        outer_radius = outer_radius,
        inner_radius = inner_radius,
        thickness = thickness,
        alternating = false,
        center_hole = center_hole,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) children();
}

/**
 * Atomic starburst with classic 1950s proportions.
 * 8 long points with 8 short points between.
 */
module atomic_starburst(
    size = 100,
    thickness = 5,
    center_hole = 0,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    // Classic atomic proportions: long points 2.5x short points
    starburst(
        points = 8,
        outer_radius = size / 2,
        inner_radius = size / 5,
        mid_radius = size / 8,
        thickness = thickness,
        alternating = true,
        center_hole = center_hole,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) children();
}


// === TEST / DEMO ===
// Only runs when this file is opened directly, not when included
if ($preview && is_undef($parent_modules)) {
    $parent_modules = true;
    // Show variety of starbursts

    // Classic atomic starburst (Las Vegas sign style)
    atomic_starburst(size=80, thickness=5);

    // Simple 5-point star
    translate([100, 0, 0])
    star(points=5, outer_radius=35, inner_radius=15);

    // 12-point alternating starburst
    translate([0, 100, 0])
    starburst(points=12, outer_radius=40, inner_radius=25, mid_radius=12);

    // 6-point with center hole for mounting
    translate([100, 100, 0])
    starburst(points=6, outer_radius=35, inner_radius=18, center_hole=6);
}
