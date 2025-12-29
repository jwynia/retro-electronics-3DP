// 21-placement-jigs.scad
// Demonstrates placement jigs for letter alignment when gluing.
// Print jig separately, use it to position letters, then glue.

$parent_modules = true;

include <../modules/googie/sign-text.scad>

// === DEMONSTRATION: LETTERS + MATCHING JIG ===

// The letters (print in your accent color)
color("Coral")
translate([0, 30, 0])
sign_text_letters("CAFE", font = "Atomic Age", size = 25, backing = false);

// The matching continuous jig (print in any color, reusable)
color("Gray")
translate([0, 0, 0])
sign_text_jig("CAFE", font = "Atomic Age", size = 25);

// === INDIVIDUAL LETTER JIG WITH DIVIDERS ===
// Better when letters are very different widths

translate([120, 30, 0])
color("Gold")
sign_text_letters("EAT", font = "Bungee", size = 30, backing = false);

translate([120, 0, 0])
color("DimGray")
sign_text_letter_jig("EAT", font = "Bungee", size = 30, dividers = true);

// === CONVENIENCE MODULE: LETTERS + JIG TOGETHER ===

translate([0, -80, 0])
sign_text_with_jig("OPEN", font = "Futura Bold", size = 22,
                   jig_style = "continuous", render_part = "both");

translate([120, -80, 0])
sign_text_with_jig("DINER", font = "Atomic Age", size = 18,
                   jig_style = "individual", render_part = "both");
