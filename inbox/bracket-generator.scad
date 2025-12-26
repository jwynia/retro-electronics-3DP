include <BOSL2/std.scad>;
include <BOSL2/screws.scad>;

/**
 * Bracket Generator
 *      
 * Author: Jason Koolman  
 * Version: 1.1  
 *
 * Description:
 * This OpenSCAD script generates a variety of fully parametric  
 * brackets with FDM optimization and customizable options.
 *
 * License:
 * This script licensed under a Standard Digital File License.
 *
 * Changelog:
 * [v1.1]:
 * - Added the ability to specify screw hole placement.
 */
    
/* [📏 Bracket] */

// Bracket type.
Type = "angle"; // [angle: Angle Bracket, flat: Flat Bracket, T: T-Bracket]

// Bracket arm thickness.
Thickness = 3;

// Bracket arm width.
Width = 20;

// Length of a bracket arm.
Length = 50;

// Interior angle in degrees.
Angle = 90; // [0:1:135]

// Outer edge rounding (0 = sharp).
Rounding = 0; // [0:0.05:1]

// Fillet radius between arms (0 = none).
Fillet = 0;

/* [🪛 Holes] */

// Hole grid per arm [columns, rows].
Hole_Grid = [1, 2];

// Hole spacing [x, y].
Hole_Spacing = [8, 16];

// Hole grid pattern.
Hole_Stagger = "none"; // [none: None, stagger: Stagger, alt: Alternate]

// Offset holes from edges.
Hole_Offset = 0;

// Which sides to perforate holes.
Hole_Placement = "both"; // [both: Front and Back, front: Front only, back: Back only]

// Screw specification (ISO/UTS).
Screw_Spec = "M5"; // [M2, M2.5, M3, M4, M5, M6, M8, M10, M12, M14, M16, M18, M20, #4, #6, #8, #10, #12, 1/4, 5/16, 3/8, 7/16, 1/2, 9/16, 3/4]

// Screw head type.
Screw_Head = "none"; // [none: None, flat: Flat, button: Button, socket: Socket, hex: Hex, pan: Pan, cheese: Cheese]

// Counterbore depth (-1 = auto).
Screw_Counterbore = -1;

// Add screw thread.
Screw_Thread = false;

/* [📐 Support] */

// Number of supports.
Support_Count = 0;

// Taper ratio (coverage area).
Support_Taper = 0.5; // [0:0.05:1]

// Support thickness.
Support_Thickness = 2;

/* [📷 Render] */

// Optimize for 3D printing.
FDM = false;

// Mirror the model.
Mirror = false;

// Color of the model.
Color = "#ddd"; // color

/* [Hidden] */

$fa = 2;
$fs = 0.2;

_Size = [Width, Length, Thickness];
_Hole_Stagger = Hole_Stagger == "none" ? false : Hole_Stagger == "stagger" ? true : Hole_Stagger;
_Screw_Counterbore = Screw_Counterbore == 0 ? false : Screw_Counterbore < 0 ? true : Screw_Counterbore;

// Render
color(Color)
    mirror([Mirror ? 1 : 0, 0])
        generate();

module generate() {
    if (Type == "angle") {
        up(FDM ? Width / 2 : 0)
        yrot(FDM ? 90 : 0)
        angle_bracket(
            size = _Size,
            rounding = Rounding,
            interior_angle = Angle,
            fillet_r = Fillet,
            hole_grid = Hole_Grid,
            hole_spacing = Hole_Spacing,
            hole_stagger = _Hole_Stagger,
            hole_offset = Hole_Offset,
            hole_teardrop = FDM,
            screw_spec = Screw_Spec,
            screw_head = Screw_Head,
            screw_thread = Screw_Thread,
            screw_counterbore = _Screw_Counterbore,
            support_thickness = Support_Thickness,
            support_taper = Support_Taper,
            support_count = Support_Count
        );
    } else if (Type == "flat") {
        flat_bracket(
            size = _Size,
            rounding = Rounding,
            interior_angle = Angle,
            fillet_r = Fillet,
            hole_grid = Hole_Grid,
            hole_spacing = Hole_Spacing,
            hole_stagger = _Hole_Stagger,
            hole_offset = Hole_Offset,
            screw_spec = Screw_Spec,
            screw_head = Screw_Head,
            screw_thread = Screw_Thread,
            screw_counterbore = _Screw_Counterbore,
        );
    } else if (Type == "T") {
        t_bracket(
            size = _Size,
            rounding = Rounding,
            interior_angle = Angle,
            fillet_r = Fillet,
            hole_grid = Hole_Grid,
            hole_spacing = Hole_Spacing,
            hole_stagger = _Hole_Stagger,
            hole_offset = Hole_Offset,
            screw_spec = Screw_Spec,
            screw_head = Screw_Head,
            screw_thread = Screw_Thread,
            screw_counterbore = _Screw_Counterbore,
        );
    } else if (Type == "U") {
        // WIP
        u_bracket(
            size = _Size,
            rounding = Rounding,
            interior_angle = Angle,
            fillet_r = Fillet,
            hole_grid = Hole_Grid,
            hole_spacing = Hole_Spacing,
            hole_stagger = _Hole_Stagger,
            hole_offset = Hole_Offset,
            screw_spec = Screw_Spec,
            screw_head = Screw_Head,
            screw_thread = Screw_Thread,
            screw_counterbore = _Screw_Counterbore,
        );
    }
}

