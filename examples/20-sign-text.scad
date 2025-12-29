// 20-sign-text.scad
// Demonstrates Googie sign text options.
// Shows standalone text pieces and text attached to signs.

$parent_modules = true;  // Prevent module test code from running

include <../modules/googie/sign-text.scad>

// === LAYOUT CONFIGURATION ===
SPACING_X = 100;
SPACING_Y = 60;
COLS = 3;
ROWS = 5;

// Calculate scene bounds for centering
SCENE_WIDTH = (COLS - 1) * SPACING_X;
SCENE_HEIGHT = (ROWS - 1) * SPACING_Y;
CENTER_X = -SCENE_WIDTH / 2;
CENTER_Y = SCENE_HEIGHT / 2;  // Start from top

translate([CENTER_X, CENTER_Y, 0]) {

// === ROW 0: STANDALONE TEXT PIECES ===
// These can be printed separately and glued to signs

// Basic standalone text
translate([0, 0, 0])
color("Coral")
sign_text("CAFE", font = "Atomic Age", size = 20);

// Text with backing plate (easier to handle and glue)
translate([SPACING_X, 0, 0])
color("Gold")
sign_text("DINER", font = "Bungee", size = 18, backing = true, backing_thick = 1.5);

// Fitted to width
translate([2 * SPACING_X, 0, 0])
color("DeepSkyBlue")
sign_text_fit("MOTEL", target_width = 70, font = "Futura Bold");

// === ROW 1: INDIVIDUAL LETTERS ===
// Print each letter separately for multi-color without AMS

translate([0, -SPACING_Y, 0])
color("LimeGreen")
sign_text_letters("OPEN", font = "Atomic Age", size = 16);

// Letters with backing plates
translate([SPACING_X + 30, -SPACING_Y, 0])
color("Tomato")
sign_text_letters("EAT", font = "Bungee", size = 20, backing = true);

// === ROW 2: SPECIAL TEXT EFFECTS ===

// Outline/hollow text (good for LED channels)
translate([0, -2 * SPACING_Y, 0])
color("MediumOrchid")
sign_text_outline("NEON", font = "Arial Black", size = 25, wall = 3);

// Curved/arc text
translate([SPACING_X + 50, -2 * SPACING_Y, 0])
color("Gold")
sign_text_arc("ATOMIC", font = "Futura Bold", size = 12, radius = 40, arc_angle = 120);

// === ROW 3: COMPLETE SIGNS WITH TEXT ===

// Rectangular sign with raised text
translate([0, -3 * SPACING_Y - 20, 0])
color("Coral")
sign_with_text("CAFE", sign_size = [80, 35, 5], text_size = 12,
               font = "Atomic Age", text_style = "raised");

// Oval sign with inset text
translate([SPACING_X, -3 * SPACING_Y - 20, 0])
color("DeepSkyBlue")
sign_with_text("BAR", sign_size = [60, 35, 6], text_size = 14,
               font = "Bungee", text_style = "inset", sign_style = "oval");

// Arrow sign with through-cut text (for backlighting)
translate([2 * SPACING_X, -3 * SPACING_Y - 20, 0])
color("Gold")
sign_with_text("GO", sign_size = [70, 30, 5], text_size = 14,
               font = "Futura Bold", text_style = "through", sign_style = "arrow");

// === ROW 4: PLACEMENT JIGS ===
// Jigs for aligning letters when gluing

// Continuous jig (letters as one notch)
translate([0, -4 * SPACING_Y - 40, 0])
color("Gray")
sign_text_jig("CAFE", font = "Atomic Age", size = 20);

// Individual letter jig with dividers
translate([SPACING_X + 20, -4 * SPACING_Y - 40, 0])
color("DimGray")
sign_text_letter_jig("OPEN", font = "Bungee", size = 18);

// Letters with matching jig shown together
translate([2 * SPACING_X + 20, -4 * SPACING_Y - 40, 0]) {
    color("Coral")
    sign_text_with_jig("EAT", font = "Futura Bold", size = 20,
                       jig_style = "continuous", render_part = "both");
}

}  // End of centering translate
