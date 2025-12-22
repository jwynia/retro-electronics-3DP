// Grille Faceplate Generator
// Creates face plates with various speaker/ventilation grille patterns.
// Supports 7 pattern types for retro aesthetics.

include <BOSL2/std.scad>

// Default values
_GRILLE_THICKNESS = 4;
_GRILLE_CORNER_R = 8;
_GRILLE_MARGIN = 10;

// ============================================================
// PATTERN MODULES (Internal - generate cutting geometry)
// ============================================================

/**
 * Circular perforation grid pattern
 */
module _grille_perf(w, h, t, hole_dia=4, spacing=6) {
    cols = floor(w / spacing);
    rows = floor(h / spacing);
    offset_x = (w - (cols - 1) * spacing) / 2;
    offset_y = (h - (rows - 1) * spacing) / 2;

    translate([-w/2 + offset_x, -h/2 + offset_y, 0])
    for (x = [0 : cols-1], y = [0 : rows-1]) {
        translate([x * spacing, y * spacing, 0])
        cyl(d=hole_dia, h=t + 1, $fn=16);
    }
}

/**
 * Horizontal slot pattern
 */
module _grille_slots(w, h, t, slot_width=40, slot_height=2, spacing=5) {
    rows = floor(h / spacing);
    offset_y = (h - (rows - 1) * spacing) / 2;

    translate([0, -h/2 + offset_y, 0])
    for (y = [0 : rows-1]) {
        translate([0, y * spacing, 0])
        cuboid([slot_width, slot_height, t + 1], anchor=CENTER);
    }
}

/**
 * Vertical slot pattern (Braun style)
 */
module _grille_vslots(w, h, t, slot_width=2, slot_height=40, spacing=5) {
    cols = floor(w / spacing);
    offset_x = (w - (cols - 1) * spacing) / 2;

    translate([-w/2 + offset_x, 0, 0])
    for (x = [0 : cols-1]) {
        translate([x * spacing, 0, 0])
        cuboid([slot_width, slot_height, t + 1], anchor=CENTER);
    }
}

/**
 * Hexagonal honeycomb pattern
 */
module _grille_hex(w, h, t, cell_size=8, wall=1.5) {
    hex_h = cell_size;
    hex_w = cell_size * sqrt(3) / 2;
    spacing_x = (hex_w + wall) * 2;
    spacing_y = (hex_h + wall) * 0.75;

    cols = floor(w / spacing_x) + 1;
    rows = floor(h / spacing_y) + 1;

    intersection() {
        cuboid([w, h, t + 2], anchor=CENTER);

        for (y = [0 : rows-1]) {
            x_offset = (y % 2) * spacing_x / 2;
            translate([-w/2 + x_offset, -h/2 + y * spacing_y, 0])
            for (x = [0 : cols-1]) {
                translate([x * spacing_x, 0, 0])
                cyl(d=cell_size, h=t + 1, $fn=6);
            }
        }
    }
}

/**
 * Concentric circles pattern
 */
module _grille_circles(w, h, t, ring_count=5, ring_width=2, ring_gap=4) {
    max_radius = min(w, h) / 2 - ring_width;
    ring_spacing = ring_width + ring_gap;

    intersection() {
        cuboid([w, h, t + 2], anchor=CENTER);

        for (i = [1 : ring_count]) {
            r = i * ring_spacing;
            if (r <= max_radius) {
                difference() {
                    cyl(r=r, h=t + 1, $fn=64);
                    cyl(r=r - ring_width, h=t + 2, $fn=64);
                }
            }
        }
    }
}

/**
 * Diamond/diagonal grid pattern (45° rotated)
 */
module _grille_diamond(w, h, t, hole_size=4, spacing=8) {
    // Expand grid to cover rotated area
    diag = sqrt(w*w + h*h);
    cols = floor(diag / spacing) + 2;
    rows = floor(diag / spacing) + 2;

    intersection() {
        cuboid([w, h, t + 2], anchor=CENTER);

        rotate([0, 0, 45])
        translate([-(cols-1)*spacing/2, -(rows-1)*spacing/2, 0])
        for (x = [0 : cols-1], y = [0 : rows-1]) {
            translate([x * spacing, y * spacing, 0])
            rotate([0, 0, 45])
            cuboid([hole_size, hole_size, t + 1], anchor=CENTER);
        }
    }
}

/**
 * Sunburst/radial pattern
 */
module _grille_sunburst(w, h, t, ray_count=12, ray_width=3, center_dia=10) {
    max_radius = min(w, h) / 2;
    ray_length = max_radius - center_dia/2;

    intersection() {
        cuboid([w, h, t + 2], anchor=CENTER);

        union() {
            // Center hole
            cyl(d=center_dia, h=t + 1, $fn=32);

            // Radiating rays
            for (a = [0 : 360/ray_count : 359]) {
                rotate([0, 0, a])
                translate([center_dia/2 + ray_length/2, 0, 0])
                cuboid([ray_length, ray_width, t + 1], anchor=CENTER);
            }
        }
    }
}