/** 
 * Creates a support flange for an angled bracket.
 * 
 * @param thickness       Thickness of the support flange.
 * @param arm_size        Vector [width, length, thickness] of a bracket arm.
 * @param interior_angle  Angle between the two bracket arms.
 * @param taper           Coverage ratio along the length (0 to 1).
 */
module support_flange(thickness, arm_size, interior_angle, taper=1) {
    taper = max(0, min(1, taper));
    path = path3d([
        [0, -arm_size.z * (1 - cos(interior_angle)) / sin(interior_angle), arm_size.z],
        [0, -arm_size.y * taper, arm_size.z],
        [
            0,
            arm_size.y * cos(interior_angle) * taper - arm_size.z * sin(interior_angle),
            arm_size.y * sin(interior_angle) * taper + arm_size.z * cos(interior_angle)
        ]
    ]);

    skin([left(thickness / 2, path), right(thickness / 2, path)], slices=0) {
        children();
    }
}

/** 
 * Creates an L-shaped bracket.
 *
 * @param size           Bracket arm size as [length, width, thickness]
 * @param rounding       Rounding factor of outer edges (0 = none, 1 = max)
 * @param interior_angle Angle between the two bracket arms.
 * @param fillet_r       Radius of the fillet between the two arms.
 * @param hole_grid      Number of columns and rows for the hole grid.
 * @param hole_size      Diameter of each screw hole.
 * @param hole_spacing   Horizontal and vertical spacing between holes.
 * @param hole_stagger   Staggers every other row for a zigzag pattern.
 * @param hole_offset    Vertical offset for the hole grid.
 */
module angle_bracket(
    size,
    rounding = 0,
    interior_angle = 90,
    fillet_r = 2,
    support_placement = "both",
    support_thickness = 2,
    support_taper = 1,
    support_count = 2,
    hole_grid = [1, 2],
    hole_size = 4,
    hole_spacing = [8, 16],
    hole_stagger = false,
    hole_offset = 0,
    hole_teardrop = false,
    screw_spec = "M4",
    screw_head = "none",
    screw_thread = false,
    screw_counterbore = undef
) {
    arm_rounding = (min(size.x, size.y) / 2) * rounding;
    
    module arm(spin, mirror = [0, 0]) {
        is_front = spin == 0;
        perforate = Hole_Placement == "both" || (Hole_Placement == "front" && is_front) || (Hole_Placement == "back" && !is_front);
        bracket_arm(
            size = size,
            rounding = rounding,
            hole_mirror = mirror,
            hole_grid = perforate ? hole_grid : [0, 0],
            hole_size = hole_size,
            hole_spacing = hole_spacing,
            hole_stagger = hole_stagger,
            hole_offset = hole_offset,
            hole_teardrop = hole_teardrop,
            screw_spec = screw_spec,
            screw_head = screw_head,
            screw_thread = screw_thread,
            screw_counterbore = screw_counterbore,
            spin = spin
        );
    }

    difference() {
        diff()
        union() {
            // Front side
            arm(0);

            // Back side
            xrot(interior_angle)
                arm(180, [1, 0]);
            
            // Add fillet between two parts
            if (interior_angle > 0 && fillet_r > 0) {
                ty = size.z * (1 - cos(interior_angle)) / sin(interior_angle);
                
                translate([0, -ty, size.z])
                    rotate([-90, 180, 90])
                        fillet(
                            l = size.x,
                            r = fillet_r,
                            ang = 180 - interior_angle,
                            anchor = LEFT+FRONT
                        );
            }
            
            // Add support flange(s)
            if (interior_angle > 0 && support_taper > 0 && support_thickness > 0) {
                xcopies(
                    l = size.x - support_thickness,
                    sp = -size.x / 2 + support_thickness/2,
                    n = support_count
                ) {
                    support_flange(
                        support_thickness,
                        size - [0, arm_rounding, 0],
                        interior_angle,
                        support_taper
                    );
                }
            }
        }
    
        // Removes excess material when the bracket angle is non-90 degrees.
        if (interior_angle > 0 && interior_angle != 90) {
            xy = size.z / sin(interior_angle);
            
            // Cut under the first side due to rotation of the second side
            down(size.z / 2 + 0.01)
                cube(size + [0.01, 0, 0], center = true);
                
            // Cut to the left of the second side due to rotation
            xrot(interior_angle - 180) up(size.z / 2 + 0.01)
                cube(size + [0.01, 0, 0], center = true);
        }
    }
}

