// Edge Strip for Plywood Cases
// Straight strips that provide mid-span support between corner brackets.

include <BOSL2/std.scad>
include <plywood-constants.scad>

// Default dimensions
_DEFAULT_WALL = 3;
_DEFAULT_SLOT_DEPTH = 8;
_DEFAULT_TOLERANCE = 0.2;
_DEFAULT_SCREW_DIA = 3;

/**
 * Creates a straight edge strip for mid-panel support.
 * Used between corner brackets for longer edges.
 *
 * Arguments:
 *   length        - Length of the strip (along the edge)
 *   case_height   - Height of the side panels (mm)
 *   ply_thickness - Actual plywood thickness (use constants)
 *   wall          - Strip wall thickness (default: 3mm)
 *   slot_depth    - How deep plywood sits in slot (default: 8mm)
 *   tolerance     - Extra clearance for plywood fit (default: 0.2mm)
 *   screw_holes   - Add countersunk screw holes (default: false)
 *   screw_dia     - Screw hole diameter (default: 3mm)
 *   screw_spacing - Distance between screw holes (default: 50mm)
 *   anchor        - BOSL2 anchor (default: BOT)
 *   spin          - BOSL2 spin (default: 0)
 *   orient        - BOSL2 orient (default: UP)
 *
 * The strip is oriented with:
 *   - Length along the X axis
 *   - Side slot on the BACK face (receives panel from -Y direction)
 *   - Bottom slot on BOT face (receives bottom panel from +Z direction)
 */
module edge_strip(
    length,
    case_height,
    ply_thickness = PLY_DEFAULT,
    wall = _DEFAULT_WALL,
    slot_depth = _DEFAULT_SLOT_DEPTH,
    tolerance = _DEFAULT_TOLERANCE,
    screw_holes = false,
    screw_dia = _DEFAULT_SCREW_DIA,
    screw_spacing = 50,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    // Calculate dimensions
    slot_width = ply_thickness + tolerance;
    strip_depth = wall + slot_depth;
    total_height = case_height + wall;  // Extra for bottom slot floor

    // Overall bounding box for attachable
    size = [length, strip_depth, total_height];

    attachable(anchor, spin, orient, size=size) {
        difference() {
            // Main body
            cuboid(size, anchor=CENTER);

            // Cuts
            union() {
                // Side slot (for wall panel)
                translate([0, strip_depth/2 - wall - slot_width/2, wall/2])
                cuboid([length + 0.1, slot_width, case_height + 0.1], anchor=CENTER);

                // Bottom slot (for bottom panel)
                translate([0, slot_depth/2, -total_height/2 + wall/2])
                cuboid([length + 0.1, slot_depth + 0.1, slot_width], anchor=CENTER);

                // Optional screw holes
                if (screw_holes) {
                    num_screws = max(1, floor(length / screw_spacing));
                    spacing = length / (num_screws + 1);

                    for (i = [1:num_screws]) {
                        translate([-length/2 + i * spacing, -strip_depth/2 - 0.1, 0])
                        rotate([90, 0, 0])
                        cyl(d=screw_dia, h=wall + 0.2, anchor=BOT, $fn=16);
                    }
                }
            }
        }

        children();
    }
}

/**
 * Creates edge strips for all four sides of a rectangular case.
 * Strips are positioned to sit between corner brackets.
 *
 * Arguments:
 *   case_width    - Interior width of case (X dimension)
 *   case_depth    - Interior depth of case (Y dimension)
 *   case_height   - Height of side panels
 *   ply_thickness - Plywood thickness
 *   wall          - Bracket wall thickness
 *   slot_depth    - Slot depth
 *   tolerance     - Plywood clearance
 *   corner_inset  - How far to inset from corners (to leave room for corner brackets)
 */
module edge_strip_set(
    case_width,
    case_depth,
    case_height,
    ply_thickness = PLY_DEFAULT,
    wall = _DEFAULT_WALL,
    slot_depth = _DEFAULT_SLOT_DEPTH,
    tolerance = _DEFAULT_TOLERANCE,
    corner_inset = 20
) {
    arm_width = wall + slot_depth;
    strip_depth = wall + slot_depth;

    // Calculate strip lengths (case dimension minus two corner bracket widths)
    x_strip_length = case_width - 2 * corner_inset;
    y_strip_length = case_depth - 2 * corner_inset;

    // Front strip (along X, at -Y)
    if (x_strip_length > 0) {
        translate([0, -case_depth/2 - strip_depth/2, 0])
        edge_strip(
            length = x_strip_length,
            case_height = case_height,
            ply_thickness = ply_thickness,
            wall = wall,
            slot_depth = slot_depth,
            tolerance = tolerance,
            anchor = BOT
        );

        // Back strip (along X, at +Y)
        translate([0, case_depth/2 + strip_depth/2, 0])
        rotate([0, 0, 180])
        edge_strip(
            length = x_strip_length,
            case_height = case_height,
            ply_thickness = ply_thickness,
            wall = wall,
            slot_depth = slot_depth,
            tolerance = tolerance,
            anchor = BOT
        );
    }

    // Left strip (along Y, at -X)
    if (y_strip_length > 0) {
        translate([-case_width/2 - strip_depth/2, 0, 0])
        rotate([0, 0, 90])
        edge_strip(
            length = y_strip_length,
            case_height = case_height,
            ply_thickness = ply_thickness,
            wall = wall,
            slot_depth = slot_depth,
            tolerance = tolerance,
            anchor = BOT
        );

        // Right strip (along Y, at +X)
        translate([case_width/2 + strip_depth/2, 0, 0])
        rotate([0, 0, -90])
        edge_strip(
            length = y_strip_length,
            case_height = case_height,
            ply_thickness = ply_thickness,
            wall = wall,
            slot_depth = slot_depth,
            tolerance = tolerance,
            anchor = BOT
        );
    }
}

// === TEST / DEMO ===
// Only show demo when this file is opened directly, not when included
if ($preview && is_undef($parent_modules)) {
    $parent_modules = true;
    color("teal")
    edge_strip(
        length = 100,
        case_height = 50,
        ply_thickness = PLY_3_8,
        wall = 3,
        slot_depth = 8,
        screw_holes = false,
        anchor = BOT
    );
}
