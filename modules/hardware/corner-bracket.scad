// Corner Bracket for Plywood Cases
// L-shaped external brackets that hold plywood panels at box corners.

include <BOSL2/std.scad>
include <plywood-constants.scad>

// Default dimensions
_DEFAULT_WALL = 3;
_DEFAULT_TOLERANCE = 0.2;
_DEFAULT_SCREW_DIA = 3;  // M3 or #4 wood screw

/**
 * Creates an L-shaped corner bracket for box corners.
 * Wraps around the external corner with slots for two side panels
 * and a bottom panel.
 *
 * Arguments:
 *   case_height   - Height of the side panels (mm)
 *   ply_thickness - Actual plywood thickness (use constants from plywood-constants.scad)
 *   wall          - Bracket wall thickness (default: 3mm)
 *   slot_depth    - How deep plywood sits in slot (default: 8mm)
 *   tolerance     - Extra clearance for plywood fit (default: 0.2mm)
 *   screw_holes   - Add countersunk screw holes (default: false)
 *   screw_dia     - Screw hole diameter (default: 3mm)
 *   chamfer       - Chamfer size for exterior edges (default: 0, no chamfer)
 *   anchor        - BOSL2 anchor (default: BOT+LEFT+FWD, external corner)
 *   spin          - BOSL2 spin (default: 0)
 *   orient        - BOSL2 orient (default: UP)
 *
 * The bracket is oriented with:
 *   - External corner at BOT+LEFT+FWD (default anchor)
 *   - X-slot on the RIGHT face (receives panel from -X direction)
 *   - Y-slot on the BACK face (receives panel from -Y direction)
 *   - Bottom slot on BOT face (receives bottom panel from +Z direction)
 */
