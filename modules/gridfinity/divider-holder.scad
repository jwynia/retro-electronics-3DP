// Gridfinity Divider Frame
// Full-height frames that sit on Gridfinity bases and hold thin plywood/hardboard dividers
//
// Use Case: Custom compartmentalization in Gridfinity cases using
// laser-cut or hand-cut 1/8" plywood dividers instead of printed bins.
// These frames lock into the baseplate like regular bins.

include <BOSL2/std.scad>

// Gridfinity standard dimensions (from gridfinity-rebuilt-openscad)
GRID_PITCH = 42;           // mm per grid unit
BASE_TOP = 41.5;           // actual base size (0.5mm gap)
BASE_HEIGHT = 7;           // height per z-unit
BASE_PROFILE_HEIGHT = 5.45; // height of interlocking profile
BASE_TOP_RADIUS = 3.75;    // corner radius at top of base
BASE_BOTTOM_RADIUS = 0.8;  // corner radius at bottom

// Base profile for Gridfinity compatibility
// Points from inner bottom to outer top (will be swept around corners)
BASE_PROFILE = [
    [0, 0],
    [0.8, 0.8],
    [0.8, 2.6],
    [2.95, 5.45]
];

// Divider frame defaults
_DEFAULT_MATERIAL = 3.2;   // 1/8" = 3.175mm, plus tolerance
_DEFAULT_WALL = 1.6;       // frame wall thickness (2 perimeters at 0.4mm)
_DEFAULT_SLOT_DEPTH = 5;   // how deep divider sits in slot

/**
 * Creates the Gridfinity base profile for a single unit.
 * This is the interlocking shape that sits in the baseplate.
 */
module gridfinity_base_unit() {
    // Base top is 41.5mm, profile adds 2.95mm on each side at bottom
    base_bottom = BASE_TOP - 2 * 2.95;  // ~35.6mm

    hull() {
        // Bottom - smaller, rounded
        translate([0, 0, 0])
        linear_extrude(0.1)
        offset(r = BASE_BOTTOM_RADIUS)
        square([base_bottom - 2*BASE_BOTTOM_RADIUS,
                base_bottom - 2*BASE_BOTTOM_RADIUS], center=true);

        // Top - larger, rounded
        translate([0, 0, BASE_PROFILE_HEIGHT])
        linear_extrude(0.1)
        offset(r = BASE_TOP_RADIUS)
        square([BASE_TOP - 2*BASE_TOP_RADIUS,
                BASE_TOP - 2*BASE_TOP_RADIUS], center=true);
    }
}

/**
 * Creates a full-height divider frame that locks into Gridfinity baseplate.
 *
 * Arguments:
 *   grid_x, grid_y    - Size in grid units (e.g., 3x2)
 *   height_units      - Height in Gridfinity units (e.g., 6 for 6u)
 *   material          - Divider material thickness (default: 3.2mm for 1/8")
 *   wall              - Frame wall thickness (default: 1.6mm)
 *   slot_depth        - How deep dividers sit in slots (default: 5mm)
 *   dividers_x        - Number of X dividers (default: 0, just outer frame)
 *   dividers_y        - Number of Y dividers (default: 0)
 *   anchor, spin, orient - BOSL2 attachment
 */
