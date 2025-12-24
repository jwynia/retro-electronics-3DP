// Braun-Style Bluetooth Speaker
// Complete example combining shell, grille, controls, knob, and back panel.
//
// Inspired by Dieter Rams' designs for Braun (1960s-70s)
// Features:
// - Wedge shell with raked front (like Braun RT 20)
// - Vertical slot grille (signature Braun speaker pattern)
// - Volume knob with Braun-style minimalism
// - USB-C charging, aux input, power switch
// - Magnetic faceplate attachment

include <BOSL2/std.scad>

// Include project modules
use <../modules/shells/wedge.scad>
use <../modules/faces/grille.scad>
use <../modules/faces/back-panel.scad>
use <../modules/controls/controls.scad>
use <../modules/controls/knobs.scad>
use <../modules/hardware/speaker-mount.scad>

// ============================================================
// SPEAKER PARAMETERS
// ============================================================

// Overall size (fits 3" driver)
speaker_width = 140;
speaker_height = 100;
speaker_depth = 80;

// Shell parameters
shell_wall = 3;
shell_corner_r = 10;
shell_taper = 0.65;  // Front is 65% height of back

// Faceplate parameters
faceplate_thickness = 4;
lip_depth = 3;
lip_inset = 1.5;

// Speaker driver (3" / 77mm)
driver_dia = 77;
driver_cone = 65;

// Grille area (sized to cover driver)
grille_width = 90;
grille_height = 70;

// Control strip below grille
control_strip_height = 22;

// ============================================================
// CALCULATED VALUES
// ============================================================

// Front opening size (grille + controls)
front_opening_w = speaker_width - 20;
front_opening_h = speaker_height * shell_taper - 15;

// Faceplate size (fits into lip)
faceplate_w = front_opening_w + (lip_inset * 2);
faceplate_h = front_opening_h + (lip_inset * 2);

// Calculate rake angle for front face
rake_angle = atan2(speaker_height - speaker_height * shell_taper, speaker_depth);

// ============================================================
// SHELL
// ============================================================

module speaker_shell() {
    color("WhiteSmoke")
    shell_wedge(
        size = [speaker_width, speaker_height, speaker_depth],
        taper = shell_taper,
        taper_style = "front",
        wall = shell_wall,
        corner_r = shell_corner_r,
        opening = [front_opening_w, front_opening_h],
        opening_r = 5,
        lip_depth = lip_depth,
        lip_inset = lip_inset
    );
}

// ============================================================
// FRONT FACEPLATE (Grille + Controls combined)
// ============================================================

module speaker_faceplate() {
    // Two-part faceplate: grille on top, control strip below

    color("Silver")
    translate([0, 0, 0]) {
        // Main grille area
        translate([0, control_strip_height/2, 0])
        faceplate_grille(
            size = [faceplate_w, faceplate_h - control_strip_height],
            thickness = faceplate_thickness,
            corner_r = 6,
            grille_size = [grille_width, grille_height - 10],
            pattern = "vslots",           // Braun signature vertical slots
            slot_width = 2,
            slot_height = grille_height - 15,
            spacing = 5,
            steel_pockets = false         // Will use combined mounting
        );
    }

    // Control strip at bottom
    color("DimGray")
    translate([0, -(faceplate_h/2 - control_strip_height/2), 0])
    faceplate_controls(
        size = [faceplate_w, control_strip_height],
        thickness = faceplate_thickness,
        corner_r = 6,
        style = "braun",
        controls = [
            ["pot", [0, 0], 6.2, true],           // Volume pot (center)
            ["led", [faceplate_w/2 - 20, 0], 3],  // Power LED (right)
        ],
        steel_pockets = true,
        steel_inset = 15
    );
}

// ============================================================
// VOLUME KNOB
// ============================================================

module volume_knob() {
    color("Black")
    knob(
        dia = 28,
        height = 16,
        style = "braun",
        shaft_dia = 6,
        shaft_type = "d",
        pointer = true,
        style_options = [0.5, 1.0, 0.6]  // Subtle chamfer, thin pointer
    );
}

// ============================================================
// BACK PANEL
// ============================================================

module speaker_back_panel() {
    // Back panel sized to fit shell back opening
    // (In a real build, this would snap or screw into the back)

    back_w = speaker_width - shell_wall * 2 - 2;
    back_h = speaker_height - shell_wall * 2 - 2;