/** 
 * Creates a Flat Bracket.
 *
 * @param size           Bracket arm size as [length, width, thickness]
 * @param rounding       Rounding factor of outer edges (0 = none, 1 = max)
 * @param skew_angle     Skew angle for the second arm.
 * @param fillet_r       Radius of the fillet between the two arms.
 * @param hole_grid      Number of columns and rows for the hole grid.
 * @param hole_size      Diameter of each screw hole.
 * @param hole_spacing   Horizontal and vertical spacing between holes.
 * @param hole_stagger   Staggers every other row for a zigzag pattern.
 * @param hole_offset    Vertical offset for the hole grid.
 */
module flat_bracket(
    size,
    rounding = 0,
    interior_angle = 90,
    fillet_r = 0,
    hole_grid = [1, 2],
    hole_size = 4,
    hole_spacing = [8, 16],
    hole_stagger = false,
    hole_offset = 0,
    screw_spec = "M4",
    screw_head = "none",
    screw_thread = false,
    screw_counterbore = undef
) {
    module arm(spin, mirror = [0, 0]) {
        is_front = spin == 0;
        perforate = Hole_Placement == "both" || (Hole_Placement == "front" && is_front) || (Hole_Placement == "back" && !is_front);
        bracket_arm(
            size = size,
            rounding = rounding,
            hole_mirror = mirror,
            hole_grid = perforate ? hole_grid : [0, 0],
            hole_size = hole_size,
            hole_spacing = hole_spacing,
            hole_stagger = hole_stagger,
            hole_offset = hole_offset,
            screw_spec = screw_spec,
            screw_head = screw_head,
            screw_thread = screw_thread,
            screw_counterbore = screw_counterbore,
            spin = spin
        );
    }

    left(size.x / 2)
    difference() {
        diff()
        union() {
            // Front side
            right(size.x / 2)
                arm(0);
            
            // Back side
            zrot(-interior_angle)
                right(size.x / 2)
                    arm(180, [1, 0]);
                
            // Add fillet between two parts
            if (interior_angle > 0 && fillet_r > 0) {
                ty = -size.x * (1 - cos(interior_angle)) / sin(interior_angle);
                
                translate([size.x, ty])
                    fillet(
                        l = size.z,
                        r = fillet_r,
                        ang = 180 - interior_angle,
                        spin= -90,
                        anchor = BOTTOM
                    );
            }
        }
    
        // Remove excess material
        if (interior_angle > 90) {
            down(0.01) {
                zrot(-180)
                    cube(size + [0, 0, 0.02]);
                zrot(-interior_angle)
                    translate([-size.x, 0, 0])
                        cube(size + [0, 0, 0.02]);
            }
        }
    }
}

/** 
 * Creates a T-Bracket.
 *
 * @param size           Bracket arm size as [length, width, thickness]
 * @param rounding       Rounding factor of outer edges (0 = none, 1 = max)
 * @param skew_angle     Skew angle for the second arm.
 * @param fillet_r       Radius of the fillet between the two arms.
 * @param hole_grid      Number of columns and rows for the hole grid.
 * @param hole_size      Diameter of each screw hole.
 * @param hole_spacing   Horizontal and vertical spacing between holes.
 * @param hole_stagger   Staggers every other row for a zigzag pattern.
 * @param hole_offset    Vertical offset for the hole grid.
 */