module divider_frame(
    grid_x = 2,
    grid_y = 2,
    height_units = 6,
    material = _DEFAULT_MATERIAL,
    wall = _DEFAULT_WALL,
    slot_depth = _DEFAULT_SLOT_DEPTH,
    dividers_x = 0,
    dividers_y = 0,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    // Calculate dimensions
    outer_x = grid_x * GRID_PITCH - 0.5;  // 0.5mm gap like standard bins
    outer_y = grid_y * GRID_PITCH - 0.5;
    total_height = height_units * BASE_HEIGHT + BASE_HEIGHT;  // +7 for base

    // Inner dimensions (where dividers go)
    inner_x = outer_x - 2 * wall;
    inner_y = outer_y - 2 * wall;

    size = [outer_x, outer_y, total_height];

    attachable(anchor, spin, orient, size=size) {
        union() {
            // Frame walls with slots
            difference() {
                // Outer frame
                translate([0, 0, BASE_PROFILE_HEIGHT])
                linear_extrude(total_height - BASE_PROFILE_HEIGHT)
                difference() {
                    offset(r = 2)
                    square([outer_x - 4, outer_y - 4], center=true);

                    offset(r = 1)
                    square([inner_x - 2, inner_y - 2], center=true);
                }

                // Slots in X walls (for Y-spanning dividers)
                if (dividers_y > 0) {
                    y_spacing = inner_y / (dividers_y + 1);
                    for (i = [1:dividers_y]) {
                        // Slot in +X wall
                        translate([outer_x/2 - slot_depth/2, -inner_y/2 + i * y_spacing, total_height/2 + BASE_PROFILE_HEIGHT/2])
                        cube([slot_depth + 1, material, total_height], center=true);

                        // Slot in -X wall
                        translate([-outer_x/2 + slot_depth/2, -inner_y/2 + i * y_spacing, total_height/2 + BASE_PROFILE_HEIGHT/2])
                        cube([slot_depth + 1, material, total_height], center=true);
                    }
                }

                // Slots in Y walls (for X-spanning dividers)
                if (dividers_x > 0) {
                    x_spacing = inner_x / (dividers_x + 1);
                    for (i = [1:dividers_x]) {
                        // Slot in +Y wall
                        translate([-inner_x/2 + i * x_spacing, outer_y/2 - slot_depth/2, total_height/2 + BASE_PROFILE_HEIGHT/2])
                        cube([material, slot_depth + 1, total_height], center=true);

                        // Slot in -Y wall
                        translate([-inner_x/2 + i * x_spacing, -outer_y/2 + slot_depth/2, total_height/2 + BASE_PROFILE_HEIGHT/2])
                        cube([material, slot_depth + 1, total_height], center=true);
                    }
                }
            }

            // Gridfinity base units (one per grid cell)
            for (gx = [0:grid_x-1]) {
                for (gy = [0:grid_y-1]) {
                    translate([
                        -outer_x/2 + GRID_PITCH/2 + gx * GRID_PITCH,
                        -outer_y/2 + GRID_PITCH/2 + gy * GRID_PITCH,
                        0
                    ])
                    gridfinity_base_unit();
                }
            }

            // Bridge between bases (fills the gap at top of bases)
            translate([0, 0, BASE_PROFILE_HEIGHT])
            linear_extrude(BASE_HEIGHT - BASE_PROFILE_HEIGHT)
            difference() {
                offset(r = 2)
                square([outer_x - 4, outer_y - 4], center=true);

                // Don't fill the inner area
                offset(r = 1)
                square([inner_x - 2, inner_y - 2], center=true);
            }
        }

        children();
    }
}

/**
 * Calculates divider dimensions for a frame.
 *
 * Arguments:
 *   grid_units  - Grid units the divider spans (X or Y direction)
 *   height_units - Frame height in Gridfinity units
 *   wall        - Frame wall thickness
 *   slot_depth  - Slot depth in frame walls
 *
 * Returns: [width, height] of the divider in mm
 */
function divider_size(grid_units, height_units, wall = _DEFAULT_WALL, slot_depth = _DEFAULT_SLOT_DEPTH) =
    let(
        frame_inner = grid_units * GRID_PITCH - 0.5 - 2 * wall,
        divider_width = frame_inner + 2 * slot_depth,
        divider_height = height_units * BASE_HEIGHT  // doesn't include base profile area
    )
    [divider_width, divider_height];

/**
 * Generates a simple divider shape for visualization or export.
 */
module divider_panel(
    width,
    height,
    thickness = _DEFAULT_MATERIAL - 0.2  // slightly under for fit
) {
    color("BurlyWood")
    cube([width, thickness, height], center=true);
}

// === DEMO ===
if ($preview && is_undef($parent_modules)) {
    $parent_modules = true;

    // Show a 3x2 frame with divider slots
    color("teal")
    divider_frame(
        grid_x = 3,
        grid_y = 2,
        height_units = 6,
        dividers_x = 2,  // 2 dividers splitting into 3 X sections
        dividers_y = 1   // 1 divider splitting into 2 Y sections
    );

    // Show example dividers (ghosted)
    div_x = divider_size(2, 6);  // Y-spanning divider (spans 2 grid units in Y)
    div_y = divider_size(3, 6);  // X-spanning divider (spans 3 grid units in X)

    echo(str("Y-spanning divider size: ", div_x, " mm"));
    echo(str("X-spanning divider size: ", div_y, " mm"));

    // Show dividers in place
    frame_inner_x = 3 * GRID_PITCH - 0.5 - 2 * _DEFAULT_WALL;
    frame_inner_y = 2 * GRID_PITCH - 0.5 - 2 * _DEFAULT_WALL;

    // X dividers (span full Y width)
    color("BurlyWood", 0.5) {
        translate([-frame_inner_x/3, 0, 6*7/2 + 7])
        divider_panel(div_y.x, div_y.y, 3);

        translate([frame_inner_x/3, 0, 6*7/2 + 7])
        divider_panel(div_y.x, div_y.y, 3);
    }

    // Y divider (spans full X width)
    color("BurlyWood", 0.5)
    translate([0, 0, 6*7/2 + 7])
    rotate([0, 0, 90])
    divider_panel(div_x.x, div_x.y, 3);
}
