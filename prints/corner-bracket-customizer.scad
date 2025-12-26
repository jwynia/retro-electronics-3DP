// Parametric Corner Brackets for Plywood Cases
// https://github.com/jwynia/retro-electronics-3DP
//
// L-shaped external brackets that hold plywood panels at box corners.
// Designed for FDM 3D printing without supports.
//
// Features:
// - Parametric for any case height and plywood thickness
// - Diamond screw holes (print without supports)
// - Chamfered edges for clean appearance
// - Separate feet with counterbore for screws

include <BOSL2/std.scad>

/* [Case Dimensions] */
// Interior height of the case (mm)
Case_Height = 152; // [50:300]

// Plywood thickness preset
Plywood_Type = "3/8 inch"; // ["1/4 inch", "3/8 inch", "1/2 inch", "3/4 inch", "3mm", "6mm", "9mm", "12mm", "18mm", "Custom"]

// Custom plywood thickness (only used if Plywood_Type is "Custom")
Custom_Plywood_Thickness = 9; // [3:0.1:25]

/* [Bracket Options] */
// Wall thickness of bracket
Wall_Thickness = 3; // [2:0.5:5]

// Clearance for plywood fit
Tolerance = 0.2; // [0.1:0.05:0.5]

// Chamfer size (0 = no chamfer)
Chamfer = 1; // [0:0.5:2]

// Add screw holes for securing plywood
Add_Screw_Holes = true;

// Screw hole diameter (for wood screws)
Screw_Diameter = 3; // [2:0.5:5]

/* [Foot Options] */
// Foot diameter
Foot_Diameter = 20; // [15:30]

// Foot height
Foot_Height = 8; // [5:15]

// Use same material/color for feet as brackets
Same_Material = false;

/* [Output] */
// What to generate
Output = "Bracket + Foot"; // ["Bracket Only", "Foot Only", "Bracket + Foot", "Full Set (4+4)"]

/* [Hidden] */
$fn = 32;

// === PLYWOOD THICKNESS LOOKUP ===
function get_ply_thickness() =
    Plywood_Type == "1/4 inch" ? 5.5 :
    Plywood_Type == "3/8 inch" ? 8.7 :
    Plywood_Type == "1/2 inch" ? 11.9 :
    Plywood_Type == "3/4 inch" ? 18.3 :
    Plywood_Type == "3mm" ? 3 :
    Plywood_Type == "6mm" ? 6 :
    Plywood_Type == "9mm" ? 9 :
    Plywood_Type == "12mm" ? 12 :
    Plywood_Type == "18mm" ? 18 :
    Custom_Plywood_Thickness;

// === DERIVED VALUES ===
ply = get_ply_thickness();
wall = Wall_Thickness;
tolerance = Tolerance;
chamfer = Chamfer;
case_height = Case_Height;
screw_dia = Screw_Diameter;

slot_width = ply + tolerance;
arm_width = wall + (ply + tolerance) * 2 + wall;
total_height = case_height + wall;
ext_corner = [-arm_width/2, -arm_width/2];
bot_z = -total_height/2;

// === CORNER BRACKET MODULE ===
module corner_bracket() {
    floor_size = arm_width - wall;
    floor_thickness = wall * 2;

