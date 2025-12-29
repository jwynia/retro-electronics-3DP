// Googie Boomerang
// Parametric curved arrow/boomerang shapes for Googie-style signs.
// Classic mid-century modern motion symbol.

include <BOSL2/std.scad>

// Default values
_DEFAULT_SPAN = 100;
_DEFAULT_SWEEP = 120;
_DEFAULT_WIDTH = 15;
_DEFAULT_THICKNESS = 5;

/**
 * Creates a Googie-style boomerang/curved arrow.
 *
 * The boomerang is a classic mid-century design element suggesting
 * motion and direction. Used on signs, as arrows, and decorative accents.
 *
 * Arguments:
 *   span          - Tip-to-tip distance (mm)
 *   sweep_angle   - Curve angle in degrees (90=quarter circle, 120=more curved)
 *   width         - Width/thickness of the arm at center (mm)
 *   taper         - Taper ratio at tips (0=pointed, 1=no taper)
 *   thickness     - 3D extrusion depth (mm)
 *   arrow_head    - Add arrow point to one end (true/false)
 *   arrow_size    - Size of arrow head if enabled (mm)
 *   symmetric     - If false with arrow, only one end gets arrow
 *   anchor        - BOSL2 anchor (default: CENTER)
 *   spin          - BOSL2 spin (default: 0)
 *   orient        - BOSL2 orient (default: UP)
 *
 * Example:
 *   boomerang();  // Default 100mm span
 *   boomerang(span=150, sweep_angle=90);  // Wider, less curved
 *   boomerang(arrow_head=true);  // With arrow point
 */
module boomerang(
    span = _DEFAULT_SPAN,
    sweep_angle = _DEFAULT_SWEEP,
    width = _DEFAULT_WIDTH,
    taper = 0.2,
    thickness = _DEFAULT_THICKNESS,
    arrow_head = false,
    arrow_size = undef,
    symmetric = true,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    // Validate
    assert(span > 0, "span must be positive");
    assert(sweep_angle > 0 && sweep_angle < 180, "sweep_angle must be between 0 and 180");
    assert(width > 0, "width must be positive");
    assert(taper >= 0 && taper <= 1, "taper must be between 0 and 1");

    // Calculate arc parameters
    // The boomerang follows an arc; we calculate radius from span and angle
    half_angle = sweep_angle / 2;
    // span = 2 * radius * sin(half_angle)
    radius = span / (2 * sin(half_angle));

    // Arrow size defaults to width
    _arrow_size = is_undef(arrow_size) ? width * 1.5 : arrow_size;

    // Generate the boomerang profile as a 2D shape
    // We'll create the outer and inner arcs, with tapered ends

    steps = max(24, floor(sweep_angle / 3));  // More steps for smoother curves

    // Outer edge points (from -half_angle to +half_angle)
    outer_points = [
        for (i = [0:steps])
        let(
            angle = -half_angle + i * sweep_angle / steps,
            // Taper: width varies from taper*width at ends to width at center
            t = abs(angle) / half_angle,  // 0 at center, 1 at ends
            local_width = width * (1 - t * (1 - taper)) / 2,
            r = radius + local_width
        )
        [r * sin(angle), r * cos(angle) - radius * cos(half_angle)]
    ];

    // Inner edge points (reversed, from +half_angle to -half_angle)
    inner_points = [
        for (i = [steps:-1:0])
        let(
            angle = -half_angle + i * sweep_angle / steps,
            t = abs(angle) / half_angle,
            local_width = width * (1 - t * (1 - taper)) / 2,
            r = radius - local_width
        )
        [r * sin(angle), r * cos(angle) - radius * cos(half_angle)]
    ];

    // Combine into closed polygon
    boomerang_points = concat(outer_points, inner_points);

    // Calculate bounding box for attachable
    min_x = min([for (p = boomerang_points) p[0]]);
    max_x = max([for (p = boomerang_points) p[0]]);
    min_y = min([for (p = boomerang_points) p[1]]);
    max_y = max([for (p = boomerang_points) p[1]]);

    size = [max_x - min_x, max_y - min_y, thickness];
    center_offset = [(max_x + min_x) / 2, (max_y + min_y) / 2, 0];

    attachable(anchor, spin, orient, size=size) {
        translate(-center_offset)
        union() {
            // Main boomerang body
            linear_extrude(height=thickness, center=true)
            polygon(boomerang_points);

            // Optional arrow heads
            if (arrow_head) {
                // Right tip arrow
                tip_angle = half_angle;
                tip_x = radius * sin(tip_angle);
                tip_y = radius * cos(tip_angle) - radius * cos(half_angle);

                translate([tip_x, tip_y, 0])
                rotate([0, 0, -tip_angle])
                linear_extrude(height=thickness, center=true)
                polygon([
                    [0, _arrow_size/2],
                    [_arrow_size, 0],
                    [0, -_arrow_size/2]
                ]);

                // Left tip arrow (if symmetric)
                if (symmetric) {
                    translate([-tip_x, tip_y, 0])
                    rotate([0, 0, tip_angle])
                    linear_extrude(height=thickness, center=true)
                    polygon([
                        [0, _arrow_size/2],
                        [-_arrow_size, 0],
                        [0, -_arrow_size/2]
                    ]);
                }
            }
        }
        children();
    }
}

/**
 * Creates a simple curved arrow (boomerang with one arrow head).
 * Convenience wrapper for directional signage.
 */
module curved_arrow(
    span = 80,
    sweep_angle = 90,
    width = 12,
    thickness = 5,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    boomerang(
        span = span,
        sweep_angle = sweep_angle,
        width = width,
        thickness = thickness,
        arrow_head = true,
        symmetric = false,
        taper = 0.3,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) children();
}

/**
 * Creates a decorative swoosh (highly tapered boomerang).
 * Used as accent elements on Googie signs.
 */
module swoosh(
    span = 120,
    sweep_angle = 100,
    width = 20,
    thickness = 5,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    boomerang(
        span = span,
        sweep_angle = sweep_angle,
        width = width,
        thickness = thickness,
        taper = 0.05,  // Very pointed ends
        arrow_head = false,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) children();
}


// === TEST / DEMO ===
// Only runs when this file is opened directly, not when included
if ($preview && is_undef($parent_modules)) {
    $parent_modules = true;

    // Basic boomerang
    boomerang();

    // Curved arrow
    translate([120, 0, 0])
    curved_arrow(span=80);

    // Decorative swoosh
    translate([0, 80, 0])
    swoosh(span=100);

    // Tight curve boomerang
    translate([120, 80, 0])
    boomerang(span=70, sweep_angle=150, width=10);
}
