// 18-googie-signs.scad
// Demonstrates complete Googie sign assemblies.
// Combines bases, pylons, sign bodies, and decorations.

$parent_modules = true;  // Prevent module test code from running

include <../modules/googie/sign-assembly.scad>

// === LAYOUT CONFIGURATION ===
SPACING = 120;
COLS = 3;
ROWS = 2;

// Calculate scene bounds for centering
SCENE_WIDTH = (COLS - 1) * SPACING;
SCENE_HEIGHT = (ROWS - 1) * SPACING;

// Center offset
CENTER_X = -SCENE_WIDTH / 2;
CENTER_Y = -SCENE_HEIGHT / 2;

// === RENDER SIGN ASSEMBLIES ===
translate([CENTER_X, CENTER_Y, 0]) {

    // Row 0: Direct mount signs (no pylon)

    // Simple rect on disc base
    translate([0 * SPACING, 0 * SPACING, 0])
    color("Coral")
    sign_direct_mount(
        sign_size = [70, 35, 6],
        sign_style = "rect",
        base_style = "disc",
        base_size = 55
    );

    // Oval on kidney base
    translate([1 * SPACING, 0 * SPACING, 0])
    color("DeepSkyBlue")
    sign_direct_mount(
        sign_size = [75, 40, 6],
        sign_style = "oval",
        base_style = "kidney",
        base_size = 60,
        sign_tilt = 15
    );

    // Shield on rect base
    translate([2 * SPACING, 0 * SPACING, 0])
    color("Gold")
    sign_direct_mount(
        sign_size = [45, 55, 6],
        sign_style = "shield",
        base_style = "rect",
        base_size = 55
    );

    // Row 1: Pylon mount signs

    // Classic pylon with arrow sign
    translate([0 * SPACING, 1 * SPACING, 0])
    color("Tomato")
    sign_pylon_mount(
        sign_size = [85, 35, 6],
        sign_style = "arrow",
        pylon_height = 55,
        pylon_profile = "round"
    );

    // Diamond pylon with oval sign
    translate([1 * SPACING, 1 * SPACING, 0])
    color("MediumOrchid")
    sign_pylon_mount(
        sign_size = [70, 40, 6],
        sign_style = "oval",
        pylon_height = 50,
        pylon_profile = "diamond"
    );

    // Complete Googie sign with starburst
    translate([2 * SPACING, 1 * SPACING, 0])
    color("LimeGreen")
    googie_sign(
        sign_size = [75, 35, 6],
        sign_style = "rect",
        mount_style = "pylon",
        pylon_height = 45,
        add_starburst = true,
        starburst_size = 22,
        starburst_pos = "top-right"
    );
}