module corner_bracket(
    case_height,
    ply_thickness = PLY_DEFAULT,
    wall = _DEFAULT_WALL,
    tolerance = _DEFAULT_TOLERANCE,
    screw_holes = false,
    screw_dia = _DEFAULT_SCREW_DIA,
    foot_hole = true,
    chamfer = 0,
    anchor = BOT+LEFT+FWD,
    spin = 0,
    orient = UP
) {
    // Calculate dimensions
    // arm_width: wide enough that centered screws always hit solid plywood
    // Need: wall + ply (side panel) + ply (front panel) + wall
    slot_width = ply_thickness + tolerance;
    arm_width = wall + (ply_thickness + tolerance) * 2 + wall;  // ~25mm for 3/8" ply
    total_height = case_height + wall;  // Extra for bottom floor

    // Overall bounding box for attachable
    size = [arm_width, arm_width, total_height];

    // Build L-shape:
    // - External corner at [-arm_width/2, -arm_width/2]
    // - X-arm: front panel sits against it, screw goes through outer wall
    // - Y-arm: side panel sits against it, screw goes through outer wall
    // - At corner: side panel goes full depth, front panel butts against it

    ext_corner = [-arm_width/2, -arm_width/2];
    bot_z = -total_height/2;

    attachable(anchor, spin, orient, size=size) {
        difference() {
            // Main L-shaped body - single piece for continuous chamfers
            union() {
                // L-shape profile as a single extrusion with 3D chamfers
                // Points define the L from external corner going clockwise
                // Main external corner is split into two points for chamfer
                c = chamfer > 0 ? chamfer : 0;
                l_points = [
                    [ext_corner.x + c, ext_corner.y],                // External corner - chamfer pt 1
                    [ext_corner.x, ext_corner.y + c],                // External corner - chamfer pt 2
                    [ext_corner.x, arm_width/2],                     // Y-arm end exterior
                    [ext_corner.x + wall*2, arm_width/2],            // Y-arm end interior
                    [ext_corner.x + wall*2, ext_corner.y + wall*2],  // Inner corner
                    [arm_width/2, ext_corner.y + wall*2],            // X-arm end interior
                    [arm_width/2, ext_corner.y],                     // X-arm end exterior
                ];

                // Chamfer the 2D corners for vertical edge chamfers
                // Skip tight interior corners, chamfer arm ends
                corner_cuts = [0, 0, chamfer, 0, 0, 0, chamfer];
                l_chamfered = chamfer > 0
                    ? round_corners(l_points, cut=corner_cuts, method="chamfer", closed=true)
                    : l_points;

                // Use offset_sweep for top edge chamfer (bottom is flat for floor alignment)
                up(bot_z)
                offset_sweep(
                    path=l_chamfered,
                    height=total_height,
                    top=os_chamfer(chamfer)
                );

                // Floor piece at bottom corner for base panel
                // Bottom flush with L-bracket bottom, chamfered outer edges
                // Size and thickness match the bracket arms
                floor_size = arm_width - wall;  // Slightly smaller than arm width
                floor_thickness = wall * 2;     // Match arm thickness
                floor_pos = [ext_corner.x + wall * 2 + floor_size/2,
                             ext_corner.y + wall * 2 + floor_size/2,
                             bot_z];
                translate(floor_pos)
                cuboid([floor_size, floor_size, floor_thickness], anchor=BOT,
                       chamfer=chamfer, edges=BOT);
            }

            // Optional screw holes - multiple along height
            // Diamond shape prints without supports, wood screws self-tap fine
            if (screw_holes) {
                num_screws = max(1, round(case_height / 50));
                screw_spacing = case_height / (num_screws + 1);
                // Screw goes through wall + into plywood
                screw_length = wall * 2 + ply_thickness * 0.5;
                // Diamond side length for desired diagonal (screw diameter)
                diamond_side = screw_dia / sqrt(2);

                for (i = [1:num_screws]) {
                    screw_z = bot_z + wall + i * screw_spacing;

                    // Screw through X-arm into FRONT panel
                    // Diamond with points at top/bottom (±Z)
                    translate([0, ext_corner.y - 0.1, screw_z])
                    rotate([-90, 0, 0])
                    rotate([0, 0, 45])
                    cuboid([diamond_side, diamond_side, screw_length], anchor=BOT);

                    // Screw through Y-arm into SIDE panel
                    // Diamond with points at top/bottom (±Z)
                    translate([ext_corner.x - 0.1, 0, screw_z])
                    rotate([0, 90, 0])
                    rotate([0, 0, 45])
                    cuboid([diamond_side, diamond_side, screw_length], anchor=BOT);
                }
            }

            // Foot screw hole - countersunk on BOTTOM for screw head
            if (foot_hole) {
                foot_floor_size = arm_width - wall;
                foot_floor_thickness = wall * 2;
                floor_center = [ext_corner.x + wall * 2 + foot_floor_size/2,
                                ext_corner.y + wall * 2 + foot_floor_size/2];

                // Clearance hole through floor for screw
                translate([floor_center.x, floor_center.y, bot_z - 0.1])
                cyl(d=screw_dia, h=foot_floor_thickness + 0.2, anchor=BOT, $fn=24);

                // Countersink at BOTTOM of floor for screw head
                translate([floor_center.x, floor_center.y, bot_z])
                cyl(d1=screw_dia*2, d2=screw_dia, h=foot_floor_thickness/2 + 0.1, anchor=BOT, $fn=24);
            }
        }

        children();
    }
}

/**
 * Returns screw hole positions for a corner bracket.
 * Useful for drilling guides or assembly documentation.
 *
 * Arguments:
 *   wall       - Bracket wall thickness
 *   slot_depth - Slot depth
 *
 * Returns: List of [position, direction] pairs
 *   position  - [x, y, z] relative to bracket center
 *   direction - normal vector pointing outward from screw head
 */
function corner_bracket_screw_positions(wall, slot_depth) =
    let(arm_width = wall + slot_depth)
    [
        // X-arm screw (through wall, into panel)
        [[wall/2 + slot_depth/2, -arm_width/2, 0], [0, -1, 0]],
        // Y-arm screw
        [[-arm_width/2, wall/2 + slot_depth/2, 0], [-1, 0, 0]]
    ];