    color("DimGray")
    back_panel(
        size = [back_w, back_h],
        thickness = 3,
        corner_r = shell_corner_r - shell_wall,
        ports = [
            ["usbc", [0, back_h/3]],                    // USB-C charging
            ["audio", [-back_w/3, back_h/3]],           // Aux input
            ["slide", [back_w/3, back_h/3], [8, 4]],    // Power slide switch
            ["vent_slots", [0, -back_h/4], [back_w * 0.6, 20], 3, 4]  // Ventilation
        ],
        mounting = "magnetic"
    );
}

// ============================================================
// INTERNAL SPEAKER MOUNT
// ============================================================

module internal_speaker_mount() {
    color("Gray")
    speaker_mount_ring(
        driver_dia = driver_dia,
        cone_dia = driver_cone,
        screw_circle = driver_dia - 8,
        screw_count = 4,
        ring_width = 10,
        thickness = 4
    );
}

// ============================================================
// COMPLETE ASSEMBLY
// ============================================================

module braun_speaker_assembly(exploded = false) {
    explode = exploded ? 40 : 0;

    // Front face center height (average of front and back heights)
    front_face_z = (speaker_height * shell_taper) / 2;

    // Shell sits with bottom at z=0
    speaker_shell();

    // Front faceplate - sits in the lip on the raked front face
    // The front face is at y = -speaker_depth/2, tilted back by rake_angle
    translate([0, -speaker_depth/2 - explode, front_face_z])
    rotate([-rake_angle, 0, 0])
    translate([0, 0, lip_depth - faceplate_thickness/2])
    speaker_faceplate();

    // Volume knob - centered on control strip area of faceplate
    // Control strip is at bottom of faceplate
    knob_offset_on_plate = -(faceplate_h/2 - control_strip_height/2);
    translate([0, -speaker_depth/2 - explode*1.5, front_face_z])
    rotate([-rake_angle, 0, 0])
    translate([0, knob_offset_on_plate, lip_depth + faceplate_thickness/2 + 2])
    volume_knob();

    // Back panel - vertical on the back
    translate([0, speaker_depth/2 - shell_wall + explode, speaker_height/2])
    rotate([90, 0, 0])
    speaker_back_panel();

    // Internal speaker mount (shown in exploded view)
    if (exploded) {
        translate([0, 0, front_face_z])
        rotate([-rake_angle, 0, 0])
        translate([0, 10, -30])
        internal_speaker_mount();
    }
}

// ============================================================
// RENDER OPTIONS
// ============================================================

// Choose what to render:
// "assembly"    - Complete assembled speaker
// "exploded"    - Exploded view showing all parts
// "shell"       - Shell only
// "faceplate"   - Front faceplate only
// "controls"    - Control strip only
// "knob"        - Volume knob only
// "back"        - Back panel only
// "mount"       - Speaker mount ring only
// "printable"   - All parts laid out for printing

render_mode = "assembly";  // Change this to render different views

if (render_mode == "assembly") {
    braun_speaker_assembly(exploded = false);
}
else if (render_mode == "exploded") {
    braun_speaker_assembly(exploded = true);
}
else if (render_mode == "shell") {
    speaker_shell();
}
else if (render_mode == "faceplate") {
    speaker_faceplate();
}
else if (render_mode == "controls") {
    faceplate_controls(
        size = [faceplate_w, control_strip_height],
        thickness = faceplate_thickness,
        controls = [
            ["pot", [0, 0], 6.2, true],
            ["led", [faceplate_w/2 - 20, 0], 3],
        ]
    );
}
else if (render_mode == "knob") {
    volume_knob();
}
else if (render_mode == "back") {
    speaker_back_panel();
}
else if (render_mode == "mount") {
    internal_speaker_mount();
}
else if (render_mode == "printable") {
    // All parts laid out for 3D printing

    // Shell
    translate([0, 0, 0])
    speaker_shell();

    // Faceplate (flat for printing)
    translate([speaker_width + 20, 0, faceplate_thickness/2])
    speaker_faceplate();

    // Back panel
    translate([speaker_width + 20, faceplate_h + 20, 1.5])
    speaker_back_panel();

    // Volume knob
    translate([-50, 0, 0])
    volume_knob();

    // Speaker mount
    translate([-50, 60, 2])
    internal_speaker_mount();
}