// ============================================================
// MAIN MODULE
// ============================================================

/**
 * Creates a face plate with grille pattern.
 *
 * Arguments:
 *   size          - [width, height] outer dimensions
 *   thickness     - plate thickness (default: 4)
 *   corner_r      - corner radius (default: 8)
 *   grille_size   - [width, height] of grille area, or undef for auto
 *   grille_margin - margin from edges if grille_size not specified (default: 10)
 *   pattern       - pattern type: "perf", "slots", "vslots", "hex",
 *                   "circles", "diamond", "sunburst"
 *
 * Pattern-specific parameters (with defaults):
 *   hole_dia      - hole diameter for perf/diamond (default: 4)
 *   spacing       - spacing for grid patterns (default: 6)
 *   slot_width    - slot width for slots/vslots (default: 40)
 *   slot_height   - slot height for slots/vslots (default: 2)
 *   cell_size     - hex cell size (default: 8)
 *   hex_wall      - hex wall thickness (default: 1.5)
 *   ring_count    - number of concentric rings (default: 5)
 *   ring_width    - ring line width (default: 2)
 *   ring_gap      - gap between rings (default: 4)
 *   ray_count     - number of sunburst rays (default: 12)
 *   ray_width     - sunburst ray width (default: 3)
 *   center_dia    - sunburst center hole diameter (default: 10)
 *
 * Standard faceplate options:
 *   steel_pockets - include steel disc pockets (default: true)
 *   steel_inset   - pocket distance from corners (default: 12)
 *   steel_dia     - steel disc diameter (default: 10)
 *   steel_depth   - pocket depth (default: 1)
 */
module faceplate_grille(
    size,
    thickness = _GRILLE_THICKNESS,
    corner_r = _GRILLE_CORNER_R,
    grille_size = undef,
    grille_margin = _GRILLE_MARGIN,
    pattern = "perf",
    // Pattern parameters
    hole_dia = 4,
    spacing = 6,
    slot_width = 40,
    slot_height = 2,
    cell_size = 8,
    hex_wall = 1.5,
    ring_count = 5,
    ring_width = 2,
    ring_gap = 4,
    ray_count = 12,
    ray_width = 3,
    center_dia = 10,
    // Standard faceplate options
    steel_pockets = true,
    steel_inset = 12,
    steel_dia = 10,
    steel_depth = 1,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    width = size[0];
    height = size[1];

    // Calculate grille area
    gw = is_undef(grille_size) ? width - grille_margin * 2 : grille_size[0];
    gh = is_undef(grille_size) ? height - grille_margin * 2 : grille_size[1];

    // Steel pocket positions
    pocket_positions = [
        [ width/2 - steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset,  height/2 - steel_inset],
        [-width/2 + steel_inset, -height/2 + steel_inset],
        [ width/2 - steel_inset, -height/2 + steel_inset]
    ];

    attachable(anchor, spin, orient, size=[width, height, thickness]) {
        diff()
        cuboid([width, height, thickness], rounding=corner_r, edges="Z", anchor=CENTER) {

            // Grille pattern
            tag("remove")
            if (pattern == "perf") {
                _grille_perf(gw, gh, thickness, hole_dia, spacing);
            } else if (pattern == "slots") {
                _grille_slots(gw, gh, thickness, slot_width, slot_height, spacing);
            } else if (pattern == "vslots") {
                _grille_vslots(gw, gh, thickness, slot_height, slot_width, spacing);
            } else if (pattern == "hex") {
                _grille_hex(gw, gh, thickness, cell_size, hex_wall);
            } else if (pattern == "circles") {
                _grille_circles(gw, gh, thickness, ring_count, ring_width, ring_gap);
            } else if (pattern == "diamond") {
                _grille_diamond(gw, gh, thickness, hole_dia, spacing);
            } else if (pattern == "sunburst") {
                _grille_sunburst(gw, gh, thickness, ray_count, ray_width, center_dia);
            }

            // Steel disc pockets for magnetic attachment
            if (steel_pockets) {
                tag("remove")
                position(BOT)
                for (pos = pocket_positions) {
                    translate([pos[0], pos[1], 0])
                    cyl(d=steel_dia + 0.3, h=steel_depth + 0.1, anchor=BOT, $fn=32);
                }
            }
        }

        children();
    }
}

// ============================================================
// TEST / DEMO
// ============================================================

if ($preview) {
    // Show perforation pattern
    faceplate_grille(
        size = [100, 80],
        thickness = 4,
        corner_r = 8,
        pattern = "perf",
        hole_dia = 4,
        spacing = 6
    );
}