    difference() {
        union() {
            // L-shape profile with chamfered external corner
            c = chamfer > 0 ? chamfer : 0;
            l_points = [
                [ext_corner.x + c, ext_corner.y],
                [ext_corner.x, ext_corner.y + c],
                [ext_corner.x, arm_width/2],
                [ext_corner.x + wall*2, arm_width/2],
                [ext_corner.x + wall*2, ext_corner.y + wall*2],
                [arm_width/2, ext_corner.y + wall*2],
                [arm_width/2, ext_corner.y],
            ];

            corner_cuts = [0, 0, chamfer, 0, 0, 0, chamfer];
            l_chamfered = chamfer > 0
                ? round_corners(l_points, cut=corner_cuts, method="chamfer", closed=true)
                : l_points;

            up(bot_z)
            offset_sweep(
                path=l_chamfered,
                height=total_height,
                top=os_chamfer(chamfer)
            );

            // Floor piece
            floor_pos = [ext_corner.x + wall * 2 + floor_size/2,
                         ext_corner.y + wall * 2 + floor_size/2,
                         bot_z];
            translate(floor_pos)
            cuboid([floor_size, floor_size, floor_thickness], anchor=BOT);
        }

        // Diamond screw holes
        if (Add_Screw_Holes) {
            num_screws = max(1, round(case_height / 50));
            screw_spacing = case_height / (num_screws + 1);
            screw_length = wall * 2 + ply * 0.5;
            diamond_side = screw_dia / sqrt(2);

            for (i = [1:num_screws]) {
                screw_z = bot_z + wall + i * screw_spacing;

                // X-arm screw
                translate([0, ext_corner.y - 0.1, screw_z])
                rotate([-90, 0, 0])
                rotate([0, 0, 45])
                cuboid([diamond_side, diamond_side, screw_length], anchor=BOT);

                // Y-arm screw
                translate([ext_corner.x - 0.1, 0, screw_z])
                rotate([0, 90, 0])
                rotate([0, 0, 45])
                cuboid([diamond_side, diamond_side, screw_length], anchor=BOT);
            }
        }

        // Foot screw hole
        foot_floor_size = arm_width - wall;
        foot_floor_thickness = wall * 2;
        floor_center = [ext_corner.x + wall * 2 + foot_floor_size/2,
                        ext_corner.y + wall * 2 + foot_floor_size/2];

        translate([floor_center.x, floor_center.y, bot_z - 0.1])
        cyl(d=screw_dia, h=foot_floor_thickness + 0.2, anchor=BOT, $fn=24);

        translate([floor_center.x, floor_center.y, bot_z])
        cyl(d1=screw_dia*2, d2=screw_dia, h=foot_floor_thickness/2 + 0.1, anchor=BOT, $fn=24);
    }
}

// === CORNER FOOT MODULE ===
module corner_foot() {
    difference() {
        cyl(d=Foot_Diameter, h=Foot_Height, anchor=BOT,
            chamfer1=chamfer, chamfer2=chamfer, $fn=32);

        // Countersink at bottom for flush screw head
        translate([0, 0, -0.1])
        cyl(d1=screw_dia*2.5, d2=screw_dia + 0.5, h=screw_dia*0.75 + 0.1, anchor=BOT, $fn=24);

        // Clearance hole
        cyl(d=screw_dia + 0.5, h=Foot_Height + 0.2, anchor=BOT, $fn=24);
    }
}

// === PRINT ORIENTATION ===
module print_bracket() {
    // Lay bracket flat - one arm on bed, other arm vertical
    // This orientation needs NO supports
    // Centered at origin for slicer compatibility
    translate([0, total_height/2, arm_width/2])
    rotate([90, 0, 0])
    translate([0, 0, total_height/2])
    corner_bracket();
}

module print_foot() {
    // Foot centered at origin, bottom at Z=0
    corner_foot();
}

// === OUTPUT GENERATION ===
spacing = 10;
floor_size = arm_width - wall;
foot_color = Same_Material ? "teal" : "gray";

if (Output == "Bracket Only") {
    color("teal")
    print_bracket();
}
else if (Output == "Foot Only") {
    color(foot_color)
    print_foot();
}
else if (Output == "Bracket + Foot") {
    // Both parts centered on bed
    color("teal")
    print_bracket();

    translate([arm_width/2 + spacing + Foot_Diameter/2, 0, 0])
    color(foot_color)
    print_foot();
}
else if (Output == "Full Set (4+4)") {
    // Center all parts on bed
    total_bracket_width = 4 * arm_width + 3 * spacing;
    translate([-total_bracket_width/2 + arm_width/2, 0, 0]) {
        // Arrange brackets in a row
        for (i = [0:3]) {
            translate([i * (arm_width + spacing), 0, 0])
            color("teal")
            print_bracket();
        }
    }
    // Feet in a row offset in Y
    total_foot_width = 4 * Foot_Diameter + 3 * spacing;
    translate([-total_foot_width/2 + Foot_Diameter/2, -total_height/2 - spacing - Foot_Diameter/2, 0]) {
        for (i = [0:3]) {
            translate([i * (Foot_Diameter + spacing), 0, 0])
            color(foot_color)
            print_foot();
        }
    }
}
