// Googie Pylon
// Parametric tapered mounting poles for Googie-style signs.
// Classic "reaching skyward" Space Age structures.

include <BOSL2/std.scad>

// Default values
_DEFAULT_HEIGHT = 80;
_DEFAULT_BASE_DIA = 25;
_DEFAULT_TOP_DIA = 15;

/**
 * Creates a Googie-style tapered pylon/pole.
 *
 * The pylon is the classic "reaching skyward" element of Googie design.
 * Used to mount signs, giving them that Space Age floating appearance.
 *
 * Arguments:
 *   height        - Overall height (mm)
 *   base_dia      - Diameter at base (mm)
 *   top_dia       - Diameter at top (mm)
 *   profile       - Shape: "round", "square", "diamond", "fin"
 *   base_flare    - Extra flare at base (0=none, adds stability)
 *   top_plate     - Add flat mounting plate at top (true/false)
 *   plate_size    - Size of top mounting plate [width, depth] or diameter
 *   plate_thick   - Thickness of mounting plate (mm)
 *   mount_holes   - Add screw holes in top plate (true/false)
 *   hole_dia      - Mounting hole diameter (mm)
 *   anchor        - BOSL2 anchor (default: BOT)
 *   spin          - BOSL2 spin (default: 0)
 *   orient        - BOSL2 orient (default: UP)
 *
 * Example:
 *   pylon();  // Default tapered cylinder
 *   pylon(height=100, profile="diamond");  // Diamond cross-section
 *   pylon(top_plate=true, mount_holes=true);  // With mounting plate
 */
module pylon(
    height = _DEFAULT_HEIGHT,
    base_dia = _DEFAULT_BASE_DIA,
    top_dia = _DEFAULT_TOP_DIA,
    profile = "round",
    base_flare = 0,
    top_plate = false,
    plate_size = undef,
    plate_thick = 3,
    mount_holes = false,
    hole_dia = 3,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    // Validate
    assert(height > 0, "height must be positive");
    assert(base_dia > 0, "base_dia must be positive");
    assert(top_dia > 0, "top_dia must be positive");

    // Calculate plate size
    _plate_size = is_undef(plate_size) ?
        (is_num(top_dia) ? top_dia * 1.5 : top_dia) :
        plate_size;

    // Total height including plate
    total_height = top_plate ? height + plate_thick : height;

    // Size for attachable
    max_dia = max(base_dia, top_dia, base_flare > 0 ? base_dia + base_flare * 2 : 0);
    size = [max_dia, max_dia, total_height];

    attachable(anchor, spin, orient, size=size) {
        union() {
            // Main pylon body
            if (profile == "round") {
                // Tapered cylinder
                cylinder(h=height, d1=base_dia, d2=top_dia, center=false, $fn=32);

                // Base flare
                if (base_flare > 0) {
                    cylinder(h=base_flare, d1=base_dia + base_flare*2, d2=base_dia, center=false, $fn=32);
                }
            }
            else if (profile == "square") {
                // Tapered square prism
                hull() {
                    cube([base_dia, base_dia, 0.01], center=true);
                    translate([0, 0, height])
                    cube([top_dia, top_dia, 0.01], center=true);
                }
            }
            else if (profile == "diamond") {
                // Tapered diamond (rotated square)
                hull() {
                    rotate([0, 0, 45])
                    cube([base_dia, base_dia, 0.01], center=true);
                    translate([0, 0, height])
                    rotate([0, 0, 45])
                    cube([top_dia, top_dia, 0.01], center=true);
                }
            }
            else if (profile == "fin") {
                // Fin-style pylon (wide front, narrow side)
                hull() {
                    scale([1, 0.4, 1])
                    cube([base_dia, base_dia, 0.01], center=true);
                    translate([0, 0, height])
                    scale([1, 0.4, 1])
                    cube([top_dia, top_dia, 0.01], center=true);
                }
            }

            // Top mounting plate
            if (top_plate) {
                translate([0, 0, height]) {
                    difference() {
                        // Plate
                        if (is_list(_plate_size)) {
                            translate([0, 0, plate_thick/2])
                            cube([_plate_size[0], _plate_size[1], plate_thick], center=true);
                        } else {
                            cylinder(h=plate_thick, d=_plate_size, $fn=32);
                        }

                        // Mount holes
                        if (mount_holes) {
                            hole_offset = (is_list(_plate_size) ? min(_plate_size) : _plate_size) * 0.3;
                            for (angle = [0, 90, 180, 270]) {
                                rotate([0, 0, angle])
                                translate([hole_offset, 0, -0.1])
                                cylinder(h=plate_thick+0.2, d=hole_dia, $fn=16);
                            }
                        }
                    }
                }
            }
        }
        children();
    }
}

/**
 * Creates a pylon with integrated weighted base.
 * Good for freestanding desktop signs.
 */
module pylon_with_base(
    height = 80,
    base_dia = 25,
    top_dia = 15,
    base_width = 50,
    base_height = 8,
    profile = "round",
    top_plate = true,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    total_height = height + base_height + (top_plate ? 3 : 0);
    size = [base_width, base_width, total_height];

    attachable(anchor, spin, orient, size=size) {
        union() {
            // Weighted base
            hull() {
                cylinder(h=0.01, d=base_width, $fn=32);
                translate([0, 0, base_height])
                cylinder(h=0.01, d=base_dia, $fn=32);
            }

            // Pylon
            translate([0, 0, base_height])
            pylon(
                height = height,
                base_dia = base_dia,
                top_dia = top_dia,
                profile = profile,
                top_plate = top_plate,
                anchor = BOT
            );
        }
        children();
    }
}

/**
 * Creates a double-fin pylon (classic Googie style).
 * Two fins crossing at 90 degrees.
 */
module double_fin_pylon(
    height = 80,
    base_size = 25,
    top_size = 15,
    fin_thickness = 0.4,  // Ratio of width
    top_plate = true,
    anchor = BOT,
    spin = 0,
    orient = UP
) {
    size = [base_size, base_size, height + (top_plate ? 3 : 0)];

    attachable(anchor, spin, orient, size=size) {
        union() {
            // First fin
            hull() {
                scale([1, fin_thickness, 1])
                cube([base_size, base_size, 0.01], center=true);
                translate([0, 0, height])
                scale([1, fin_thickness, 1])
                cube([top_size, top_size, 0.01], center=true);
            }

            // Second fin (rotated 90°)
            hull() {
                scale([fin_thickness, 1, 1])
                cube([base_size, base_size, 0.01], center=true);
                translate([0, 0, height])
                scale([fin_thickness, 1, 1])
                cube([top_size, top_size, 0.01], center=true);
            }

            // Top plate
            if (top_plate) {
                translate([0, 0, height])
                cylinder(h=3, d=top_size * 1.3, $fn=32);
            }
        }
        children();
    }
}


// === TEST / DEMO ===
// Only runs when this file is opened directly, not when included
if ($preview && is_undef($parent_modules)) {
    $parent_modules = true;

    // Basic round pylon
    pylon();

    // Diamond profile
    translate([50, 0, 0])
    pylon(profile="diamond", height=70);

    // With base
    translate([100, 0, 0])
    pylon_with_base(height=60);

    // Double fin
    translate([0, 60, 0])
    double_fin_pylon(height=70);

    // Fin profile with mounting plate
    translate([50, 60, 0])
    pylon(profile="fin", top_plate=true, mount_holes=true);
}