/**
 * Creates a mirrored pair of corner brackets for opposite corners.
 * Useful for generating left/right or front/back pairs.
 *
 * Arguments:
 *   Same as corner_bracket()
 *   mirror_x - Mirror across YZ plane (default: false)
 *   mirror_y - Mirror across XZ plane (default: false)
 */
module corner_bracket_pair(
    case_height,
    ply_thickness = PLY_DEFAULT,
    wall = _DEFAULT_WALL,
    slot_depth = _DEFAULT_SLOT_DEPTH,
    tolerance = _DEFAULT_TOLERANCE,
    screw_holes = false,
    screw_dia = _DEFAULT_SCREW_DIA,
    mirror_x = false,
    mirror_y = false
) {
    corner_bracket(
        case_height = case_height,
        ply_thickness = ply_thickness,
        wall = wall,
        slot_depth = slot_depth,
        tolerance = tolerance,
        screw_holes = screw_holes,
        screw_dia = screw_dia,
        anchor = CENTER
    );

    if (mirror_x) {
        mirror([1, 0, 0])
        corner_bracket(
            case_height = case_height,
            ply_thickness = ply_thickness,
            wall = wall,
            slot_depth = slot_depth,
            tolerance = tolerance,
            screw_holes = screw_holes,
            screw_dia = screw_dia,
            anchor = CENTER
        );
    }

    if (mirror_y) {
        mirror([0, 1, 0])
        corner_bracket(
            case_height = case_height,
            ply_thickness = ply_thickness,
            wall = wall,
            slot_depth = slot_depth,
            tolerance = tolerance,
            screw_holes = screw_holes,
            screw_dia = screw_dia,
            anchor = CENTER
        );
    }

    if (mirror_x && mirror_y) {
        mirror([1, 0, 0])
        mirror([0, 1, 0])
        corner_bracket(
            case_height = case_height,
            ply_thickness = ply_thickness,
            wall = wall,
            slot_depth = slot_depth,
            tolerance = tolerance,
            screw_holes = screw_holes,
            screw_dia = screw_dia,
            anchor = CENTER
        );
    }
}

/**
 * Round rubber-foot style piece that sits under a corner bracket.
 * Has a counterbore for the screw head and clearance hole for the shaft.
 *
 * Arguments:
 *   foot_dia      - Diameter of the foot
 *   foot_height   - Total height of the foot
 *   screw_dia     - Screw shaft clearance hole diameter
 *   head_dia      - Screw head counterbore diameter
 *   head_depth    - Depth of counterbore for screw head
 *   chamfer       - Chamfer size for top edge (default: 0)
 *   anchor        - BOSL2 anchor
 */
module corner_foot(
    foot_dia = 20,
    foot_height = 8,
    screw_dia = _DEFAULT_SCREW_DIA,
    head_dia = 7,
    head_depth = 3,
    chamfer = 0,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    attachable(anchor, spin, orient, size=[foot_dia, foot_dia, foot_height]) {
        difference() {
            // Round foot body with chamfers on top and bottom edges
            cyl(d=foot_dia, h=foot_height, anchor=CENTER,
                chamfer1=chamfer, chamfer2=chamfer, $fn=32);

            // Counterbore for screw head (from bottom, above chamfer)
            translate([0, 0, -foot_height/2 + chamfer])
            cyl(d=head_dia, h=head_depth + 0.1, anchor=BOT, $fn=24);

            // Clearance hole for screw shaft (through entire foot)
            cyl(d=screw_dia + 0.5, h=foot_height + 0.2, anchor=CENTER, $fn=24);
        }
        children();
    }
}

// === TEST / DEMO ===
// Only show demo when this file is opened directly, not when included
if ($preview && is_undef($parent_modules)) {
    $parent_modules = true;
    color("teal")
    corner_bracket(
        case_height = 50,
        ply_thickness = PLY_3_8,
        wall = 3,
        screw_holes = true,
        chamfer = 1,
        anchor = BOT
    );
}