module t_bracket(
    size,
    rounding = 0,
    interior_angle = 90,
    fillet_r = 0,
    hole_grid = [1, 2],
    hole_size = 4,
    hole_spacing = [8, 16],
    hole_stagger = false,
    hole_offset = 0,
    screw_spec = "M4",
    screw_head = "none",
    screw_thread = false,
    screw_counterbore = undef
) {
    angle = max(90, interior_angle);

    module arm(spin) {
        is_front = $ang == 0;
        perforate = Hole_Placement == "both" || (Hole_Placement == "front" && is_front) || (Hole_Placement == "back" && !is_front);
        bracket_arm(
            size = size,
            rounding = rounding,
            hole_grid = perforate ? hole_grid : [0, 0],
            hole_size = hole_size,
            hole_spacing = hole_spacing,
            hole_stagger = hole_stagger,
            hole_offset = hole_offset,
            screw_spec = screw_spec,
            screw_head = screw_head,
            screw_thread = screw_thread,
            screw_counterbore = screw_counterbore,
            spin = spin
        );
    }

    difference() {
        diff()
        union() {
            zrot_copies([0, 180 - angle - (90 - angle) * 2, -angle])
                arm();
            
            // Add fillet between two parts
            if (fillet_r > 0 && angle == 90) {
                translate([size.x / 2, -size.x / 2])
                    fillet(
                        l = size.z,
                        r = fillet_r,
                        ang = angle,
                        spin= -90,
                        anchor = BOTTOM
                    );
                    
                translate([-size.x / 2, -size.x / 2])
                    fillet(
                        l = size.z,
                        r = fillet_r,
                        ang = angle,
                        spin= 180,
                        anchor = BOTTOM
                    );
            
                /* TODO: Support angled fillets
                ty = size.x / 2 * (1 - cos(interior_angle - 90)) / sin(interior_angle - 90);
                translate([size.x / 2, -ty])
                    fillet(
                        l = size.z + 1,
                        r = fillet_r,
                        ang = angle,
                        spin= -90,
                        anchor = BOTTOM
                    );
                */
            }
        }
    }
}

/** 
 * Creates a U-Bracket (WIP).
 *
 * @param size           Bracket arm size as [length, width, thickness]
 * @param rounding       Rounding factor of outer edges (0 = none, 1 = max)
 * @param fillet_r       Radius of the fillet between the two arms.
 * @param hole_grid      Number of columns and rows for the hole grid.
 * @param hole_size      Diameter of each screw hole.
 * @param hole_spacing   Horizontal and vertical spacing between holes.
 * @param hole_stagger   Staggers every other row for a zigzag pattern.
 * @param hole_offset    Vertical offset for the hole grid.
 */
module u_bracket(
    size,
    rounding = 0,
    fillet_r = 0,
    hole_grid = [1, 2],
    hole_size = 4,
    hole_spacing = [8, 16],
    hole_stagger = false,
    hole_offset = 0,
    screw_spec = "M4",
    screw_head = "none",
    screw_thread = false,
    screw_counterbore = undef
) {
    module arm(spin, mirror = [0, 0]) {
        bracket_arm(
            size = size,
            rounding = rounding,
            hole_mirror = mirror,
            hole_grid = hole_grid,
            hole_size = hole_size,
            hole_spacing = hole_spacing,
            hole_stagger = hole_stagger,
            hole_offset = hole_offset,
            screw_spec = screw_spec,
            screw_head = screw_head,
            screw_thread = screw_thread,
            screw_counterbore = screw_counterbore,
            spin = spin,
            orient=LEFT,
            anchor=CENTER
        ) children();
    }

    //left(size.x / 2)
    difference() {
        diff()
        union() {
            zrot_copies([0, 180, -90])
                fwd(16)
                arm(0);
        }
    }
}

/**
 * Creates a single bracket arm with screw holes.
 */
module bracket_arm(
    size,
    rounding,
    hole_mirror = [0, 0],
    hole_grid = [1, 2],
    hole_size = 4,
    hole_spacing = [8, 16],
    hole_stagger = false,
    hole_offset = 0,
    hole_teardrop = false,
    screw_spec = "M4",
    screw_head = "none",
    screw_thread = false,
    screw_counterbore = undef,
    anchor = BACK+BOTTOM,
    spin = 0,
    orient = UP    
) {
    module holes() {
        cp = [0, -size.z / 2 - hole_offset];
        pts = grid_copies(
            n = hole_grid,
            p = cp,
            spacing = hole_spacing,
            stagger = hole_stagger,
            inside = move(cp, rect([size.x - hole_size, size.y - hole_size])),
        );
        
        mirror(hole_mirror)
        move_copies(pts) {
            screw_hole(screw_spec, 
                length = size.z + 0.02, 
                thread = screw_thread,
                head = screw_head,
                counterbore = screw_counterbore,
                teardrop = hole_teardrop ? true : false,
                spin = hole_teardrop ? -90 : 0,
                $slop = screw_thread ? 0.1 : 0
            );
        }
    }

    cuboid(
        size = size,
        edges = [FRONT+LEFT, FRONT+RIGHT],
        rounding = (min(size.x, size.y) / 2) * rounding,
        anchor = anchor,
        spin = spin,
        orient = orient,
    ) {
        children();
        attach(TOP, UP, inside = true, shiftout = 0.01)
            holes();
    }
}